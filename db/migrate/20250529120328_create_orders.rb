class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, index: true
      t.integer    :status
      t.decimal    :total
      t.timestamps
    end

    add_foreign_key :orders, :customers
  end
end
