# frozen_string_literal: true

require 'net/http'
require 'clover/api/url'
module Clover
  module Api
    # This class is responsible for basic (low-level) interactions with clover API
    module Http
      MAX_RETRIES_PER_REQUEST = 10

      class << self
        def post(resource_path_name, options = {})
          call(:post, resource_path_name, options)
        end

        # Clover::Api::Http.get "http://clover...?params=..."
        # Clover::Api::Http.get :merchant_orders, params: { limit: 100, access_token: ... }
        def get(resource_path_name, options = {})
          call(:get, resource_path_name, options)
        end

        def call(type, resource_path_name, options = {})
          url = resource_path_name.is_a?(String) ? resource_path_name : url(resource_path_name, options[:params])
          Rails.logger.debug "url: #{url}"
          uri = URI.parse(url)
          request = create_request(type, uri)
          request.body = options[:payload].to_json if options[:payload]

          response = get_response(uri, request)
          Clover::Utils::LogJson.({
              url: url,
              payload: options[:payload],
              response: response
          }) unless Rails.env.production?
          response
        end

        protected

        def get_response uri, request, tries_left = MAX_RETRIES_PER_REQUEST
          str = client(uri).request(request).body

          if str.include? '{"message":"429 Too Many Requests"}'
            Rails.logger.warn "Api Limit reached, wait 2s (#{tries_left} tries_left)"
            if tries_left > 0
              sleep 1
              get_response uri, request, tries_left - 1
            else
              raise "Api Limits out"
            end
          else
            str == 'null' ? nil : Clover::Utils::RestructureElements.(JSON.parse(str))
          end
        end

        def create_request(type, uri)
          net_class = {
            post: Net::HTTP::Post,
            get: Net::HTTP::Get,
            delete: Net::HTTP::Delete
          }[type]

          net_class.new(uri.request_uri, 'Content-Type' => 'application/json')
        end

        def url(resource_path_name, params = {})
          Clover::Api::Url.(resource_path_name, params)
        end

        def client(uri)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http
        end
      end
    end
  end
end

