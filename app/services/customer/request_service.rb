# frozen_string_literal: true

module Customer
  class RequestService < ApplicationService
    before do
      @body = {
        data: {
          identifier: context.user.identifier
        }
      }
    end

    def call
      saltedge = Saltedge.new
      saltedge.post('customers', @body)

      if saltedge.ok?
        add_context saltedge.body
      else
        context.fail!(error: saltedge.error[:message])
      end
    end

    private

    def add_context(body)
      context.customer_id = body[:id]
      context.identifier  = body[:identifier]
      context.secret      = body[:secret]
    end
  end
end
