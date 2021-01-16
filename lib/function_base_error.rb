class FunctionBaseError < StandardError
  attr_reader :operation_id, :screen_shot

  def initialize(operation_id, msg, screen_shot = nil)
    super(msg)
    @operation_id = operation_id
    @screen_shot = screen_shot
  end
end