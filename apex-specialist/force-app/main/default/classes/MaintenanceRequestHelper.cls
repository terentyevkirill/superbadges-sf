public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(Map<Id, Case> caseMap) {
        Map<Id, Integer> productIdMap = new Map<Id, Integer>();
        List<Case> newCaseList = new List<Case>();
        List<Product2> productList = [select Id, Maintenance_Cycle__c from Product2];     
        for (Product2 product_i : productList) {
            if (product_i != null && product_i.Maintenance_Cycle__c != null) {
                productIdMap.put(product_i.Id, Integer.valueOf(product_i.Maintenance_Cycle__c));
            }
        }

        for (Case req_i : caseMap.values()) {
            Case newReq = new Case(
                Vehicle__c = req_i.Vehicle__c,
                Equipment__c = req_i.Equipment__c,
                Type = 'Routine Maintenance',
                Subject = String.isBlank(req_i.Subject) ? 'Future routine checkup' : req_i.Subject,
                Date_Reported__c = Date.today(),
                Status = 'New',
                Product__c = req_i.Product__c,
                AccountId = req_i.AccountId,
                ContactId = req_i.ContactId,
                AssetId = req_i.AssetId, 
                Origin = req_i.Origin,
                Reason = req_i.Reason,
                Date_Due__c = productIdMap.get(req_i.Id) != null ? Date.today().addDays(productIdMap.get(req_i.Id)) : Date.today()
            );
            newCaseList.add(newReq);
        }
        if (newCaseList.size() > 0) {
            insert newCaseList;
        }
    }        
}