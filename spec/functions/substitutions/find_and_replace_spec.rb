require_relative '../../../lib/functions/substitutions/find_and_replace'


RSpec.describe Functions::Substitutions::FinAndReplace do
  let(:storage) { {} }
  let(:for_output_storage) { {} }

  context 'call' do
    it { expect(described_class.call('$calculate(percent, 12, 100)', storage, for_output_storage)).to eq('12') }
  end
end