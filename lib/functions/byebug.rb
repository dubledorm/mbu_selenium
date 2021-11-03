require_relative 'base.rb'

module Functions
  class ByeBug < Base

    def done!(element)
      byebug
    end
  end
end