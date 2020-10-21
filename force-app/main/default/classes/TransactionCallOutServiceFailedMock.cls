/**
* HttpCalloutMock for negative testing
**/
public class TransactionCallOutServiceFailedMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(200);
        resp.setStatus('Failed');
        return resp;
    }
}