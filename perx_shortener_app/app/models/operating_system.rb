class OperatingSystem < ApplicationRecord
  has_many :operating_system_versions
  validates_presence_of :name
  validates_uniqueness_of :name
end
