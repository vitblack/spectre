# frozen_string_literal: true

class PagesController < DashboardController
  def home
    result = HomeService.call(user: current_user)

    if result.success?
      @connections = result.connections
      @accounts = result.accounts
    else
      flash[:alert] = result.error
    end
  end
end
