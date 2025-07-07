class RenameAdminUsersToUsers < ActiveRecord::Migration[8.0]
  def change
    # Rename the table
    rename_table :admin_users, :users

    # Rename foreign keys in sessions and stores
    rename_column :sessions, :admin_user_id, :user_id
    rename_column :stores, :admin_user_id, :user_id
    rename_column :meta_tags, :admin_user_id, :user_id

    # Rename indexes if necessary
    remove_index :users, name: :index_admin_users_on_email_address if index_name_exists?(:users, :index_admin_users_on_email_address)
    add_index :users, :email_address, unique: true unless index_name_exists?(:users, :index_users_on_email_address)

    if index_name_exists?(:sessions, :index_sessions_on_admin_user_id)
      remove_index :sessions, name: :index_sessions_on_admin_user_id
      add_index :sessions, :user_id
    end
    if index_name_exists?(:stores, :index_stores_on_admin_user_id)
      remove_index :stores, name: :index_stores_on_admin_user_id
      add_index :stores, :user_id
    end
    if index_name_exists?(:meta_tags, :index_stores_on_admin_user_id)
      remove_index :meta_tags, name: :index_stores_on_admin_user_id
      add_index :meta_tags, :user_id
    end

    # Update foreign keys
    remove_foreign_key :sessions, :admin_users if foreign_key_exists?(:sessions, :admin_users)
    add_foreign_key :sessions, :users
    remove_foreign_key :stores, :admin_users if foreign_key_exists?(:stores, :admin_users)
    add_foreign_key :stores, :users
    remove_foreign_key :meta_tags, :admin_users if foreign_key_exists?(:meta_tags, :admin_users)
    add_foreign_key :meta_tags, :users
  end
end
