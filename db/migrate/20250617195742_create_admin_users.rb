class CreateAdminUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_users do |t|
      t.string  :email_address, null: false
      t.string  :password_digest, null: false
      t.boolean :super_admin, default: false

      t.timestamps
    end
    add_index :admin_users, :email_address, unique: true
  end
end
