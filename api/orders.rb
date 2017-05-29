# frozen_string_literal: true

module Clover
  module Api
    # This module is responsible for working with orders API:
    module Orders
      MAX_ORDERS_LIMIT = 1000
      class << self
        # Get order details from api
        # @return Hash
        # Example:
        #  Clover::Api::Orders.get id: 'N4891H4BW4VVY', access_token: ENV['CLOVER_ACCESS_TOKEN']
        def get(params = {})
          params = expanded_params params
          Clover::Api::Http.get :merchant_order, params: params
        end

        # Get orders from api
        # Transforms "from" and "to" params into a filter
        # @return Array
        # Example:
        #  Clover::Api::Orders.list from: 1.month.ago, to: Time.zone.now, limit: 22
        #  Clover::Api::Orders.list from: 1234567890123, to: 1234567890123
        def list(params = {})
          params = expanded_params params
          filter = params[:filter] || []

          from = params.delete :from
          filter << "createdTime>#{Clover::Utils::Time.to_i(from)}" if from

          to = params.delete :to
          filter << "createdTime<#{Clover::Utils::Time.to_i(to)}" if to

          params[:filter] = filter if filter.any?
          result = Clover::Api::Http.get(:merchant_orders, params: params)

          result
        end

        # Get orders with pagination if there are more then can serve single response
        # @return Array
        # Example:
        #  Clover::Api::Orders.list_deep from: 1.month.ago, to: Time.zone.now
        #  Clover::Api::Orders.list_deep from: 1234567890123, to: 1234567890123
        def list_deep(params = {})
          params = params.dup
          raise "\"offset\" is not available option" if params[:offset]
          raise "\"limit\" is not available option" if params[:limit]

          result = []
          params[:limit] = MAX_ORDERS_LIMIT

          page = params.delete(:page) || 0
          while true do
            current_page_orders = list params.merge(offset: page * params[:limit])
            begin
              result = result + current_page_orders
            rescue => e
              p e.to_s
              p current_page_orders
            end
            page = page + 1
            break if current_page_orders.count < MAX_ORDERS_LIMIT
          end

          result.reverse
        end

        protected

        # will NOT add expand fields if params[:expand] === false
        def expanded_params params
          params[:expand] = 'lineItems,payments,discounts' if params[:expand].nil?
          params
        end
      end
    end
  end
end
