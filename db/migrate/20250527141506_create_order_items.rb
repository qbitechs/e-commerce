class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.decimal :unit_price
      t.references :order, null: false
      t.references :product, null: false

      t.timestamps
    end

    add_foreign_key :order_items, :orders, on_delete: :cascade
    add_foreign_key :order_items, :products
  end
end
