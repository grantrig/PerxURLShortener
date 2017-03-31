class CreateShortenedUrlHits < ActiveRecord::Migration[5.0]
  def change
    create_table :shortened_url_hits do |t|
      t.integer :shortened_url_id
      t.string :user_agent
      t.string :referer #misspelled on purpose
      t.string :ip_address
      t.string :accept_language
      t.timestamps
    end
  end
end
