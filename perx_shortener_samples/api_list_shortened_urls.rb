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


json_data = {api_key: APICredential::API_KEY, utc_time_in_seconds: Time.now.to_i}

params = {json_data: json_data.to_json, verification_hash: verification_hash(APICredential::API_SECRET, json_data.to_json)}

response = RestClient::Request.execute(method: :get, url: "http://127.0.0.1:3000/api_credentials/#{APICredential::API_KEY}", payload: params, headers: {accept: :json})

puts JSON.parse(response.body).inspect

