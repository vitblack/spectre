# frozen_string_literal: true

module Transactions
  class ListService < ApplicationService
    delegate :connection_id, :account_id, to: :context

    before do
      validate_context
    end

    def call
      saltedge = Saltedge.new
      saltedge.get('transactions', connection_id: context.connection_id, account_id: context.account_id)

      if saltedge.ok?
        context.transactions = saltedge.body
      else
        context.fail!(error: saltedge.error[:message])
      end
    end

    private

    def validate_context
      context.fail!(error: 'Missing connection_id attribute') if context.connection_id.blank?
    end
  end
end
