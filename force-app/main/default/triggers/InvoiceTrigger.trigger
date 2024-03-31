trigger InvoiceTrigger on Invoice__c (after insert) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            InvoiceTriggerHandler.afterInsert(Trigger.new);
        }
    }
}