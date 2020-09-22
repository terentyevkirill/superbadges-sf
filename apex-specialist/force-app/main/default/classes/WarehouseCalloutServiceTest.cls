@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    static void testGetCallout() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        HttpResponse res = WarehouseCalloutService.makeGetCallout();
        System.assertEquals(200, res.getStatusCode());
    }

    @isTest
    static void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        HttpResponse res = WarehouseCalloutService.makePostCallout('something');
        System.assertEquals(400, res.getStatusCode());
    }

    @isTest
    static void testRunWarehouseEquipmentSync() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }


}