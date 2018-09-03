require 'rails_helper'

RSpec.describe EnvSpec::Schema, type: :model do
  let(:config) { { raise_error: true, variables: { 'VARIABLE_A' => { required: false, inclusion: %w[default option_1] } } } }
  let(:schema) { EnvSpec::Schema.new(path: './env.yml') }
  subject { schema }
  before(:each) do
    allow(YAML).to receive(:load_file).and_return(config)
  end

  it { expect(subject.instance_variable_get(:@config).as_json).to eq(config.as_json) }

  describe '#validate!' do
    subject { schema.validate! }
    it 'checks each variables given and see if they are valid' do
      expect_any_instance_of(EnvSpec::Variable).to receive(:valid?).and_return(true)
      subject
    end

    context 'when variable is invalid' do
      let(:should_raise_error) { true }
      before(:each) do
        expect_any_instance_of(EnvSpec::Variable).to receive(:valid?).and_return(false)
        allow_any_instance_of(EnvSpec::Variable).to receive(:error).and_return(EnvSpec::Variable::InvalidVariableError.new('VARIABLE_A', 'Some error'))
        allow(schema).to receive(:raise_error?).and_return(should_raise_error)
      end

      it 'checks each variables given and see if they are valid' do
        expect(schema).to receive(:puts).with(/Invalid/)
        expect{ subject }.to raise_error(EnvSpec::Schema::ValidationError)
      end

      context 'when raise error is disabled' do
        let(:should_raise_error) { false }
        it do
          expect(schema).to receive(:puts).with(/Invalid/)
          expect{ subject }.not_to raise_error
        end
      end
    end
  end

  describe '#raise_error?' do
    let(:config) { { raise_error: false } }
    subject { EnvSpec::Schema.new(path: './env.yml').raise_error? }
    it { is_expected.to be(false) }

    context 'when raise_error is not specified in config' do
      let(:config) { {} }
      it { is_expected.to be(true) }
    end
  end
end
