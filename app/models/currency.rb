class Currency < ApplicationRecord
  has_many :wallets
  has_one :market, -> { where primary_currency_id: 1 }, foreign_key: :secondary_currency_id
end
