({
    doInit : function(component, event, helper) {
        helper.onInit(component);
    },

    onSave : function(component, event, helper) {
        component.find("service").saveRecord(function(result) {
            var state = result.state;
            if(state === 'SUCCESS' || state === 'DRAFT') {
                // saved successfully
                var resultToast = $A.get("e.force:showToast");
                if (resultToast == undefined) {
                    alert("The record was saved");
                } else {
                    resultToast.setParams({
                        "title" : "Saved",
                        "message" : "The record was saved"
                    });
                    resultToast.fire();
                    helper.onInit(component);
                    component.getEvent("BoatReviewAdded").fire();
                }
            } else if (state === 'INCOMPLETE') {
                console.log("User is offline, device doesn't support drafts");
            } else if (state === 'ERROR') {
                console.log("Problem saving record: " + JSON.stringify(result.error));
            } else {
                console.log("Unknown problem: " + JSON.stringify(result.error));
            }
        })
    },
    
    onRecordUpdated : function(component, event, helper) {
        
    }
})
