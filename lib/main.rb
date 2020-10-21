require "selenium-webdriver"
require_relative 'programs/mbu.rb'
require_relative 'test_case.rb'
require_relative 'api/main_center'
require 'pry'
require 'awesome_print'

require_relative 'capcha'

include Programs::Mbu

START_PAGE_URL = 'https://noqu.ru/group/kultura/kulturno-dosugovye-uchrezhdeniya/munitsipalnoe-byudzhetnoe-uchrezhdenie-gorodskogo-okruga-solnechnogorsk-tsentr-informatsionnoy-kultu/'.freeze


logger = Logger.new(STDOUT)

# Запускаем FireFox
client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 300 # seconds
client.open_timeout = 300 # seconds

driver = Selenium::WebDriver.for :firefox, http_client: client
driver.manage.timeouts.implicit_wait = Functions::FIND_ELEMENT_TIMEOUT
driver.manage.timeouts.script_timeout = 30
driver.manage.timeouts.page_load = 300

# Цикл получения заданий
while true
  begin
    response = API::MainCenter.get_job!
  rescue StandardError => e
    logger.error('Ошибка чтения задания: ' + e.message)
  end

  if response && response[:job_status] == 'job'
    # Выполнение задания
    if response[:start_page_url].present?
      driver.navigate.to response[:start_page_url]
    end

    page_number = 1

    begin
      while TestCase::new(driver, response[:test][page_number.to_s], logger).handler! do
        page_number += 1
      end
    rescue StandardError => e
      logger.error("Ошибка при выполнении скрипта на странице #{page_number}. Message: #{e.message}")
    end

    # ToDo Записать ответ о выполнении теста

    # Запросить следующий тест
    next
  end
  # Задание не получено делаем паузу перед новым запросом
  sleep(60)
end



driver.quit
