global class UpdateInvoiceBatch implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts{
 
    global void execute(SchedulableContext sc) {
        UpdateInvoiceBatch b = new UpdateInvoiceBatch(); 
        Database.executeBatch(b);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
       return Database.getQueryLocator('SELECT Id, BasePrice__c, Status__c, ExpirationDate__c FROM Invoice__c');
    }
 
    public void execute(Database.BatchableContext bc, List<Invoice__c> scope) {
        List<Invoice__c> invoicesToUpdate = new List<Invoice__c>();
        Invoice__c tempInvoice;
        List<LogEvent__e> logEvents = new List<LogEvent__e>();
        
        for(Invoice__c i : scope) {
            tempInvoice = new Invoice__c(Id = i.Id);

            Decimal usdPrice;
            
            try {
                usdPrice = InvoiceUtil.convertBtcToUsd(InvoiceUtil.convertEurToBtc(i.BasePrice__c));
            } catch (Exception e) {
                logEvents.add(new LogEvent__e(Type__c = 'ERROR', Timestamp__c = DateTime.now(), LogLevel__c = 'ERROR',
                    Details__c = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString()
                    +' ; '+e.getTypeName()));
            }

            tempInvoice.UsdPrice__c = usdPrice;

            if(i.ExpirationDate__c <= Date.today() && i.Status__c == 'Open') {
                tempInvoice.isExpired__c = true;
                tempInvoice.Status__c = 'Expired';
            }

            invoicesToUpdate.add(tempInvoice);
        }

        EventBus.publish(logEvents);

        Database.SaveResult[] results = Database.Update(invoicesToUpdate, false);

        InvoiceUtil.logFailedUpdates(results);
    }

    public void finish(Database.BatchableContext bc){}
 
 }