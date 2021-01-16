require 'active_model'
require "selenium/webdriver/common/error"
require 'pry'

module Functions
  class ElementNotFound < StandardError; end;
  class TestInterrupted < StandardError; end;

  FIND_ELEMENT_TIMEOUT = 5

  class Base
    include ActiveModel::Model

    attr_accessor :human_name, :human_description, :operation_id, :selector, :do, :driver, :storage, :for_output_storage, :logger
    delegate :find_element, to: :driver

    validates :do, :operation_id, presence: true

    def find_and_done!
      element = waiting_for_element! if self.selector.present?
      # Перемещаемся на элемент
      if element && !element.displayed?
        element.location_once_scrolled_into_view
        @driver.execute_script("window.scrollBy(0,50)")
        #  driver.execute_script("arguments[0].scrollIntoView();", element)
      end

      # Выполняем запланированное действие
      done!(element)
      self.logger.info(done_message)
    end

    protected

    def done!(element)
      raise NotImplementedError
    end

    private

    def waiting_for_element!
      # Ищем элемент на странице
      begin
        element = find_element(**selector.symbolize_keys)
        return element
      rescue Selenium::WebDriver::Error::NoSuchElementError
        raise Functions::ElementNotFound, "Для теста #{self.human_name}, операция id = #{self.operation_id} не могу найти элемент по правилу: #{selector}"
      end
    end

    def done_message
      name = self.human_name.presence || self.selector.presence.to_s || self.do.to_s
      "#{self.operation_id}: #{name} выполнен"
    end
  end
end