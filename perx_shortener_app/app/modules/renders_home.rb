module RendersHome
  
  def render_dashboard_home
    @shortened_url ||= ShortenedUrl.new
    @api_credential ||= APICredential.new
    render 'dashboards/home'
  end
end
