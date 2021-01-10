require_relative 'base.rb'

module Functions
  class SelectClick < Base

    VALIDATE_ERROR_MESSAGE = 'Должен быть заполнен один из атрибутов :option_text, :option_value'.freeze

    attr_accessor :option_text, :option_value
    validates :selector, presence: true

    validates_each :option_text, :option_value do |record, attr|
      record.errors.add(attr, VALIDATE_ERROR_MESSAGE) if record.option_text.nil? && record.option_value.nil?
    end

    def done!(element)
      raise Functions::TestInterrupted, 'Должен быть выбран элемент с типом select, а выбран с типом ' + element.tag_name unless element.tag_name == 'select'
      # Первый раз кликаем, раскрываем список
      element.click
      # Ищем option, лежащие ниже элемета
      option_element = element.find_element(make_xpath)
      raise Functions::ElementNotFound, "Не могу найти элемент по правилу: #{make_xpath}" unless option_element
      option_element.click
    end

    private

    def selector_type
      self.option_text.present? ? :text : :value
    end

    def make_xpath
      case selector_type
      when :text
        return { 'xpath' => "option[contains(text(),'#{self.option_text}')]" }
      when :value
        return { 'xpath' => "option[@value='#{self.option_value}']" }
      else
        raise 'Unknown selector type'
      end
    end
  end
end