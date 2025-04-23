public with sharing class LeadDuplicateHandler {
    
    public static void handleDuplicateLeads(List<Lead> listLeads) {

        Map<String, List<Lead>> mapOfDuplicatesByUniqueKey = buildDuplicateMap(listLeads);
        List<List<Lead>> listOfDuplicateGroupsToMerge = buildDuplicateLists(mapOfDuplicatesByUniqueKey);
        
        LeadMergerBatch batch = new LeadMergerBatch(listOfDuplicateGroupsToMerge);
        Id batchId = Database.executeBatch(batch, 1);

        CustomLogger logger = CustomLogger.getInstance();
        logger.log('LeadDuplicateHandler handleDuplicateLeads batch id: ' + batchId, 'INFO', batchId);
        logger.flush();
    }

    public static Map<String, List<Lead>> buildDuplicateMap(List<Lead> listLeads) {

        Map<String, List<Lead>> mapOfDuplicatesByUniqueKey = new Map<String, List<Lead>>();

        for(Lead currentLead : listLeads)
        {
            String matchingKey = searchMatchingUniqueKey(currentLead, mapOfDuplicatesByUniqueKey.keySet());

            if(matchingKey == '') {
                matchingKey = buildUniqueKey(currentLead);
                mapOfDuplicatesByUniqueKey.put(matchingKey, new List<Lead>());
            }
    
            mapOfDuplicatesByUniqueKey.get(matchingKey).add(currentLead);
            
        }
    
        return mapOfDuplicatesByUniqueKey;
    }
    
    public static String searchMatchingUniqueKey(Lead currentLead, Set<String> listUniqueKeys) {
    
        String matchingKey = '';
    
        for(String currentKey : listUniqueKeys) {
    
            List<String> listCurrentKeyValues = currentKey.split('&&&');
            Integer matchesCount = 0;
    
            if(currentLead.LeadSource != listCurrentKeyValues[0])
                continue;
    
            if(currentLead.LastName == listCurrentKeyValues[1])
                matchesCount++;
    
            if(currentLead.Email == listCurrentKeyValues[2])
                matchesCount++;
    
            if(currentLead.Phone == listCurrentKeyValues[3])
                matchesCount++;
    
            if(matchesCount >= 2)
            {
                matchingKey = currentKey;
                break;
            }
        }
    
        return matchingKey;
    }

    public static String buildUniqueKey(Lead currentLead) {
    
        String uniqueKey = currentLead.LeadSource + '&&&' + currentLead.LastName + '&&&' + currentLead.Email + '&&&' + currentLead.Phone;
    
        return uniqueKey;
    }

    public static List<List<Lead>> buildDuplicateLists(Map<String, List<Lead>> mapOfDuplicatesByUniqueKey) {
    
        List<List<Lead>> finalLists = new List<List<Lead>>();
    
        Integer maxListSize = 301; //This is to limit the number of DML merge operations. 301 is 1 winning record + 300 duplicates, each merge can use 3 records, so 150 DML operations
    
        for(List<Lead> currentList : mapOfDuplicatesByUniqueKey.values()) {
            Lead winningRecord = currentList[0];
            Integer currentListSize = currentList.size();

            if(currentListSize == 1)
                continue;

            if(currentListSize <= maxListSize) {
                finalLists.add(currentList);
                continue;
            } 
            
            List<Lead> newCurrentList = new List<Lead>();
            
            for (Lead leadRecord : currentList) {

                if (newCurrentList.size() == maxListSize) {
                    finalLists.add(newCurrentList);
                    newCurrentList = new List<Lead>();
                    newCurrentList.add(winningRecord);
                }
                newCurrentList.add(leadRecord);
            }

            if (!newCurrentList.isEmpty()) {
                finalLists.add(newCurrentList);
            }
        }
    
        return finalLists;
    }
}