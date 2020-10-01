public with sharing class BoatReviews {

    @AuraEnabled
    public static List<BoatReview__c> getAll(Id boatId) {
        return [
            SELECT 
                Id, 
                Name, 
                Comment__c, 
                Boat__c, 
                Rating__c,
                CreatedDate,
                LastModifiedDate,
                CreatedBy.Id,
                CreatedBy.Name,
                CreatedBy.CompanyName,
                CreatedBy.SmallPhotoUrl
            FROM BoatReview__c
            WHERE
                Boat__c = :boatId
        ];
    }

}
