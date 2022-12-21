require_relative '../../../lib/functions/find_and_replace'


RSpec.describe Functions::FinAndReplace do
  let(:storage) { {'first_var' => 12, 'bad_var' => '$variable(bad_var)'} }
  let(:for_output_storage) { {'second_var' => 'first_var', '$variable(bad_var)' => 'Ok'} }

  describe 'call' do
    let(:storage_1) { { 'source_str' => '   10,0 hfjdfkdkds', 'regular' => '\d+,\d+' } }
    context 'when dose not exist nesting functions' do
      it { expect(described_class.call('$calculate(percent, 12, 100)', storage, for_output_storage)).to eq('12') }
      it { expect(described_class.call('$calculate(percent, 12, 100) $calculate(percent, 10, 100)', storage, for_output_storage)).to eq('12 10') }
    end

    context 'when nesting functions exist' do
      it { expect(described_class.call('$calculate(percent, $variable(first_var), 100)', storage, for_output_storage)).to eq('12') }
      it { expect(described_class.call('$variable($variable(second_var))', storage, for_output_storage)).to eq('12') }
      it { expect(described_class.call('$calculate(percent, $variable($variable(second_var)), 100)', storage, for_output_storage)).to eq('12') }
      it { expect(described_class.call('$find_sub_string($variable(source_str), $variable(regular))', storage_1, for_output_storage)).to eq('10,0') }
      it { expect(described_class.call('$find_sub_string(   10\\,0 hfjdfkdkds, \d+\\,\d+)', storage_1, for_output_storage)).to eq('10,0') }
      it { expect(described_class.call('$find_sub_string(   10\\,0 hfjd\\,fkd\\,kds, \d+\\,\d+)', storage_1, for_output_storage)).to eq('10,0') }
      #it { expect(described_class.call('$variable($variable(bad_var))', storage, for_output_storage)).to eq('12') }
    end
  end

  describe 'table_element_in_row' do
    it { expect(described_class.call('$table_element_in_row(/html/body/div[1]/div/div/main/div[2]/table,MFC-0005/2021-431,Присоединение образов)',
                                     storage, for_output_storage)).to eq("/html/body/div[1]/div/div/main/div[2]/table//*[contains(text(), 'MFC-0005/2021-431')]/ancestor::tr//*[contains(text(), 'Присоединение образов')]") }
  end
end