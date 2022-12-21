require_relative 'base'
require 'byebug'


module Functions
  module Substitutions
    class FindSubString < Functions::Substitutions::Base
      attr_accessor :source_string, :search_expression
      validates :source_string, :search_expression, presence: true

      def calculate
        source_string.strip.scan(%r(#{search_expression.strip})).first
      end

      private
        def map_arguments
          [:source_string, :search_expression]
        end
    end
  end
end