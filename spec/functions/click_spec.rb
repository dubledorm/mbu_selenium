require_relative '../../lib/functions/click'
require 'awesome_print'

RSpec.describe Functions::Click do

  context 'wrong_arguments' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new(selector: { xpath: '//fieldset[17]/button[2]' })).to_not be_valid }
    it { expect(described_class.new(do: 'click')).to_not be_valid }

    it 'print only' do
      function = described_class.new(do: 'click')
      function.valid?
      ap function.errors.full_messages
    end
  end

  context 'truth arguments' do
    let!(:click) { described_class.new( selector: { xpath: '//fieldset[17]/button[2]' }, do: 'click', operation_id: 1 ) }

    it { expect(click).to be_valid }
  end
end