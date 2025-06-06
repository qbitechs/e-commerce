class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, index: true
      t.string     :recipient_first_name, null: false
      t.string     :recipient_last_name,  null: false
      t.string     :recipient_phone,  null: false
      t.string     :shipping_address,  null: false
      t.string     :shipping_city,  null: false
      t.string     :shipping_country,  null: false
      t.string     :shipping_zip_code,  null: false
      t.string     :status
      t.decimal    :total
      t.timestamps
    end

    add_foreign_key :orders, :customers
  end
end
