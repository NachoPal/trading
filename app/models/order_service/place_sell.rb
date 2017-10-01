module OrderService
  class PlaceSell
    def fire!(transaction, buy_order)

      buy_price = buy_order.limit_price
      sell_price = BigDecimal.new((100 + THRESHOLD_OF_GAIN) * buy_price / 100).floor(8)

      sell_order = Orderr::Sell.new(limit_price: sell_price,
                                    quantity: buy_order.quantity,
                                    quantity_remaining: BigDecimal.new(0),
                                    open: true)

      Rails.logger.info "Sell order place: #{sell_order.attributes}"

      transaction.orderrs << sell_order
    end
  end
end