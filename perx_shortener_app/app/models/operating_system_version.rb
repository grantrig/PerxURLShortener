class OperatingSystemVersion < ApplicationRecord
  belongs_to :operating_system
  has_many :shortened_url_hits

  validates_presence_of :name
  validates_presence_of :operating_system
  validates_uniqueness_of :name, scope: :operating_system_id
end
