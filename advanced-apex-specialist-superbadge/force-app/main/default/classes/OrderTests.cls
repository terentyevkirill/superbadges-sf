@isTest
private class OrderTests {

    @testSetup
    static void SetupTestData() {
        TestDataFactory.InsertTestData(Constants.DEFAULT_ROWS);
    }

    @isTest
    static void OrderUpdate_UnitTest() {
        List<Order> orders = [SELECT Id, Name, Status FROM Order];
        for (Order order_i : orders) {
            OrderItem originalItem = [
                SELECT
                    Id,
                    PricebookEntry.Product2Id
                FROM
                    OrderItem
                WHERE
                    OrderId = :order_i.Id
            ];
            Product2 originalProduct = [
                SELECT
                    Id,
                    Name,
                    Family,
                    Quantity_Ordered__c,
                    Quantity_Remaining__c
                FROM
                    Product2
                WHERE 
                    Id = :originalItem.PricebookEntry.Product2Id 
            ];
            order_i.Status = Constants.ACTIVATED_ORDER_STATUS;
            update order_i;

            OrderItem updatedItem = [
                SELECT
                    Id,
                    PricebookEntry.Product2Id
                FROM
                    OrderItem
                WHERE
                    OrderId = :order_i.Id
            ];
            Product2 updatedProduct = [
                SELECT
                    Id,
                    Name,
                    Family,
                    Quantity_Ordered__c,
                    Quantity_Remaining__c
                FROM
                    Product2
                WHERE 
                    Id = :originalItem.PricebookEntry.Product2Id 
            ];

            TestDataFactory.VerifyQuantityOrdered(originalProduct, updatedProduct, Constants.DEFAULT_ROWS);
        }
    }

}