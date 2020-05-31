# frozen_string_literal: true

class ConnectionsController < DashboardController
  def index; end

  def new
    result = Connections::CreateService.call(user: current_user)

    if result.success?
      connect_url = result.connect_url

      redirect_to connect_url
    else
      flash[:alert] = result.error
      redirect_back fallback_location: root_path
    end
  end
end
