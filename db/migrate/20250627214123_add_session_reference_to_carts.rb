class AddSessionReferenceToCarts < ActiveRecord::Migration[8.0]
  def change
    add_reference :carts, :session, null: true, foreign_key: true
  end
end
