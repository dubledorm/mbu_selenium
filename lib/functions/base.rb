require 'active_model'
require "selenium/webdriver/common/error"
require 'pry'

module Functions
  class ElementNotFound < StandardError; end;
  class TestInterrupted < StandardError; end;

  FIND_ELEMENT_TIMEOUT = 5

  class Base
    include ActiveModel::Model

    attr_accessor :human_name, :human_description, :selector, :do, :driver, :storage, :logger
    delegate :find_element, to: :driver

    validates :do, presence: true

    def find_and_done!
      element = waiting_for_element! if self.selector.present?
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
        raise Functions::ElementNotFound, "Для теста #{self.human_name} не могу найти элемент по правилу: #{selector}"
      end
    end

    def done_message
      name = self.human_name.presence || self.selector.presence.to_s || self.do.to_s
      "#{name} выполнен"
    end
  end
end