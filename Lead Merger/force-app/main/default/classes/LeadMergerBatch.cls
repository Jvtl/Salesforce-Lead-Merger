public with sharing class LeadMergerBatch implements Database.Batchable<List<Lead>> {

    private final List<List<Lead>> listOfDuplicatedLeadLists;

    public LeadMergerBatch(List<List<Lead>> listOfDuplicatedLeadLists) {
        this.listOfDuplicatedLeadLists = listOfDuplicatedLeadLists;
    }

    public Iterable<List<Lead>> start(Database.BatchableContext bc) {
        return this.listOfDuplicatedLeadLists;
    }

    public void execute(Database.BatchableContext bc, List<List<Lead>> listOfDuplicatedLeadLists) {
        CustomLogger logger = CustomLogger.getInstance();
        List<Lead> currentList = listOfDuplicatedLeadLists[0];
        Lead winningLead = currentList[0];
        
        try {
            LeadDuplicateMerger.processBatch(currentList);
            logger.log('LeadMergerBatch execute winning lead: ' + winningLead, 'INFO', winningLead.Id);
        } catch (Exception e) {
            logger.log('Error merging leads: ' + e.getMessage(), 'ERROR', winningLead.Id);
        }

        logger.flush();
    }

    public void finish(Database.BatchableContext bc) {
        String jobId = bc.getJobId();
        CustomLogger logger = CustomLogger.getInstance();
        logger.log('LeadMergerBatch Finished Job ID: ' + jobId, 'INFO', jobId);
        logger.flush();
    }
}