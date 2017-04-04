class CreateBrowserVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :browser_versions do |t|
      t.string :name
      t.integer :browser_type_id
      t.belongs_to :browser_type
      t.index [:name, :browser_type_id], unique: true
      t.timestamps
    end
  end
end
