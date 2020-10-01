({
    doInit : function(component, event, helper) {
        helper.loadBoatTypes(component, event);
        var selected = component.get("v.selectedBoatType");
        console.log("selected boat: " + selected);
        var isEnabled = $A.get("e.force:createRecord");
        if (isEnabled) {
            component.set("v.isNewButtonAvailable", true);
        }
    },

    onBoatTypeChanged : function(component, event, helper) {
        component.set("v.selectedBoatType", component.find("boatTypes").get("v.value"));
    },

    createBoat : function(component, event, helper) {
        var boatTypeId = component.get("v.selectedBoatType");
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName" : "Boat__c",
            "defaultFieldValues" : {"BoatType__c" : boatTypeId}
        });
        console.log("boatTypeId: " + boatTypeId);
        createRecordEvent.fire();
    },

    onFormSubmit : function(component, event, helper) {
        var boatTypeId = component.find("boatTypes").get("v.value");
        var data = {
            "boatTypeId" : boatTypeId
        };
        var formsubmit = component.getEvent("formsubmit");
        formsubmit.setParams({
            "formData" : data
        });
        formsubmit.fire();
    }
})
