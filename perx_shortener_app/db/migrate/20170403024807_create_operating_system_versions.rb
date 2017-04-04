class CreateOperatingSystemVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :operating_system_versions do |t|
      t.integer :operating_system_id
      t.string :name
      t.index [:name, :operating_system_id], unique: true
      t.timestamps
    end
  end
end
