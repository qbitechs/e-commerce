class AddTitleToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :title, :string
  end
end
