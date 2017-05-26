# frozen_string_literal: true

module Clover
  module Api
    # This module is responsible for working with Payments API:
    module Payments
      MAX_LIMIT = 1000

      class << self
        # Get Payments from api
        # Transforms "from" and "to" params into a filter
        # @return Array
        # Example:
        #  Clover::Api::Payments.list from: 1.month.ago, to: Time.zone.now, limit: 22
        #  Clover::Api::Payments.list from: 1234567890123, to: 1234567890123
        def list(params = {})
          params = expanded_params(params)
          filter = params[:filter] || []

          from = params.delete :from
          filter << "createdTime>#{Clover::Utils::Time.to_i(from)}" if from

          to = params.delete :to
          filter << "createdTime<#{Clover::Utils::Time.to_i(to)}" if to

          params[:filter] = filter if filter.any?
          result = Clover::Api::Http.get(:merchant_payments, params: params)

          result
        end

        # Get Payments with pagination if there are more then can serve single response
        # @return Array
        # Example:
        #  Clover::Api::Payments.list_deep from: 1.month.ago, to: Time.zone.now
        #  Clover::Api::Payments.list_deep from: 1234567890123, to: 1234567890123
        def list_deep(params = {})
          params = params.dup
          raise "\"offset\" is not available option" if params[:offset]
          raise "\"limit\" is not available option" if params[:limit]

          result = []
          params[:limit] = MAX_LIMIT

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
            break if current_page_orders.count < MAX_LIMIT
          end

          result.reverse
        end

        protected

        def expanded_params(params)
          params = params.dup
          # params[:expand] ||= 'lineItems,payments,discounts'
          params
        end
      end
    end
  end
end
