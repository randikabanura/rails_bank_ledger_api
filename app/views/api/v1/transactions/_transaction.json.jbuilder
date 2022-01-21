json.extract! transaction, :id, :customer_id, :account_id, :to_account_id, :transaction_type, :amount, :notes, :created_at
json.url transaction_url(transaction, format: :json)
