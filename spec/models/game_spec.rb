require 'spec_helper'

RSpec.describe Game, type: :model do
  let(:secret) { 'platypus' }
  let(:game) { Game.new(secret: secret) }

  shared_examples "a letters-only field" do
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
    describe "#secret" do
      let(:field) { :secret= }

      it_behaves_like "a letters-only field"

      context "rejects" do
        it "empty word" do
          expect{ game.secret = "" }.to change{ game.valid? }.from(true).to(false)
        end

        it "nil word" do
          expect{ game.secret = nil }.to change{ game.valid? }.from(true).to(false)
        end
      end
    end

    describe "#lives" do
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

    describe "#tries" do
      let(:field) { :tries= }

      it_behaves_like "a letters-only field"

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
    context "when no lives left" do
      it "is truthy" do
        expect(game).to receive(:lives).and_return(0)
        expect(game).to be_lost
      end
    end

    context "when some lives left" do
      it "is falsey" do
        expect(game).to receive(:lives).and_return(5)
        expect(game).not_to be_lost
      end
    end
  end

  describe "#won?" do
    context "when all secret's letters have been guessed" do
      it "is truthy" do
        expect(game).to receive(:tries).exactly(secret.length).times.and_return(secret)
        expect(game).to be_won
      end
    end

    context "when not all secret letters have been guessed" do
      it "is falsey" do
        expect(game).not_to be_won
      end
    end
  end

  describe "#secret_word_masked" do
    context "when no letter has been guessed" do
      it "returns a array of nils" do
        expect(game).to receive(:tries).exactly(secret.length).times.and_return("")
        expect(game.secret_word_masked).to eq [nil] * secret.length
      end
    end

    context "when one letter has been guessed" do
      it "returns an array of nils, except for the guessed letter" do
        expect(game).to receive(:tries).exactly(secret.length).times.and_return('p')
        expect(game.secret_word_masked).to eq ["p", nil, nil, nil, nil, "p", nil, nil]
      end
    end

    context "when all letters have been guessed" do
      it "returns an array with the letters, without any nil" do
        expect(game).to receive(:tries).exactly(secret.length).times.and_return('platyus')
        expect(game.secret_word_masked).to eq 'platypus'.chars
      end
    end
  end

  describe "#failed_try?" do
    context "when submitting bad input" do
      it "is falsey" do
        expect(game).to receive(:valid?).and_return(false)
        expect(game.failed_try?('1')).to be_falsey
      end
    end

    context "when submitting a bad letter" do
      it "is truthy" do
        expect(game.failed_try?('x')).to be_truthy
      end
    end

    context "when submitting a good letter" do
      it "is falsey" do
        expect(game.failed_try?(secret[0])).to be_falsey
      end
    end
  end

  describe "#guess" do
    context "on bad input" do
      let(:play) { double(Play) }
      let(:make_an_invalid_guess) { game.guess('1') }

      it "invalidates the game (which means it can't be saved)" do
        expect{ make_an_invalid_guess }.to change{ game.valid? }.from(true).to(false)
      end

      it "the current play is never retrieved (so no life is lost)" do
        expect(game).not_to receive(:current_play)
        make_an_invalid_guess
      end

      it "stays to the same turn" do
        expect(game).not_to receive(:set_next_turn)
        make_an_invalid_guess
      end
    end

    context "on duplicated guess" do
      let(:guess) { secret[0] }

      before do
        game.guess(guess)
      end

      it "invalidates the game (which means it can't be saved)" do
        expect{ game.guess(guess) }.to change{ game.valid? }.from(true).to(false)
      end

      it "the current play is never retrived (so no life is lost)" do
        expect(game).not_to receive(:current_play)
        game.guess(guess)
      end

      it "stays to the same turn" do
        expect(game).not_to receive(:set_next_turn)
        game.guess(guess)
      end
    end

    # context "on wrong letter" do
    #   it "decrements lives" do
    #     expect{ game.guess('x') }.to change{ game.lives }.by(-1)
    #   end
    # end
  end

  # TODO: moar tests! (I'd like to get into Cucumber, so no more RSpec
  # tests right now)
end
