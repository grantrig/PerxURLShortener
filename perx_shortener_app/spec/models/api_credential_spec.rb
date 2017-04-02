require 'rails_helper'
require 'spec_helper'

RSpec.describe APICredential, type: :model do
  describe 'Validations' do
    api_credential = APICredential.create!(name: 'Test')
    it 'validates length of api_key' do
      expect(api_credential).to validate_length_of(:api_key).is_equal_to(APICredential::API_KEY_LENGTH)
    end
    it 'validates length of api_secret' do
      expect(api_credential).to validate_length_of(:api_secret).is_equal_to(APICredential::API_SECRET_LENGTH)
    end
    it 'sets short code before create' do
      expect(api_credential).to callback(:set_key_and_secret).before(:validation)
    end
  end
end
