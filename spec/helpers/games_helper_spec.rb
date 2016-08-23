require 'rails_helper'

RSpec.describe GamesHelper, type: :helper do
  describe ".format_masked_word" do
    let(:array) { ['a', nil, nil, 'q', 'w'] }

    it 'transforms an array into a obfuscated string' do
      expect(format_masked_word(array)).to eq 'a _ _ q w'
    end
  end

  describe ".format_tries" do
    let(:tries) { 'qwertyuiop' }

    it "joins the tried characters with a comma and space" do
      expect(format_tries(tries)).to eq tries.chars.join(', ')
    end
  end
end
