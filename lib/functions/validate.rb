require_relative 'base.rb'

module Functions
  class Validate < Base

    STRICTLY_VALUES = { yes: 'true', no: 'false' }.freeze

    attr_accessor :value, :attribute, :strictly
    validates :value, :attribute, presence: true

    # Прервать выполнение теста если условие не выполнено
    def done!(element)
      value = read(element)

      if strictly == STRICTLY_VALUES[:no]
        return if value.to_s.scan(self.value.to_s).size > 0
      end

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
      when 'class'
        value = element.attribute('class')
      else
        value = element.property(self.attribute)
      end

      value
    end
  end
end