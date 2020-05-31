# frozen_string_literal: true

class PagesController < DashboardController
  def home
    result = Connections::ListService.call(user: current_user)

    if result.success?
      @connections = result.connections
    else
      flash[:alert] = result.error
    end
  end
end
