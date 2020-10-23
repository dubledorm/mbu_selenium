require_relative 'base.rb'

module Functions
  class SendText < Base

    VALIDATE_ERROR_MESSAGE = 'Должен быть заполнен один из атрибутов :value, :value_from_storage'.freeze

    attr_accessor :value, :value_from_storage, :send_return
    validates :selector, presence: true

    validates_each :value, :value_from_storage do |record, attr|
      record.errors.add(attr, VALIDATE_ERROR_MESSAGE) if record.value.nil? && record.value_from_storage.nil?
    end

    def done!(element)
      value = self.value_from_storage.present? ? storage[self.value_from_storage] : self.value
      element.send_keys(value)
      if send_return.present?
        element.send_keys(:return)
      end
    end
  end
end