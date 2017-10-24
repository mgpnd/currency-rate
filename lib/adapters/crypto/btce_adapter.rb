module CurrencyRate
  class BTCEAdapter < Adapter
    FETCH_URL = {
      'btc_usd' => 'https://btc-e.com/api/2/btc_usd/ticker',
      'btc_eur' => 'https://btc-e.com/api/2/btc_eur/ticker',
      'btc_rub' => 'https://btc-e.com/api/2/btc_rur/ticker',
    }

    def normalize(data)
      super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["ticker"]["last"].to_s)
        result
      end
    end

  end
end