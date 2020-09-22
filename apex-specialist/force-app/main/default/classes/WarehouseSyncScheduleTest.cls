@isTest
public class WarehouseSyncScheduleTest {
    
    @isTest
    static void test() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        WarehouseSyncSchedule wss = new WarehouseSyncSchedule();
        String chron = '0 0 23 * * ?';
        System.schedule('Test WarehouseSyncSchedule', chron, wss);
        Test.stopTest();
    }
}
