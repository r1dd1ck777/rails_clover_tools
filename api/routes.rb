# frozen_string_literal: true

module Clover
  module Api
    # This class is responsible for holding routes
    module Routes
      class << self
        def list
          {
              merchant_exports: '/v3/merchants/:merchant_id/exports',
              merchant_export: '/v3/merchants/:merchant_id/exports/:id',
              merchant_devices: '/v3/merchants/:merchant_id/devices',
              merchant_device: '/v3/merchants/:merchant_id/devices/:id',
              merchant_orders: '/v3/merchants/:merchant_id/orders',
              merchant_order: '/v3/merchants/:merchant_id/orders/:id',
              merchant_payments: '/v3/merchants/:merchant_id/payments',
              merchant_payment: '/v3/merchants/:merchant_id/payments/:id',
              merchant_order_line_items: '/v3/merchants/:merchant_id/orders/:order_id/line_items',
              merchant_order_line_item: '/v3/merchants/:merchant_id/orders/:order_id/line_items/:id',
          }
        end
      end
    end
  end
end
