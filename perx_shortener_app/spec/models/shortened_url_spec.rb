require 'rails_helper'
require 'spec_helper'

RSpec.describe ShortenedUrl, type: :model do
  describe 'Validations' do
    let(:url){'http://www.google.com'}
    let(:shortened_url){ShortenedUrl.create!(url: url)}
    it 'creates a short code without an api credential id using a model method' do
      expect(shortened_url).to be_valid
    end

    # The uniqueness test is not possible, due to short code being set during before validate when it's a new_record?.  Rspec tries to set short_code to the same value which is always overwritten in before_validation.  So it looks like its saving with the same value, but the model changes the value before save.  I could fix it by writing a custom test which skips validation, but I'm going to save that for later since I'm unfamilier with writing shoulda/rspec.  I could also make a special bypass method/var for set_short_code, but that might be abused later on.
    # it 'checks unique short code' do
    #   expect(shortened_url).to validate_uniqueness_of(:short_code)
    # end
    it 'validates length of short code' do
      expect(shortened_url).to validate_length_of(:short_code).is_at_least(6).is_at_most(12)
    end
    it 'validates length of url' do
      expect(shortened_url).to validate_length_of(:url).is_at_least(6).is_at_most(1000)
    end
    it 'sets short code before create' do
      expect(shortened_url).to callback(:set_short_code).before(:validation)
    end
    it 'should not change the short code when resaved' do
      shortened_url.url = 'http://www.yahoo.com'
      old_short_code = shortened_url.short_code
      shortened_url.save!
      expect(shortened_url.short_code).to eq(old_short_code)
    end
  end
  specify{should belong_to(:api_credential)}
  specify{should have_many(:shortened_url_hits)}
  it{should have_db_index(:short_code).unique(true)}
end
