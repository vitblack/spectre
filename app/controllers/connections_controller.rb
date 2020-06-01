# frozen_string_literal: true

class ConnectionsController < DashboardController
  before_action :find_connection, only: [:destroy]

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

  def destroy
    result = Connections::RemoveService.call(
      connection_id: @connection[:id],
      connection_secret: @connection[:secret]
    )

    if result.success?
      flash[:notice] = 'Connection was successfully destroyed.'
    else
      flash[:alert] = result.error
    end

    redirect_to root_path
  end

  private

  def find_connection
    result = Connections::FindService.call(
      connection_id: params[:id],
      customer_secret: current_user.secret
    )

    if result.success?
      @connection = result.connection
    else
      redirect_to root_path
    end
  end
end
