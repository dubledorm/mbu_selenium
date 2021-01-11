class FunctionBaseError < StandardError
  attr_reader :operation_id

  def initialize(operation_id, msg)
    super(msg)
    @operation_id = operation_id
  end
end