module OrderService
  class Sell
    def fire!(market_name, wallet, buy_order, sell_order)

      bid_orders = check_bid_orders(market_name)

      bid_orders.each do |bid_order|
        if bid_order['Quantity'] >= wallet.balance
          OrderService::Cancel.new.fire!(sell_order) if sell_order.present?
          sell_order = sell(buy_order, bid_order['Rate'], wallet.balance, true)
          return {success: true, order: sell_order}
        else
          next
        end
      end
      {success: false, order: nil}
    end

    private

    def check_bid_orders(market)
      Bittrex.client.get("public/getorderbook?market=#{market}&type=buy")
    end

    def sell(buy_record, price, quantity, success)
      sell_order = Orderr::Sell.new(limit_price: price,
                                    quantity: quantity,
                                    quantity_remaining: BigDecimal.new(0),
                                    open: !success)

      transaction = buy_record.transactionn

      transaction.orderrs << sell_order

      sell_order
    end
  end
end