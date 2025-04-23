@IsTest
private class LeadMergerBatchTest {

    @TestSetup
    public static void setup() {

        Lead master = new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='100', LeadSource='Email');
        insert master;
        
        insert new List<Lead>{
            new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='101', LeadSource='Email'),
            new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='102', LeadSource='Email'),
            new Lead(LastName='Test Name', Company='Test Company', Email='test@test.com', Phone='103', LeadSource='Email')
        };
    }

    @isTest
    public static void batchTest() {

        List<Lead> listLeads = [SELECT Id FROM Lead WHERE Email='test@test.com' ORDER BY CreatedDate];

        List<List<Lead>> listOfDuplicatesLeads = new List<List<Lead>>{ listLeads };

        Test.startTest();
            LeadMergerBatch batch = new LeadMergerBatch(listOfDuplicatesLeads);
            Database.executeBatch(batch, 1);
        Test.stopTest();

        List<Lead> remaining = [SELECT Id FROM Lead WHERE Email='test@test.com' AND IsDeleted=false];
        System.assertEquals(1, remaining.size());

        List<CustomLog__c> logs = [SELECT Type__c, Message__c, RelatedRecordId__c FROM CustomLog__c WHERE RelatedRecordId__c = :remaining[0].Id];
        System.assert(logs.size() > 0);
    }
}