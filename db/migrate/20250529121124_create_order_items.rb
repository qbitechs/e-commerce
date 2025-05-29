class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, index: true
      t.references :product, null: false
      t.integer    :quantity
      t.decimal    :unit_price, precision: 10, scale: 2
      t.timestamps
    end

    add_foreign_key :order_items, :orders
    add_foreign_key :order_items, :products
  end
end
