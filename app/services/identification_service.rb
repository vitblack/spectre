# frozen_string_literal: true

require 'base64'
require 'openssl'
require 'digest'

class IdentificationService < ApplicationService
  delegate :request, to: :context

  before do
    request_signature || context.fail!
    api_version       || context.fail!

    @public_key = OpenSSL::PKey::RSA.new(File.read('config/spectre_public.pem'))
    @body = { data: request.params.dig(:data), meta: request.params.dig(:meta) }.to_s
  end

  def call
    validate_signature || context.fail!
  end

  private

  def request_signature
    request.headers['Signature']
  end

  def validate_signature
    url  = "https://spectre-t.herokuapp.com#{request.fullpath}"
    data = "#{url}|#{@body}"

    @public_key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(request_signature), data)
  end

  def api_version
    request.params.dig(:meta, :version).to_i == 5
  end
end
