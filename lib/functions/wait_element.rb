require_relative 'base.rb'

module Functions
  class WaitElement < Base

    VALIDATE_ERROR_MESSAGE = 'Должен быть заполнен один из атрибутов :value, :value_from_storage'.freeze

    attr_accessor :delay
    validates :delay, numericality: { only_integer: true }, presence: true

    def find_and_done!
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

      raise Functions::TestInterrupted, "Не обнаружен элемент по правилу #{selector} в течение #{delay} секунд" unless element
      self.logger.info(done_message)
    end
  end
end