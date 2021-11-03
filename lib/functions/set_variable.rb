require_relative 'base.rb'
require_relative 'find_and_replace'

module Functions
  class SetVariable < Base

    attr_accessor :value, :variable_name, :storage_output
    validates :variable_name, :value, presence: true

    def done!(element)
      result = Functions::FinAndReplace::call(self.value,
                                              storage,
                                              for_output_storage)
      if storage_output == 'true'
        self.for_output_storage[variable_name] = result
      else
        self.storage[variable_name] = result
      end
    end
  end
end