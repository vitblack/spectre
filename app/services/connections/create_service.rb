# frozen_string_literal: true

require 'uri'

module Connections
  class CreateService < ApplicationService
    delegate :user, to: :context

    before do
      validate_context

      @body = {
        data: {
          customer_id: context.user.customer_id,
          consent: consent,
          attempt: attempt
        }
      }
    end

    def call
      saltedge = Saltedge.new(customer_secret: context.user.secret)
      saltedge.post('connect_sessions/create', @body)

      if saltedge.ok?
        context.connect_url = saltedge.body[:connect_url]
      else
        context.fail!(error: saltedge.error[:message])
      end
    end

    private

    def validate_context
      context.fail!(error: 'Customer not attached') if context.user.customer_id.blank?
      context.fail! if context.user.secret.blank?
    end

    def consent
      { scopes: %w[account_details transactions_details] }
    end

    def attempt
      {
        return_to: 'https://spectre-t.herokuapp.com/',
        fetch_scopes: %w[accounts transactions]
      }
    end
  end
end
