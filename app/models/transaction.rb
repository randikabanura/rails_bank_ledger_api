class Transaction < ApplicationRecord
  enum transaction_type: { deposit: 1, withdraw: 2, transfer: 3 }

  belongs_to :to_account, class_name: 'Account', optional: true
  belongs_to :account, class_name: 'Account'
  belongs_to :customer

  validates :amount, presence: true
  validates :transaction_type, inclusion: { in: transaction_types.keys }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :to_account, presence: true, if: :transfer?

  after_create :set_account_amount_by_transaction

  def set_account_amount_by_transaction
    if withdraw? || transfer?
      account.amount -= amount
      to_account.amount += amount if transfer?
    else
      account.amount += amount
    end

    account.save
    to_account.save if to_account.present?
  end

  def set_account_amount
    balance = 0.0
    all_transactions = account.transactions

    all_transactions.each do |transaction|
      if transaction.withdraw? || transaction.transfer?
        account.amount -= transaction.amount
      else
        account.amount += transaction.amount
      end
    end

    account.amount = balance
    account.save
  end
end
