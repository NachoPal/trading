module TransactionService
  class Create

    def fire!(market)
      t = Transactionn.new(market_id: market.id, account_id: 1)
      t.save
      t
    end
  end
end