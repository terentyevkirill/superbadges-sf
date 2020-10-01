({
    onInit : function(component) {
        var boatId = component.get("v.boat").Id;
        console.log("Boat Id received in doInit: " + boatId);
        var action = component.get("c.getAll");
        action.setParams({
            "boatId" : boatId
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === 'SUCCESS') {
                var data = result.getReturnValue();
                component.set("v.boatReviews", data);
                console.log("BoatReviews received: " + data);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})
