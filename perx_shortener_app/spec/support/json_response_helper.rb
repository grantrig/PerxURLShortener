# spec/support/request_helpers.rb
module Requests  
  module JsonHelpers
    def json_response
      @response_json ||= JSON.parse(response.body).with_indifferent_access
    end
  end
end  
