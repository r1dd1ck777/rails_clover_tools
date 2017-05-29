# frozen_string_literal: true

require 'net/http'
module Clover
  module Api
    # This class is responsible for generating endpoints for Clover API
    module Url
      class << self
        # @param resource_path_name Symbol
        # @param params Hash
        # examples:
        #  Clover::Api::Url.(:merchant_exports, access_token: 'foo', limit: 100)
        #  =>
        def call(resource_path_name, params = {})
          resource_path = resource_path(resource_path_name)
          final_params = magic_params.merge(params)

          Rails.logger.debug "final_params #{final_params}"
          resource_path, params_left_for_query = replace_params(resource_path, magic_params.merge(params))
          result = resource_path + '?' + params_left_for_query.to_query
          url = replace_array_brackets result
          validate_params!(url)
          url
        end

        protected

        def validate_params!(url)
          raise ParamsException, "Missing required params, " if url =~ /\/:[.]+\//
        end

        def replace_array_brackets str
          str.gsub "%5B%5D", ''
        end

        def magic_params
          {
              # merchant_id: ENV['CLOVER_MERCHANT_ID'],
              # api_domain: ENV['CLOVER_API_DOMAIN'],
              # access_token: ENV['CLOVER_ACCESS_TOKEN']
          }
        end

        def replace_params str, params
          params = params.dup
          params.each do |k, v|
            next if v.nil?
            param_key = ":#{k}"
            if str.include? param_key
              str = str.gsub param_key, v.to_s
              params.delete k
            end
          end

          return str, params
        end

        def routes
          Clover::Api::Routes.list
        end

        def resource_path(name)
          result = routes[name]
          raise BadRouteException unless result
          ":api_domain#{result}"
        end
      end

      class BadRouteException < Exception
      end

      class ParamsException < Exception
      end
    end
  end
end
