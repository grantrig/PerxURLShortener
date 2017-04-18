class ShortenedUrlsController < ApplicationController

  include RendersHome

  def create
    respond_to do |format|
      format.html{create_via_frontend}
      format.json{create_via_api}
    end
  end

  def permitted_params
    params.require(:shortened_url).permit(:url)
  end

  def show
    respond_to do |format|
      format.html{show_via_html}
      format.json{show_via_api}
    end
  end

  def show_via_api
    api_request = APIRequest.new_from_params(params)
    return head :forbidden unless api_request.authenticated?
    json_parsed = api_request.json_parsed
    # Using json for the short code instead of params[:short_code] since the api_request is signed
    shortened_url = ShortenedUrl.where('short_code = ?', json_parsed[:short_code]).first
    return head :not_found unless shortened_url
    return head :forbidden unless shortened_url.api_credential_id == api_request.api_credential.id
    query = shortened_url.shortened_url_hits
    query = query.where('UNIX_TIMESTAMP(CONVERT_TZ(created_at, "+00:00", @@session.time_zone)) >= ?', json_parsed[:since_utc_seconds]) if json_parsed[:since_utc_seconds]
    query = query.where('UNIX_TIMESTAMP(CONVERT_TZ(created_at, "+00:00", @@session.time_zone)) <= ?', json_parsed[:until_utc_seconds]) if json_parsed[:until_utc_seconds]
    hits = query
    render json: APIHitResult.create_from_records(json_parsed, hits).response
  end

  def show_via_html
    shortened_url = ShortenedUrl.where('short_code = ?', params[:short_code]).first
    return head :not_found unless shortened_url
    ShortenedUrlHit.record_hit(request: request, shortened_url: shortened_url)
    redirect_to shortened_url.url
  end

  private

  def create_via_frontend
    @shortened_url = ShortenedUrl.new(permitted_params)
    if @shortened_url.save
      render :create
    else
      render_dashboard_home
    end
  end

  def create_via_api
    api_request = APIRequest.new_from_params(params)
    return head :forbidden unless api_request.authenticated?
    @shortened_url = ShortenedUrl.new(url: api_request.json_parsed[:url], api_credential: api_request.api_credential)
    return head :bad_request unless @shortened_url.save
    render status: :created, location: @shortened_url.full_shortened_url, json: @shortened_url
  end
end
