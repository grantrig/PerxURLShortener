class CreateBrowserTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :browser_types do |t|
      t.string :name
      t.timestamps
      t.index :name, unique: true
    end
  end
end
