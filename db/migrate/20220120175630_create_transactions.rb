class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :customer, foreign_key: true, type: :uuid
      t.references :to_account, foreign_key: { to_table: :accounts, primary_key: :id }, type: :uuid
      t.references :account, foreign_key: { to_table: :accounts, primary_key: :id }, type: :uuid
      t.decimal :amount, default: 0.0
      t.integer :transaction_type, null: false
      t.json :meta
      t.text :notes

      t.timestamps
    end
  end
end
