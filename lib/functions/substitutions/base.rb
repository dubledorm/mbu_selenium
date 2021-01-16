# frozen_string_literal: true
require 'active_model'
require 'pry'

module Functions
  module Substitutions
    class Base
      include ActiveModel::Model

      attr_accessor :storage, :for_output_storage

      def initialize(*args)
        raise ArgumentError,
              "Количество аргументов функции #{self.class.name} не должно превышать #{map_arguments_count}" if args.count > map_arguments_count
        hash_attributes = Hash[*args.map.with_index{ |attr, index| [ map_arguments[index], attr ] }.flatten]
        super(hash_attributes)
        self.attributes=hash_attributes # Этот вызов нужен, чтобы была возможность переопределить attributes=
      end

      def calculate
        raise NotImplementedError
      end

      def map_arguments
        []
      end

      def attributes=(hash)
        hash.each do |key, value|
          send("#{key}=", value)
        end
      end

      protected

      def map_arguments_count
        @map_arguments_count ||= map_arguments.count
      end
    end
  end
end