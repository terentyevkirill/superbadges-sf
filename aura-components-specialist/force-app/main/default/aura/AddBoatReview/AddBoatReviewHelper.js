({
    onInit : function(component) {
        component.find("service").getNewRecord(
            "BoatReview__c",
            null,
            false,
            $A.getCallback(function() {
                var record = component.get("v.simpleBoatReview");
                var error = component.get("v.recordError");
                if (error || record == null) {
                    comsole.log("Error initializing record template: " + error);
                } else {
                    component.set("v.boatReview.Boat__c", component.get("v.boat.Id"));
                    console.log("Record template initialized: " + record.apiName);
                }
            })
        )
    }
})
