# frozen_string_literal: true

require 'uri'

module Connections
  class FindService < ApplicationService
    delegate :connection_id, :customer_secret, to: :context

    before do
      validate_context
    end

    def call
      saltedge = Saltedge.new(customer_secret: customer_secret)
      saltedge.get("connections/#{connection_id}")

      if saltedge.ok?
        context.connection = saltedge.body
      else
        context.fail!(error: saltedge.error[:message])
      end
    end

    private

    def validate_context
      context.fail!(error: 'Missing connection_id attribute')   if connection_id.blank?
      context.fail!(error: 'Missing customer_secret attribute') if customer_secret.blank?
    end
  end
end
