require 'faraday'
require 'pry'

module API
  class MainCenter

    MAIN_CENTR_URL = 'http://localhost:3000'
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

    def self.post_job_result!(result)
      url = MAIN_CENTR_URL + '/' + JOB_RESULT_URL + '/' +result[:job_id].to_s + '/'

      response = Faraday.patch(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = result.to_json
      end
      raise 'Сетевая ошибка при обращении к северу. body = ' + response.body unless response.status == 200
    end
  end
end