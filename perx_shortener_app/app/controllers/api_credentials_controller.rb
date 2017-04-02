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

  def permitted_params
    params.require(:api_credential).permit(:name)
  end

end
