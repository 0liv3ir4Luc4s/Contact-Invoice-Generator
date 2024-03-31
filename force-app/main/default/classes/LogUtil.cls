public without sharing class LogUtil {
    public static void sendEmailToAdminsWhenErrorLogIsCreated(List<Log__c> logs) {
        String emailBody = '';

        for(Log__c log : logs) {
            if(log.LogLevel__c == 'ERROR') {
                emailBody += buildEmailMessageLine(log);
            }
        }

        List<User> adminUsers = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true];

        List<String> adminUserIds = new List<String>();
        if(!adminUsers.isEmpty()) {
            adminUserIds.addAll(new List<Id>((new Map<Id,User>(adminUsers)).keySet()));
        }

        if(emailBody != '' && !adminUserIds.isEmpty()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(adminUserIds);
            mail.setSubject('Please, review the following errors');
            mail.setPlainTextBody(emailBody);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    private static String buildEmailMessageLine(Log__c log) {
        if(log.Type__c == 'CALLOUT') {
            return 'An error has ocurred:\n  Type: '+ log.Type__c +
                    '\n  Method: ' + log.Method__c + 
                    '\n Endpoint URL: ' + log.EndpointUrl__c +
                    '\n Response Body: ' + log.ResponseBody__c + 
                    '\n Log Id: ' + log.Id + 
                    '\n\n';
        } else {
            return 'An error has ocurred:\n  Type: '+ log.Type__c +
                    '\n  Details: ' + log.Details__c +
                    '\n Log Id: ' + log.Id + 
                    '\n\n';
        }
    }
}