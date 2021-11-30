# frozen_string_literal: true

require "oreilly_api/version"
require 'base64'
require 'json'
require 'rest-client'
require 'redis'
require 'redis_utility'

# rubocop:disable Metrics/MethodLength

# OreillyApi
module OreillyApi
  TOKEN = 'oreilly_api_token'
  class << self
    attr_accessor :domain, :version, :client_id, :client_secret, :identity, :account_number

    def config
      yield self
    end

    def redis_utility=(redis_config)
      RedisUtility.redis_config = redis_config
    end

    def payload_id
      "YM#{OreillyApi.account_number}#{DateTime.now.strftime('%Y%m%d%l%S%M')}}"
    end

    def place_order(po_number, vehicles_with_items, stop_order: false)
      payload = {
        'header' => {
          'identity' => OreillyApi.identity,
          'payloadId' => OreillyApi.payload_id,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S")
        },
        'orderHeader' => {
          'poNumber' => po_number,
          'accountNumber' => OreillyApi.account_number,
          'comments' => "test"
        },
        'vehicles' => vehicles_with_items
      }.to_json
      url = "#{base_url}/order/placeOrder?stopOrder=#{stop_order}"
      token = fetch_token
      res = RestClient.post(url, payload, get_header(token))
      place_order_response = JSON.parse(res)
      [res.code, place_order_response]
    end

    def fetch_quote(items)
      payload = {
        'accountNumber' => OreillyApi.account_number,
        'header' => {
          'identity' => OreillyApi.identity,
          'payloadId' => OreillyApi.payload_id,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S")
        },
        'items' => items
      }.to_json
      url = "#{base_url}/quote/fetchQuote"
      token = fetch_token
      res = RestClient.post(url, payload, get_header(token))
      sample_request = JSON.parse(res)
      [res.code, sample_request]
    end

    def sample_request
      token = fetch_token
      url = "#{base_url}/quote/sampleRequest?detailsRequired=false"
      res = RestClient.get(url, get_header(token))
      sample_request = JSON.parse(res)
      [res.code, sample_request]
    end

    def test_place_order
      token = fetch_token
      url = "#{base_url}/order/testPlaceOrder?detailsRequired=false"
      res = RestClient.get(url, get_header(token))
      place_order_response = JSON.parse(res)
      [res.code, place_order_response]
    end

    def invoice(order_number)
      token = fetch_token

      params = "identity=#{OreillyApi.identity}&orderDetails=true&orderNumber=#{order_number}"
      url = "#{base_url}/order/invoice?#{params}"
      res = RestClient.get(url, get_header(token))
      invoice_info = JSON.parse(res)
      [res.code, invoice_info]
    end

    private

    def fetch_token
      oreilly_api_token = RedisUtility.redis.get(OreillyApi::TOKEN) || ''
      return oreilly_api_token unless oreilly_api_token.empty?

      payload = {
        'header' => {
          'identity' => OreillyApi.identity
        }
      }.to_json

      params = "&client_id=#{OreillyApi.client_id}&client_secret=#{OreillyApi.client_secret}"
      url = "#{OreillyApi.domain}/oauth-server/oauth/token?grant_type=client_credentials&device_id=test#{params}"
      res = RestClient.post(url, payload, { 'Content-Type' => 'application/json' })
      token_info = JSON.parse(res)
      @token = token_info['access_token']
      RedisUtility.redis.setex(OreillyApi::TOKEN, 119, @token)
      @token
    end

    def get_header(token)
      { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' }
    end

    def base_url
      "#{OreillyApi.domain}/#{OreillyApi.version}"
    end
  end
  # rubocop:enable Metrics/MethodLength
end
