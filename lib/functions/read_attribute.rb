require_relative 'base.rb'

module Functions
  class ReadAttribute < Base

    attr_accessor :attribute_name, :save_as
    validates :selector, :attribute_name, :save_as, presence: true

    def done!(element)
      if self.attribute_name == 'text'
        value = element.text
      else
        value = element.property(self.attribute_name)
      end

      self.storage[self.save_as] = value
    end
  end
end