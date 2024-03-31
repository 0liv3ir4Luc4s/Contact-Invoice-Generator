public with sharing class InvoiceTriggerHandler {
    public static void afterInsert(List<Invoice__c> newInvoices) {
        InvoiceUtil.setBitcoinPriceBasedOnBtcEurQuotation((new Map<Id,Invoice__c>(newInvoices)).keySet());
    }
}