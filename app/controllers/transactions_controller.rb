# frozen_string_literal: true

class TransactionsController < DashboardController
  def index
    result = Transactions::ListService.call(
      connection_id: params[:connection_id],
      account_id: params[:account_id],
      status: params[:status]
    )

    if result.success?
      @transactions = result.transactions
    else
      flash[:alert] = result.error
    end
  end
end
