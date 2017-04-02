require 'digest/md5'
class APIRequest
  attr_accessor :json_data, :verification_hash

  def api_credential
    @api_credential ||= APICredential.where('api_key = ?', json_parsed[:api_key]).first
  end

  def json_parsed
    @json_parsed = JSON.parse(json_data).with_indifferent_access
  end

  def calculate_hash(secret, message)
    Digest::MD5.hexdigest(secret + Digest::MD5.hexdigest(secret + message))
  end

  def hash_secret_verified?
    verification_hash == calculate_hash(api_credential.api_secret, json_data)
  end

  def utc_time_verified?
    (2.minutes.ago.to_i..2.minutes.from_now.to_i).cover? json_parsed[:utc_time_in_seconds].to_i
  end

  def authenticated?
    api_credential && hash_secret_verified? && utc_time_verified?
  end

  def json_data=(new_json_data)
    @json_data = new_json_data
    @json_parsed = nil
  end

  def self.new_from_params(params)
    o = new
    o.json_data = params[:json_data]
    o.verification_hash = params[:verification_hash]
    o
  end
end
