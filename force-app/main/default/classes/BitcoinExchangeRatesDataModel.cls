public without sharing class BitcoinExchangeRatesDataModel {
    public Bpi bpi;

    public class Bpi {
        public ExchangeRateDetails usd;
        public ExchangeRateDetails eur;
    }

    public class ExchangeRateDetails {
        public String code;
        public Decimal rate_float;
    }

    public static BitcoinExchangeRatesDataModel parse(String json) {
        return ((BitcoinExchangeRatesDataModel) System.JSON.deserialize(json, BitcoinExchangeRatesDataModel.class));
    }
}