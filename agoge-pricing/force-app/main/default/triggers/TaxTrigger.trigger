trigger TaxTrigger on Tax__c (before insert) {
    //Instanciando a classe TaxTriggerHandler
    TaxTriggerHandler handler = new TaxTriggerHandler(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);

    switch on Trigger.operationType{
        when BEFORE_INSERT{
            handler.beforeInsert();
        }
    }
}