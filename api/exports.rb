# frozen_string_literal: true

module Clover
  module Api
    # This module is responsible for working with exports API:
    module Exports
      POLL_DELAY_IN_SECONDS = 15
      class << self
        # get single export details by export id
        # @return Hash
        # example:
        #  Clover::Api::Exports.get id: '2Z4W0KZSRPS24', access_token: ENV['CLOVER_ACCESS_TOKEN']
        def get(params)
          Clover::Api::Http.get :merchant_export, params: params
        end

        # will wait until status != 'PENDING'
        # get single export details by export id
        # @return Hash
        # example:
        #  Clover::Api::Exports.get_when_ready id: '2Z4W0KZSRPS24', access_token: ENV['CLOVER_ACCESS_TOKEN']
        def get_when_ready(params)
          export = get params
          Rails.logger.info("Export - get_when_ready: #{export}", export)

          while ['PENDING', 'IN_PROGRESS'].include?(export['status'])
            Rails.logger.info("Export - poll: #{export}", export)
            export = get params
            sleep POLL_DELAY_IN_SECONDS
          end

          Rails.logger.info("Export - ready: #{export}", export)

          export
        end

        # create a new export
        # return created export info
        # @return Hash
        # example:
        #  Clover::Api::Exports.create from: Time.zone.now, to: 1.week.ago, access_token: ENV['CLOVER_ACCESS_TOKEN']
        def create(from:, to:, **params)
          payload = {
            type: 'ORDERS',
            startTime: from.to_time.to_i * 1000,
            endTime: to.to_time.to_i * 1000
          }
          Rails.logger.info("Export - try to create: #{payload}")
          response = Clover::Api::Http.post :merchant_exports, params: params, payload: payload
          Rails.logger.info("Export - created: #{response}", response)
          response
        end

        # Clover::Api::Exports.index access_token: ENV['CLOVER_ACCESS_TOKEN']
        def list(params)
          Clover::Api::Http.get :merchant_exports, params: params
        end

        # Clover::Api::Exports.download id: '9NYBM3GGK05E2', access_token: ENV['CLOVER_ACCESS_TOKEN']
        def download(params)
          export = Clover::Api::Exports.get_when_ready(params)
          Clover::Api::Exports::Elements.download(export)
        end
      end
    end
  end
end
