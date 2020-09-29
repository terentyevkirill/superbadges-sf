@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('Bad Request');
        res.setStatusCode(500);
        return res;
    }
}
