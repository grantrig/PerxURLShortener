require 'securerandom'

class APICredential < ApplicationRecord
  API_KEY_LENGTH = 12
  API_SECRET_LENGTH = 6

  before_validation :set_key_and_secret

  validates_uniqueness_of :api_key
  validates_length_of :api_key, is: API_KEY_LENGTH
  validates_length_of :api_secret, is: API_SECRET_LENGTH

  validates :name, presence: true

  has_many :shortened_urls

  def set_key_and_secret
    return unless new_record?
    self.api_key = self.class.unique_api_key
    self.api_secret = self.class.generate_random_hash(API_SECRET_LENGTH)
  end

  def self.unique_api_key
    is_unique = false
    api_key = ''
    until is_unique
      api_key = generate_random_hash(API_KEY_LENGTH)
      is_unique = where('api_key = ?', api_key).count.zero?
    end
    api_key
  end

  def self.generate_random_hash(length)
    SecureRandom.hex[1..length]
  end
end
