require_relative 'base.rb'

module Functions
  class Connect < Base

    attr_accessor :value
    validates :value, presence: true

    def done!(element)
      driver.navigate.to Functions::FinAndReplace::call(self.value,
                                                                       storage,
                                                                       for_output_storage)
    end
  end
end