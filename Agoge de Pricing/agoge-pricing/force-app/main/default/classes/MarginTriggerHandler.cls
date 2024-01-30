public with sharing class MarginTriggerHandler {
    //Variáveis
    List<Margin__c> oldRecords {get; set;} //Trigger.old - registros antigos em List
    List<Margin__c> newRecords {get; set;} //Trigger.new - registros novos em List
    
    Map<Id, Margin__c> oldMap {get; set;} //Trigger.oldMap - registros antigos em Map
    Map<Id, Margin__c> newMap {get; set;} //Trigger.newMap - registros novos em Map
    
    public MarginTriggerHandler(List<Margin__c> oldRecords, List<Margin__c> newRecords, Map<Id, Margin__c> oldMap,  Map<Id, Margin__c> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert(){
        MarginHelper.checkMarginFields(this.newRecords);
        MarginHelper.checkDuplicateMargins(this.newRecords);
    }
}