require_relative 'base.rb'

module Functions
  class SwitchToFrame < Base
    attr_accessor :value, :to_default_frame

    def done!(element)
      return driver.switch_to().default_content() if to_default_frame == 'true'
      frame_name_or_number = 0
      if value.present?
        frame_name_or_number = value.to_i if value =~ /^\d+$/
      end
      driver.switch_to().frame(frame_name_or_number)
    end
  end
end