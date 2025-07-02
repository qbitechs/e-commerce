class AddAdminUserIdToStores < ActiveRecord::Migration[8.0]
  def change
    add_reference :stores, :admin_user, null: false, foreign_key: true
  end
end
