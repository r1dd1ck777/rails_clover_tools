# frozen_string_literal: true

module Clover
  module Utils
    # This module is responsible translating date to Clover API
    module Time
      class << self
        # Clover::Utils::Time.at(123123123000)
        # @return Time
        def at(clover_timestamp)
          ::Time.zone.at(clover_timestamp/1000)
        end

        # Clover::Utils::Time.prettify(123123123000)
        def prettify(clover_timestamp)
          ::I18n.l(at(clover_timestamp))
        end

        # Clover::Utils::Time.to_i(123123123000)
        # Clover::Utils::Time.to_i(Time.zone.now)
        def to_i(ruby_date_time)
          is_i?(ruby_date_time) ? ruby_date_time : ruby_date_time.to_i * 1000
        end
        
        protected

        # sorry but linux & windows have different mention in var.is_a?(Fixnum)
        def is_i?(var)
          var == var.to_i
        end
      end
    end
  end
end
