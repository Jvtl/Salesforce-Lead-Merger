@IsTest
private class LeadDuplicateMergerTest {

    @TestSetup
    public static void setup() {

        insert new List<Lead>{
            new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='123', LeadSource='Phone'),
            new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='123', LeadSource='Phone'),
            new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='999', LeadSource='Phone')
        };
    }

    @isTest
    public static void processBatchTest() {

        List<Lead> listLeads = [SELECT Id FROM Lead WHERE Email='test@test.com'];

        Test.startTest();
            LeadDuplicateMerger.processBatch(listLeads);
        Test.stopTest();

        listLeads = [SELECT Id FROM Lead WHERE Email='test@test.com'];
        Assert.areEqual(1, listLeads.size());

        List<CustomLog__c> logs = [SELECT Type__c, Message__c FROM CustomLog__c WHERE RelatedRecordId__c = :listLeads[0].Id];
        Assert.isTrue(logs.size() > 0);
    }
}