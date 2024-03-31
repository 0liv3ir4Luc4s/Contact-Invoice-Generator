trigger LogTrigger on Log__c (after insert) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            LogTriggerHandler.afterInsert(Trigger.new);
        }
    }
}