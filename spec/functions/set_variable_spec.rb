require_relative '../../lib/functions/set_variable'
require 'awesome_print'

RSpec.describe Functions::SetVariable do

  context 'wrong_arguments' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new(do: 'set_variable')).to_not be_valid }

    # it 'print only' do
    #   function = described_class.new(do: 'click')
    #   function.valid?
    #   ap function.errors.full_messages
    # end
  end

  context 'truth arguments' do
    it { expect(described_class.new( do: 'set_variable', variable_name: 'variable_name', value: 'value',  operation_id: 1 )).to be_valid }
  end

  describe 'save to storage' do
    let(:storage) { { 'first_value' => '20' } }
    let(:for_output_storage) { { 'second_value' => '100' } }

    before :each do
      set_variable.done!(nil)
    end

    context 'when storage_output has default value' do
      let(:set_variable) { described_class.new( do: 'set_variable',
                                                 variable_name: 'variable_name',
                                                 value: 'value',
                                                operation_id: 1,
                                                 storage: storage,
                                                 for_output_storage: for_output_storage) }

      it {  expect(storage).to eq({ 'first_value' => '20', 'variable_name' => 'value' })}
      it {  expect(for_output_storage).to eq({ 'second_value' => '100' })}
    end

    context 'when storage_output had set to true' do
      let(:set_variable) { described_class.new( do: 'set_variable',
                                                variable_name: 'variable_name',
                                                value: 'value',
                                                operation_id: 1,
                                                storage_output: false,
                                                storage: storage,
                                                for_output_storage: for_output_storage) }

      it {  expect(storage).to eq({ 'first_value' => '20', 'variable_name' => 'value' })}
      it {  expect(for_output_storage).to eq({ 'second_value' => '100' })}
    end

    context 'when storage_output had set to true' do
      let(:set_variable) { described_class.new( do: 'set_variable',
                                                variable_name: 'variable_name',
                                                value: 'value',
                                                operation_id: 1,
                                                storage_output: 'true',
                                                storage: storage,
                                                for_output_storage: for_output_storage) }

      it {  expect(storage).to eq({ 'first_value' => '20' })}
      it {  expect(for_output_storage).to eq({ 'second_value' => '100', 'variable_name' => 'value' })}
    end

    # Следующий тест н6е актуален, т.к. подстановка переменных и выполнение функций вынесено в TestCase.section_done
    # context 'when value has functions' do
    #   let(:set_variable) { described_class.new( do: 'set_variable',
    #                                             variable_name: 'variable_name',
    #                                             value: 'Это first_value = $variable(first_value), а это second_value = $variable(second_value)',
    #                                             operation_id: 1,
    #                                             storage: storage,
    #                                             for_output_storage: for_output_storage) }
    #
    #   it {  expect(storage).to eq({ 'first_value' => '20', 'variable_name' => 'Это first_value = 20, а это second_value = 100' })}
    #   it {  expect(for_output_storage).to eq({ 'second_value' => '100' })}
    # end

    # TODO Открыть тест если исправим регулярное выражение и функцию find_and_replace для использования имён переменных без функции $variable
    # context 'when value has variable' do
    #   let(:set_variable) { described_class.new( do: 'set_variable',
    #                                             variable_name: 'variable_name',
    #                                             value: 'Это first_value = $first_value, а это second_value = $second_value',
    #                                             operation_id: 1,
    #                                             storage: storage,
    #                                             for_output_storage: for_output_storage) }
    #
    #   it {  expect(storage).to eq({ 'first_value' => '20', 'variable_name' => 'Это first_value = 20, а это second_value = 100' })}
    #   it {  expect(for_output_storage).to eq({ 'second_value' => '100' })}
    # end
  end
end