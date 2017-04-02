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
    @shortened_url = ShortenedUrl.where('short_code = ?', params[:short_code]).first
    redirect_to @shortened_url.url
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
    @shortened_url = ShortenedUrl.new(url: api_request.json_parsed[:url])
    if @shortened_url.save
      render status: :created, location: @shortened_url.full_shortened_url, json: @shortened_url
    else
      return head :bad_request
    end
  end
end
