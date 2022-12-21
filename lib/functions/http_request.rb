# frozen_string_literal: true

require_relative 'base.rb'
require 'byebug'
require 'json'
require 'faraday'
require 'hash_at_path'

module Functions
  class HttpRequest < Base
    REQUEST_TYPE_VALUES = {get: 'get',
                           post: 'post',
                           patch: 'patch',
                           put: 'put',
                           delete: 'delete'}

    attr_accessor :url, :request_type, :request_header_json, :request_body,
                  :only_response_200, :result_selector_json, :response_status_variable

    validates :url, :request_type, presence: true
    validates :request_type, inclusion: { in: REQUEST_TYPE_VALUES.values }
    validates :url, format: { with: Regexp.new('\A(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#\[\]@!\$&\'\(\)\*\+,;=.]+\Z') }

    def done!(_element)
      send_request
      save_status
      if only_response_200 && @http_response.status != 200
        raise StandardError, "Запрос вернул статус #{@http_response.status}, а ожидалось 200"
      end

      save_result
    end

    private

    attr_accessor :http_response

    def send_request
      case request_type
      when REQUEST_TYPE_VALUES[:get]
        @http_response = Faraday.get(url)
      when REQUEST_TYPE_VALUES[:post]
        @http_response = Faraday.post(url) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['accept'] = 'text/plain'
          req.body = request_body.to_json
        end
      when REQUEST_TYPE_VALUES[:patch]
        @http_response = Faraday.patch(url) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['accept'] = 'text/plain'
          req.body = subject_attributes.to_json
        end
      when REQUEST_TYPE_VALUES[:put]
        @http_response = Faraday.put(url) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['accept'] = 'text/plain'
          req.body = subject_attributes.to_json
        end
      when REQUEST_TYPE_VALUES[:delete]
        @http_response = Faraday.delete(url)
      else
        raise ArgumentError, "Неизвестный RequestType #{request_type}"
      end



      # response = Faraday.get(target_url, { 'PageSize' => page_size, 'PageNumber' => page_number })
      # raise HttpServiceError, response.body unless response.status == 200
      #
      # JSON.parse(response.body).dig(*index_data_way).map do |brand_hash|
      #   subject_class.new(brand_hash)
      # end
    end

    def save_status
      return if @response_status_variable.blank?

      self.storage[@response_status_variable] = @http_response.status
    end

    def save_result
      return if result_selector_json.empty?

      result_selector = result_selector_json
      response_body_json = @http_response.body
      response_body = JSON.parse(response_body_json)
      result_selector.each do |variable_name, xpath|
        self.storage[variable_name] = response_body.deep_stringify_keys.at_path(xpath)
      end
    end
  end
end
