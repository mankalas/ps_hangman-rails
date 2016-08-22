require 'rails_helper'

RSpec.describe TriesController, type: :controller do
  describe "GET #new" do
    fixtures :games
    let(:game) { games(:game) }
    let(:letter) { 'e' }
    # TODOL POST

    def guess(input)
      get :new, params: { guess: input, game_id: game.id }
    end

    describe "interaction with the game" do
      before do
        expect(Game).to receive(:find).and_return(game)
      end

      after do
        guess(letter)
      end

      it "sends the input to the game" do
        expect(game).to receive(:guess).with(letter).once
      end

      it "updates the game" do
        expect(game).to receive(:update).once.with(any_args)
      end
    end

    context "guess is good" do
      before do
        guess(letter)
      end

      it "redirects to the game's page" do
        expect(response).to redirect_to game
      end

      it "redirects without any error" do
        expect(flash[:notice]).to eq nil
      end
    end

    context "guess is bad input" do
      before do
        guess('!')
      end

      it "redirects to the game's page" do
        expect(response).to redirect_to game
      end

      it "redirects with an error" do
        expect(flash[:notice]).to eq ["input must be a letter"]
      end
    end

    # shared example???
    context "guess has already been made" do
      before do
        2.times { guess(letter) }
      end

      it "redirects to the game's page" do
        expect(response).to redirect_to game
      end

      it "redirects with an error" do
        expect(flash[:notice]).to eq ["Already tried '#{letter}'"]
      end
    end
  end
end
