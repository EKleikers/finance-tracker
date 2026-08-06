class Stock < ApplicationRecord

  require "httparty"

  def self.new_lookup(ticker_symbol)
    response = HTTParty.get(
      "https://www.alphavantage.co/query",
      query: {
        function: "GLOBAL_QUOTE",
        symbol: ticker_symbol,
        apikey: Rails.application.credentials.stock_client[:alphavantage_api_key]
      }
    )

    response.parsed_response["Global Quote"]["05. price"]
  end
end
