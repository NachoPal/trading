module TransactionService
  class Close

    def fire!(transaction, buy_order, sell_order)
      result = calculate_statistics(buy_order, sell_order)

      transaction.update(benefit: result[:benefit], percentage: result[:percentage])
    end

    def calculate_statistics(buy_order, sell_order)
     begin
       buy_price = buy_order.limit_price
       sell_price = sell_order.limit_price
       quantity = buy_order.quantity

       Rails.logger.info "Buy price: #{buy_price} -- Sell price: #{sell_price}"

       benefit = BigDecimal.new(quantity * (sell_price - buy_price)).floor(8)
       percentage = BigDecimal.new((((sell_price * 100) / buy_price) - 100)).floor(2)

       {benefit: benefit, percentage: percentage}
     rescue  => e
       Rails.logger.error "Error: #{e}"
       Rails.logger.error "Sell order: #{sell_order}\n"
       Rails.logger.error "Buy order: #{buy_order}\n"
       return {benefit: nil, percentage: nil}
     end
    end
  end
end