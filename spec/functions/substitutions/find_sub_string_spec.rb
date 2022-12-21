require_relative '../../../lib/functions/substitutions/find_sub_string'
require 'awesome_print'

RSpec.describe Functions::Substitutions::FindSubString do

  context 'wrong_arguments' do
    it { expect(described_class.new).to_not be_valid }
    it { expect{ described_class.new('bad_function_name', 'arg1', 'arg2') }.to raise_error(ArgumentError)}
  end

  context 'truth arguments' do
    let!(:variable) { described_class.new('source_string', 'search_expression') }

    it { expect(variable).to be_valid }
  end

  context '#calculate' do
    let(:storage) { { 'first_value' => '20' } }
    let(:for_output_storage) { { 'second_value' => '100' } }

    it { expect(described_class.new('source_string', 'source').calculate).to eq('source') }
    it { expect(described_class.new('source_123string', '\d{3}').calculate).to eq('123') }
    it { expect(described_class.new('Заявление № MFC-0003/2021-458-1', 'MFC-\d{4}/\d{4}-\d{3}').calculate).to eq('MFC-0003/2021-458') }
    it { expect(described_class.new('  10,0  fsafasf', '\d+,\d+').calculate).to eq('10,0') }
  end
end