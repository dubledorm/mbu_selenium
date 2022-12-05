# frozen_string_literal: true

module Services
  class ReadVariablesService

    def self::read(environment_json, storage)
      return if environment_json.empty?
      environment = JSON.parse(environment_json).deep_symbolize_keys
      environment.dig(:environment_variables)&.each do |variable|
        storage[variable[:key]] = variable[:value]
      end
    end
  end
end