require 'rails_helper'
require 'spec_helper'

RSpec.describe OperatingSystem, type: :model do
  subject{OperatingSystem.new}
  describe 'validations' do
    specify{should validate_presence_of(:name)}
    specify{should validate_uniqueness_of(:name)}
    specify{should have_db_index(:name).unique(true)}
  end
end
