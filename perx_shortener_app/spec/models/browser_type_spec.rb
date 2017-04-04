require 'rails_helper'

RSpec.describe BrowserType, type: :model do
  describe 'validations' do
    specify{should validate_presence_of(:name)}
    specify{should validate_uniqueness_of(:name)}
    specify{should have_db_index(:name).unique(true)}
  end
end
