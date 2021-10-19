require_relative '../../../lib/functions/substitutions/calculate'
require 'awesome_print'

RSpec.describe Functions::Substitutions::Calculate do

  context 'wrong_arguments' do
    it { expect{described_class.new}.to raise_error(ArgumentError) }
    it { expect(described_class.new('bad_function_name', 'arg1', 'arg2')).to_not be_valid }
    it { expect(described_class.new('percent', 'arg1')).to_not be_valid }
    it { expect(described_class.new('percent', 'arg1', 'arg2' )).to_not be_valid }
    it { expect(described_class.new('request_number', 'arg1', 'arg2' )).to_not be_valid }
    it { expect(described_class.new('request_number', 'arg1' )).to be_valid }


    it 'print only' do
      function = described_class.new('bad_function_name', 'arg1', 'arg2')
      function.valid?
      ap function.errors.full_messages
    end
  end

  context 'truth arguments' do
    let!(:calculate) { described_class.new('percent', '30', '100') }

    it { expect(calculate).to be_valid }
  end

  context '#calculate' do
    let(:storage) { {} }
    let(:for_output_storage) { {} }
    let!(:percent) { described_class.new('percent', '12', '100') }

    before :each do
      percent.storage = storage
      percent.for_output_storage = for_output_storage
    end

    it { expect(percent).to be_valid }
    it { expect(percent.calculate).to eq(12) }
  end

  context 'arguments from variables' do
    let(:storage) { { 'first_value' => '20' } }
    let(:for_output_storage) { { 'second_value' => '100' } }
    let!(:percent) { described_class.new('percent', '$first_value', '$second_value') }
    let!(:percent1) { described_class.new('percent', '$absent', '$second_value') }

    before :each do
      percent.storage = storage
      percent.for_output_storage = for_output_storage
      percent1.storage = storage
      percent1.for_output_storage = for_output_storage
    end

    it { expect(percent).to be_valid }
    it { expect(percent1).to be_valid }
    it { expect(percent.calculate).to eq(20) }
    it { expect{percent1.calculate}.to raise_error(ArgumentError) }
  end

  context 'when operation is request_number' do
    let(:storage) { { } }
    let(:for_output_storage) { { 'source_str' => 'Строка с номером Other-2021-12-02-000072 djsfasdfdas',
                                 'source_str1' => 'Строка без номера'} }
    let!(:request_number) { described_class.new('request_number', '$source_str') }
    let!(:request_number1) { described_class.new('request_number', '$source_str1') }

    before :each do
      request_number.storage = storage
      request_number.for_output_storage = for_output_storage
      request_number1.storage = storage
      request_number1.for_output_storage = for_output_storage
    end

    it { expect(request_number).to be_valid }
    it { expect(request_number.calculate).to eq('Other-2021-12-02-000072') }
    it { expect(request_number1).to be_valid }
    it { expect(request_number1.calculate).to eq('') }
  end
end