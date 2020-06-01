# frozen_string_literal: true

require 'uri'

module Connections
  class RemoveService < ApplicationService
    delegate :connection_id, :connection_secret, to: :context

    before do
      validate_context
    end

    def call
      saltedge = Saltedge.new(connection_secret: connection_secret)
      saltedge.delete("connections/#{connection_id}")

      if saltedge.ok?
        context.body = saltedge.body
      else
        context.fail!(error: saltedge.error[:message])
      end
    end

    private

    def validate_context
      context.fail!(error: 'Missing connection_id attribute')     if connection_id.blank?
      context.fail!(error: 'Missing connection_secret attribute') if connection_secret.blank?
    end
  end
end
