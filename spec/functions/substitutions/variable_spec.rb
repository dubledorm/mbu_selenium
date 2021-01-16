require_relative '../../../lib/functions/substitutions/variable'
require 'awesome_print'

RSpec.describe Functions::Substitutions::Variable do

  context 'wrong_arguments' do
    it { expect(described_class.new).to_not be_valid }
    it { expect{ described_class.new('bad_function_name', 'arg1', 'arg2') }.to raise_error(ArgumentError)}
  end

  context 'truth arguments' do
    let!(:variable) { described_class.new('var_name') }

    it { expect(variable).to be_valid }
  end

  context '#calculate' do
    let(:storage) { { 'first_value' => '20' } }
    let(:for_output_storage) { { 'second_value' => '100' } }
    let!(:variable) { described_class.new('first_value') }
    let!(:variable1) { described_class.new('second_value') }
    let!(:variable2) { described_class.new('third_value') }


    before :each do
      variable.storage = storage
      variable.for_output_storage = for_output_storage
      variable1.storage = storage
      variable1.for_output_storage = for_output_storage
      variable2.storage = storage
      variable2.for_output_storage = for_output_storage
    end

    it { expect(variable).to be_valid }
    it { expect(variable.calculate).to eq('20') }
    it { expect(variable1.calculate).to eq('100') }
    it { expect{ variable2.calculate }.to raise_error(ArgumentError) }
  end
end