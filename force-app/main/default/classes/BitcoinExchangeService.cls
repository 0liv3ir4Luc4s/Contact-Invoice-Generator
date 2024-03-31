public without sharing class BitcoinExchangeService {

    public class BitcoinExchangeServiceException extends Exception {
    }

    public static Decimal getBtcToEurExchangeRate() {
        HttpResponse response = doGet('callout:CoinDesk');

        switch on response.getStatusCode() {
            when 200 {
                try {
                    return BitcoinExchangeRatesDataModel.parse(response.getBody()).bpi.eur.rate_float;
                } catch (System.JSONException jse) {
                    throw new BitcoinExchangeServiceException(jse.getMessage());
                }
            }
            when 404 {
                throw new BitcoinExchangeServiceException('404 error!');
            }
            when else {
                throw new BitcoinExchangeServiceException(
                    'Unexpected Response code: ' + response.getStatusCode()
                );
            }
        }
    }

    private static HttpResponse doGet(String endpoint) {
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');

        HttpResponse res = h.send(req);

        EventBus.publish(new LogEvent__e(Type__c = 'CALLOUT', Timestamp__c = DateTime.now(), LogLevel__c = 'INFO',
                            Method__c = req.getMethod(), EndpointUrl__c = req.getEndpoint(), ResponseBody__c = res.getBody(), StatusCode__c = String.valueOf(res.getStatusCode())));

        return res;
    }
}