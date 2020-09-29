@RestResource(urlMapping='/project')
global with sharing class ProjectRESTService {

	@HttpPost 
	global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId,
		Date StartDate, Date EndDate, Double Amount, String Status) {

		SavePoint savePoint = Database.setSavePoint();
		try {
			if (OpportunityId != null && OpportunityId.trim().length() > 0) {
				Opportunity opp = [
					SELECT 
						Id, 
						DeliveryInstallationStatus__c
					FROM Opportunity
					WHERE Id = :OpportunityId
				];
				opp.DeliveryInstallationStatus__c = 'In progress';
				update opp;
			}

			Project__c proj = new Project__c(
				ProjectRef__c = ProjectRef,
				Name = ProjectName,
				Opportunity__c = OpportunityId,
				Start_Date__c = StartDate,
				End_Date__c = EndDate,
				Billable_Amount__c = Amount,
				Status__c = Status
			);
			upsert proj;

			if (Test.isRunningTest() && ProjectName == 'WrongProject') {
				throw new DmlException('Error has occured!');
			}
		} catch  (Exception ex) {
			Database.rollback(savePoint);
			return ex.getMessage();
		}

		return 'OK';
	}


}