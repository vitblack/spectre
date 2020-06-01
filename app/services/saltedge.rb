# frozen_string_literal: true

require 'faraday'
require 'json'

class Saltedge
  APP_ID = Rails.application.credentials.saltedge[:app_id]
  SECRET = Rails.application.credentials.saltedge[:secret]

  KNOWN_HEADERS_KEYS = %i[customer_secret connection_secret].freeze
  INVALID_JSON_FORMAT_ERROR = {
    class: 'Spectre.InvalidJsonFormat',
    message: 'Invalid JSON format',
    documentation_url: nil
  }.freeze

  attr_reader :connection, :response, :body, :error

  def initialize(headers = {})
    @body = {}
    @connection = Faraday.new(url: 'https://www.saltedge.com/api/v5') do |faraday|
      faraday.response :logger                 # log requests to STDOUT
      faraday.adapter Faraday.default_adapter  # make requests with Net::HTTP
      add_headers faraday, headers
    end
  end

  def post(url, args)
    @response = connection.post(url, args.to_json)
    read_body
  end

  def get(url, args = {})
    @response = connection.get(url, args)
    read_body
  end

  def delete(url)
    @response = connection.delete(url)
    read_body
  end

  def ok?
    error.blank?
  end

  private

  def extra_headers(conn, headers)
    headers&.each do |header, value|

      next unless KNOWN_HEADERS_KEYS.include? header

      conn.headers[normalize_header header] = value
    end
  end

  def normalize_header(header)
    header = header.to_s.tr('_', '-') if header.is_a? Symbol
    header.capitalize
  end

  def add_headers(conn, headers)
    conn.headers['User-Agent']    = 'Spectre/TestApp'
    conn.headers['Accept']        = 'application/json'
    conn.headers['Content-type']  = 'application/json'
    conn.headers['App-Id'] = APP_ID
    conn.headers['Secret'] = SECRET

    extra_headers conn, headers
  end

  def read_body
    parse_request response.body
    @error = INVALID_JSON_FORMAT_ERROR if @body.nil?
  end

  def parse_request(body)
    response = JSON.parse(body, symbolize_names: true)

    @body   = response[:data]   if response[:data]
    @error  = response[:error]  if response[:error]

    if Rails.env.development?
      p '-------------parse_request-----------------------'
      p body
      p '-------------parse_request-----------------------'
    end
  rescue JSON::ParserError
    @error = INVALID_JSON_FORMAT_ERROR
  end

  def response_successful?
    response.status == 200
  end
end