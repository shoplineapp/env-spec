require 'rails_helper'

RSpec.describe EnvSpec do
  describe '::VERSION' do
    it 'has a version constant' do
      expect(EnvSpec).to have_constant(:VERSION)
    end
  end
end
