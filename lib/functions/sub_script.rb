require_relative 'base.rb'

module Functions
  class SubScript < Base

    attr_accessor :script_id, :script_json
    validates :script_id, :script_json, presence: true

    def done!(element)
      logger.info("Выполняем вложенный тест с id = #{script_id}")
      response = {}
      response[:job_id] = 1
      response[:test] = script_json
      result = TaskHandler::process(driver, response, logger, storage, for_output_storage)

      raise FunctionBaseError.new(operation_id, result[:error_message], result[:failed_screen_shot]) unless result[:status] == :processed
      logger.info("Завершён вложенный тест с id = #{script_id}")
    end

    protected

    def attributes_for_replace_hash
      super.except( 'script_json' )
    end
  end
end