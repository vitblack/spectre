# frozen_string_literal: true

require 'faraday'
require 'json'

class Saltedge
  APP_ID = Rails.application.credentials.saltedge[:app_id]
  SECRET = Rails.application.credentials.saltedge[:secret]

  INVALID_JSON_FORMAT_ERROR = {
    class: 'Spectre.InvalidJsonFormat',
    message: 'Invalid JSON format',
    documentation_url: nil
  }.freeze

  attr_reader :connection, :response, :body, :error

  def initialize
    @body = {}
    @connection = Faraday.new(url: 'https://www.saltedge.com/api/v5') do |faraday|
      faraday.response :logger                 # log requests to STDOUT
      faraday.adapter Faraday.default_adapter  # make requests with Net::HTTP
      add_headers faraday
    end
  end

  def post(url, args)
    @response = connection.post(url, args.to_json)
    read_body
  end

  def ok?
    error.blank?
  end

  private

  def add_headers(conn)
    conn.headers['User-Agent']    = 'Spectre/TestApp'
    conn.headers['Accept']        = 'application/json'
    conn.headers['Content-type']  = 'application/json'
    conn.headers['App-Id'] = APP_ID
    conn.headers['Secret'] = SECRET
  end

  def read_body
    parse_request response.body
  end

  def parse_request(body)
    @body = JSON.parse(body, symbolize_names: true)
    @error = @body[:error] if @body[:error]
  rescue JSON::ParserError
    @error = INVALID_JSON_FORMAT_ERROR
  end

  def response_successful?
    response.status == 200
  end
end