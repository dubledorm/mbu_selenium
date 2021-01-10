require_relative 'base.rb'

module Functions
  class Sleep < Base
    attr_accessor :value
    validates :value, numericality: { only_integer: true }, allow_blank: true

    def done!(element)
      sleep(self.value.present? ? self.value.to_i : 3)
    end
  end
end