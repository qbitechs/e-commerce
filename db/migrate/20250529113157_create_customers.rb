class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.references :user, null: false, index: true
      t.string     :first_name
      t.string     :last_name
      t.string     :phone
      t.timestamps
    end

    add_foreign_key :customers, :users
  end
end
