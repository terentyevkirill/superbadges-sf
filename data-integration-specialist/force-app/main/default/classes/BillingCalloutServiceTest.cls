@isTest
public class BillingCalloutServiceTest {
    @TestSetup
    static void makeData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        insert opp;
        
        Project__c proj = new Project__c();
        proj.Name = 'Test Project';
        proj.Billable_Amount__c = 1000;        
        proj.ProjectRef__c = 'TestRef1';
        proj.Status__c = 'Running';
        proj.Opportunity__c = opp.Id;
        insert proj;
        
        ServiceCredentials__c creds = new ServiceCredentials__c();
        creds.Name = 'BillingServiceCredential';
        creds.Username__c = 'usr1';
        creds.Password__c = 'pwd1';
        insert creds;
    }

    @isTest
    static void testCallBillingServiceSuccess() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock()); 
        Project__c project = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'TestRef1'];
        Test.startTest(); 
            project.Status__c = 'Billable';
            update project;
        Test.stopTest();
    }

    @isTest
    static void testCallBillingServiceFailure() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure()); 
        Project__c project = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'TestRef1'];
        Test.startTest(); 
            project.Status__c = 'Running';
            update project;
        Test.stopTest();
    }
}
