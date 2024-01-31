public with sharing class FreightHelper {
    public static void checkFreightFields(List<Freight__c> freightsList){
        Set<Id> productIds = new Set<Id>();
        Set<Id> productHierarchyIds = new Set<Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();

        for (Freight__c freight : freightsList) {
            if (freight.Product__c != null && freight.ProductHierarchy__c != null) {
                freight.addError('Não é permitido preencher ambos os campos de Produto.');
            } else if (freight.Product__c != null) {
                productIds.add(freight.Product__c);
            } else if (freight.ProductHierarchy__c != null) {
                productHierarchyIds.add(freight.ProductHierarchy__c);
            } else {
                freight.addError('É obrigatório preencher pelo menos um campo de Produto.');
            }

            if (freight.City__c != null) {
                if (freight.State__c != null || freight.Country__c != null) {
                    freight.addError('Não é permitido preencher o campo City em conjunto com State ou Country.');
                } else {
                    cityIds.add(freight.City__c);
                }
            } else if (freight.State__c != null) {
                if (freight.City__c != null || freight.Country__c != null) {
                    freight.addError('Não é permitido preencher o campo State em conjunto com City ou Country.');
                } else {
                    stateIds.add(freight.State__c);
                }
            } else if (freight.Country__c != null) {
                if (freight.City__c != null || freight.State__c != null) {
                    freight.addError('Não é permitido preencher o campo Country em conjunto com City ou State.');
                } else {
                    countryIds.add(freight.Country__c);
                }
            } else {
                freight.addError('É obrigatório preencher pelo menos um campo de Localidade.');
            }
        }
    }

    public static void checkDuplicateFreights(List<Freight__c> freightsList){
        Set<Id> productIds = new Set<Id>();
        Set<Id> productHierarchyIds = new Set<Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();

        for (Freight__c freight : freightsList) {
            if (freight.Product__c != null) {
                productIds.add(freight.Product__c);
            }
            if (freight.ProductHierarchy__c != null) {
                productHierarchyIds.add(freight.ProductHierarchy__c);
            }
            if (freight.City__c != null) {
                cityIds.add(freight.City__c);
            }
            if (freight.State__c != null) {
                stateIds.add(freight.State__c);
            }
            if (freight.Country__c != null) {
                countryIds.add(freight.Country__c);
            }
        }

        List<Freight__c> registeredFreights = [
            SELECT Id, Name, Product__c, ProductHierarchy__c, City__c, State__c, Country__c, Value__c 
            FROM Freight__c 
            WHERE Status__c = 'Approved' 
            AND (Product__c IN : productIds OR ProductHierarchy__c IN : productHierarchyIds)     
            AND (City__c IN : cityIds OR State__c IN : stateIds OR Country__c IN : countryIds)
        ];

        Set<String> freightSet = new Set<String>();
        for(Freight__c freight : registeredfreights){
            String freightKey = freight.Product__c + '-' + freight.ProductHierarchy__c + '-' + freight.City__c + '-' + freight.State__c + '-' + freight.Country__c;
            freightSet.add(freightKey);
        }

        for (Freight__c freight : freightsList) {
            String freightKey = freight.Product__c + '-' + freight.ProductHierarchy__c + '-' + freight.City__c + '-' + freight.State__c + '-' + freight.Country__c;
            if(freightSet.contains(freightKey)){
                freight.addError('Não é permitido o cadastro de Margens duplicadas!');
            }
        }
    }
}