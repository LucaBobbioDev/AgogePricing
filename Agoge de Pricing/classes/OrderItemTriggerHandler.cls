public with sharing class OrderItemTriggerHandler {
    
    //Variáveis
    List<OrderItem> oldRecords {get; set;} //Trigger.old - registros antigos em List
    List<OrderItem> newRecords {get; set;} //Trigger.new - registros novos em List
    
    Map<Id, OrderItem> oldMap {get; set;} //Trigger.oldMap - registros antigos em Map
    Map<Id, OrderItem> newMap {get; set;} //Trigger.newMap - registros novos em Map

    //Método construtor
    public OrderItemTriggerHandler(List<OrderItem> oldRecords, List<OrderItem> newRecords, Map<Id, OrderItem> oldMap,  Map<Id, OrderItem> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert(){
        OrderItemHelper.findMargin(this.newRecords);
        OrderItemHelper.findFreight(this.newRecords);
        OrderItemHelper.findTax(this.newRecords);
        
        OrderItemHelper.checkPriceParameters(this.newRecords);
        OrderItemHelper.calcPrice(this.newRecords);
    }

    public void beforeUpdate(){
        OrderItemHelper.updateOrderItemFields(this.newRecords);
        OrderItemHelper.preventOrderItemUpdate(this.oldMap, this.newMap);
    }
}