require_relative 'base.rb'

module Functions
  class WaitElement < Base

    VALIDATE_ERROR_MESSAGE = 'Должен быть заполнен один из атрибутов :value, :value_from_storage'.freeze

    attr_accessor :delay, :need_refresh, :refresh_period_in_sec
    validates :delay, numericality: { only_integer: true }, presence: true
    validates :refresh_period_in_sec, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

    def find_and_done!
      if need_refresh == 'true'
        element = wait_with_refresh
      else
        element = simple_wait
      end

      raise Functions::TestInterrupted, "Не обнаружен элемент по правилу #{selector} в течение #{delay} секунд" unless element
      self.logger.info(done_message)
    end

    private

    def simple_wait
      start_time = Time.now
      begin
        begin
          element = waiting_for_element!
          if element
            element = nil unless element.displayed?
          end
        rescue Functions::ElementNotFound
        end
      end while element.nil? && (Time.now - start_time) < delay.to_i
      element
    end

    def wait_with_refresh
      start_time = Time.now
      refresh_period = refresh_period_in_sec || 10

      begin
        begin
          sleep(refresh_period.to_i)
          driver.navigate.refresh
          element = waiting_for_element!
          if element
            element = nil unless element.displayed?
          end
        rescue Functions::ElementNotFound
        end
      end while element.nil? && (Time.now - start_time) < delay.to_i
      element
    end
  end
end