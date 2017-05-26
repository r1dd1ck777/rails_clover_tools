# frozen_string_literal: true

require 'open-uri'
module Clover
  module Api
    module Orders
      # This module is responsible for downloading elements from export:
      module LineItems
        class << self

          # Clover::Api::Orders::LineItems.get order_id: '', id: ''
          def get(params = {})
            params = expanded_params params
            Clover::Api::Http.get :merchant_order_line_item, params: params
          end

          # Clover::Api::Orders::LineItems.list order_id: ''
          def list(params = {})
            params = expanded_params params
            Clover::Api::Http.get :merchant_order_line_items, params: params
          end

          protected

          def expanded_params params
            params[:expand] ||= 'discounts,taxRates,payments'
            params
          end
        end
      end
    end
  end
end
