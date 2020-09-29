global class ProjectCalloutServiceMock implements HttpCalloutMock {
    
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK');
        res.setStatusCode(201);
        return res;
    }
}
