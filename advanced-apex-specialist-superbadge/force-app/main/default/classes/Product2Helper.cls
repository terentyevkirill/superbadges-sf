public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST' + Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList, List<Product2> oldList){
        List<Product2> needsAnnouncement = new List<Product2>();
        Map<String, Inventory_Setting__mdt> stringToInventorySetting = new Map<String, Inventory_Setting__mdt>();
        for (Inventory_Setting__mdt set_i : [SELECT 
                                                DeveloperName,  
                                                Id,  
                                                Label,  
                                                Language,  
                                                Low_Quantity_Alert__c,  
                                                MasterLabel,  
                                                NamespacePrefix,  
                                                QualifiedApiName 
                                            FROM 
                                                Inventory_Setting__mdt]) {
            stringToInventorySetting.put(set_i.DeveloperName, set_i);
        }
        for (Product2 prod_i : newList) {
            Boolean hasToBeAnnounced =  stringToInventorySetting.containsKey(prod_i.Family) && 
                                        prod_i.Quantity_Remaining__c < stringToInventorySetting.get(prod_i.Family).Low_Quantity_Alert__c;
            if (hasToBeAnnounced) {
                needsAnnouncement.add(prod_i);
            }
        }
        PostAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.AnnouncementInput announcementInput = new ConnectApi.AnnouncementInput();

            announcementInput.sendEmails = false;
            announcementInput.expirationDate = Date.today().addDays(1);
            announcementInput.parentId = COLLABORATION_GROUP[0].Id;
            
            textSegmentInput.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;

            messageBodyInput.messageSegments = new List<ConnectApi.TextSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);

            announcementInput.body = messageBodyInput;
            toPost.add(announcementInput);
        }
        AnnouncementQueueable q = new AnnouncementQueueable();
        q.toPost = toPost;
        System.enqueueJob(q);
    }
}