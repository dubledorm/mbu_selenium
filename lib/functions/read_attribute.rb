require_relative 'base.rb'

module Functions
  class ReadAttribute < Base

    attr_accessor :attribute_name, :save_as
    validates :selector, :attribute_name, :save_as, presence: true

    def done!(element)
      self.storage[self.save_as] = element.property(self.attribute_name)
    end
  end
end