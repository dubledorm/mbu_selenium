require "selenium-webdriver"
require 'active_support'
require 'active_support/core_ext'
require_relative 'functions/factory'
require_relative 'capcha'
require_relative 'function_base_error'
require_relative 'functions/if_exists'

class TestCase

  class FunctionArgumentError < StandardError; end;

  WAITING_ELEMENT_TIMEOUT = 10

  def initialize(driver, command_hash, storage, for_output_storage, logger)
    @driver = driver
    @command_hash = command_hash
    @storage = storage
    @for_output_storage = for_output_storage
    @logger = logger
  end

  def handler!
    return false unless command_hash.present?

    begin
      section_done!('check')

      section_done!('do')

      section_done!('next')
    rescue Functions::IfExists::InterruptStep
      self.logger.info('Прерван шаг.')
    end
    true
  end


  attr_reader :driver, :command_hash, :element, :storage, :for_output_storage, :logger

  private

  def section_done!(section_key)
    steps = command_hash[section_key]
    return if steps.nil?

    steps.sort_by!{ |operation| operation['number']}
    steps.each do |operation|
      function = function_init(operation['operation_json'], operation['id'])
      function_process(function)
    end
  end

  def function_init(hash_attributes, operation_id)
    replaced_hash_attributes = replace_functions(hash_attributes)
    function = Functions::Factory.build!(replaced_hash_attributes)
    function.operation_id = operation_id
    function.driver = driver
    function.storage = storage
    function.for_output_storage = for_output_storage
    function.logger = logger
    function
  end

  def replace_functions(hash_attributes)
    replaced_hash_attributes = {}
    hash_attributes.each do |key, value|
      if value.is_a?(Hash)
        replaced_hash_attributes[key] = replace_functions(value)
      else
        replaced_hash_attributes[key] = Functions::FinAndReplace::call(value, storage, for_output_storage)
      end
    end
    replaced_hash_attributes
  end

  def function_process(function)
      unless function.valid?
        raise TestCase::FunctionArgumentError, "Ошибка при передаче аргументов для функции #{function.do} на шаге #{operation['id']}, message = #{function.errors.full_messages}"
      end
      function.find_and_done!
    rescue Functions::IfExists::InterruptStep => e
      raise e
    rescue StandardError => e
      picture = function.driver.screenshot_as(:png)
      raise FunctionBaseError.new(function.operation_id, e.message, picture)
  end
end
