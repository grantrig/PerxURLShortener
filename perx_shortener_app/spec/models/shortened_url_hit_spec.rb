require 'rails_helper'
require 'spec_helper'

RSpec.describe ShortenedUrlHit, type: :model do
  describe 'validations' do
    specify{should validate_presence_of(:user_agent)}
    specify{should validate_presence_of(:url)}
    specify{should validate_presence_of(:shortened_url)}
    specify{should validate_presence_of(:accept_language)}
    specify{should validate_presence_of(:browser_version)}
    specify{should validate_presence_of(:operating_system_version)}
    specify{should_not validate_presence_of(:device)} # Device is sometimes nil
    specify{should have_db_index(:shortened_url_id)}
    specify{should allow_value('').for(:referer)}
    specify{should_not allow_value(nil).for(:referer)}
    specify{should validate_length_of(:referer).is_at_least(0).is_at_most(1000)}

  end
  describe '#load_ua_agent' do
    let(:shortened_url_hit){ShortenedUrlHit.new}
    let(:shortened_url_hit_with_ua){ShortenedUrlHit.new.tap{|s| s.load_user_agent(ua_agent)}}
    let(:ua_agent){'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36'}
    subject{shortened_url_hit}
    context 'when brand new operating system & version' do
      before{shortened_url_hit.load_user_agent(ua_agent)}
      specify{expect(shortened_url_hit.operating_system_version).to be_a_new_record}
      specify{expect(shortened_url_hit.operating_system_version.name).to eq('10.12.2')}
      specify{expect(shortened_url_hit.operating_system_version.operating_system.name).to eq('Mac')}
    end
    context 'when operating system & version have been encountered' do
      before do
        OperatingSystemVersion.create!(name: '10.12.2', operating_system: OperatingSystem.create!(name: 'Mac'))
        shortened_url_hit.load_user_agent(ua_agent)
      end
      specify{expect(shortened_url_hit.operating_system_version).not_to be_a_new_record}
      specify{expect(OperatingSystemVersion.count).to eq(1)}
      specify{expect(OperatingSystem.count).to eq(1)}
    end
    specify{expect(shortened_url_hit_with_ua.operating_system_version).to have_attributes(name: '10.12.2', operating_system: have_attributes(name: 'Mac'))}
    specify{expect(shortened_url_hit_with_ua.browser_version).to have_attributes(name: '57.0.2987.98', browser_type: have_attributes(name: 'Chrome'))}
    specify{expect(shortened_url_hit_with_ua.device).to have_attributes(name: 'desktop')}
    specify{should belong_to(:shortened_url)}

  end
end
