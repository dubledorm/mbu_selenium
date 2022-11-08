# frozen_string_literal: true

require 'faraday'
require 'base64'

module API
  class MainCenter

    I_AM_FREE_URL = 'api/test_tasks/get_task/'
    JOB_RESULT_URL = 'api/test_tasks'
    INSTANCE_ID = 'Это на будующее'

    def initialize(main_center_url)
      @server_url = main_center_url
    end

    def get_job!
      params = { instance_id: INSTANCE_ID }
      url = @server_url + '/' + I_AM_FREE_URL

      response = Faraday.get(url, params, {'Accept' => 'application/json'})
      raise 'Сетевая ошибка при обращении к северу. body = ' + response.body unless response.status == 200

      JSON.parse(response.body).symbolize_keys
    end

    def post_job_result!(job_id, result_kod, output_values_hash, statistic_hash, error_hash)
      url = @server_url + '/' + JOB_RESULT_URL + '/' + job_id.to_s + '/'
      result = { test_task: { result_kod: result_kod == :processed ? :processed : :interrupted,
                              output_values: output_values_hash,
                              statistic: { duration: statistic_hash[:duration] },
                              errors: { operation_id: error_hash[:operation_id],
                                        failed_screen_shot: error_hash[:failed_screen_shot].present? ? Base64.encode64(error_hash[:failed_screen_shot]) : nil,
                                        message: error_hash[:error_message] }
                            }
               }

      response = Faraday.patch(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = result.to_json
      end

      raise "Сетевая ошибка при обращении к северу. message = #{JSON.parse(response.body)['message']}" unless response.status == 200
    end

    private

    attr_accessor :server_url
  end
end