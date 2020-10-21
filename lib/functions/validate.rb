require_relative 'base.rb'
require 'pry'

module Functions
  class Validate < Base

    attr_accessor :value, :attribute
    validates :value, :attribute, presence: true

    # Прервать выполнение теста если условие не выполнено
    def done!(element)
      case self.attribute
      when 'visible'
        return if value =~ /true|TRUE/ ? element.displayed? : !element.displayed?
      else
        value = element.attribute(self.attribute)
        return if value == self.value
      end

      raise Functions::TestInterrupted, "Не та страница #{self.selector}. Ожидается условие: |#{[self.attribute, self.value].join(' == ')}|"
    end
  end
end