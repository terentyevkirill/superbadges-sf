({
    onSearch : function(component) {
        var action = component.get("c.getBoats");
        action.setParams({"boatTypeId" : component.get("v.boatTypeId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var tmp = response.getReturnValue();
                component.set("v.boats", tmp);
                console.log("Received boats: " + tmp);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})
