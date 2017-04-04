$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
require 'digest/md5'
require 'rest-client'
require 'active_support'
require 'active_support/core_ext/object/json'
require 'api_keys'



def verification_hash(secret, message)
  Digest::MD5.hexdigest(secret + Digest::MD5.hexdigest(secret + message))
end


# This is the data used to create the shortened url.  utc_time_in_seconds is required to be within 3 minutes of the server time.  In order to prevent replay attacks.
json_data = {url: "http://www.google.com", api_key: APICredential::API_KEY, utc_time_in_seconds: Time.now.to_i}

params = {json_data: json_data.to_json, verification_hash: verification_hash(APICredential::API_SECRET, json_data.to_json)}

response = RestClient.post 'http://127.0.0.1:3000/shortened_urls', params, {accept: :json}

puts "The shortened url is at #{response.headers[:location]}"
