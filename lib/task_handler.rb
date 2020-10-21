require_relative 'test_case.rb'
require_relative 'test_case.rb'


class TaskHandler

  def self.process(driver, response, logger)
    result = { status: :idle,
               output: {}
    }

    return result if response.nil?
    return result unless response[:job_status] == 'job'

    result[:status] = :started
    result[:job_id] = response[:job_id]

    # Выполнение задания
    if response[:start_page_url].present?
      driver.navigate.to response[:start_page_url] # Переход на начальную страницу
    end

    # Проходим в цикле по всем шагам теста, до тех пор пока не закончатся или test_case не вернёт false
    test_case_number = 1
    begin
      while TestCase::new(driver, response[:test][test_case_number.to_s], logger).handler! do
        test_case_number += 1
      end
    rescue StandardError => e
      logger.error("Ошибка при выполнении test case № #{test_case_number}. Message: #{e.message}")
    end

    # ToDo Записать ответ о выполнении теста

    result[:status] = :processed

    result
  end
end