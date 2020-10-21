require_relative 'base.rb'

module Functions
  class Sleep < Base

    def done!(element)
      sleep(3)
    end
  end
end