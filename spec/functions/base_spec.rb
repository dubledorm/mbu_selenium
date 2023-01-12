require_relative '../../lib/functions/http_request'
require 'json'



RSpec.describe Functions::Base do
  describe 'replace_attributes' do
    context 'when storage dose not set' do
      let(:function) { described_class.new(do: 'function', operation_id: 1) }
      let(:function1) { described_class.new(do: 'http_request', operation_id: 1, storage: {}) }

      it { expect{ function.replace_attributes }.to raise_error(ArgumentError) }
      it { expect{ function1.replace_attributes }.to raise_error(ArgumentError) }
    end

    context 'when attributes for replace do not exist' do
      let(:function) { described_class.new(do: 'http_request', operation_id: 1,
                                           storage: {}, for_output_storage: {}) }

      it { expect{ function.replace_attributes }.to_not raise_exception }
    end
  end
end