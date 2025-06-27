class CreateMetaTags < ActiveRecord::Migration[8.0]
  def change
    create_table :meta_tags do |t|
      t.string :title
      t.text :description
      t.string :page
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
