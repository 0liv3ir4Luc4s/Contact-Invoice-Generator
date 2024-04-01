@isTest
private class BitcoinExchange_Tests {
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void Should_SetBitcoinPriceBasedOnBtcEurQuotation_When_InvoiceIsCreated() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BitcoinExchangeTestDataFactory.createInvoices(1);
        Test.stopTest();

        List<Invoice__c> testedInvoice = [SELECT Id, BitcoinPrice__c FROM Invoice__c LIMIT 1];

        Assert.isFalse(testedInvoice.isEmpty(), 'Expected the Invoice to be saved to the database');
        Assert.areEqual(0.0006577529, testedInvoice[0].BitcoinPrice__c.setScale(10), 'Expected the Base Euro Price to be converted to Bitcoin price correctly');
        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');  
    }

    @isTest
    static void Should_SetBitcoinPriceBasedOnBtcEurQuotation_When_InvoiceIsCreated_Bulk() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BitcoinExchangeTestDataFactory.createInvoices(200);
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id, BitcoinPrice__c FROM Invoice__c];

        Assert.areEqual(200, testedInvoices.size(), 'Expected all the Invoices to be saved to the database');

        for(Invoice__c i : testedInvoices) {
            Assert.areEqual(0.0006577529, i.BitcoinPrice__c.setScale(10), 'Expected the Base Euro Price to be converted to Bitcoin price correctly');
        }

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');
    }

    @isTest
    static void ShouldNot_SetBitcoinPriceBasedOnBtcEurQuotation_When_InvoiceIsCreatedButCalloutResponds404() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BitcoinExchangeTestDataFactory.createInvoices(1);
        Test.stopTest();

        List<Invoice__c> testedInvoice = [SELECT Id, BitcoinPrice__c FROM Invoice__c LIMIT 1];

        Assert.isFalse(testedInvoice.isEmpty(), 'Expected the Invoice to be saved to the database');
        Assert.areEqual(null, testedInvoice[0].BitcoinPrice__c, 'Expected the Bitcoin price to remain null when callout fails');
    
        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'ERROR\''), 'Error log was not created');
    }
    
    @isTest
    static void ShouldNot_SetBitcoinPriceBasedOnBtcEurQuotation_When_InvoiceIsCreatedButCalloutResponds404_Bulk() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BitcoinExchangeTestDataFactory.createInvoices(200);
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id, BitcoinPrice__c FROM Invoice__c];

        Assert.areEqual(200, testedInvoices.size(), 'Expected all the Invoices to be saved to the database');

        for(Invoice__c i : testedInvoices) {
            Assert.areEqual(null, i.BitcoinPrice__c, 'Expected the Bitcoin price to remain null when callout fails');
        }

        Assert.areEqual(100, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Not all callout info logs were created');

        Assert.areEqual(200, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'ERROR\''), 'Not all error logs were created');
    }

    @isTest
    static void ShouldNot_SetBitcoinPriceBasedOnBtcEurQuotation_When_InvoiceIsCreatedButCalloutRespondsOtherThan200Or404() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(401);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BitcoinExchangeTestDataFactory.createInvoices(1);
        Test.stopTest();

        List<Invoice__c> testedInvoice = [SELECT Id, BitcoinPrice__c FROM Invoice__c LIMIT 1];

        Assert.isFalse(testedInvoice.isEmpty(), 'Expected the Invoice to be saved to the database');
        Assert.areEqual(null, testedInvoice[0].BitcoinPrice__c, 'Expected the Bitcoin price to remain null when callout fails');
    
        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'ERROR\''), 'Error log was not created');
    }

    @isTest
    static void ShouldNot_SetBitcoinPriceBasedOnBtcEurQuotation_When_InvoiceIsCreatedButCalloutRespondsOtherThan200Or404_Bulk() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(401);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BitcoinExchangeTestDataFactory.createInvoices(200);
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id, BitcoinPrice__c FROM Invoice__c];

        Assert.areEqual(200, testedInvoices.size(), 'Expected all the Invoices to be saved to the database');

        for(Invoice__c i : testedInvoices) {
            Assert.areEqual(null, i.BitcoinPrice__c, 'Expected the Bitcoin price to remain null when callout fails');
        }

        Assert.areEqual(100, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Not all callout info logs were created');

        Assert.areEqual(200, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'ERROR\''), 'Not all error logs were created');
    }
    
    @isTest
    static void ShouldNot_SetBitcoinPriceBasedOnBtcEurQuotation_When_InvoiceIsCreatedButCalloutResponseIsAnInvalidJson() {
        MockHttpResponseGenerator mock = new MockHttpResponseGenerator();

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BitcoinExchangeTestDataFactory.createInvoices(1);
        Test.stopTest();

        List<Invoice__c> testedInvoice = [SELECT Id, BitcoinPrice__c FROM Invoice__c LIMIT 1];

        Assert.isFalse(testedInvoice.isEmpty(), 'Expected the Invoice to be saved to the database');
        Assert.areEqual(null, testedInvoice[0].BitcoinPrice__c, 'Expected the Bitcoin price to remain null when callout fails');
    
        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'ERROR\''), 'Error log was not created');
    }

    @isTest
    static void ShouldNot_SetBitcoinPriceBasedOnBtcEurQuotation_When_InvoiceIsCreatedButCalloutResponseIsAnInvalidJson_Bulk() {
        MockHttpResponseGenerator mock = new MockHttpResponseGenerator();

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BitcoinExchangeTestDataFactory.createInvoices(200);
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id, BitcoinPrice__c FROM Invoice__c];

        Assert.areEqual(200, testedInvoices.size(), 'Expected all the Invoices to be saved to the database');

        for(Invoice__c i : testedInvoices) {
            Assert.areEqual(null, i.BitcoinPrice__c, 'Expected the Bitcoin price to remain null when callout fails');
        }

        Assert.areEqual(100, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');

        Assert.areEqual(200, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'ERROR\''), 'Not all error logs were created');
    }

    @isTest
    static void Should_SetUsdPriceBasedOnBaseEuroPriceAndBtcQuotation_When_DailyAutomationRuns() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();

        BitcoinExchangeTestDataFactory.createExpiredInvoices(1);
        BitcoinExchangeTestDataFactory.createPaidInvoices(1);

        System.schedule('Daily Automation Test', '0 0 8 * * ?', new UpdateInvoiceBatch());
        
        UpdateInvoiceBatch b = new UpdateInvoiceBatch(); 
        Database.executeBatch(b);
        
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id, UsdPrice__c, isExpired__c, Status__c FROM Invoice__c];

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Invoice__c WHERE Status__c = \'Expired\' AND isExpired__c = true'), 'There should be an expired invoice');
        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Invoice__c WHERE Status__c = \'Paid\' AND isExpired__c = false'), 'There should be a paid invoice');

        for(Invoice__c i : testedInvoices) {
            Assert.areEqual(10.7786717635, i.UsdPrice__c.setScale(10), 'Expected the Base Euro Price to be converted to USD price correctly');
        }

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');
    }

    @isTest
    static void Should_SetUsdPriceBasedOnBaseEuroPriceAndBtcQuotation_When_DailyAutomationRuns_Bulk() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();

        System.schedule('Daily Automation Test', '0 0 8 * * ?', new UpdateInvoiceBatch());

        BitcoinExchangeTestDataFactory.createExpiredInvoices(100);
        BitcoinExchangeTestDataFactory.createPaidInvoices(100);

        UpdateInvoiceBatch b = new UpdateInvoiceBatch(); 
        Database.executeBatch(b);
        
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id, UsdPrice__c, isExpired__c, Status__c FROM Invoice__c];

        Assert.areEqual(100, Database.countQuery('SELECT Count() FROM Invoice__c WHERE Status__c = \'Expired\' AND isExpired__c = true'), 'There should be expired invoices');
        Assert.areEqual(100, Database.countQuery('SELECT Count() FROM Invoice__c WHERE Status__c = \'Paid\' AND isExpired__c = false'), 'There should be paid invoices');

        for(Invoice__c i : testedInvoices) {
            Assert.areEqual(10.7786717635, i.UsdPrice__c.setScale(10), 'Expected the Base Euro Price to be converted to USD price correctly');
        }

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');
    }

    @isTest
    static void ShouldNot_SetUsdPriceBasedOnBaseEuroPriceAndBtcQuotation_When_DailyAutomationRunsButCalloutResponds404() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();

        System.schedule('Daily Automation Test', '0 0 8 * * ?', new UpdateInvoiceBatch());

        BitcoinExchangeTestDataFactory.createExpiredInvoices(1);
        BitcoinExchangeTestDataFactory.createPaidInvoices(1);

        UpdateInvoiceBatch b = new UpdateInvoiceBatch(); 
        Database.executeBatch(b);
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id, UsdPrice__c, isExpired__c, Status__c FROM Invoice__c];

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Invoice__c WHERE Status__c = \'Expired\' AND isExpired__c = true'), 'There should be an expired invoice');
        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Invoice__c WHERE Status__c = \'Paid\' AND isExpired__c = false'), 'There should be a paid invoice');

        for(Invoice__c i : testedInvoices) {
            Assert.areEqual(null, i.UsdPrice__c, 'Expected the USD price to remain null when callout fails');
        }

        Assert.areEqual(4, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');

        Assert.areEqual(4, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'ERROR\''), 'Error log was not created');
    }

    @isTest
    static void ShouldNot_SetUsdPriceBasedOnBaseEuroPriceAndBtcQuotation_When_DailyAutomationRunsButCalloutResponds404_Bulk() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();

        System.schedule('Daily Automation Test', '0 0 8 * * ?', new UpdateInvoiceBatch());

        BitcoinExchangeTestDataFactory.createExpiredInvoices(100);
        BitcoinExchangeTestDataFactory.createPaidInvoices(100);

        UpdateInvoiceBatch b = new UpdateInvoiceBatch(); 
        Database.executeBatch(b);
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id, UsdPrice__c, isExpired__c, Status__c FROM Invoice__c];

        Assert.areEqual(100, Database.countQuery('SELECT Count() FROM Invoice__c WHERE Status__c = \'Expired\' AND isExpired__c = true'), 'There should be an expired invoice');
        Assert.areEqual(100, Database.countQuery('SELECT Count() FROM Invoice__c WHERE Status__c = \'Paid\' AND isExpired__c = false'), 'There should be a paid invoice');

        for(Invoice__c i : testedInvoices) {
            Assert.areEqual(null, i.UsdPrice__c, 'Expected the USD price to remain null when callout fails');
        }

        Assert.areEqual(100, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\''), 'Callout info log was not created');

        Assert.areEqual(200, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'ERROR\''), 'Error log was not created');
    }

    @isTest
    /*As the method InvoiceUtil.logFailedUpdates is not called on mapped regular or error paths,
    it is necessary to run it mannually in order to test it and the enough coverage*/
    static void Should_ThrowDmlError_When_InvoiceIsCreatedWithoutContact() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();

        Database.SaveResult[] results = new List<Database.SaveResult>{Database.insert(new Invoice__c(), false)};

        InvoiceUtil.logFailedUpdates(results);
        
        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id FROM Invoice__c];

        Assert.isTrue(testedInvoices.isEmpty(), 'Test invoice should not be saved to the database');
        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'DML ERROR\''), 'Error log was not created');
    }

    @isTest
    /*As the method InvoiceUtil.logFailedUpdates is not called on mapped regular or error paths,
    it is necessary to run it mannually in order to test it and the enough coverage*/
    static void Should_ThrowDmlError_When_InvoiceIsCreatedWithoutContact_Bulk() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('CoinDeskBtcCurrentPrinceMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);
        
        List<Invoice__c> invoicesToInsert = new List<Invoice__c>();
        
        for(Integer i = 0; i < 200; i++) {
            invoicesToInsert.add(new Invoice__c());
        }

        Test.startTest();

        Database.SaveResult[] results = Database.insert(invoicesToInsert, false);

        InvoiceUtil.logFailedUpdates(results);

        Test.stopTest();

        List<Invoice__c> testedInvoices = [SELECT Id FROM Invoice__c];

        Assert.isTrue(testedInvoices.isEmpty(), 'Test invoices should not be saved to the database');
        Assert.areEqual(200, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'DML ERROR\''), 'Not all error logs were created');
    }

    @isTest
    /*As the method InvoiceUtil.logFailedUpdates is not called on mapped regular or error paths,
    it is necessary to run it mannually in order to test it and the enough coverage*/
    static void Should_LogCalloutError_When_FatalCalloutErrorOccurs() {
        Test.startTest();

        EventBus.publish(new LogEvent__e(Type__c = 'CALLOUT', Timestamp__c = DateTime.now(), LogLevel__c = 'ERROR',
                            Method__c = 'GET', EndpointUrl__c = 'TEST ENDPOINT', ResponseBody__c = '{}', StatusCode__c = '500'));

        Test.stopTest();

        Assert.areEqual(1, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\' AND LogLevel__c = \'ERROR\''), 'Error log was not created');
    }

    @isTest
    /*As the method InvoiceUtil.logFailedUpdates is not called on mapped regular or error paths,
    it is necessary to run it mannually in order to test it and the enough coverage*/
    static void Should_LogCalloutError_When_FatalCalloutErrorOccurs_Bulk() {
        Test.startTest();

        List<LogEvent__e> logEvents = new List<LogEvent__e>();

        for(Integer i = 0; i < 200; i++) {
            logEvents.add(new LogEvent__e(Type__c = 'CALLOUT', Timestamp__c = DateTime.now(), LogLevel__c = 'ERROR',
                Method__c = 'GET', EndpointUrl__c = 'TEST ENDPOINT', ResponseBody__c = '{}', StatusCode__c = '500'));
        }
        
        EventBus.publish(logEvents);

        Test.stopTest();

        Assert.areEqual(200, Database.countQuery('SELECT Count() FROM Log__c WHERE Type__c = \'CALLOUT\' AND LogLevel__c = \'ERROR\''), 'Error log was not created');
    }

}