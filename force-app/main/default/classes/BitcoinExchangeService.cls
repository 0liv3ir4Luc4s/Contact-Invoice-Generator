public without sharing class BitcoinExchangeService {
    private static Integer calloutCount = 0;
    private static BitcoinExchangeRatesDataModel exchangeRates {
        get {
            if (calloutCount == 100) {
                throw new BitcoinExchangeServiceException(
                    'Too many failed tries: Callout limit reached, no more callouts will be made in this transaction'
                );
            }
            
            if (exchangeRates == null) {
                HttpResponse response = doGet('callout:CoinDesk');

                switch on response.getStatusCode() {
                    when 200 {
                        try {
                            calloutCount++;
                            exchangeRates = BitcoinExchangeRatesDataModel.parse(response.getBody());
                        } catch (System.JSONException jse) {
                            throw new BitcoinExchangeServiceException(jse.getMessage());
                        }
                    }
                    when 404 {
                        calloutCount++;
                        throw new BitcoinExchangeServiceException('404 error!');
                    }
                    when else {
                        calloutCount++;
                        throw new BitcoinExchangeServiceException(
                            'Unexpected Response code: ' + response.getStatusCode()
                        );
                    }
                }
            }

            return exchangeRates;
       }
       set;
    }

    public class BitcoinExchangeServiceException extends Exception {
    }

    public static Decimal getBtcToEurExchangeRate() {
        return exchangeRates.bpi.eur.rate_float;
    }

    public static Decimal getBtcToUsdExchangeRate() {
        return exchangeRates.bpi.usd.rate_float;
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