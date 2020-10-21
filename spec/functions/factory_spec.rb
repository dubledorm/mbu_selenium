require_relative '../../lib/functions/factory'
require_relative '../../lib/functions/click'


RSpec.describe Functions::Factory do
  let!(:click_arguments) { { selector: { xpath: '//fieldset[17]/button[2]' }, do: 'click' } }
  let!(:empty_arguments) { {} }
  let!(:unknown_function_arguments) { { selector: { xpath: '//fieldset[17]/button[2]' }, do: 'unknown' } }


  context 'click' do
    it { expect(described_class.build!(click_arguments).class).to eq(Functions::Click) }
  end

  context 'wrong_arguments' do
    it { expect{ described_class.build!(empty_arguments) }.to \
    raise_error(an_instance_of(Functions::Factory::FunctionBuildError).and having_attributes(message: 'В переданных параметрах должен присутствовать ключ :do. Передано: {}')) }

    it { expect{ described_class.build!(unknown_function_arguments) }.to \
    raise_error(an_instance_of(Functions::Factory::FunctionBuildError).and having_attributes(message: 'Неизвестное имя функции unknown')) }
  end
end