class CreateShortenedUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :shortened_urls do |t|
      t.string :short_code, null: false
      t.string :url, null: false, limit: 1000
      t.integer :api_credential_id, null: true
      t.belongs_to :api_credential, null: true
      t.index :short_code, unique: true
      t.timestamps
    end
  end
end
