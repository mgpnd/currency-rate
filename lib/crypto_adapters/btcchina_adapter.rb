module CurrencyRate
  class BTCChinaAdapter < CryptoAdapter

    FETCH_URL = 'https://data.btcchina.com/data/ticker'
    DEFAULT_CURRENCIES = ["CNY", "BTC"]
    SUPPORTED_CRYPTO_CURRENCIES = ["BTC"]

    def rate_for(from,to)
      super
      rate = rate_to_f(@rates['ticker'] && @rates['ticker']['last'])
      invert_rate(from,to,rate)
    end

    def supported_currency_pairs
      ["BTC/CNY"]
    end

  end
end