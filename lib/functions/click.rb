require_relative 'base.rb'

module Functions
  class Click < Base

    validates :selector, presence: true

    def done!(element)
      element.click
    end
  end
end