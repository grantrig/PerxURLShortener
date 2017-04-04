require 'rails_helper'

RSpec.describe BrowserVersion, type: :model do
  describe 'validations' do
    specify{should validate_presence_of(:name)}
    specify{should validate_uniqueness_of(:name).scoped_to(:browser_type_id)}
    specify{should validate_presence_of(:browser_type)}
    specify{should have_db_index(%i[name browser_type_id]).unique(true)}
  end
end
