class AddCustomerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :customer_id,  :string
    add_column :users, :identifier,   :string, null: false
    add_column :users, :secret,       :string

    add_index :users, :customer_id, unique: true
    add_index :users, :identifier,  unique: true
  end
end
