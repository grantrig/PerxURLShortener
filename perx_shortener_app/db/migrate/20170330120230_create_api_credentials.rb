class CreateApiCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :api_credentials do |t|
      t.string :name
      t.string :api_key
      t.string :api_secret
      t.timestamps
      t.index :api_key, unique: true
    end
    
  end
end
