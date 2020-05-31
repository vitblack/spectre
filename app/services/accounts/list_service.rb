# frozen_string_literal: true

module Accounts
  class ListService < ApplicationService
    delegate :user, to: :context

    before do
      validate_context
    end

    def call
      saltedge = Saltedge.new
      saltedge.get('accounts', customer_id: context.user.customer_id)

      if saltedge.ok?
        context.accounts = saltedge.body
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
