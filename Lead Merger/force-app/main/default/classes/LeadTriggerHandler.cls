public with sharing class LeadTriggerHandler {

    public static void handleTrigger(List<Lead> triggerNew, List<Lead> triggerOld, Map<Id, Lead> triggerNewMap, Map<Id, Lead> triggerOldMap, System.TriggerOperation triggerEvent) {
        switch on triggerEvent {
            when BEFORE_INSERT {
                handleBeforeInsert(triggerNew);
            }

            when AFTER_INSERT {
                handleAfterInsert(triggerNew, triggerNewMap);
            }

            when BEFORE_UPDATE {
                handleBeforeUpdate(triggerNew, triggerOld, triggerNewMap, triggerOldMap);
            }

            when AFTER_UPDATE {
                handleAfterUpdate(triggerNew, triggerOld, triggerNewMap, triggerOldMap);
            }

            when BEFORE_DELETE {
                handleBeforeDelete(triggerOld, triggerOldMap);
            }

            when AFTER_DELETE {
                handleAfterDelete(triggerOld, triggerOldMap);
            }

            when AFTER_UNDELETE {
                handleAfterUndelete(triggerNew, triggerNewMap);
            }

            when else {

            }
        }
    }

    private static void handleBeforeInsert(List<Lead> triggerNew) {
    }

    private static void handleAfterInsert(List<Lead> triggerNew, Map<Id, Lead> triggerNewMap) {
        if (!TriggerContext.hasHandledLeadDuplicates) {
            TriggerContext.hasHandledLeadDuplicates = true;
            LeadDuplicateHandler.handleDuplicateLeads(triggerNew);
            CustomLogger logger = CustomLogger.getInstance();
            logger.log('LeadTriggerHandler handleAfterInsert first Lead: ' + triggerNew[0]?.Id, 'INFO', null);
            logger.flush();
        }
    }

    private static void handleBeforeUpdate(List<Lead> triggerNew, List<Lead> triggerOld, Map<Id, Lead> triggerNewMap, Map<Id, Lead> triggerOldMap) {
    }

    private static void handleAfterUpdate(List<Lead> triggerNew, List<Lead> triggerOld, Map<Id, Lead> triggerNewMap, Map<Id, Lead> triggerOldMap) {
    }

    private static void handleBeforeDelete(List<Lead> triggerOld, Map<Id, Lead> triggerOldMap) {
    }

    private static void handleAfterDelete(List<Lead> triggerOld, Map<Id, Lead> triggerOldMap) {
    }

    private static void handleAfterUndelete(List<Lead> triggerNew, Map<Id, Lead> triggerNewMap) {
    }
}