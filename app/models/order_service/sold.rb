module OrderService
  class Sold

    def fire!(sell_order, market_name)
      price_history = Bittrex.client.get("public/getmarkethistory?market=#{market_name}")

      sold = sold_in_the_last_period(price_history, sell_order)

      sell_order.update(open: false) if sold

      sold
    end

    private

    def sold_in_the_last_period(price_history, sell_order)
      price_history.each do |transaction|
        time = "#{transaction['TimeStamp'].split('.').first}+00:00"
        if DateTime.rfc3339(time) > sell_order.updated_at.to_datetime
          return true if transaction['Price'] >= sell_order.limit_price
        end
      end
      false
    end
  end
end