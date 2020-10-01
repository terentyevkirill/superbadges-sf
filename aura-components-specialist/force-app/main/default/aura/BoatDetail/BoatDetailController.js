({
    init : function(component, event, helper) {
        var redirectToSObjectPageEvent = $A.get("e.force:navigateToSObject");
        if(redirectToSObjectPageEvent){
            component.set("v.displaybutton",true);
        }  
    },
   
    onFullDetails : function(component, event, helper) {
        var redirectToSObjectPageEvent = $A.get("e.force:navigateToSObject");
        var boatRecord=component.get("v.boat");
        if (boatRecord) {
            redirectToSObjectPageEvent.setParams({
                "recordId": "00QB0000000ybNX",
                "slideDevName": "detail"
            });
            redirectToSObjectPageEvent.fire();
        }
    }
})