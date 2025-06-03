class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.references :customer, null: false, index: true

      t.timestamps
    end

    add_foreign_key :carts, :customers
  end
end
