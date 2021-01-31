require 'net/http'
require 'uri'
require_relative 'base.rb'

module Functions
  class LoadFile < Base
    URL_PREFIX = 'http://92.63.193.31'

    attr_accessor :file_id, :file_url
    validates :file_id, numericality: { only_integer: true }, allow_blank: false
    validates :file_url, presence: true

    def done!(element)
      data = download_file!
      local_path = Tempfile.open('load_file') { |f| f << data }.path
      element.send_keys(local_path)
    end

    private

    def download_file!
      Net::HTTP.get(full_file_storage_path).force_encoding('utf-8')
    end

    def full_file_storage_path
      URI.join(URL_PREFIX, file_url)
    end
  end
end