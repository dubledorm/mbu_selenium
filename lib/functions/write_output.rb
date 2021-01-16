require_relative 'base.rb'
require_relative 'substitutions/find_and_replace'

module Functions
  class WriteOutput < Base

    attr_accessor :variable_name, :save_as
    validates :variable_name, :save_as, presence: true

    def done!(element)
      self.for_output_storage[save_as] = Functions::Substitutions::FinAndReplace::call(self.variable_name,
                                                                                       storage,
                                                                                       for_output_storage)
    end
  end
end