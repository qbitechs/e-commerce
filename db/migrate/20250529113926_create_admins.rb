class CreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.references :user, null: false, index: true
      t.timestamps
    end

    add_foreign_key :admins, :users
  end
end
