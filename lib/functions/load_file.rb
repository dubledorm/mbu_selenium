require 'net/http'
require 'uri'
require_relative 'base.rb'

module Functions
  class LoadFile < Base

    attr_accessor :file_id, :file_body, :base_file_name, :file_extension
    validates :file_id, numericality: { only_integer: true }, allow_blank: false
    validates :file_body, :base_file_name, presence: true

    def done!(element)
      local_path = Tempfile.open([base_file_name, file_extension].compact) { |f| f << Base64.strict_encode64(file_body) }.path
      element.send_keys(local_path)
    end
  end
end