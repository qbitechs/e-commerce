class CreateCustomDomains < ActiveRecord::Migration[8.0]
  def change
    create_table :custom_domains do |t|
      t.references :store, null: false, foreign_key: true
      t.string :domain
      t.string :status
      t.datetime :verified_at

      t.timestamps
    end
  end
end
