# frozen_string_literal: true

module Clover
  module Utils
    module LogJson
      class << self
        def call(data)
          File.write log_file, data.to_json unless Rails.env.production?
        end

        def log_file
          Rails.root.join('tmp', "#{::Time.zone.now.to_i}.json")
        end
      end
    end
  end
end
