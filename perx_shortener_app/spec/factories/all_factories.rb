FactoryGirl.define do
  factory :api_credential, class: APICredential do
    name 'Factory Test API Credential'
    factory :api_credential_2_urls do
      transient do
        urls_count 2
      end
      after(:create) do |api_credential, evaluator|
        create_list(:google_shortened_url, evaluator.urls_count, api_credential: api_credential)
      end
    end
  end
  factory :shortened_url do
    
  end
  factory :shortened_url_hit do
    shortened_url
    factory :google_shortened_url_hit_mac_chrome, class: ShortenedUrlHit do
      created_at {Faker::Time.between(5.years.ago, Date.today, :day)}
      after(:build) do |rec|
        rec.url = rec.shortened_url.url
        rec.load_user_agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36')
        rec.accept_language = 'en-US'
        rec.ip_address = '0.0.0.0'
        rec.referer = ["", "http://www.yahoo.com"].sample
      end
    end
  end
  factory :google_shortened_url, class: ShortenedUrl do
    url 'https://www.google.com'
    api_credential {APICredential.first || create(:api_credential)}
  end
  factory :shortened_url_with_first_api, class: ShortenedUrl do
    url 'https://www.google.com'
    api_credential {APICredential.first || create(:api_credential)}
    factory :google_shortened_url_with_hits_and_first_api, class: ShortenedUrl do
      transient do
        hits_count 10
      end
      after(:create) do |shortened_url, evaluator|
        create_list(:google_shortened_url_hit_mac_chrome, evaluator.hits_count, shortened_url: shortened_url)
      end
    end
  end
end
