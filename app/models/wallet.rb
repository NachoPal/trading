class Wallet < ApplicationRecord
  belongs_to :account
  belongs_to :currency

  def self.main_wallet
    self.joins(:currency).where(currencies: {name: BASE_MARKET}).first
  end
end
