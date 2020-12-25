require_relative 'base.rb'

module Functions
  class ReadAttribute < Base

    attr_accessor :attribute_name, :save_as
    validates :selector, :attribute_name, :save_as, presence: true

    def done!(element)
      case self.attribute_name
      when 'text'
        value = element.text
      when 'displayed'
        value = element.displayed?
      when 'enabled'
        value = element.enabled?
      when 'hash'
        value = element.hash
      when 'hover'
        value = element.property('hover')
      when 'selected'
        value = element.selected?
      when 'size'
        value = "width=#{element.size.width} height=#{element.size.height}"
      when 'style'
        value = element.style
      when 'tag_name'
        value = element.tag_name
      else
        value = element.property(self.attribute_name)
      end

      self.storage[self.save_as] = value
    end
  end
end