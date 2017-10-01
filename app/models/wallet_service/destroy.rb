module WalletService
  class Destroy

    def fire!(wallet, btc_wallet, sell_order)
      quantity = sell_order.quantity
      rate = sell_order.limit_price

      commission = (quantity * rate) * (COMMISSION / 100)
      btc_wallet.update(available: btc_wallet.available + (quantity * rate) - commission,
                        balance: btc_wallet.balance + (quantity * rate) - commission)
      wallet.destroy
    end
  end
end