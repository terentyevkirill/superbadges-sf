public with sharing class BillingCalloutService {
    
    @future(callout=true)
    public static void callBillingService(String projectRef, Decimal billingAmount) {

        ServiceCredentials__c creds = ServiceCredentials__c.getValues('BillingServiceCredential');
        BillingServiceProxy.project projectInstance = new BillingServiceProxy.project();
        projectInstance.username = creds.Username__c;
        projectInstance.password = creds.Password__c;
        projectInstance.projectid = projectRef;
        projectInstance.billAmount = billingAmount;

        BillingServiceProxy.InvoicesPortSoap11 invPortSoapInst = new BillingServiceProxy.InvoicesPortSoap11();
        String response = invPortSoapInst.billProject(projectInstance);

        List<Project__c> projects = new List<Project__c>();
        if (response != null && response.equals('OK')) {
            Project__c proj = [SELECT Id, Status__c FROM Project__c WHERE ProjectRef__c = :projectRef];
            proj.Status__c = 'Billed';
            projects.add(proj);
        }
        update projects;
    }
}
