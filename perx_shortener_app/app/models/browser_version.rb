class BrowserVersion < ApplicationRecord
  belongs_to :browser_type, required: true
  validates_presence_of :browser_type
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :browser_type_id
end
