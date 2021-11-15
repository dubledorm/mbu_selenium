require_relative 'base.rb'

module Functions
  class IfExists < Base

    class InterruptStep < StandardError

    end

    attr_accessor :delay
    validates :delay, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

    def find_and_done!
      begin
        element = waiting_for_element! if self.selector.present?
      rescue Functions::ElementNotFound
      end

      if element
        self.logger.info(done_message + ' Элемент найден.')
        return element
      end

      self.logger.info(done_message + ' Элемент не найден.')
      raise InterruptStep
    end
  end
end