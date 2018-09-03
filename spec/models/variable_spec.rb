require 'rails_helper'

RSpec.describe EnvSpec::Variable, type: :model do
  let(:variable_key) { 'VARIABLE_A' }
  let(:params) { {} }
  let(:variable) { EnvSpec::Variable.new(params.merge(key: variable_key)) }
  subject { variable }

  it do
    is_expected.to respond_to(:key)
    is_expected.to respond_to(:required?)
    is_expected.to respond_to(:missing?)
  end

  describe '#value' do
    let(:variable_value) { 'Testing value' }
    subject { variable.value }
    before(:each) do
      allow(::ENV).to receive(:[]).with(variable_key).and_return(variable_value)
    end
    context 'environemnt variable is set' do
      it { is_expected.to eq(variable_value) }
    end
  end

  describe '#required?' do
    it do
      expect(EnvSpec::Variable.new.required?).to be(true)
      expect(EnvSpec::Variable.new(required: true).required?).to be(true)
      expect(EnvSpec::Variable.new(required: false).required?).to be(false)
    end
  end

  describe '#missing?' do
    subject { variable.missing? }
    it do
      expect(::ENV).to receive(:key?).with(variable_key)
      subject
    end
  end

  describe '#valid?' do
    let(:variable_value) { 'AAA' }
    subject { variable.valid? }
    before(:each) do
      allow(variable).to receive(:value).and_return(variable_value)
      allow(variable).to receive(:missing?).and_return(false)
    end

    shared_examples_for 'valid environment variable' do
      it { is_expected.to be(true) }
      it do
        subject
        expect(variable.error).to be(nil)
      end
    end

    shared_examples_for 'invalid environment variable' do
      it { is_expected.to be(false) }
      it do
        subject
        expect(variable.error).to be_a(EnvSpec::Variable::InvalidVariableError)
        expect(variable.error.message).to include(variable_key)
      end
    end

    context 'when variable is required and value inclusion is specified' do
      let(:params) { { required: true, inclusion: %w[AAA BBB CCC] } }
      it_behaves_like 'valid environment variable'

      context 'and value is not present' do
        let(:variable_value) { 'DDD' }
        it_behaves_like 'invalid environment variable'
      end
    end

    context 'when variable is required and value pattern is specified' do
      let(:params) { { required: true, pattern: '[A]{3}' } }
      it_behaves_like 'valid environment variable'

      context 'and value is valid' do
        let(:variable_value) { 'DDD' }
        it_behaves_like 'invalid environment variable'
      end
    end

    context 'when variable is missing' do
      before(:each) do
        allow(variable).to receive(:missing?).and_return(true)
      end
      context 'and variable is not required' do
        let(:params) { { required: false } }
        it_behaves_like 'valid environment variable'
      end

      context 'and variable is required' do
        let(:params) { { required: true } }
        it_behaves_like 'invalid environment variable'
      end
    end

    context 'when variable is not required but inclusion/pattern is given' do
      let(:variable_value) { 'AAA' }
      let(:params) { { required: false, pattern: '[B]{3}' } }
      it_behaves_like 'invalid environment variable'
    end
  end
end
