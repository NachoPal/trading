namespace :trade do

  desc 'Trade markets'
  task :markets, [:test] => :environment do |t, args|
    test = args[:test]

    def has_been_sold(wallet, main_wallet, transaction, buy_order, sell_order)
      TransactionService::Close.new.fire!(transaction, buy_order, sell_order)
      WalletService::Destroy.new.fire!(wallet, main_wallet, sell_order)
    end

    if CACHE.get('start_to_trade')
      markets = CACHE.get('markets')
      percentile_volume = CACHE.get('percentile_volume')

      #============= TRADE ===============================

      Rails.logger.info "------------------------ Trade ------------------------------"
      wallets = Wallet.all
      main_wallet = Wallet.main_wallet

      wallets = wallets - [main_wallet]

      #------- Sell --------
      if wallets.present?
        wallet = wallets.last
        market_to_sell = wallet.currency.market
        transaction = market_to_sell.transactionns.joins(:account).
            where(accounts: {id: 1}).all.last
        sell_order = transaction.sells.last
        buy_order = transaction.buys.last

        if OrderService::Sold.new.fire!(sell_order, market_to_sell.name)
          sell_order = transaction.sells.where(open: false).last
          has_been_sold(wallet, main_wallet, transaction, buy_order, sell_order)

        elsif MarketService::ShouldBeSold.new.fire!(markets, market_to_sell.name, buy_order)
          Rails.logger.info ".............Should be sold..................\n"
          sell = OrderService::Sell.new.fire!(market_to_sell.name, wallet, buy_order, sell_order)
          Rails.logger.info "Success: #{sell[:success]}"
          if sell[:success]
            has_been_sold(wallet, main_wallet, transaction, buy_order, sell[:order])
          end
        end
      else

        #------- Buy ---------
        sky_rocket_market = MarketService::DetectSkyRocket.new.fire!(markets, percentile_volume)

        if sky_rocket_market.present?

          bought = OrderService::Buy.new.fire!(sky_rocket_market, main_wallet)

          if bought[:success]
            transaction = bought[:transaction]
            buy_order = bought[:order]
            OrderService::PlaceSell.new.fire!(transaction, buy_order)
          end
        end
      end
    end
  end
end
