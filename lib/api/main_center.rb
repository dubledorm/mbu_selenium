require 'faraday'
require 'base64'
require 'pry'

module API
  class MainCenter

    MAIN_CENTR_URL = 'http://localhost:3000' # 'http://92.63.193.31'
    I_AM_FREE_URL = 'api/test_tasks/get_task/'
    JOB_RESULT_URL = 'api/test_tasks'
    INSTANCE_ID = 'Это на будующее'

    def self.get_job!
      params = { instance_id: INSTANCE_ID }
      url = MAIN_CENTR_URL + '/' + I_AM_FREE_URL

      response = Faraday.get(url, params, {'Accept' => 'application/json'})
      raise 'Сетевая ошибка при обращении к северу. body = ' + response.body unless response.status == 200

      JSON.parse(response.body).symbolize_keys
    end

    def self.post_job_result!(job_id, result_kod, output_values_hash, statistic_hash, error_hash)
      url = MAIN_CENTR_URL + '/' + JOB_RESULT_URL + '/' + job_id.to_s + '/'
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
  end
end