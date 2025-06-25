class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.references :customer, null: true, foreign_key: true
      t.string :session_id, null: true

      t.timestamps
    end

    add_index :carts, :session_id
  end
end
