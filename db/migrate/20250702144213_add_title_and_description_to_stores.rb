class AddTitleAndDescriptionToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :title, :string
    add_column :stores, :description, :string
  end
end
