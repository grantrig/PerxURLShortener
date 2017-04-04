class APICredentialResult
  attr_accessor :api_credential

  def initialize(api_credential)
    self.api_credential = api_credential
  end
  def shortened_urls_response
    api_credential.shortened_urls.map do |surl|
      {
        short_code: surl.short_code,
        url: surl.url,
        created_at_utc_seconds: surl.created_at.to_i
      }
    end
  end
  def response
    {
      api_key: api_credential.api_key,
      shortened_urls: shortened_urls_response
    }
  end
end
