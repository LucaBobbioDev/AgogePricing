public with sharing class TaxTriggerHandler {
    List<Tax__c> oldRecords {get; set;}
    List<Tax__c> newRecords {get; set;}
    Map<Id, Tax__c> oldMap {get; set;}
    Map<Id, Tax__c> newMap {get; set;}
    
    public TaxTriggerHandler(List<Tax__c> oldRecords, List<Tax__c> newRecords, Map<Id, Tax__c> oldMap,  Map<Id, Tax__c> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert(){
        TaxHelper.checkDuplicateTaxes(this.newRecords);
    }
}