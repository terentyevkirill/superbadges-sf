@isTest
public class ProjectRESTServiceTest {
    
    @TestSetup
    static void makeData(){
        Opportunity opp = new Opportunity(
            Name = 'Test opp',
            DeliveryInstallationStatus__c = 'Yet to begin',
            CloseDate = Date.today().addDays(7),
            Amount = 150000,
            StageName = 'Submitted Project'
        );
        insert opp;
    }   

    @isTest
    static void testPostProjectData() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        String result = ProjectRESTService.postProjectData('ProjectRef', 'ProjectName', String.valueOf(opp.Id), Date.today(), Date.today().addDays(7), 150000, 'Running');
        System.assertEquals('OK', result);
        List<Project__c> projects = [SELECT Id FROM Project__c];
        System.assert(projects.size() == 1);
        
    }

    @isTest
    static void testPostProjectDataFailure() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        String result = ProjectRESTService.postProjectData('ProjectRef', 'WrongProject', String.valueOf(opp.Id), Date.today(), Date.today().addDays(7), 150000, 'Running');
        System.assertNotEquals('OK', result);
        List<Project__c> projects = [SELECT Id FROM Project__c];
        System.assert(projects.size() == 0);
    }
}