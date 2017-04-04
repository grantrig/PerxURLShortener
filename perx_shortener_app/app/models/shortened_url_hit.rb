class ShortenedUrlHit < ApplicationRecord
  belongs_to :operating_system_version
  belongs_to :browser_version
  belongs_to :device, optional: true
  belongs_to :shortened_url

  validates_presence_of :url
  validates_presence_of :shortened_url
  validates_presence_of :accept_language
  validates_presence_of :browser_version
  validates_presence_of :operating_system_version
  validates_presence_of :user_agent
  validates_length_of :referer, in: 0..1000

  def load_user_agent(user_agent)
    dd = DeviceDetector.new(user_agent)
    load_operating_system(dd)
    load_browser(dd)
    device_name = [dd.device_type, dd.device_name].join(' ').strip
    self.device = Device.where(name: device_name).first_or_initialize unless device_name.blank?
    self.user_agent = user_agent
  end

  def load_operating_system(dd)
    self.operating_system_version = OperatingSystemVersion.where(name: dd.os_full_version, operating_system: OperatingSystem.where(name: dd.os_name).first_or_create).first_or_initialize
  end

  def load_browser(dd)
    self.browser_version = BrowserVersion.where(name: dd.full_version, browser_type: BrowserType.where(name: dd.name).first_or_create).first_or_initialize
  end

  def self.record_hit(**options)
    options.assert_required_keys(:request, :shortened_url)
    request = options[:request]
    shortened_url = options[:shortened_url]
    record = new(shortened_url: shortened_url, url: shortened_url.url, accept_language: request.headers['Accept-Language'], ip_address: request.remote_ip, referer: request.referer.to_s)
    record.load_user_agent(request.user_agent)
    record.save!
    record
  end
end
