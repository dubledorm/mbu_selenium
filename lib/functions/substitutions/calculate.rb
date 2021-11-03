require_relative 'base'

module Functions
  module Substitutions
    class ArgumentValidator < ActiveModel::Validator
      def validate(record)
        case record.operation
        when 'percent'
          record.errors.add :values, "Функция percent должна иметь 2 аргумента" unless record.values.count == 2
          record.values.each do |value|
            record.errors.add :values, "Значение #{value} должно быть числом" unless value =~ /^([\d]+|\$[\w_\d]+)$/
          end
        when 'sum'
          record.errors.add :values, "Функция sum должна иметь минимум 2 аргумента" if record.values.count < 2
        when 'request_number'
          record.errors.add :values, "Функция request_number должна иметь один аргумент" unless record.values.count == 1
        end
      end
    end

    class Calculate < Functions::Substitutions::Base
      OPERATION_VALUES = %w(sum percent request_number)

      attr_accessor :operation, :values
      validates :operation, inclusion: { in: OPERATION_VALUES,
                                         message: "%{value} не верное значение. Допустимые значения: #{OPERATION_VALUES}" }

      validates :values, presence: true
      validates_with Functions::Substitutions::ArgumentValidator

      def initialize(*args)
        raise ArgumentError,
              "Количество аргументов функции Calculate должно быть не меньше 2" if args.count < 2

        hash_attributes = {}
        hash_attributes[:operation] = args[0].strip
        hash_attributes[:values] = args[1..-1].map{ |arg| arg.strip}
        self.attributes=hash_attributes # Этот вызов нужен, чтобы была возможность переопределить attributes=
      end

      REG_SEPARATE_VARIABLE = /^\$(?<name>[\d\w_]+)$/
      def calculate
        translated_values = values.map do |value|
          # Ищем переменные
          m = value.match(REG_SEPARATE_VARIABLE)
          if m.nil? || m[:name].nil?
            value
          else
            replace(m[:name])
          end
        end
        fnc_calculate(translated_values)
      end

      private

      def map_arguments_count
        2
      end

      def replace(value)
        result = storage[value] || for_output_storage[value]
        raise ArgumentError, 'Не найдена переменная с именем ' + value unless result
        result
      end

      def fnc_calculate(translated_values)
        case operation
        when 'sum'
          return translated_values.inject(0){ |result, value| result = result + value.to_i }
        when 'percent'
          return (translated_values[0].to_i * 100 ) / translated_values[1].to_i
        when 'request_number'
          m = translated_values[0].match(/(?<number>\w+-\d{4}-\d{2}-\d{2}-\d{6})/)
          return m.nil? ? '' : m[:number]
        end
      end
    end
  end
end