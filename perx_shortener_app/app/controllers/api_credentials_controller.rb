class ApiCredentialsController < ApplicationController

  include RendersHome

  def create
    @api_credential = APICredential.new(permitted_params)
    if @api_credential.save
      render :create
    else
      render_dashboard_home
    end
  end

  def show
    api_request = APIRequest.new_from_params(params)
    return head :forbidden unless api_request.authenticated? && params[:api_key] == api_request.api_credential.api_key

    render json: APICredentialResult.new(api_request.api_credential).response
  end

  def permitted_params
    params.require(:api_credential).permit(:name)
  end

end
