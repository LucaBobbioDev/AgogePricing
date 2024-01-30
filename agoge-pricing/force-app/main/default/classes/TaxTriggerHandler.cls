public with sharing class TaxTriggerHandler {
    //Variáveis
    List<Tax__c> oldRecords {get; set;} //Trigger.old - registros antigos em List
    List<Tax__c> newRecords {get; set;} //Trigger.new - registros novos em List
    
    Map<Id, Tax__c> oldMap {get; set;} //Trigger.oldMap - registros antigos em Map
    Map<Id, Tax__c> newMap {get; set;} //Trigger.newMap - registros novos em Map
    
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