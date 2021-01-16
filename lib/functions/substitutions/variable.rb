require_relative 'base'

module Functions
  module Substitutions
    class Variable < Functions::Substitutions::Base
      attr_accessor :variable_name
      validates :variable_name, presence: true

      def calculate
        replace(variable_name)
      end

      private

      def map_arguments
        ['variable_name']
      end

      def replace(value)
        result = storage[value] || for_output_storage[value]
        raise ArgumentError, 'Не найдена переменная с именем ' + value unless result
        result
      end
    end
  end
end