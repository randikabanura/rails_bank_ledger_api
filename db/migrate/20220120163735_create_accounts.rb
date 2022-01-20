class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.references :customer, null: false, foreign_key: true, type: :uuid
      t.decimal :amount, default: 0.0, null: false
      t.json :meta
      t.string :nick_name

      t.timestamps
    end
  end
end
