require_relative '../../lib/functions/validate'
require 'selenium/webdriver'
require 'selenium/webdriver/common'
require 'awesome_print'

RSpec.describe Functions::Validate do

  context 'wrong_arguments' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new(selector: { xpath: '//fieldset[17]/button[2]' })).to_not be_valid }
    it { expect(described_class.new(do: 'validate', operation_id: 1)).to_not be_valid }
    it { expect(described_class.new(selector: { xpath: '//fieldset[17]/button[2]' },
                                    do: 'validate',
                                    value: 'проверяемое значение',
                                    attribute: 'text',
                                    operation_id: 1,
                                    strictly: 'wrong value')).to_not be_valid }

    it 'print only' do
      function = described_class.new(do: 'validate')
      function.valid?
      ap function.errors.full_messages
    end
  end

  context 'truth arguments' do
    let(:validate) { described_class.new( selector: { xpath: '//fieldset[17]/button[2]' },
                                          do: 'validate',
                                          value: 'проверяемое значение',
                                          attribute: 'text',
                                          operation_id: 1 ) }
    let(:strictly_validate) { described_class.new( selector: { xpath: '//fieldset[17]/button[2]' },
                                          do: 'validate',
                                          value: 'проверяемое значение',
                                          attribute: 'text',
                                          operation_id: 1,
                                          strictly: 'false') }


    it { expect(validate).to be_valid }
    it { expect(validate.strictly).to eq('true') }

    it { expect(strictly_validate).to be_valid }
    it { expect(strictly_validate.strictly).to eq('false') }
  end

  describe 'done' do
    let(:validate) { described_class.new( selector: { xpath: '//fieldset[17]/button[2]' },
                                          do: 'validate',
                                          value: 'проверяемое значение',
                                          attribute: 'text',
                                          operation_id: 1 ) }

    let(:element) { Selenium::WebDriver::Element.new(Selenium::WebDriver.for(:firefox), 1) }

    context 'when successfully' do
      before do
        allow(element).to receive(:text).and_return('проверяемое значение')
      end

      it { expect{validate.done!(element)}.to_not raise_error}
    end

    context 'when failed' do
      before do
        allow(element).to receive(:text).and_return('другое значение')
      end

      it { expect{validate.done!(element)}.to raise_error(Functions::TestInterrupted)}
    end

    context 'when strictly is false' do
      before do
        allow(element).to receive(:text).and_return('проверяемое значение и ещё чуть чуть')
        validate.strictly = 'false'
      end

      it { expect{validate.done!(element)}.to_not raise_error}
    end
  end
end