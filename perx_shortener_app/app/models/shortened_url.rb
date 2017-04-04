require 'uri'

class ShortenedUrl < ApplicationRecord

  CODE_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.delete('I').delete('L')
  SHORT_CODE_LENGTH = 6

  before_validation :set_short_code

  belongs_to :api_credential, optional: true, class_name: 'APICredential'

  validates_uniqueness_of :short_code
  validates_length_of :short_code, in: 6..12
  validates_length_of :url, in: 6..1000
  validates_format_of :url, with: %r{https?://.*}

  has_many :shortened_url_hits

  def set_short_code
    self.short_code = self.class.unique_short_code if new_record?
  end

  def self.unique_short_code
    is_unique = false
    short_code = ''
    until is_unique
      short_code = make_random_short_code
      is_unique = where('short_code = ?', short_code).count.zero?
    end
    short_code
  end

  def full_shortened_url
    @port ||= APP_CONFIG[:port].to_i == 80 ? '' : ':' + APP_CONFIG[:port].to_s
    @uri ||= URI("http://#{APP_CONFIG[:hostname]}#{@port}/s/#{short_code}")
    @uri.to_s
  end

  # This is only for generating the random characters.  DOES NOT CHECK UNIQUENESS.
  def self.make_random_short_code
    SHORT_CODE_LENGTH.times.to_a.map{CODE_CHARS[rand(CODE_CHARS.length)]}.join
  end
end
