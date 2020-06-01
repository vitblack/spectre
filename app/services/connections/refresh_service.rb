# frozen_string_literal: true

require 'uri'

module Connections
  class RefreshService < ApplicationService
    delegate :connection_id, :customer_secret, to: :context

    before do
      validate_context
      @body = {
        data: {
          connection_id: context.connection_id,
          attempt: attempt
        }
      }
    end

    def call
      saltedge = Saltedge.new(customer_secret: customer_secret)
      saltedge.post('connect_sessions/refresh', @body)

      if saltedge.ok?
        context.connect_url = saltedge.body[:connect_url]
      else
        context.fail!(error: saltedge.error[:message])
      end
    end

    private

    def validate_context
      context.fail!(error: 'Missing connection_id attribute')   if connection_id.blank?
      context.fail!(error: 'Missing customer_secret attribute') if customer_secret.blank?
    end

    def attempt
      {
        return_to: 'https://spectre-t.herokuapp.com/',
        fetch_scopes: %w[accounts transactions]
      }
    end
  end
end
