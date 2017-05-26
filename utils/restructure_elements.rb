# frozen_string_literal: true

module Clover
  module Utils
    # This module is responsible traslating date to Clover API
    module RestructureElements
      class << self

        # Clover::Utils::RestructureElements.({'elements' => [123]})
        #  => [123]
        def call(hash)
          process(hash)
        end

        protected

        def process(value)
          if value.is_a?(Hash)
            return process_hash(value)
          end

          if value.is_a?(Array)
            return process_array(value)
          end

          value
        end

        def process_array(array)
          array.map{ |hash_or_array| process hash_or_array }
        end

        def process_hash(hash)
          result = {}
          hash.each do |k, v|
            if k == 'elements'
              return process(v)
            else
              result[k] = process(v)
            end
          end

          result
        end
      end
    end
  end
end
