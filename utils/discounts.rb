# frozen_string_literal: true

module Clover
  module Utils
    module Discounts
      class << self
        # Example: Clover::Utils::Discounts.calculate(res['discounts'], 'amount')
        def calculate(elements, item)
          total = 0
          elements.each do |ele|
            total += ele[item].present? ? ele[item] : 0
          end
          total.present? ? total : 0
        end
      end
    end
  end
end
