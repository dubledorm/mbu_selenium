require_relative 'calculate'
require_relative 'variable'
require_relative 'xpath_table_element_in_row'
require_relative 'find_sub_string'

module Functions
  module Substitutions
    class Factory
      NAME_TO_CLASS = { 'find_sub_string' => Functions::Substitutions::FindSubString,
                        'calculate' => Functions::Substitutions::Calculate,
                        'variable' => Functions::Substitutions::Variable,
                        'table_element_in_row' => Functions::Substitutions::XpathTableElementInRow}.freeze

      class FunctionBuildError < StandardError; end

      def self.build!(function_name, attributes = [])
        function_class = NAME_TO_CLASS[function_name]
        raise Substitutions::Factory::FunctionBuildError, "Неизвестное имя функции #{function_name}" unless function_class
        function_class.new(*attributes)
      end
    end
  end
end