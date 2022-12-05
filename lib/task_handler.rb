require_relative 'test_case.rb'
require_relative 'function_base_error'
require_relative 'services/read_variables_service'

class TaskHandler

  def self.process(driver, response, logger, storage = {}, result_output = {})
    result = { status: :before_start,
               output: result_output,
               failed_operation_id: nil,
               error_message: ''
    }
    #  storage = {}
    start = Time.now
    logger.debug('TaskHandler start')

    result[:status] = :started
    result[:job_id] = response[:job_id]

    # Выполнение задания
    if response[:start_page_url].present?
      logger.debug('Переход на страницу ' + response[:start_page_url])
      driver.navigate.to response[:start_page_url] # Переход на начальную страницу
    end

    if response[:environment_json].present?
      # Заполняем значения переменных
      Services::ReadVariablesService::read(response[:environment_json], storage)
    end

    # Проходим в цикле по всем шагам теста, до тех пор пока не закончатся или test_case не вернёт false
    experiment_cases = response[:test]['experiment_cases'].sort_by{|experiment_case| experiment_case['number']}
    experiment_case_index = 0
    begin
      while experiment_case_index < experiment_cases.length &&
        TestCase::new(driver, experiment_cases[experiment_case_index], storage, result[:output], logger).handler! do
        experiment_case_index += 1
      end
    rescue FunctionBaseError => e
      result[:error_message] = "Ошибка при выполнении test case № #{experiment_cases[experiment_case_index]['number']}. Message: #{e.message}"
      result[:duration] = Time.now - start
      result[:failed_operation_id] = e.operation_id
      result[:failed_screen_shot] = e.screen_shot
      logger.error(result[:error_message])
      return result
    end

    # ToDo Записать ответ о выполнении теста
    result[:status] = :processed
    result[:duration] = Time.now - start
    result
  end
end