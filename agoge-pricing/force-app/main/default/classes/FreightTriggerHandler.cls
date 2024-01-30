public with sharing class FreightTriggerHandler {
    //Variáveis
    List<Freight__c> oldRecords {get; set;} //Trigger.old - registros antigos em List
    List<Freight__c> newRecords {get; set;} //Trigger.new - registros novos em List
    
    Map<Id, Freight__c> oldMap {get; set;} //Trigger.oldMap - registros antigos em Map
    Map<Id, Freight__c> newMap {get; set;} //Trigger.newMap - registros novos em Map
    
    public FreightTriggerHandler(List<Freight__c> oldRecords, List<Freight__c> newRecords, Map<Id, Freight__c> oldMap,  Map<Id, Freight__c> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert(){
        FreightHelper.checkFreightFields(this.newRecords);
        FreightHelper.checkDuplicateFreights(this.newRecords);
    }
}