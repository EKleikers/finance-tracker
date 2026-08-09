class Stock < ApplicationRecord
  require "httparty"
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true
  def self.company_lookup(ticker_symbol)
    response = HTTParty.get(
      "https://finnhub.io/api/v1/stock/profile2",
      query: {
        symbol: ticker_symbol,
        token: Rails.application.credentials.stock_client[:finnhub_api_key]
      }
    )

    response.parsed_response["name"]
  end

  def self.new_lookup(ticker_symbol)
    response = HTTParty.get(
      "https://finnhub.io/api/v1/quote",
      query: {
        symbol: ticker_symbol,
        token: Rails.application.credentials.stock_client[:finnhub_api_key]
      }
    )

    last_price = response.parsed_response["c"]
    name = company_lookup(ticker_symbol)

    return nil if name.blank?

    new(
      ticker: ticker_symbol.upcase,
      name: name,
      last_price: last_price
    )
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
