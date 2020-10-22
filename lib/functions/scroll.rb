require_relative 'base.rb'

module Functions
  class Scroll < Base

    VALIDATE_ERROR_MESSAGE = 'Должен быть заполнен один из атрибутов :value, :value_from_storage'.freeze

    attr_accessor :value, :direction
    validates :value, :direction, presence: true
    validates :direction, inclusion: { in: %w(up down),
                                       message: "Поле direction может содержать значения up или down. %{value} это не корректное значение" }

    def done!(element)
      @driver.execute_script("window.scrollBy(0,#{value})")
    end

    private
      def value
        return @value if @direction == 'down'
        @value * -1
      end
  end
end
