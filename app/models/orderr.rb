class Orderr < ApplicationRecord
  belongs_to :transactionn

  scope :buys, -> { where(type: 'Buy') }
  scope :sells, -> { where(type: 'Sell') }
end
