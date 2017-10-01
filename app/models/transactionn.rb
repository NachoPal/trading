class Transactionn < ApplicationRecord
  #belongs_to :buy_order, class_name: 'Order', foreign_key: :buy_order_id
  #belongs_to :sell_order, class_name: 'Order', foreign_key: :sell_order_id, optional: true
  has_many :orderrs

  belongs_to :market
  belongs_to :account

  def sells
    self.orderrs.sells
  end

  def buys
    self.orderrs.buys
  end
end