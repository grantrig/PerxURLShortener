class APIHitResult
  attr_accessor :request_json, :hits
  def self.create_from_records(request_json, hits)
    o = new
    o.request_json = request_json
    o.hits = hits
    o
  end

  def hit_results
    hits.map do |hit|
      {
        id: hit.id,
        ip_address: hit.ip_address,
        utc_seconds: hit.created_at.to_i,
        operating_system: hit.operating_system_version.operating_system.name,
        operating_system_version: hit.operating_system_version.name,
        browser_type: hit.browser_version.browser_type.name,
        browser_version: hit.browser_version.name,
        device: hit.device.name,
        accept_language: hit.accept_language,
        user_agent: hit.user_agent,
        url: hit.url,
        referer: hit.referer
      }
    end
  end

  def query_result
    request_json.slice(:short_code, :since_utc_seconds, :until_utc_seconds)
  end

  def response
    {
      shortened_url_hits: hit_results,
      query: query_result
    }
  end
end
