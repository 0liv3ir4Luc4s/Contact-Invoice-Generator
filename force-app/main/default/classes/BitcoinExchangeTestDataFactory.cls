@isTest
public class BitcoinExchangeTestDataFactory {
    public static List<Invoice__c> createInvoices(Integer numInvoices) {
        Contact c = new Contact(LastName = 'Test Contact');
        insert c;

        List<Invoice__c> invoicesToInsert = new List<Invoice__c>();
        
        for(Integer i = 0; i < numInvoices; i++) {
            invoicesToInsert.add(new Invoice__c(BasePrice__c = 10.50, Contact__c = c.Id));
        }

        insert invoicesToInsert;
        return invoicesToInsert;
    }

    public static List<Invoice__c> createExpiredInvoices(Integer numInvoices) {
        List<Invoice__c> invoicesToUpdate = new List<Invoice__c>();

        for(Invoice__c i : createInvoices(numInvoices)) {
            invoicesToUpdate.add(new Invoice__c(Id = i.Id, ExpirationDate__c = Date.today(), Status__c = 'Open'));
        }

        update invoicesToUpdate;
        return invoicesToUpdate;
    }

    public static List<Invoice__c> createPaidInvoices(Integer numInvoices) {
        List<Invoice__c> invoicesToUpdate = new List<Invoice__c>();

        for(Invoice__c i : createInvoices(numInvoices)) {
            invoicesToUpdate.add(new Invoice__c(Id = i.Id, ExpirationDate__c = Date.today(), Status__c = 'Paid'));
        }

        update invoicesToUpdate;
        return invoicesToUpdate;
    }
}