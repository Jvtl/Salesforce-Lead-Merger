@IsTest
private class LeadDuplicateHandlerTest {

    @TestSetup
    static void setup() {

        insert new List<Lead>{
            new Lead(LastName='Test Name 1', Company='Test Company', Email='test1@test.com', Phone='111', LeadSource='Email'),
            new Lead(LastName='Test Name 2', Company='Test Company', Email='test2@test.com', Phone='222', LeadSource='Email')
        };

        Lead leadTest = new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='333', LeadSource='Phone');
        insert leadTest;

        insert new List<Lead>{
            new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='334', LeadSource='Phone'),
            new Lead(LastName='Test Name 1', Company='Test Company', Email='test@test.com', Phone='335', LeadSource='Phone')
        };
    }

    @isTest
    public static void handleDuplicateLeadsTest() {

        TriggerContext.hasHandledLeadDuplicates = false;
        List<Lead> listLead = [SELECT Id, Email, LastName, LeadSource, Phone FROM Lead WHERE Email='test@test.com' ORDER BY CreatedDate];

        Test.startTest();
            LeadDuplicateHandler.handleDuplicateLeads(listLead);
        Test.stopTest();

        AsyncApexJob job = [SELECT Id, JobType, Status FROM AsyncApexJob WHERE JobType = 'BatchApex' LIMIT 1];
        Assert.isTrue(job != null);

        List<CustomLog__c> logs = [SELECT Type__c, Message__c, RelatedRecordId__c FROM CustomLog__c];
        Assert.isTrue(logs.size() > 0);
    }

    @isTest
    public static void handleDuplicateLeadsNoEnqueueTest() {

        TriggerContext.hasHandledLeadDuplicates = false;
        List<Lead> listLead = [SELECT Id, Email, LastName, LeadSource, Phone FROM Lead WHERE Email IN ('test1@test.com','test2@test.com')];

        Test.startTest();
            LeadDuplicateHandler.handleDuplicateLeads(listLead);
        Test.stopTest();

        Integer jobCount = [SELECT COUNT() FROM AsyncApexJob WHERE JobType='BatchApex'];
        Assert.isTrue(jobCount > 0);
    }
}