require 'active_model'
require "selenium/webdriver/common/error"
require_relative 'find_and_replace'

module Functions
  class ElementNotFound < StandardError; end
  class TestInterrupted < StandardError; end

  FIND_ELEMENT_TIMEOUT = 5

  class Base
    include ActiveModel::Model

    attr_accessor :human_name, :human_description, :operation_id, :selector, :do, :driver, :storage, :for_output_storage, :logger
    delegate :find_element, to: :driver

    validates :do, :operation_id, presence: true

    EXCEPT_REPLACE_ATTRIBUTES = %i[@human_name @human_description @operation_id @do @driver @storage @for_output_storage
    @logger @validation_context @errors].freeze

    def find_and_done!
      element = waiting_for_element! if self.selector.present?
      # Перемещаемся на элемент
      if element #&& !element.displayed?
        #element.location_once_scrolled_into_view
        #@driver.execute_script("window.scrollBy(0,50)")
        driver.execute_script("arguments[0].scrollIntoView();", element)
        @driver.execute_script("window.scrollBy(0,-100);")
      end

      # Выполняем запланированное действие
      done!(element)
      self.logger.info(done_message)
    end

    # Заменить в атрибутах функции на их значения
    # Важно! Должно выполняться после того как установлены все остальные аттрибуты, в частности
    # :storage, :for_output_storage (отсюда берутся значения)
    def replace_attributes
      raise ArgumentError, 'До запуска replace_attributes \
должны быть установлены :storage и :for_output_storage' if storage.nil? || for_output_storage.nil?

      replaced_variable_hash = replace_functions(attributes_for_replace_hash)
      assign_attributes(replaced_variable_hash)
    end

    protected

    def done!(element)
      raise NotImplementedError
    end

    # Возвращает hash атрибутов, в которых надо искать функции на замену.
    def attributes_for_replace_hash
      replaced_variable_hash = {}
      (instance_variables - EXCEPT_REPLACE_ATTRIBUTES).each do |variable_name|
        real_name = variable_name.to_s[1..-1]
        replaced_variable_hash[real_name] = send(real_name)
      end

      replaced_variable_hash
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

    # Преобразует переданный аргумент. Возвращает его такого же типа.
    def replace_functions(attributes)

      return Functions::FinAndReplace::call(attributes, storage, for_output_storage) if attributes.is_a?(String)

      if (attributes.is_a?(Array))
        return attributes.map { |item| replace_functions(item) }
      end

      if (attributes.is_a?(Hash))
        replaced_hash_attributes = {}
        attributes.each do |key, value|
          replaced_hash_attributes[key] = replace_functions(value)
        end
        return replaced_hash_attributes
      end

      attributes
    end
  end
end