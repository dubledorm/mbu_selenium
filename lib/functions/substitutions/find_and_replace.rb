require_relative 'factory'
require_relative 'calculate'

module Functions
  module Substitutions

    # Ищем и заменяем функции в строке source_str на их значения
    class FinAndReplace
      REG_FIND_FUNCTIONS = /(^|[^\\]|[\\]{2}+)\$(?<function>[^\s()]+\([^()]*+\))/
      REG_SEPARATE_NAME_ARGS = /(?<prefix>(^|[^\\]|[\\]{2}+))\$(?<name>[^\s()]+)\((?<args>[^()]*)\)/

      def self.call(source_str, storage, for_output_storage)
        return unless source_str
        # Цикл по найденным функциям
        source_str.gsub(REG_FIND_FUNCTIONS) do |function|
          # Разделяем имя функции и аргументы
          m = function.match(REG_SEPARATE_NAME_ARGS)
          raise ArgumentError, "Ошибка разбора аргументов функции #{function}" if m.nil? || m[:name].nil? || m[:args].nil?

          # Применяем функцию
          fnc = Functions::Substitutions::Factory.build!(m[:name], m[:args].gsub(' ', '').split(','))
          raise ArgumentError, "Ошибка разбора аргументов функции #{m[:name]} с аргументами #{m[:args]}. Ошибка: #{fnc.errors.full_messages}" unless fnc.valid?

          fnc.storage = storage
          fnc.for_output_storage = for_output_storage
          # вычисляем и заменяем функцию в исходной строке
          "#{m[:prefix]}#{fnc.calculate}"
        end
      end
    end
  end
end