require 'rails_helper'
require 'spec_helper'

RSpec.describe OperatingSystemVersion, type: :model do
  describe 'validations' do
    specify{should validate_presence_of(:name)}
    specify{should validate_uniqueness_of(:name).scoped_to(:operating_system_id)}
    specify{should validate_presence_of(:operating_system)}
    specify{should have_db_index(%i[name operating_system_id]).unique(true)}
  end
end
