# frozen_string_literal: true

require 'open-uri'
module Clover
  module Api
    module Exports
      # This module is responsible for downloading elements from export:
      module Elements
        class << self

          # @param export Hash
          #  export - data in json given by API
          # @return Array
          #  returns an array of saved files
          def download(export)
            Paranoya::Log.("Elements - download: #{export}", export)
            result = download_urls urls: urls(export), export_id: export['id']
            Paranoya::Log.("Elements - downloaded: #{export['id']}", {
              export: export,
              result: result,
            })

            result
          end

          protected

          def download_urls(urls:, export_id:)
            urls.each_with_index do  |url, i|
              download_url url: url, export_id: export_id, i: i
            end
          end

          def download_url(url:, export_id:, i:)
            file_location = Rails.root.join('tmp', "#{export_id}_#{i}.json")
            open(file_location, 'wb') do |file|
              file << open(url).read
            end
            file_location
          end

          def urls(export)
            export['exportUrls'].map{|e| e["url"] }
          end
        end
      end
    end
  end
end
