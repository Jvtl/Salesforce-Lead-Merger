@IsTest
private class LeadTriggerTest {
    private static final Integer numberOfLogs = 1;

    @isTest
    public static void triggerTest() {
        Lead testLead = new Lead(LastName='Test Name 1', Company='Test Company', Email='test@test.com', Phone='123', LeadSource='Phone');

        Test.startTest();
            insert testLead;
            testLead.LastName = 'Test Name 2';
            update testLead;
            delete testLead;
            undelete testLead;
        Test.stopTest();

        List<CustomLog__c> logs = [
            SELECT Type__c, Message__c 
            FROM CustomLog__c 
            WHERE Message__c LIKE 'LeadTriggerHandler%'
        ];
        Assert.areEqual(numberOfLogs, logs.size());
        Assert.areEqual('INFO', logs[0].Type__c);
    }
}