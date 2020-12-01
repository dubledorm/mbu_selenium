require_relative 'base.rb'

module Functions
  class WriteOutput < Base

    attr_accessor :variable_name, :save_as
    validates :variable_name, :save_as, presence: true

    def done!(element)
      self.for_output_storage[save_as] = self.storage[self.variable_name]
    end
  end
end