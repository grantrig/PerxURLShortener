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
  describe '#show_via_api' do
    context 'when valid credentials' do
      let(:api_credential){APICredential.first || create(:api_credential)}
      let(:shortened_url){create(:google_shortened_url_with_hits_and_first_api)}
      before do
        request.accept = 'application/json'
        get :show, params: {short_code: shortened_url.short_code}.merge(test_api_request.build_api_request)
      end
      context 'get all (10) hits' do
        let(:test_api_request){APIRequestTestBuilder.new(api_credential, short_code: shortened_url.short_code)}
        specify{expect(response).to have_header(:ok)}
        subject{json_response}
        specify{expect(json_response[:shortened_url_hits]).to have_exactly(10).items}
      end
      context 'get a range of 3 hits (rows[1..3]) (based on times)' do
        let(:expected_hit_records){shortened_url.shortened_url_hits.order("created_at ASC")[0..2]}
        let(:since_utc_seconds){expected_hit_records.first.created_at.to_i}
        let(:until_utc_seconds){expected_hit_records.last.created_at.to_i}
        let(:test_api_request){APIRequestTestBuilder.new(api_credential, since_utc_seconds: since_utc_seconds, until_utc_seconds: until_utc_seconds, short_code: shortened_url.short_code)}
        let(:response_hits_short_codes){json_response[:shortened_url_hits].map{|h| h[:id]}}
        subject{response_hits_short_codes}
        specify{should have_exactly(3).items}
        specify{should match_array(expected_hit_records.map(&:id))}
      end
    end
  end
  describe '#show_via_frontend' do
    let(:last_hit){ShortenedUrlHit.last}
    let(:ua_agent){'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36'}
    let(:shortened_url){create(:google_shortened_url)}
    context 'non existing shortened_url' do
      before do
        get :show, params: {short_code: short_code}
      end
      let(:short_code){'RANOIOIJD'}
      specify{expect(response).to have_http_status(:not_found)}
    end
    context 'valid shortened_url' do
      before do
        request.user_agent = ua_agent
        request.env['HTTP_ACCEPT_LANGUAGE'] = "en-US"
        get :show, params: {short_code: short_code}
      end
      let(:short_code){shortened_url.short_code}
      let(:short_path){"/s/#{shortened_url.short_code}"}
      specify{expect(response).to redirect_to(shortened_url.url)}
      context 'recording the hit' do
        subject{last_hit}
        specify{should_not be_nil}
        specify{should have_attributes(operating_system_version: have_attributes(name: '10.12.2'))}
        specify{should have_attributes(ip_address: request.remote_ip)}
        specify{should have_attributes(accept_language: 'en-US', url: shortened_url.url, shortened_url_id: shortened_url.id, user_agent: ua_agent)}
      end
    end
  end
end
