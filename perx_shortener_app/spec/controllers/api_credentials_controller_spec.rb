require 'rails_helper'
require 'digest/md5'
require './spec/support/api_request_test_builder.rb'
require './spec/custom_matchers/have_header'

RSpec.describe ApiCredentialsController, type: :controller do
  describe '#show_via_api' do
    context 'when valid credentials' do
      before do
        request.accept = 'application/json'
        get :show, params: {api_key: api_credentials.api_key}.merge(test_api_request.build_api_request)
      end
      context 'get credential with 2 urls' do
        let(:api_credentials){APICredential.first || create(:api_credential_2_urls)}
        let(:test_api_request){APIRequestTestBuilder.new(api_credentials)}
        subject{json_response[:shortened_urls]}
        specify{should have_exactly(2).items}
      end
    end
  end
end
