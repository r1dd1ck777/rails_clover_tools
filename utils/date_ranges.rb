# frozen_string_literal: true

module Clover
  module Utils
      module DateRanges
        class << self
          # Example: Clover::Utils::DateRanges.create from: 1.month.ago, to: Time.zone.now, range: 2.days
          def create(from:, to:, range:)
            result = []
            i_from = from
            while i_from < to
              i_to = i_from + range
              i_to = to if i_to > to
              result << {
                  from: i_from,
                  to: i_to,
              }
              i_from = i_from + range
            end
            result
          end
        end
      end
  end
end
