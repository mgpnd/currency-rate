require 'spec_helper'

RSpec.describe CurrencyRate::OkcoinAdapter do

  before :each do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/okcoin_adapter'
  end

  after :each do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::OkcoinAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(1021.09)
    expect(@exchange_adapter.rate_for('USD', 'BTC').to_f).to eq(0.000979346)
    expect(@exchange_adapter.rate_for('BTC', 'CNY')).to eq(7203.0)
    expect(@exchange_adapter.rate_for('CNY', 'BTC').to_f).to eq(0.000138831)

    expect(@exchange_adapter.rate_for('LTC', 'USD')).to eq(3.987)
    expect(@exchange_adapter.rate_for('USD', 'LTC').to_f).to eq(0.250815149)
    expect(@exchange_adapter.rate_for('LTC', 'CNY')).to eq(28.0)
    expect(@exchange_adapter.rate_for('CNY', 'LTC').to_f).to eq(0.035714286)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    response = [
      '{"date":"1422679981","ticker":{}}',
      '{"date":"1422679981","ticker":{"buy":"227.27","high":"243.55","bambo":"226.89","low":"226.0","sell":"227.74","vol":"16065.2085"}}',
      '{"date":"1422679981","ticker":{"buy":"227.27","high":"243.55","last":null,"low":"226.0","sell":"227.74","vol":"16065.2085"}}',
    ]
    3.times do |i|
      @exchange_adapter.instance_variable_set :@rates_updated_at, Time.now
      @exchange_adapter.instance_variable_set :@rates, JSON.parse(response[i])
      expect( -> { @exchange_adapter.rate_for('FEDcoin', 'BTC') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end