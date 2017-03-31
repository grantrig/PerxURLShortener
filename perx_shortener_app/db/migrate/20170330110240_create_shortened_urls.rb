class CreateShortenedUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :shortened_urls do |t|
      t.string :short_code, index: true, null: false
      t.string :url, null: false, limit: 1000
      t.integer :api_credential_id, index: true, null: true
      t.timestamps
    end
  end
end
