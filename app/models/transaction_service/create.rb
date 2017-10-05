module TransactionService
  class Create

    def fire!(market, account_id)
      t = Transactionn.new(market_id: market.id, account_id: account_id)
      t.save
      t
    end
  end
end