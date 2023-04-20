public with sharing class OrderHelper {
    public static void preventAccountUpdate(Map<Id, Order> oldMap, Map<Id, Order> newMap) {
        for (Id orderId : newMap.keySet()) {
            Order newOrder = newMap.get(orderId);
            Order oldOrder = oldMap.get(orderId);
            if (newOrder.AccountId != null && newOrder.AccountId != oldOrder.AccountId) {
                newOrder.addError('Não é possível atualizar a conta do pedido');
            }
        }
    }
    
    public static void preventOrderUpdate(Map<Id, Order> oldMap, Map<Id, Order> newMap) {
        for (Order order : newMap.values()) {
            if (oldMap.containsKey(order.Id) && oldMap.get(order.Id).Status == 'Activated' && order.Status == 'Activated') {
                System.debug('Order: ' + order.Id + ' cannot be updated because it is marked as "Activated"');
                order.addError('Não é possível atualizar um pedido marcado como "Ativo".');
            }
        }
    }
}