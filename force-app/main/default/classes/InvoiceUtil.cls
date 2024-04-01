public with sharing class InvoiceUtil {
    @future(callout=true)
    public static void setBitcoinPriceBasedOnBtcEurQuotation(Set<Id> invoiceIds) {
        List<Invoice__c> invoicesToUpdate = new List<Invoice__c>();
        List<LogEvent__e> logEvents = new List<LogEvent__e>();

        for(Invoice__c invoice : [SELECT Id, BasePrice__c FROM Invoice__c WHERE Id IN :invoiceIds]) {
            Decimal btcPrice;
            try {
                btcPrice = convertEurToBtc(invoice.BasePrice__c);
            } catch (Exception e) {
                logEvents.add(new LogEvent__e(Type__c = 'ERROR', Timestamp__c = DateTime.now(), LogLevel__c = 'ERROR',
                    Details__c = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString()
                    +' ; '+e.getTypeName()));
            }
            invoicesToUpdate.add(new Invoice__c(Id = invoice.Id, BitcoinPrice__c = btcPrice));
        }

        EventBus.publish(logEvents);
        
        Database.SaveResult[] results = Database.Update(invoicesToUpdate, false);

        logFailedUpdates(results);
    }

    public static Decimal convertEurToBtc(Decimal eur) {
        Decimal btcEurExchangeRate = BitcoinExchangeService.getBtcToEurExchangeRate();

        return eur / btcEurExchangeRate;
    }

    public static Decimal convertBtcToUsd(Decimal btc) {
        Decimal btcUsdExchangeRate = BitcoinExchangeService.getBtcToUsdExchangeRate();

        return btc * btcUsdExchangeRate;
    }

    public static void logFailedUpdates(List<Database.SaveResult> saveResults) {
        List<LogEvent__e> logEvents = new List<LogEvent__e>();
        LogEvent__e le;

        for(Database.SaveResult res : saveResults){
            if(!res.isSuccess()){
                le = new LogEvent__e(Type__c = 'DML ERROR', Timestamp__c = DateTime.now(), LogLevel__c = 'ERROR');
                String details;
                for(Database.Error err : res.getErrors()) {
                    details += err.getStatusCode()+' : '+err.getMessage() + '; '; 
                }
                le.Details__c = details + new dmlException().getStackTraceString();
                le.RecordId__c = res.getId();
                logEvents.add(le);
            }
        }

        EventBus.publish(logEvents);
    }
}