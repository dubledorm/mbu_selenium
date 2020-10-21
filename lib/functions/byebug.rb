require_relative 'base.rb'
require 'pry'

module Functions
  class ByeBug < Base

    def done!(element)
      binding.pry
    end
  end
end