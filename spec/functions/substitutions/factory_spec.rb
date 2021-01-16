require_relative '../../../lib/functions/substitutions/factory'
require_relative '../../../lib/functions/substitutions/calculate'


RSpec.describe Functions::Substitutions::Factory do
  context 'calculate' do
    it { expect(described_class.build!('calculate', %w[args1 args2]).class).to eq(Functions::Substitutions::Calculate) }
    it { expect{described_class.build!('calculate', %w[args1]).class}.to raise_error(ArgumentError) }
    it { expect{described_class.build!('bad_name', %w[args1]).class}.to raise_error(Functions::Substitutions::Factory::FunctionBuildError) }
  end
end