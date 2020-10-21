require "selenium-webdriver"
require 'active_support'
require 'active_support/core_ext'
require_relative 'capcha'


class PageHandler

  WAITING_ELEMENT_TIMEOUT = 10

  def initialize(driver, command_hash)
    @driver = driver
    @command_hash = command_hash
    @storage = {}
  end

  def handler
    return false unless command_hash.present?
    check_page! # Проверяем, что мы на нужной странице
    do_page!
    sleep(2)
    next_page!
    true
  end

private

  attr_reader :driver, :command_hash, :element, :storage

  def check_page!
    # Ищем элемент на странице
    @element = waiting_for_element(**command_hash['selector'].symbolize_keys)

    if command_hash['validate']
      validate_result!
    end
  end

  def next_page!
    # Ищем элемент на странице
    next_selector = command_hash.dig('next', 'selector')
    @element = waiting_for_element(**next_selector.symbolize_keys)

    command = command_hash.dig('next', 'do')
    @element.send(command)
  end

  def do_page!

    steps = command_hash['do']
    steps.each do |key, value|
      # Ищем элемент на странице
      do_selector = value['selector']
      return unless do_selector.present?

      @element = waiting_for_element(**do_selector.symbolize_keys)
      handle_command(@element, value)
    end
  end

  def validate_result!
    command = command_hash.dig('validate', 'attribute')
    case command.to_s
    when 'visible'
      return if @element.displayed?
    else
      value = @element.attribute(command_hash.dig('validate', 'attribute'))
      return if value == command_hash.dig('validate', 'value')
    end

    raise "Не та страница #{command_hash['selector']}. Ожидается условие: |#{command_hash['validate']}|"
  end


  def waiting_for_element(element_xpath)
    # Ищем элемент на странице
    counter =0
    while counter < WAITING_ELEMENT_TIMEOUT do
      @element = @driver.find_element(**element_xpath.symbolize_keys)
      return @element if @element.present?
      sleep(1)
    end
    raise "Не могу найти на странице элемент #{command_hash['selector']}"
  end

  def handle_command(element, command_hash)
    command = command_hash['do']

    case command
    when 'click'
      element.click
    when 'sleep'
      sleep(3)
    when 'byebug'
      byebug
    when 'send'
      value = command_hash['value_from_storage'].present? ? @storage[command_hash['value_from_storage']] : command_hash['value']
      element.send_keys value
    when 'read_attribute'
      @storage[command_hash['storage_name']] = element.property(command_hash['attribute_name'])
    when 'resolv_capcha'
      capcha = Capcha.new(@storage[command_hash['storage_src']])
      @storage[command_hash['storage_name']] = capcha.resolve
    else
      element.send(command)
    end
  end
end

