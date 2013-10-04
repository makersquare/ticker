class QuoteWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { secondly(5) }

  def perform
    stock_url = "http://query.yahooapis.com/v1/public/yql?q=select%20symbol%2C%20AskRealtime%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22YHOO%22%2C%22AAPL%22%2C%22GOOG%22%2C%22MSFT%22)%0A%09%09&format=json&diagnostics=true&env=http%3A%2F%2Fdatatables.org%2Falltables.env&callback=updateStocks"
    resp = RestClient.get(stock_url)

    logger.info "Fetching stock price..."

    Rails.cache.write 'stock_api_call', resp
  end
end