require_relative 'base.rb'
require_relative 'find_and_replace'

module Functions
  class SetVariable < Base

    attr_accessor :value, :variable_name, :storage_output
    validates :variable_name, :value, presence: true

    def done!(element)
      if storage_output == 'true'
        self.for_output_storage[variable_name] = value
      else
        self.storage[variable_name] = value
      end
    end
  end
end