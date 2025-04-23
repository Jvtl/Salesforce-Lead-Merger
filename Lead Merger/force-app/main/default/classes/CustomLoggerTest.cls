@IsTest
private class CustomLoggerTest {

    @isTest
    public static void logTest() {

        CustomLogger logger = CustomLogger.getInstance();
        logger.log('Test message 1', 'INFO', null);
        logger.log('Test message 2', 'ERROR', null);

        Test.startTest();
            logger.flush();
        Test.stopTest();

        List<CustomLog__c> logs = [SELECT Message__c,Type__c,RelatedRecordId__c FROM CustomLog__c WHERE Message__c LIKE 'Test message%'];
        Assert.areEqual(2, logs.size());
        
        for (CustomLog__c rec : logs) {
            if (rec.Message__c == 'Test message 1') {
                Assert.areEqual('INFO', rec.Type__c);
                Assert.areEqual(null, rec.RelatedRecordId__c);
            } else {
                Assert.areEqual('ERROR', rec.Type__c);
                Assert.areEqual(null, rec.RelatedRecordId__c);
            }
        }
    }

    @isTest
    public static void flushTest() {

        CustomLogger logger = CustomLogger.getInstance();

        Test.startTest();
            logger.flush();
        Test.stopTest();
        
        Integer countAfter = [SELECT COUNT() FROM CustomLog__c];
        Assert.isTrue(countAfter == 0);
    }
}