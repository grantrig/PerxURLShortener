require 'digest/md5'

# This class is to help build signed api requests
class APIRequestTestBuilder
  attr_accessor :data, :api_credential

  def initialize(api_credential, **data)
    self.data = data
    self.api_credential = api_credential
  end

  def build_api_request
    {
      json_data: data_with_extras.to_json,
      verification_hash: verification_md5
    }
  end

  def data_with_extras
    {api_key: api_credential.api_key, utc_time_in_seconds: Time.now.to_i}.merge(data)
  end

  def verification_md5
    Digest::MD5.hexdigest(api_credential.api_secret + Digest::MD5.hexdigest(api_credential.api_secret + data_with_extras.to_json))
  end
end
