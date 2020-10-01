({
    doInit : function(component, event, helper) {
        helper.onInit(component);
    },

    onUserInfoClick : function(component, event, helper) {
        var userId = event.target.getAttribute("data-userid");
        var redirectToUserEvent = $A.get("e.force:navigateToSObject");
        if (redirectToUserEvent) {
            redirectToUserEvent.setParams({
                "recordId" : userId
            });
            redirectToUserEvent.fire();
        }
    }
})