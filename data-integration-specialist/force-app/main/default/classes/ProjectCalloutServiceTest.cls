@isTest
public class ProjectCalloutServiceTest {
    @TestSetup
    static void makeData(){
        Opportunity opp1 = new Opportunity(
            Name = 'Test opp 1',
            CloseDate = Date.today(),
            Amount = 150000,
            StageName = 'Submitted Project'
        );
        insert opp1;
        Opportunity opp2 = new Opportunity(
            Name = 'Test opp 2',
            CloseDate = Date.today(),
            Amount = 150000,
            StageName = 'Resubmit Project'
        );
        insert opp2;
        ServiceTokens__c token = new ServiceTokens__c(
            Name = 'ProjectServiceToken',
            Token__c = 'some-token-data'
        );
        insert token;
    }

    @isTest
    static void testProjectCallout() {
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        List<Id> oppIds = new List<Id>(oppMap.keySet());
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        ProjectCalloutService.postOpportunityToPMS(oppIds);
        Test.stopTest();
    }

    @isTest
    static void testProjectCalloutFailure() {
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        List<Id> oppIds = new List<Id>(oppMap.keySet());
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        ProjectCalloutService.postOpportunityToPMS(oppIds);
        Test.stopTest();
    }
}
