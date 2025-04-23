public without sharing class CustomLogger {

    private static CustomLogger instance;
    private List<CustomLog__c> logs = new List<CustomLog__c>();

    private CustomLogger() { }

    public static CustomLogger getInstance() {
        if (instance == null) {
            instance = new CustomLogger();
        }
        return instance;
    }

    public void log(String message, String type, Id relatedRecordId) {
        logs.add(new CustomLog__c(
            Message__c = message,
            Type__c   = type,
            RelatedRecordId__c = relatedRecordId
        ));
    }

    public void flush() {
        if (!logs.isEmpty()) {
            try {
                insert logs;
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, 'CustomLogger failed to insert logs: ' + e.getMessage());
            } finally {
                logs.clear();
            }
        }
    }
}