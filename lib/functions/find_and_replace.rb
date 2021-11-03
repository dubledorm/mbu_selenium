require_relative 'substitutions/factory'
require 'byebug'

module Functions
  # Ищем и заменяем функции в строке source_str на их значения
  class FinAndReplace
    #REG_FIND_FUNCTIONS = /(^|[^\\]|[\\]{2}+)\$(?<function>[^\s\(\)]+\(([^\(\)]|\\\(|\\\))*?\))/
    REG_FIND_FUNCTIONS = /(^|[^\\]|[\\]{2}+)\$(?<function>[^\s\(\)]+\([^\(\)]*?\))/
    #REG_FIND_FUNCTIONS = /(^|[^\\]|[\\]{2}+)\$(?<function>[^\s\(\)]+\(.*?\))/
    REG_SEPARATE_NAME_ARGS = /(?<prefix>(^|[^\\]|[\\]{2}+))\$(?<name>[^\s()]+)\((?<args>[^()]*)\)/
    #REG_SEPARATE_NAME_ARGS = /(?<prefix>(^|[^\\]|[\\]{2}+))\$(?<name>[^\s()]+)\((?<args>((\\\()|(\\\))|[^\(\)])*)\)/

    def self.call(source_str, storage, for_output_storage)
      return unless source_str
      result_str = source_str.clone
      finish_flag = false

      until finish_flag do
        finish_flag = true
        # Цикл по найденным функциям
        result_str.gsub!(REG_FIND_FUNCTIONS) do |function|
          finish_flag = false
          # Разделяем имя функции и аргументы
          m = function.match(REG_SEPARATE_NAME_ARGS)
          raise ArgumentError, "Ошибка разбора аргументов функции #{function}" if m.nil? || m[:name].nil? || m[:args].nil?
          # вычисляем и заменяем функцию в исходной строке
          fnc_escaped_result = calculate_function(m, storage, for_output_storage).to_s
          "#{m[:prefix]}#{fnc_escaped_result}"
        end
      end
      result_str
    end

    def self.calculate_function(m_match, storage, for_output_storage)
      # Применяем функцию
      fnc = Functions::Substitutions::Factory.build!(m_match[:name], m_match[:args].split(',').map{ |arg| arg.strip })
      raise ArgumentError, "Ошибка разбора аргументов функции #{m_match[:name]} с аргументами #{m_match[:args]}. Ошибка: #{fnc.errors.full_messages}" unless fnc.valid?

      fnc.storage = storage
      fnc.for_output_storage = for_output_storage
      fnc.calculate
    end

    def self.escape_string(source_string)
      source_string.gsub('$', '\$').gsub('(', '\(').gsub(')', '\)')
    end

    def self.unescape_string!(source_string)
      source_string.gsub('\)', ')').gsub('\(', '(').gsub('\$', '$')
    end
  end
end