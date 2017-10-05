module OrderService
  class Buy

    def fire!(market_name, main_wallet, account_id)
      Rails.logger.info "Market buy -- #{market_name}"
      market = Market.where(name: market_name).first

      ask_orders = check_ask_orders(market.name)

      ask_orders.each do |ask_order|
        #quantity = BTC_QUANTITY_TO_BUY / ask_order['Rate']
        quantity = main_wallet.balance.to_f / ask_order['Rate']


        if quantity <= ask_order['Quantity']

          bought = buy(market, ask_order['Rate'], quantity, account_id)

          currency = Currency.where(name: market.name.split('-').last).first

          #new_wallet = WalletService::Create.new.fire!(currency, quantity, ask_order['Rate'])
          WalletService::Create.new.fire!(currency, quantity, ask_order['Rate'], account_id)

          return bought #.merge!({wallet: new_wallet}) if bought[:success]
        else
          next
        end
      end
      {success: false}
    end

    private

    def check_ask_orders(market)
      Bittrex.client.get("public/getorderbook?market=#{market}&type=sell")
    end

    def buy(market, price, quantity, account_id)
      transaction = TransactionService::Create.new.fire!(market, account_id)

      buy_order = Orderr::Buy.new(limit_price: price,
                                  quantity: quantity,
                                  quantity_remaining: BigDecimal.new(0),
                                  open: false)

      transaction.orderrs << buy_order

      Rails.logger.info "---------- Buy -------------"
      Rails.logger.info "Market: #{market.name}"
      Rails.logger.info "Stored Price: #{market.price}"
      Rails.logger.info "Current Price: #{price}"
      Rails.logger.info "----------------------------"

      {success: true, transaction: transaction, order: buy_order}
    end
  end
end