require 'rails_helper'
require 'digest/md5'
require './spec/support/api_request_test_builder.rb'
require './spec/custom_matchers/have_header'

RSpec.describe ShortenedUrlsController, type: :controller do
  describe '#create.api' do
    let(:api_credential){create(:api_credential)}
    let(:test_api_request){APIRequestTestBuilder.new(api_credential, url: 'http://www.google.com')}
    def do_create(test_req)
      request.accept = 'application/json'
      post :create, params: test_req.build_api_request
    end
    context 'when incorrect credentials' do
      before do
        test_api_request.api_credential.api_key = 'WRONGKEY'
        do_create(test_api_request)
      end
      it 'should return forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'when correct credentials' do
      context 'when invalid url is given' do
        before do
          test_api_request.data[:url] = 'www.google.com'
          do_create(test_api_request)
        end
        specify{expect(response).to have_http_status(:bad_request)}
      end
      context 'when valid url is given' do
        before do
          test_api_request.data[:url] = 'http://www.google.com'
          do_create(test_api_request)
        end
        specify{expect(response).to have_http_status(:created)}
        specify{expect(response).to have_header(:location, ShortenedUrl.last.full_shortened_url)}
      end
    end
  end
end
