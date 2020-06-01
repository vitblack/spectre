# frozen_string_literal: true

module Api
  class CallbacksController < ApiController
    before_action :authenticate

    def success
      head 204
    end

    def fail
      head 204
    end

    private

    def authenticate
      result = IdentificationService.call(request: request)
      head 401 if result.failure?
    end
  end
end