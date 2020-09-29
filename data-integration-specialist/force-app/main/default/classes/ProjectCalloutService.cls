public class ProjectCalloutService {

    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> oppIds) {
        Opportunity opp = [
            SELECT
                Id,
                Name,
                Account.Name,
                CloseDate,Amount
            FROM Opportunity
            WHERE
                Id = :oppIds[0]
        ];
        String token = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
        String jsonBody = '{\n'  +
        ' "opportunityId" : "'   + opp.Id+'",\n'+
        ' "opportunityName" : "' + opp.Name+'",\n'+
        ' "accountName" : "'     + opp.Account.Name+'",\n'+
        ' "closeDate" : "'       + String.ValueOf(opp.CloseDate).mid(0,10)+'",\n'+   
        ' "amount" : "'          + opp.Amount+'"\n}';

        System.enqueueJob(new QueueablePMSCall(token, jsonBody, opp.Id));
    }

    @Future(callout=true)
    private static void postToPMS(String token, String jsonBody, Id oppId) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:ProjectService');
        req.setHeader('token', token);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(jsonBody);

        Http http = new Http();
        HttpResponse res = http.send(req);
        Opportunity opp = new Opportunity(Id = oppId);
        if (res.getStatusCode() == 201) {
            opp.StageName = 'Submitted Project';
            System.debug('Success: ' + res.getStatusCode());
        } else {
            opp.StageName = 'Resubmit Project';
            System.debug('Failure: ' + res.getStatusCode());
        }

        update opp;
    }

    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        private String token;
        private String jsonBody;
        private Id oppId;
        public QueueablePMSCall(String token, String jsonBody, Id oppId) {
            this.token = token;
            this.jsonBody = jsonBody;
            this.oppId = oppId;
        }

        public void execute(QueueableContext qc) {
            postToPMS(token, jsonBody, oppId);
        }
    }

}