class BrowserType < ApplicationRecord
  has_many :browser_versions
  validates_uniqueness_of :name
  validates_presence_of :name
end
