public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());
            System.debug('results: ' + results);
            List<Product2> equipmentToUpdate = new List<Product2>();
            for (Object result_i : results) {
                Map<String, Object> item = (Map<String, Object>) result_i;
                Product2 newEqp = new Product2(
                    Warehouse_SKU__c = String.valueOf(item.get('sku')),
                    Replacement_Part__c = (Boolean) item.get('replacement'),
                    Cost__c = (Decimal) item.get('cost'),
                    Name = String.valueOf(item.get('name')),
                    Current_Inventory__c = Integer.valueOf(item.get('quantity')),
                    Lifespan_Months__c = Integer.valueOf(item.get('lifespan')),
                    Maintenance_Cycle__c = Integer.valueOf(item.get('maintenanceperiod')),
                    ProductCode = String.valueOf(item.get('_id'))
                );
                System.debug('Received product:' + newEqp);
                equipmentToUpdate.add(newEqp);
            }
            upsert equipmentToUpdate Warehouse_SKU__c;
        }   
    }
}