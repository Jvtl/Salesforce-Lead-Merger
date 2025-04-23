public with sharing class LeadDuplicateMerger {
    
    public static void processBatch(List<Lead> leadsToMerge) {
        
        CustomLogger logger = CustomLogger.getInstance();
        Lead winningLead = new Lead(Id = leadsToMerge[0].Id);

        while (leadsToMerge.size() > 1) {

            List<Id> currentLeadIdsToMerge = new List<Id>();

            currentLeadIdsToMerge.add(leadsToMerge[1].Id);
            leadsToMerge.remove(1);

            if(leadsToMerge.size() > 1) {
                currentLeadIdsToMerge.add(leadsToMerge[1].Id);
                leadsToMerge.remove(1);
            }

            Database.MergeResult[] results = Database.merge(winningLead, currentLeadIdsToMerge, false);

            for (Database.MergeResult mergeResult : results) {

                if (!mergeResult.isSuccess()) {
                    String errorMessage = mergeResult.getErrors()[0].getStatusCode() + ': ' + mergeResult.getErrors()[0].getMessage();
                    logger.log('Merge failed for ' + mergeResult.getMergedRecordIds()[0] + ': ' + errorMessage, 'ERROR', winningLead.Id);
                } else {
                    logger.log('Merged ' + mergeResult.getMergedRecordIds()[0] + ' into ' + winningLead.Id, 'INFO', winningLead.Id);
                }
            }
        }

        logger.flush();
    }
}