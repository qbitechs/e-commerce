class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.decimal :total
      t.string :status
      t.text :shipping_address
      t.string :payment_method
      t.references :user, null: false, index: true

      t.timestamps
    end

    add_foreign_key :orders, :users, on_delete: :cascade
  end
end
