public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller) {
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows() {
        for (Integer i = 0; i < Constants.DEFAULT_ROWS; i++) {
            productsToInsert.add(new ProductWrapper());
        }
    }

    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for (Schema.PicklistEntry ple_i : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(ple_i.getValue(), ple_i.getLabel()));
        }

        return options;
    }

    public List<ChartHelper.ChartData> GetInventory() {
        return ChartHelper.GetInventory();
    }

    public PageReference Save() {
        Savepoint sp = Database.setSavepoint();
        Integer insertCount = 0;
        try {
            List<Product2> productList = new List<Product2>();
            List<PricebookEntry> pbeList = new List<PricebookEntry>();
            List<ProductWrapper> filteredProductWrappers = new List<ProductWrapper>();
            for (ProductWrapper pw_i : productsToInsert) {
                Boolean hasData =   !String.isBlank(pw_i.productRecord.Name) &&
                                    !String.isBlank(pw_i.productRecord.Family) &&
                                    pw_i.productRecord.Family != Constants.SELECT_ONE &&
                                    pw_i.productRecord.isActive &&
                                    pw_i.productRecord.Initial_Inventory__c != null &&
                                    pw_i.productRecord.Initial_Inventory__c != 0 &&
                                    pw_i.pricebookEntryRecord.UnitPrice != null &&
                                    pw_i.pricebookEntryRecord.UnitPrice != 0;
                if (hasData) {
                    filteredProductWrappers.add(pw_i);
                }
            }
            for (ProductWrapper pw_i : filteredProductWrappers) {
                productList.add(pw_i.productRecord);
            }

            Database.SaveResult[] productSaveResults = Database.insert(productList, false);
            for (Integer i = 0; i < productSaveResults.size(); i++) {
                if (productSaveResults[i].isSuccess()) {
                    PricebookEntry pbe = filteredProductWrappers[i].pricebookEntryRecord;
                    pbe.Product2Id = productSaveResults[i].getId();
                    pbe.IsActive = true;
                    pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    pbeList.add(pbe);
                    insertCount++;
                }
            }

            insert pbeList;

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessage(new Apexpages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }

    public class ProductWrapper {
        public Product2 productRecord { get; set; }
        public PricebookEntry pricebookEntryRecord { get; set; }

        public ProductWrapper() {
            productRecord = new Product2();
            pricebookEntryRecord = new PricebookEntry();
        }
    }

}