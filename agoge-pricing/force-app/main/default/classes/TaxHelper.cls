public with sharing class TaxHelper {
    public static void checkDuplicateTaxes(List<Tax__c> taxList){
        Set<Id> productIds = new Set<Id>();
        Set<Id> distributionCenterIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();

        for(Tax__c tax : taxList){
            if(tax.Product__c != null){
                productIds.add(tax.Product__c);
            }
            
            if(tax.DistributionCenter__c != null){
                distributionCenterIds.add(tax.DistributionCenter__c);
            }
           
            if(tax.State__c != null){
                stateIds.add(tax.State__c);
            }
        }
        
        List<Tax__c> registeredTaxes = [
            SELECT Name, Product__c, DistributionCenter__c, State__c, TaxCost__c 
            FROM Tax__c
            WHERE Status__c = 'Approved'
            AND(
                Product__c IN: productIds
                AND DistributionCenter__c IN: distributionCenterIds
                AND State__c IN: stateIds
            )
        ];

        Set<String> taxSet = new Set<String>();

        for(Tax__c tax : registeredTaxes){
            String taxKey = tax.Product__c + ':' + tax.DistributionCenter__c + ':' + tax.State__c + ':' + String.valueOf(tax.TaxCost__c);
            taxSet.add(taxKey);
        }

        for(Tax__c tax : taxList){
            String taxKey = tax.Product__c + ':' + tax.DistributionCenter__c + ':' + tax.State__c + ':' + String.valueOf(tax.TaxCost__c);
            if(taxSet.contains(taxKey)){
                tax.addError('Não é permitido o cadastro de Impostos duplicados!');
            }
        }
    }
}