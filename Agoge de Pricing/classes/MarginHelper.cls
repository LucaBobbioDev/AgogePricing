public with sharing class MarginHelper {
    
    public static void checkMarginFields(List<Margin__c> marginsList){
        Set<Id> productIds = new Set<Id>();
        Set<Id> productHierarchyIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> accountGroupIds = new Set<Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();

        for (Margin__c margin : marginsList) {
          // Verifica a categoria Produto
            if (margin.Product__c != null && margin.ProductHierarchy__c != null) {
                margin.addError('Não é permitido preencher ambos os campos de Produto.');
            } else if (margin.Product__c != null) {
                productIds.add(margin.Product__c);
            } else if (margin.ProductHierarchy__c != null) {
                productHierarchyIds.add(margin.ProductHierarchy__c);
            } else {
                margin.addError('É obrigatório preencher pelo menos um campo de Produto.');
            }

            // Verifica a categoria Cliente
            if (margin.Account__c != null && margin.AccountGroup__c != null) {
                margin.addError('Não é permitido preencher ambos os campos de Cliente.');
            } else if (margin.Account__c != null) {
                accountIds.add(margin.Account__c);
            } else if (margin.AccountGroup__c != null) {
                accountGroupIds.add(margin.AccountGroup__c);
            } else {
                margin.addError('É obrigatório preencher pelo menos um campo de Cliente.');
            }

            // Verifica a categoria Localidade
            if (margin.City__c != null) {
                if (margin.State__c != null || margin.Country__c != null) {
                    margin.addError('Não é permitido preencher o campo City em conjunto com State ou Country.');
                } else {
                    cityIds.add(margin.City__c);
                }
            } else if (margin.State__c != null) {
                if (margin.City__c != null || margin.Country__c != null) {
                    margin.addError('Não é permitido preencher o campo State em conjunto com City ou Country.');
                } else {
                    stateIds.add(margin.State__c);
                }
            } else if (margin.Country__c != null) {
                if (margin.City__c != null || margin.State__c != null) {
                    margin.addError('Não é permitido preencher o campo Country em conjunto com City ou State.');
                } else {
                    countryIds.add(margin.Country__c);
                }
            } else {
                margin.addError('É obrigatório preencher pelo menos um campo de Localidade.');
            }
        }
    }

    public static void checkDuplicateMargins(List<Margin__c> marginsList){
        Set<Id> productIds = new Set<Id>();
        Set<Id> productHierarchyIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> accountGroupIds = new Set<Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();

        for (Margin__c margin : marginsList) {
            if (margin.Product__c != null) {
                productIds.add(margin.Product__c);
            }
            if (margin.ProductHierarchy__c != null) {
                productHierarchyIds.add(margin.ProductHierarchy__c);
            }
            if (margin.Account__c != null) {
                accountIds.add(margin.Account__c);
            }
            if (margin.AccountGroup__c != null) {
                accountGroupIds.add(margin.AccountGroup__c);
            }
            if (margin.City__c != null) {
                cityIds.add(margin.City__c);
            }
            if (margin.State__c != null) {
                stateIds.add(margin.State__c);
            }
            if (margin.Country__c != null) {
                countryIds.add(margin.Country__c);
            }
        }

        List<Margin__c> registeredMargins = [
            SELECT Id, Name, Product__c, ProductHierarchy__c, Account__c, AccountGroup__c, City__c, State__c, Country__c, Value__c 
            FROM Margin__c 
            WHERE Status__c = 'Approved' 
            AND (
                Product__c IN : productIds 
                OR ProductHierarchy__c IN : productHierarchyIds
                )    
            AND (
                Account__c IN : accountIds 
                OR AccountGroup__c IN : accountGroupIds
                )    
            AND (
                City__c IN : cityIds    
                OR State__c IN : stateIds    
                OR Country__c IN : countryIds
            )
        ];

        Set<String> marginSet = new Set<String>();

        for(Margin__c margin : registeredMargins){
            String marginKey = margin.Product__c + '-' + margin.ProductHierarchy__c + '-' + margin.Account__c + '-' + margin.AccountGroup__c + '-' + margin.City__c + '-' + margin.State__c + '-' + margin.Country__c;
            marginSet.add(marginKey);
        }

        for(Margin__c margin : marginsList){
            String marginKey = margin.Product__c + '-' + margin.ProductHierarchy__c + '-' + margin.Account__c + '-' + margin.AccountGroup__c + '-' + margin.City__c + '-' + margin.State__c + '-' + margin.Country__c;
            if(marginSet.contains(marginKey)){
                margin.addError('Não é permitido o cadastro de Margens duplicadas!');
            }
        }
    }
}