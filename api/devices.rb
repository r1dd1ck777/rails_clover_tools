# frozen_string_literal: true

module Clover
  module Api
    # This module is responsible for working merchant's devices
    module Devices
      class << self
        # get single export details by export id
        # @return Hash
        # example:
        #  Clover::Api::Devices.get id: '2Z4W0KZSRPS24', access_token: ENV['CLOVER_ACCESS_TOKEN']
        def get(params)
          Clover::Api::Http.get :merchant_device, params: params
        end

        # Clover::Api::Exports.index access_token: ENV['CLOVER_ACCESS_TOKEN']
        def list(params = {})
          Clover::Api::Http.get :merchant_devices, params: params
        end
      end
    end
  end
end
