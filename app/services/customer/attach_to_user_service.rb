# frozen_string_literal: true

module Customer
  class AttachToUserService < ApplicationService
    before do
      validate_context
    end

    def call
      context.user.update(
        customer_id: context.customer_id,
        identifier: context.identifier,
        secret: context.secret
      )
    end

    private

    def validate_context
      context.fail!(error: 'Missing attribute')   if context.customer_id.blank? || context.secret.blank?
      context.fail!(error: 'Mismatch Identifier') if context.user.identifier != context.identifier
    end
  end
end
