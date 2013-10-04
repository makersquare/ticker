class StocksController < ApplicationController
  def ticker
    respond_to do |format|
      format.json { render json: Rails.cache.read('stock_api_call') }
    end
  end
end