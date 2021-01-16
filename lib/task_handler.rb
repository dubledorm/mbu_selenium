require_relative 'test_case.rb'
require_relative 'test_case.rb'
require_relative 'function_base_error'
require 'pry'


class TaskHandler

  def self.process(driver, response, logger)
    result = { status: :before_start,
               output: {},
               failed_operation_id: nil,
               error_message: ''
    }
    storage = {}
    start = Time.now
    logger.debug('TaskHandler start')

    result[:status] = :started
    result[:job_id] = response[:job_id]

    # Выполнение задания
    if response[:start_page_url].present?
      logger.debug('Переход на страницу ' + response[:start_page_url])
      driver.navigate.to response[:start_page_url] # Переход на начальную страницу
    end

    # Проходим в цикле по всем шагам теста, до тех пор пока не закончатся или test_case не вернёт false
    test_case_number = 1
    begin
      while TestCase::new(driver, response[:test][test_case_number.to_s], storage, result[:output], logger).handler! do
        test_case_number += 1
      end
    rescue FunctionBaseError => e
      result[:error_message] = "Ошибка при выполнении test case № #{test_case_number}. Message: #{e.message}"
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