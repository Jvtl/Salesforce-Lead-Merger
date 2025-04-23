@IsTest
private class LeadTriggerHandlerTest {

    private static final Integer numberOfLogs = 1;

    @isTest
    public static void afterInsertTest() {

        List<Lead> listLeads = new List<Lead>{
            new Lead(LastName='Test Name 1', Company='Test Company', Email='test@test.com', Phone='123', LeadSource='Phone'),
            new Lead(LastName='Test Name 2', Company='Test Company', Email='test@test.com', Phone='321', LeadSource='Phone')
        };

        Test.startTest();
            insert listLeads;
        Test.stopTest();

        System.assert(TriggerContext.hasHandledLeadDuplicates);

        List<CustomLog__c> logs = [
            SELECT Type__c, Message__c 
            FROM CustomLog__c 
            WHERE Message__c LIKE 'LeadTriggerHandler handleAfterInsert%'
        ];
        Assert.areEqual(numberOfLogs, logs.size());
        Assert.areEqual('INFO', logs[0].Type__c);
    }

    @isTest
    public static void afterInsertTest2() {
        TriggerContext.hasHandledLeadDuplicates = false;

        List<Lead> listLeads = new List<Lead>{
            new Lead(LastName='Test Name 1', Company='Test Company', Email='test@test.com', Phone='123', LeadSource='Email'),
            new Lead(LastName='Test Name 2', Company='Test Company', Email='test@test.com', Phone='321', LeadSource='Email')
        };

        Test.startTest();
            insert listLeads;

            insert new List<Lead>{
                new Lead(LastName='Test Name 3', Company='Test Company', Email='test@test.com', Phone='111', LeadSource='Email')
            };
        Test.stopTest();

        List<CustomLog__c> logs = [
            SELECT Type__c, Message__c 
            FROM CustomLog__c 
            WHERE Message__c LIKE 'LeadTriggerHandler handleAfterInsert%'
        ];
        Assert.areEqual(numberOfLogs, logs.size());
        Assert.areEqual('INFO', logs[0].Type__c);
    }

    @isTest
    public static void updateTest() {

        Lead testLead = new Lead(LastName='Test Name 1', Company='Test Company', Email='test@test.com', Phone='123', LeadSource='Phone');

        Test.startTest();
            insert testLead;

            testLead.LastName = 'Test Name 2';
            update testLead;
            
        Test.stopTest();

        List<CustomLog__c> logs = [
            SELECT Type__c, Message__c 
            FROM CustomLog__c 
            WHERE Message__c LIKE 'LeadTriggerHandler handleAfterInsert%'
        ];
        Assert.areEqual(numberOfLogs, logs.size());
        Assert.areEqual('INFO', logs[0].Type__c);
    }

    @isTest
    public static void deleteTest() {

        Lead testLead = new Lead(LastName='Test Name 1', Company='Test Company', Email='test@test.com', Phone='123', LeadSource='Phone');

        Test.startTest();
            insert testLead;

            delete testLead;

            undelete testLead;
            
        Test.stopTest();

        List<CustomLog__c> logs = [
            SELECT Type__c, Message__c 
            FROM CustomLog__c 
            WHERE Message__c LIKE 'LeadTriggerHandler handleAfterInsert%'
        ];
        Assert.areEqual(numberOfLogs, logs.size());
        Assert.areEqual('INFO', logs[0].Type__c);
    }
}