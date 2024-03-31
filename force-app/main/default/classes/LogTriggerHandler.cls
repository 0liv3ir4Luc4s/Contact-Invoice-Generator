public without sharing class LogTriggerHandler {
    public static void afterInsert(List<Log__c> newLogs) {
        LogUtil.sendEmailToAdminsWhenErrorLogIsCreated(newLogs);
    }
}