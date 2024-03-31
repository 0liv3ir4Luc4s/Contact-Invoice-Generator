public with sharing class InvoiceUtil {
    @future(callout=true)
    public static void setBitcoinPriceBasedOnBtcEurQuotation(Set<Id> invoiceIds) {   
        Decimal btcEurExchangeRate = BitcoinExchangeService.getBtcToEurExchangeRate();

        List<Invoice__c> invoicesToUpdate = new List<Invoice__c>();

        for(Invoice__c invoice : [SELECT Id, BasePrice__c FROM Invoice__c WHERE Id IN :invoiceIds]) {
            invoicesToUpdate.add(new Invoice__c(Id = invoice.Id, BitcoinPrice__c = invoice.BasePrice__c / btcEurExchangeRate));
        }

        update invoicesToUpdate;
    }
}