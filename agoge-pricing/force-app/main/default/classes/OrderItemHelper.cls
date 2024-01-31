public with sharing class OrderItemHelper {
    public static void findMargin(List<OrderItem> orderItemList){
        IdSets idSets = new IdSets();

        for (OrderItem orderItem : orderItemList) {
            if (orderItem.Product2Id != null) {
                idSets.productIds.add(orderItem.Product2Id);
            }
        
            if (orderItem.OrderId != null) {
                idSets.orderIds.add(orderItem.OrderId);
            }
        }

        Map<Id, Order> ordersMap = new Map<Id, Order>([
            SELECT Id, AccountId, AccountAddress__c 
            FROM Order 
            WHERE Id IN :idSets.orderIds
        ]);

        Map<Id, Product2> productsMap = new Map<Id, Product2>([
            SELECT Id, ProductHierarchy__c 
            FROM Product2 
            WHERE Id IN :idSets.productIds
        ]);
        
        Map<Id, AccountAddress__c> accountAddressesMap = new Map<Id, AccountAddress__c>([
            SELECT Id, City__c, City__r.State__c, City__r.State__r.Country__c, Account__c, Account__r.AccountGroup__c
            FROM AccountAddress__c 
            WHERE Id IN (SELECT AccountAddress__c FROM Order WHERE Id IN :ordersMap.keySet())
        ]);

        for (OrderItem orderItem : orderItemList) {
            Order order = ordersMap.get(orderItem.OrderId);
            Product2 product = productsMap.get(orderItem.Product2Id);
            
            if (product != null && product.ProductHierarchy__c != null) {
                idSets.hierarchyIds.add(product.ProductHierarchy__c);
            }

            if (order.AccountId != null && order.AccountAddress__c != null) {
                List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                
                if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                    accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                }

                for(AccountAddress__c accountAddress : accountAddressList){
                    if (accountAddress.Account__c != null) {
                        idSets.accountIds.add(accountAddress.Account__c);
                    } 
                    
                    if (accountAddress.Account__r.AccountGroup__c != null) {
                        idSets.accountGroupIds.add(accountAddress.Account__r.AccountGroup__c);
                    }
        
                    if (accountAddress.City__c != null) {
                        idSets.cityIds.add(accountAddress.City__c);
                    }
            
                    if (accountAddress.City__r.State__c != null) {
                        idSets.stateIds.add(accountAddress.City__r.State__c);
                    }
            
                    if (accountAddress.City__r.State__r.Country__c != null) {
                        idSets.countryIds.add(accountAddress.City__r.State__r.Country__c);
                    }
                }
            }
        }

        List<Margin__c> selectedMargins = [
            SELECT Id, Name, Product__c, ProductHierarchy__c, Account__c, AccountGroup__c, City__c, State__c, Country__c, Value__c 
            FROM Margin__c 
            WHERE (Product__c IN :idSets.productIds OR ProductHierarchy__c IN :idSets.hierarchyIds)    
            AND (Account__c IN :idSets.accountIds OR AccountGroup__c IN :idSets.accountGroupIds)    
            AND (
                City__c IN :idSets.cityIds    
                OR State__c IN :idSets.stateIds    
                OR Country__c IN :idSets.countryIds
            )
            AND Status__c = 'Approved'    
        ];

        findSpecificMargin(orderItemList, selectedMargins, ordersMap, productsMap, accountAddressesMap);
    }

    public static void findFreight(List<OrderItem> orderItemList) {
        IdSets idSets = new IdSets();

        for (OrderItem orderItem : orderItemList) {
            if (orderItem.Product2Id != null) {
                idSets.productIds.add(orderItem.Product2Id);
            }
        
            if (orderItem.OrderId != null) {
                idSets.orderIds.add(orderItem.OrderId);
            }
        }

        Map<Id, Order> ordersMap = new Map<Id, Order>([
            SELECT Id, AccountId, AccountAddress__c 
            FROM Order 
            WHERE Id IN :idSets.orderIds
        ]);
        
        Map<Id, Product2> productsMap = new Map<Id, Product2>([
            SELECT Id, ProductHierarchy__c 
            FROM Product2 
            WHERE Id IN :idSets.productIds
        ]);
        
        Map<Id, AccountAddress__c> accountAddressesMap = new Map<Id, AccountAddress__c>([
            SELECT Id, City__c, City__r.State__c, City__r.State__r.Country__c, Account__c, Account__r.AccountGroup__c
            FROM AccountAddress__c 
            WHERE Id IN (SELECT AccountAddress__c FROM Order WHERE Id IN :ordersMap.keySet())
        ]);

        for (OrderItem orderItem : orderItemList) {
            Order order = ordersMap.get(orderItem.OrderId);
            Product2 product = productsMap.get(orderItem.Product2Id);

            if (product != null && product.ProductHierarchy__c != null) {
                idSets.hierarchyIds.add(product.ProductHierarchy__c);
            }

            if (order.AccountId != null && order.AccountAddress__c != null) {
                List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                
                if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                    accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                }
                
                for(AccountAddress__c accountAddress : accountAddressList){   
                    if (accountAddress.City__c != null) {
                        idSets.cityIds.add(accountAddress.City__c);
                    }
            
                    if (accountAddress.City__r.State__c != null) {
                        idSets.stateIds.add(accountAddress.City__r.State__c);
                    }
            
                    if (accountAddress.City__r.State__r.Country__c != null) {
                        idSets.countryIds.add(accountAddress.City__r.State__r.Country__c);
                    }
                }
            }
        }
        
        List<Freight__c> selectedFreights = [
            SELECT Id, Name, ProductHierarchy__c, Product__c, DistributionCenter__c, City__c, State__c, Country__c, Value__c
            FROM Freight__c
            WHERE (Product__c IN :idSets.productIds OR ProductHierarchy__c IN :idSets.hierarchyIds)
            AND (
                City__c IN :idSets.cityIds    
                OR State__c IN :idSets.stateIds    
                OR Country__c IN :idSets.countryIds
            )
            AND Status__c = 'Approved'
        ];

        findSpecificFreight(orderItemList, selectedFreights, ordersMap, productsMap, accountAddressesMap);
    }

    public static void findTax(List<OrderItem> orderItemList) {
        IdSets idSets = new IdSets();

        for (OrderItem orderItem : orderItemList) {
            if (orderItem.Product2Id != null) {
                idSets.productIds.add(orderItem.Product2Id);
            }
        
            if (orderItem.OrderId != null) {
                idSets.orderIds.add(orderItem.OrderId);
            }
        }

        Map<Id, Order> ordersMap = new Map<Id, Order>([
            SELECT Id, AccountId, AccountAddress__c, DistributionCenter__c 
            FROM Order 
            WHERE Id IN :idSets.orderIds
        ]);
        
        Map<Id, Product2> productsMap = new Map<Id, Product2>([
            SELECT Id, ProductHierarchy__c 
            FROM Product2 
            WHERE Id IN :idSets.productIds
        ]);
        
        Map<Id, AccountAddress__c> accountAddressesMap = new Map<Id, AccountAddress__c>([
            SELECT Id, City__c, City__r.State__c, City__r.State__r.Country__c, Account__c, Account__r.AccountGroup__c
            FROM AccountAddress__c 
            WHERE Id IN (SELECT AccountAddress__c FROM Order WHERE Id IN :ordersMap.keySet())
        ]);

        for (OrderItem orderItem : orderItemList) {
            Order order = ordersMap.get(orderItem.OrderId);
            Product2 product = productsMap.get(orderItem.Product2Id);

            if (order != null && order.DistributionCenter__c != null) {
                idSets.distributionCenterIds.add(order.DistributionCenter__c);
            }

            if (order.AccountId != null && order.AccountAddress__c != null) {
                List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                
                if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                    accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                }
                for(AccountAddress__c accountAddress : accountAddressList){   
                    if (accountAddress.City__r.State__c != null) {
                        idSets.stateIds.add(accountAddress.City__r.State__c);
                    }
                }
            }
        }

        List<Tax__c> selectedTaxes = [
            SELECT Name, Product__c, DistributionCenter__c, State__c, TaxCost__c 
            FROM Tax__c
            WHERE Product__c IN : idSets.productIds
            AND DistributionCenter__c IN :idSets.distributionCenterIds
            AND State__c IN :idSets.stateIds
            AND Status__c = 'Approved'
        ];

        findSpecificTax(orderItemList, selectedTaxes, ordersMap);
    }

    public static void findSpecificMargin(List<OrderItem> orderItemList, List<Margin__c> selectedMargins, Map<Id, Order> ordersMap, Map<Id, Product2> productsMap, Map<Id, AccountAddress__c> accountAddressesMap) {
        Integer highestScore = 0;
        List<Margin__c> specificMargin = new List<Margin__c>();
        for (Margin__c margin : selectedMargins) {
            Integer score = 0;
            if (margin.Product__c != null) {
                for (OrderItem orderItem : orderItemList) {
                    if (margin.Product__c == orderItem.Product2Id) {
                        
                        score += 2000;
                    }
                }
            } else if (margin.ProductHierarchy__c != null) {
                for (OrderItem orderItem : orderItemList) {
                    Product2 product = productsMap.get(orderItem.Product2Id);
                    if (margin.ProductHierarchy__c == product.ProductHierarchy__c) {
                        score += 1000;
                    }
                }
            }

            if (margin.Account__c != null) {
                for (OrderItem orderItem : orderItemList) {
                    Order order = ordersMap.get(orderItem.OrderId);
                    if (margin.Account__c == order.AccountId) {
                        score += 200;
                    }
                }
            } else if (margin.AccountGroup__c != null) {
                for (OrderItem orderItem : orderItemList) {
                    Order order = ordersMap.get(orderItem.OrderId);
                    List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                    if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                        accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                    }
                    for(AccountAddress__c accountAddress : accountAddressList){  
                        if(margin.AccountGroup__c == accountAddress.Account__r.AccountGroup__c){
                            score += 100;
                        }
                    }
                }
            }

            if(margin.City__c != null){
                for (OrderItem orderItem : orderItemList) {
                    Order order = ordersMap.get(orderItem.OrderId);
                    List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                    if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                        accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                    }
                    for(AccountAddress__c accountAddress : accountAddressList){   
                        if (margin.City__c == accountAddress.City__c) {
                            score += 30;
                        }
                    }
                }
            } else if(margin.State__c != null){
                for (OrderItem orderItem : orderItemList) {
                    Order order = ordersMap.get(orderItem.OrderId);
                    List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                    if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                        accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                    }
                    for(AccountAddress__c accountAddress : accountAddressList){   
                        if (margin.State__c == accountAddress.City__r.State__c) {
                            score += 20;
                        }
                    }
                }
            } else if(margin.Country__c != null){
                for (OrderItem orderItem : orderItemList) {
                    Order order = ordersMap.get(orderItem.OrderId);
                    List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                    if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                        accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                    }
                    for(AccountAddress__c accountAddress : accountAddressList){   
                        if (margin.Country__c == accountAddress.City__r.State__r.Country__c) {
                            score += 10;
                        }
                    }
                }
            }
            System.debug('Margem:' + margin +'Score:' + score);
            if (score > highestScore) {
                highestScore = score;
                specificMargin.clear();
                specificMargin.add(margin);
            } else if (score == highestScore) {
                specificMargin.add(margin);
            }
        }

        insertMarginPercentage(orderItemList, specificMargin);
    }
    
    public static void findSpecificFreight(List<OrderItem> orderItemList, List<Freight__c> selectedFreights, Map<Id, Order> ordersMap, Map<Id, Product2> productsMap, Map<Id, AccountAddress__c> accountAddressesMap) {
        Integer highestScore = 0;
        List<Freight__c> specificFreight = new List<Freight__c>();

        for(Freight__c freight : selectedFreights){
            Integer score = 0;
            if (freight.Product__c != null) {
                for (OrderItem orderItem : orderItemList) {
                    if (freight.Product__c == orderItem.Product2Id) {
                        score += 2000;
                    }
                }
            } else if (freight.ProductHierarchy__c != null) {
                for (OrderItem orderItem : orderItemList) {
                    if (freight.ProductHierarchy__c == productsMap.get(orderItem.Product2Id)?.ProductHierarchy__c) {
                        score += 1000;
                    }
                }
            }
            if(freight.City__c != null){
                for (OrderItem orderItem : orderItemList) {
                    Order order = ordersMap.get(orderItem.OrderId);
                    List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                    if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                        accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                    }
                    for(AccountAddress__c accountAddress : accountAddressList){   
                        if (freight.City__c == accountAddress.City__c) {
                            score += 30;
                        }
                    }
                }
            } else if(freight.State__c != null){
                for (OrderItem orderItem : orderItemList) {
                    Order order = ordersMap.get(orderItem.OrderId);
                    List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                    if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                        accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                    }
                    for(AccountAddress__c accountAddress : accountAddressList){   
                        if (freight.State__c == accountAddress.City__r.State__c) {
                            score += 20;
                        }
                    }
                }
            } else if(freight.Country__c != null){
                for (OrderItem orderItem : orderItemList) {
                    Order order = ordersMap.get(orderItem.OrderId);
                    List<AccountAddress__c> accountAddressList = new List<AccountAddress__c>();
                    if (accountAddressesMap.containsKey(order.AccountAddress__c)) {
                        accountAddressList.add(accountAddressesMap.get(order.AccountAddress__c));
                    }
                    for(AccountAddress__c accountAddress : accountAddressList){   
                        if (freight.Country__c == accountAddress.City__r.State__r.Country__c) {
                            score += 10;
                        }
                    }
                }
            }
            System.debug('Frete:' + freight +'Score:' + score);
            if (score > highestScore) {
                highestScore = score;
                specificFreight.clear();
                specificFreight.add(freight);
            } else if (score == highestScore) {
                specificFreight.add(freight);
            }
        }

        insertFreightValue(orderItemList, specificFreight);
    }
     
    public static void findSpecificTax(List<OrderItem> orderItemList, List<Tax__c> taxList, Map<Id, Order> ordersMap){
        List<Tax__c> specificTaxes = new List<Tax__c>();
        for(Tax__c tax : taxList){
            if (tax.Product__c != null && tax.DistributionCenter__c != null && tax.State__c != null) {
                for(OrderItem orderItem : orderItemList){
                    Order order = ordersMap.get(orderItem.OrderId);
                    if(tax.Product__c == orderItem.Product2Id && tax.DistributionCenter__c == order.DistributionCenter__c){
                        specificTaxes.add(tax);
                    }
                }
            }
        }

        insertTaxPercentage(orderItemList, specificTaxes);
    }

    public static void insertMarginPercentage(List<OrderItem> orderItemList, List<Margin__c> specificMargin){
        List<OrderItem> orderItemsToUpdate = new List<OrderItem>();

        for(OrderItem orderItem : orderItemList){
            for(Margin__c margin : specificMargin){
                    Decimal marginPercentage = margin.Value__c;
                    orderItem.MarginPercentage__c = marginPercentage;
                    orderItemsToUpdate.add(orderItem);
            }
        } 
    }

    public static void insertFreightValue(List<OrderItem> orderItemList, List<Freight__c> specificFreight){
        List<OrderItem> orderItemsToUpdate = new List<OrderItem>();

        for(OrderItem orderItem : orderItemList){
            for(Freight__c freight : specificFreight){
                    Decimal freightValue = freight.Value__c;
                    orderItem.FreightValue__c = freightValue;
                    orderItemsToUpdate.add(orderItem);
            }
        }    
    }

    public static void insertTaxPercentage(List<OrderItem> orderItemList, List<Tax__c> specificTax){
        List<OrderItem> orderItemsToUpdate = new List<OrderItem>();

        for(OrderItem orderItem : orderItemList){
            for(Tax__c tax : specificTax){
                Decimal taxPercentage = tax.TaxCost__c;
                orderItem.TaxPercentage__c = taxPercentage;
                orderItemsToUpdate.add(orderItem);
            }
        }
    }

    public static void checkPriceParameters(List<OrderItem> orderItemList){
        for(OrderItem orderItem : orderItemList){
            if(orderItem.ListPrice == null){
                orderItem.addError('Não está autorizada a venda deste produto devido a falta do parâmetro de custo de produção');
            }
            if(orderItem.FreightValue__c == null){
                orderItem.addError('Não está autorizada a venda deste produto devido a falta de parâmetro de valor de frete');
            }
            if(orderItem.TaxPercentage__c == null){
                orderItem.addError('Não está autorizada a venda deste produto devido a falta de parâmetro de imposto');
            }
            if(orderItem.MarginPercentage__c == null){
                orderItem.addError('Não está autorizada a venda deste produto devido a falta de parâmetro de margem ');
            }
        }
    }

    public static void calcPrice(List<OrderItem> orderItemList){    
        for (OrderItem orderItem : orderItemList) {
            Decimal productionCost = orderItem.ListPrice != null ? orderItem.ListPrice : 0;
            Decimal freight = orderItem.FreightValue__c != null ? orderItem.FreightValue__c : 0;
            Decimal tax = orderItem.TaxPercentage__c != null ? orderItem.TaxPercentage__c : 0;
            Decimal margin = orderItem.MarginPercentage__c != null ? orderItem.MarginPercentage__c : 0;

            Decimal priceWithoutMargin = (productionCost + freight) * (1 + (tax / 100));
            Decimal finalPrice = (productionCost + freight) * ( 1+ ( tax / 100 )) * (1 + (margin / 100));
            Decimal discount = (finalPrice - orderItem.UnitPrice) / finalPrice;
            
            orderItem.PriceWithoutMargin__c = priceWithoutMargin;
            orderItem.FinalPrice__c = finalPrice;
            orderItem.Discount__c = discount;
        }
    }

    public static void updateOrderItemFields(List<OrderItem> orderItemList) {
        Set<Id> orderIds = new Set<Id>();
        for (OrderItem orderItem : orderItemList) {
            orderIds.add(orderItem.OrderId);
        }
    
        Map<Id, Order> orderMap = new Map<Id, Order>([
            SELECT Id, Status 
            FROM Order 
            WHERE Id IN :orderIds
        ]);
    
        findMargin(orderItemList);
        findFreight(orderItemList);
        findTax(orderItemList);
        calcPrice(orderItemList);
        System.debug('Order item fields updated successfully.');
    }

    public static void preventOrderItemUpdate(Map<Id, OrderItem> oldMap, Map<Id, OrderItem> newMap) {
        Set<Id> orderIds = new Set<Id>();
        for (OrderItem orderItem : newMap.values()) {
            orderIds.add(orderItem.OrderId);
        }
            
        Map<Id, Order> orderMap = new Map<Id, Order>([
            SELECT Id, Status 
            FROM Order 
            WHERE Id IN :orderIds
        ]);
            
        for (OrderItem orderItem : newMap.values()) {
            Order oldOrder = oldMap.get(orderItem.Id) != null ? orderMap.get(oldMap.get(orderItem.Id).OrderId) : null;
            Order currentOrder = orderMap.get(orderItem.OrderId);
            if (currentOrder != null && currentOrder.Status == 'Activated' && oldOrder != null && oldOrder.Status == 'Activated') {
                orderItem.addError('Não é possível atualizar um item de pedido de um pedido marcado como "Ativo".');
            }
        }
    }
    
    public class IdSets {
        public Set<Id> orderIds { get; set; }
        public Set<Id> distributionCenterIds {get; set;}

        public Set<Id> productIds { get; set; }
        public Set<Id> hierarchyIds { get; set; }

        public Set<Id> accountIds { get; set; }
        public Set<Id> accountGroupIds { get; set; }

        public Set<Id> cityIds { get; set; }
        public Set<Id> stateIds { get; set; }
        public Set<Id> countryIds { get; set; }
    
        public IdSets() {
            this.orderIds = new Set<Id>();
            this.distributionCenterIds = new Set<Id>();

            this.productIds = new Set<Id>();
            this.hierarchyIds = new Set<Id>();

            this.accountIds = new Set<Id>();
            this.accountGroupIds = new Set<Id>();

            this.cityIds = new Set<Id>();
            this.stateIds = new Set<Id>();
            this.countryIds = new Set<Id>();
        }
    }
}