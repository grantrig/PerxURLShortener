class DashboardsController < ApplicationController
  include RendersHome
  def home
    render_dashboard_home
  end
end
