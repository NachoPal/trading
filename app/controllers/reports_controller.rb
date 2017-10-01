class ReportsController < ApplicationController

  def generate

    @transactions = []

    Transactionn.all.each do |transaction|

      buy_price = transaction.buys.first.limit_price
      market_name = transaction.market.name
      current_price = Bittrex.client.get("public/getmarketsummary?market=#{market_name}").first['Last']

      growth = (((current_price * 100) / buy_price) - 100).round(2)

      time = transaction.buys.first.created_at.to_time.to_s
      time.slice!('+0000')


      @transactions << {time: time,
                        name: transaction.market.name,
                        open: transaction.sells.present? ? transaction.sells.first.open : true,
                        quantity: transaction.buys.first.quantity,
                        buy: transaction.buys.first.limit_price,
                        sell: transaction.sells.present? ? transaction.sells.first.limit_price : nil,
                        benefit: transaction.benefit,
                        percentage: transaction.percentage.present? ? transaction.percentage : "(#{growth})" }
    end


    @title = 'REPORT'

    respond_to do |format|
      format.pdf do
        render pdf: @title, template: 'reports/generate.slim'
      end
    end
  end

  def cache
    markets = Market.all.map(&:name)
    @cache_values = []

    markets.each do |market|
      if market.include?('BTC')
        prices = CACHE.get(market)
        if prices.present? && (prices.last != prices.last(2).first)
          @cache_values << "#{market} - #{prices.last}"
        end
      end
    end

    @title = 'CACHE'

    respond_to do |format|
      format.pdf do
        render pdf: @title, template: 'reports/cache.slim'
      end
    end
  end
end
