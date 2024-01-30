public with sharing class OrderTriggerHandler {

    List<Order> oldRecords {get; set;} //Trigger.old - registros antigos em List
    List<Order> newRecords {get; set;} //Trigger.new - registros novos em List
    
    Map<Id, Order> oldMap {get; set;} //Trigger.oldMap - registros antigos em Map
    Map<Id, Order> newMap {get; set;} //Trigger.newMap - registros novos em Map

    public OrderTriggerHandler(List<Order> oldRecords, List<Order> newRecords, Map<Id, Order> oldMap,  Map<Id, Order> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeUpdate(){
        OrderHelper.preventAccountUpdate(this.oldMap, this.newMap);
        OrderHelper.preventOrderUpdate(this.oldMap, this.newMap);
    }
}