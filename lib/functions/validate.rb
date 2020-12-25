require_relative 'base.rb'
require 'pry'

module Functions
  class Validate < Base

    attr_accessor :value, :attribute
    validates :value, :attribute, presence: true

    # Прервать выполнение теста если условие не выполнено
    def done!(element)
      value = read(element)

      return if value.to_s == self.value.to_s

      raise Functions::TestInterrupted, "Не выполнено условие на странице #{self.selector}. Ожидается условие: |#{[self.attribute, self.value].join(' == ')}| " +
        " Получено : |#{[self.attribute, value].join(' == ')}|"
    end

    private

    def read(element)
      case self.attribute
      when 'text'
        value = element.text
      when 'visible'
        value = element.displayed?
      when 'displayed'
        value = element.displayed?
      when 'enabled'
        value = element.enabled?
      when 'hash'
        value = element.hash
      when 'hover'
        value = element.property('hover')
      when 'selected'
        value = element.selected?
      when 'size'
        value = "width=#{element.size.width} height=#{element.size.height}"
      when 'style'
        value = element.style
      when 'tag_name'
        value = element.tag_name
      else
        value = element.property(self.attribute)
      end

      value
    end
  end
end