require_relative '../../lib/functions/send_text'
require 'awesome_print'

RSpec.describe Functions::SendText do

  context 'wrong_arguments' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new(selector: { xpath: '//fieldset[17]/button[2]' })).to_not be_valid }
    it { expect(described_class.new(do: 'send_text')).to_not be_valid }

    it 'print only' do
      function = described_class.new(do: 'send_text')
      function.valid?
      ap function.errors.full_messages
    end
  end

  context 'truth arguments' do
    let(:send_text) { described_class.new( selector: { xpath: '//fieldset[17]/button[2]' },
                                           do: 'send_text',
                                           value: 'dcscdscdsc',
                                           operation_id: 1 ) }
    let(:send_from_storage) { described_class.new( selector: { xpath: '//fieldset[17]/button[2]' },
                                                   do: 'send_text',
                                                   value_from_storage: 'dcscdscdsc',
                                                   operation_id: 1 ) }


    it { expect(send_text).to be_valid }
    it { expect(send_from_storage).to be_valid }
  end
end