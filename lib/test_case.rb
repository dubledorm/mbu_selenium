require "selenium-webdriver"
require 'active_support'
require 'active_support/core_ext'
require_relative 'functions/factory'
require_relative 'capcha'
require 'pry'


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

    # Проверяем, что мы на нужной странице
    section_done!('check')

    section_done!('do')

    section_done!('next')
    true
  end


  attr_reader :driver, :command_hash, :element, :storage, :for_output_storage, :logger

  private

  def section_done!(section_key)
    steps = command_hash[section_key]
    if steps.nil?
      logger.info("Секция #{section_key} пуста, пропускаем")
      return
    end

    steps.each do |key, value|
      function = Functions::Factory.build!(value)
      function.driver = self.driver
      function.storage = self.storage
      function.for_output_storage = self.for_output_storage
      function.logger = self.logger
      unless function.valid?
        raise TestCase::FunctionArgumentError, "Ошибка при передаче аргументов для функции #{value[:do]} на шаге #{key}"
      end
      function.find_and_done!
    end
  end
end
