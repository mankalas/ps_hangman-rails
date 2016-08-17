require 'spec_helper'

RSpec.describe Game, type: :model do
  let(:secret) { 'platypus' }
  let(:game) { Game.new(secret: secret) }

  shared_examples "a words-only field" do
    context "rejects" do
      it "numbers" do
        expect{ game.send(field, 1) }.to change{ game.valid? }.from(true).to(false)
      end

      it "symbols" do
        expect{ game.send(field, '!') }.to change{ game.valid? }.from(true).to(false)
      end

      it "whitespaces" do
        expect{ game.send(field, 'hello world') }.to change{ game.valid? }.from(true).to(false)
      end
    end

    context "accepts" do
      it "lowercased words" do
        expect{ game.send(field, 'horse') }.not_to change{ game.valid? }
      end

      it "uppercased words" do
        expect{ game.send(field, 'HORSE') }.not_to change{ game.valid? }
      end
    end
  end

  describe "validation" do
    describe ".secret" do
      let(:field) { :secret= }

      it_behaves_like "a words-only field"

      context "rejects" do
        it "empty word" do
          expect{ game.secret = "" }.to change{ game.valid? }.from(true).to(false)
        end

        it "nil word" do
          expect{ game.secret = nil}.to change{ game.valid? }.from(true).to(false)
        end
      end
    end

    describe ".lives" do
      context "rejects" do
        it "integers <0" do
          expect(Game.new(secret: secret, lives: -1)).not_to be_valid
        end

        it "non-numbers" do
          expect(Game.new(secret: secret, lives: nil)).not_to be_valid
        end

        it "non-integers" do
          expect(Game.new(secret: secret, lives: 3.14)).not_to be_valid
        end
      end

      context "accepts" do
        it "zero" do
          expect(Game.new(secret: secret, lives: 0)).to be_valid
        end

        it ">0" do
          expect(Game.new(secret: secret, lives: 42)).to be_valid
        end
      end
    end

    describe ".tries" do
      let(:field) { :tries= }

      it_behaves_like "a words-only field"

      context "rejects" do
        it "duplicates" do
          expect{ game.tries = 'aa' }.to change{ game.valid? }.from(true).to(false)
        end
      end

      context "accepts" do
        it "empty word" do
          expect{ game.tries = ''}.not_to change{ game.valid? }
        end

        it "nil" do
          expect{ game.tries = nil}.not_to change{ game.valid? }
        end
      end
    end
  end

  describe "#lost?" do
    context "no lives left" do
      before do
        expect(game).to receive(:lives).and_return(0)
      end

      it "is truthy" do
        expect(game).to be_lost
      end
    end

    context "some lives left" do
      before do
        expect(game).to receive(:lives).and_return(5)
      end

      it "is falsey" do
        expect(game).not_to be_lost
      end
    end
  end

  describe "#won?" do
    context "all secret's letters have been guessed" do
      before do
        expect(game).to receive(:tries).at_least(:once).and_return(secret)
      end

      it "is truthy" do
        expect(game).to be_won
      end
    end

    context "not all secret letters have been guessed" do
      it "is falsey" do
        expect(game).not_to be_won
      end
    end
  end

  describe "#show_secret_word" do
    context "one letter has been rightly guessed" do
      before do
        expect(game).to receive(:tries).at_least(:once).and_return('p')
      end

      it "obfuscates the word" do
        expect(game.show_secret_word).to eq 'p____p__'.chars.join(' ')
      end
    end
  end

  describe "#guess" do
    context "on bad input" do
      it "does not decrement lives" do
        expect{ game.guess('1') }.not_to change{ game.lives }
      end
    end

    context "on already tried letter" do
      let(:guess) { 'e' }

      it "does not decrement lives" do
        game.guess(guess)
        expect{ game.guess(guess) }.not_to change{ game.lives }
      end
    end

    context "on wrong letter" do
      it "decrements lives" do
        expect{ game.guess('x') }.to change{ game.lives }.by(-1)
      end
    end
  end
end
