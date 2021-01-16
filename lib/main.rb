require "selenium-webdriver"
require_relative 'api/main_center'
require_relative 'task_handler'
require_relative 'programs/mbu'
require 'pry'
require 'awesome_print'


START_PAGE_URL = 'https://noqu.ru/group/kultura/kulturno-dosugovye-uchrezhdeniya/munitsipalnoe-byudzhetnoe-uchrezhdenie-gorodskogo-okruga-solnechnogorsk-tsentr-informatsionnoy-kultu/'.freeze


logger = Logger.new(STDOUT)

# Цикл получения заданий
while true
  response = {}
  begin
    response = API::MainCenter.get_job!
  rescue StandardError => e
    logger.error('Ошибка чтения задания: ' + e.message)
  end

  # response = { job_status: 'job',
  #              job_id: 1,
  #              test: Programs::Mbu::FKP_TEST }
  if response.nil? || response[:job_status] != 'job'
    # Задание не получено делаем паузу перед новым запросом
    logger.debug('sleep')
    sleep(10)
    next
  end

  # Запускаем FireFox
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 300 # seconds
  client.open_timeout = 300 # seconds

  driver = Selenium::WebDriver.for :firefox, http_client: client
  driver.manage.timeouts.implicit_wait = Functions::FIND_ELEMENT_TIMEOUT
  driver.manage.timeouts.script_timeout = 30
  driver.manage.timeouts.page_load = 300

  # Выполняем задание
  result = TaskHandler::process(driver, response, logger)

  driver.quit
  # Передать результат выполнения
  begin
    API::MainCenter.post_job_result!(result[:job_id],
                                     result[:status],
                                     result[:output],
                                     { duration: result[:duration]},
                                     { operation_id: result[:failed_operation_id],
                                                failed_screen_shot: result[:failed_screen_shot],
                                                error_message: result[:error_message] })
  rescue StandardError => e
    logger.error('Ошибка отправки отчёта: ' + e.message)
  end
end


