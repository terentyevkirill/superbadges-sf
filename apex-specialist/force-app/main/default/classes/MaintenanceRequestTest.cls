@isTest
public class MaintenanceRequestTest {
    @isTest
    static void testMaintenancerequestTrigger() {
        Case testCase = new Case(
                Type = 'Repair',
                Status = 'New'
            );
        insert testCase;

        Product2 testProduct = new Product2(
            Name = 'Test product',
            Maintenance_Cycle__c = 10
        );
        insert testProduct;

        testCase.Status = 'Closed';
        Test.startTest();
        update testCase;
        Test.stopTest();

    }
}
