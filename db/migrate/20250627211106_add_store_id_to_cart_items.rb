class AddStoreIdToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :cart_items, :store, null: false, foreign_key: true
  end
end
