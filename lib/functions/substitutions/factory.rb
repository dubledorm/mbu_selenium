require_relative 'calculate'
require_relative 'variable'
require 'pry'

module Functions
  module Substitutions
    class Factory
      NAME_TO_CLASS = { 'calculate' => Functions::Substitutions::Calculate,
                        'variable' => Functions::Substitutions::Variable }.freeze

      class FunctionBuildError < StandardError; end

      def self.build!(function_name, attributes = [])
        function_class = NAME_TO_CLASS[function_name]
        raise Substitutions::Factory::FunctionBuildError, "Неизвестное имя функции #{function_name}" unless function_class
        function_class.new(*attributes)
      end
    end
  end
end