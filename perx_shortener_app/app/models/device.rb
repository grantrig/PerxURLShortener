class Device < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :shortened_url_hits
end
