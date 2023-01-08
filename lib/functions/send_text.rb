require_relative 'base.rb'
require_relative 'find_and_replace'

module Functions
  class SendText < Base

    VALIDATE_ERROR_MESSAGE = 'Должен быть заполнен один из атрибутов :value, :value_from_storage'.freeze

    attr_accessor :value, :value_from_storage, :send_return, :symbols_per_second
    validates :selector, presence: true
    validates :symbols_per_second, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true

    validates_each :value, :value_from_storage do |record, attr|
      record.errors.add(attr, VALIDATE_ERROR_MESSAGE) if record.value.nil? && record.value_from_storage.nil?
    end

    def done!(element)
      value_for_send = self.value_from_storage.present? ? storage[self.value_from_storage] || for_output_storage[self.value_from_storage] : self.value
      if self.symbols_per_second.presence && self.symbols_per_second.to_i > 0
        value_for_send.split('').each do |smb|
          element.send_keys(smb)
          sleep(1.0/self.symbols_per_second.to_i)
        end
      else
        element.send_keys(value_for_send)
      end
      if send_return == 'true'
        element.send_keys(:return)
      end
    end
  end
end