/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup() {
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
            CollaborationType = 'Public'
        );

        return chatterGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < cnt; i++) {
            Product2 product = new Product2(
                Name = 'testProduct' + i,
                IsActive = true,
                Initial_Inventory__c = 10,
                Family = Constants.PRODUCT_FAMILY[Math.mod(i, 4)].getValue()
            );
            products.add(product);
        }

        return products;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 prod_i : prods) {
            PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod_i.Id,
                IsActive = true,
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                UnitPrice = 100
            );
            pbes.add(pbe);
        }

        return pbes;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < cnt; i++) {
            Account acct = new Account(Name = 'Account' + i);
            accounts.add(acct);
        }

        return accounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < cnt; i++) {
            Contact con = new Contact(
                LastName = 'Contact' + i,
                AccountId = accts.get(Math.mod(i, accts.size())).Id
            );
            contacts.add(con);
        }

        return contacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < cnt; i++) {
            Order ord = new Order(
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                AccountId = accts.get(Math.mod(i, accts.size())).Id
            );
            orders.add(ord);
        }

        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i < cnt; i++) {
            OrderItem item = new OrderItem(
                Quantity = Constants.DEFAULT_ROWS,
                UnitPrice = 100,
                OrderId = ords.get(Math.mod(i, ords.size())).Id,
                PricebookEntryId = pbes.get(Math.mod(i, pbes.size())).Id
            );
            orderItems.add(item);
        }

        return orderItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        CollaborationGroup collaborationGroup = ConstructCollaborationGroup();
        insert collaborationGroup;

        List<Product2> products = ConstructProducts(cnt);
        insert products;

        List<PricebookEntry> pbes = ConstructPricebookEntries(products);
        insert pbes;

        List<Account> accts = ConstructAccounts(cnt);
        insert accts;

        List<Contact> contacts = ConstructContacts(cnt, accts);
        insert contacts;

        List<Order> orders = ConstructOrders(cnt, accts);
        insert orders;

        List<OrderItem> items = ConstructOrderItems(cnt, pbes, orders);
        insert items;
    }

}