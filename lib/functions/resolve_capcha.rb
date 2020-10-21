require_relative 'base.rb'

module Functions
  class ResolveCapcha < Base

    attr_accessor :storage_src_name, :save_result_as
    validates :storage_src_name, :save_result_as, presence: true

    def done!(element)
      capcha = Capcha.new(storage[self.storage_src_name])
      storage[self.save_result_as] = capcha.resolve
    end
  end
end