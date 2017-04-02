require 'rails_helper'
require 'spec_helper'

RSpec.describe APIRequest do
  describe 'API Authentication' do
    it 'validates the hash when the secret + data hash matches' do
      credentials = APICredential.create!(name: 'Tester')
      api_request = APIRequest.new
      api_request.json_data = {one: 1, two: 2, api_key: credentials.api_key, utc_time_in_seconds: Time.now.to_i}.to_json
      api_request.verification_hash = api_request.calculate_hash(credentials.api_secret, api_request.json_data)
      expect(api_request.hash_secret_verified?).to eq(true)
    end
    it 'validates the utc time if its almost the same time' do
      credentials = APICredential.create!(name: 'Tester')
      api_request = APIRequest.new
      api_request.json_data = {one: 1, two: 2, api_key: credentials.api_key, utc_time_in_seconds: Time.now.to_i}.to_json
      api_request.verification_hash = api_request.calculate_hash(credentials.api_secret, api_request.json_data)
      expect(api_request.utc_time_verified?).to eq(true)
    end
    # it 'validates the utc_time_in_seconds to be withing 2 mins of now' do
    #   credentials = APICredential.generate!(name: 'Tester')
    #   api_request = APIRequest.new
    #   api_request.json_data = {one: 1, two: 2, api_key: credentials.api_key, utc_time_in_seconds: 1.minute.ago.to_i}.to_json
    #   api_request.verification_hash = api_request.calculate_hash(credentials.api_secret)
    #   expect(api_request.authenticated?).to eq(true)
    #   api_request.json_data = {one: 1, two: 2, api_key: credentials.api_key, utc_time_in_seconds: 3.minute.ago.to_i}.to_json
    #   api_request.verification_hash = api_request.calculate_hash(credentials.api_secret)
    #   expect(api_request.authenticated?).to eq(false)
    # end
  end
end
