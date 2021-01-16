require_relative 'click'
require_relative 'byebug'
require_relative 'read_attribute'
require_relative 'resolve_capcha'
require_relative 'send_text'
require_relative 'sleep'
require_relative 'connect'
require_relative 'validate'
require_relative 'scroll'
require_relative 'write_output'
require_relative 'select_click'
require_relative 'wait_element'



module Functions
  class Factory

    NAME_TO_CLASS = { 'click' => Functions::Click,
                      'write_variable_to_output' => Functions::WriteOutput,
                      'byebug' => Functions::ByeBug,
                      'read_attribute' => Functions::ReadAttribute,
                      'resolve_capcha' => Functions::ResolveCapcha,
                      'send_text' => Functions::SendText,
                      'sleep' => Functions::Sleep,
                      'connect' => Functions::Connect,
                      'validate' => Functions::Validate,
                      'scroll' => Functions::Scroll,
                      'select_click' => Functions::SelectClick,
                      'wait_element' => Functions::WaitElement
    }.freeze

    class FunctionBuildError < StandardError; end;

    def self.build!(hash_attributes)
      function_name = hash_attributes['do']
      raise Functions::Factory::FunctionBuildError, 'В переданных параметрах должен присутствовать ключ \'do\'. Передано: ' +
          hash_attributes.to_s unless function_name

      function_class = NAME_TO_CLASS[function_name]
      raise Functions::Factory::FunctionBuildError, "Неизвестное имя функции #{function_name}" unless function_class

      function_class.new(hash_attributes)
    end
  end
end