class Account < ApplicationRecord
  belongs_to :customer
  has_many :to_account_transactions, class_name: 'Transaction', foreign_key: 'to_account_id', dependent: :destroy
  has_many :account_transactions, class_name: 'Transaction', foreign_key: 'account_id', dependent: :destroy

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def transactions
    (to_account_transactions.all + account_transactions.all).uniq
  end
end
