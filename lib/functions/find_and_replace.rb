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
    REG_FOR_SPLIT_ARGS = /(?<!\\),|(?<=\\)\\,/

    def self.call(source_str, storage, for_output_storage)
      return source_str unless source_str

      return source_str unless source_str.is_a?(String)

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
          fnc_escaped_result&.gsub!(',','\,') # маскируем запятые, если они там есть
          "#{m[:prefix]}#{fnc_escaped_result}"
        end
      end
      result_str.gsub('\,', ',')
    end

    def self.calculate_function(m_match, storage, for_output_storage)
      args = m_match[:args].split(REG_FOR_SPLIT_ARGS).map { |arg| arg.strip.gsub('\,', ',') }
      # Применяем функцию
      fnc = Functions::Substitutions::Factory.build!(m_match[:name], args)
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