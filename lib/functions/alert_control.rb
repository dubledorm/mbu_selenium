require_relative 'base.rb'

module Functions
  class AlertControl < Base

    attr_accessor :value
    validates :value, inclusion: { in: %w(accept dismiss),
                                     message: "Поле value может содержать значения accept или dismiss. %{value} это не корректное значение" }

    def done!(element)
      driver.switch_to.alert.accept if value == 'accept'
      driver.switch_to.alert.dismiss if value == 'dismiss'
    end
  end
end