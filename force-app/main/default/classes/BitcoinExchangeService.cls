public without sharing class BitcoinExchangeService {

    public static Decimal getBtcToEurExchangeRate() {
        HttpResponse response = doGet('callout:CoinDesk');

        switch on response.getStatusCode() {
            when 200 {
                return BitcoinExchangeRatesDataModel.parse(response.getBody()).bpi.eur.rate_float;
            }
        }

        return 0;
    }

    private static HttpResponse doGet(String endpoint) {
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');

        HttpResponse res = h.send(req);
        return res;
    }
}