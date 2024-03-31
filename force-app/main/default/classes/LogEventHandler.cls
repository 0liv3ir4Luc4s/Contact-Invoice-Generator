public with sharing class LogEventHandler {
    public static void logEvents(List<LogEvent__e> logEvents) {
        List<Log__c> logsToInsert = new List<Log__c>();
        for (LogEvent__e logEvent : logEvents) {
            logsToInsert.add(new Log__c(
                Type__c = logEvent.Type__c,
                Timestamp__c = logEvent.Timestamp__c,
                LogLevel__c = logEvent.LogLevel__c,
                Details__c = logEvent.Details__c,
                RecordId__c = logEvent.RecordId__c,
                Method__c = logEvent.Method__c,
                EndpointUrl__c = logEvent.EndpointUrl__c,
                ResponseBody__c = logEvent.ResponseBody__c,
                StatusCode__c = logEvent.StatusCode__c
            ));
        }

        if (!logsToInsert.isEmpty()) {
            insert logsToInsert;
        }
    }
}