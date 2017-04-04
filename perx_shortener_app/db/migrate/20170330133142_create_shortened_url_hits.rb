class CreateShortenedUrlHits < ActiveRecord::Migration[5.0]
  def change
    create_table :shortened_url_hits do |t|
      t.integer :shortened_url_id
      t.belongs_to :shortened_url
      t.string :user_agent
      t.string :referer, limit: 1000 #misspelled on purpose
      t.string :ip_address
      t.string :accept_language
      t.integer :operating_system_version_id
      t.belongs_to :operating_system_version
      t.integer :browser_version_id
      t.belongs_to :browser_version
      t.integer :device_id
      t.belongs_to :device, null: true
      t.string :url, limit: 1000
      t.timestamps
    end
  end
end
