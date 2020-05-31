# frozen_string_literal: true

class AccountsController < DashboardController
  def index
    result = Accounts::ListService.call(user: current_user, connection_id: params[:connection_id])

    if result.success?
      @accounts = result.accounts
    else
      flash[:alert] = result.error
    end
  end
end
