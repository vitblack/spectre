# frozen_string_literal: true

module Connections
  class ListService < ApplicationService
    delegate :user, to: :context

    before do
      validate_context
    end

    def call
      saltedge = Saltedge.new(customer_secret: context.user.secret)
      saltedge.get('connections', customer_id: context.user.customer_id)

      if saltedge.ok?
        context.connections = saltedge.body
      else
        context.fail!(error: saltedge.error[:message])
      end
    end

    private

    def validate_context
      context.fail!(error: 'Customer not attached') if context.user.customer_id.blank?
      context.fail! if context.user.secret.blank?
    end
  end
end
