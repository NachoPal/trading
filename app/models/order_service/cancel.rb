module OrderService
  class Cancel

    def fire!(sell_order)
        Rails.logger.info "Cancelo Sell order: #{sell_order.attributes}"
        sell_order.destroy
    end
  end
end