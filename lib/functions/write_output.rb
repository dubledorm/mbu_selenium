require_relative 'base.rb'
require_relative 'find_and_replace'

module Functions
  class WriteOutput < Base

    attr_accessor :variable_name, :save_as
    validates :variable_name, :save_as, presence: true

    def done!(element)
      self.for_output_storage[save_as] = Functions::FinAndReplace::call(self.variable_name,
                                                                                       storage,
                                                                                       for_output_storage)
    end
  end
end