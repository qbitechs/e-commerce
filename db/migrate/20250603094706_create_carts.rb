class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.references :customer, null: true, foreign_key: true

      t.timestamps
    end
  end
end
