@isTest
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    static TestMethod void Product2Extension_UnitTest() {
        // Set-up user
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        	EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        	LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName=uniqueUserName);

        System.runAs(u) {
            PageReference pageRef = Page.Product2New;
            Test.setCurrentPage(pageRef);
            Product2 prod = new Product2(name='Test',isActive=true);
            ApexPages.StandardController stdc = new ApexPages.StandardController(prod);
            Product2Extension ext = new Product2Extension(stdc);        
            System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());

            ext.addRows();
            System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());

            integer x = 0; 
            for (Product2Extension.ProductWrapper pw_i : ext.productsToInsert){
                pw_i.productrecord.name='TESTPRODUCT ' + x;
                pw_i.productRecord.IsActive = true;
                pw_i.productRecord.Initial_Inventory__c = 20;
                pw_i.productRecord.Family = Constants.PRODUCT_FAMILY[0].getValue();           
                pw_i.pricebookEntryRecord.UnitPrice = 10;
                x++; 
                if (x == Constants.DEFAULT_ROWS) {
                    break;
                }
            }

            ext.Save();
            List<Product2> createdProducts = [SELECT Id FROM Product2];
            System.assertEquals(5, createdProducts.size());

            ext.GetFamilyOptions();
            ext.GetInventory();
        }
    }
}