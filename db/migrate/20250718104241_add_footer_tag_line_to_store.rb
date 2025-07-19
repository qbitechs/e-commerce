class AddFooterTagLineToStore < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :footer_tag_line, :string
  end
end
