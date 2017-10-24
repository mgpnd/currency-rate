module CurrencyRate
  class ForgeAdapter < Adapter
    SUPPORTED_CURRENCIES = %w(JPY CHF CAD SEK NOK MXN ZAR TRY CNH EUR GBP AUD NZD XAU XAG)
    ANCHOR_CURRENCY = "USD"
    FETCH_URL = "https://forex.1forge.com/1.0.2/quotes?pairs=" +
      SUPPORTED_CURRENCIES.map { |c| "#{ANCHOR_CURRENCY}#{c}" }.join(",")

    def normalize(data)
      super
      rates = { "anchor" => self.class::ANCHOR_CURRENCY }
      data.each do |rate|
        rates[rate["symbol"].sub(self.class::ANCHOR_CURRENCY, "")] = BigDecimal.new(rate["price"].to_s)
      end
      rates
    end

    def exchange_data
      return nil if CurrencyRate.configuration.forge_api_key.nil?
      super
    end

  end
end