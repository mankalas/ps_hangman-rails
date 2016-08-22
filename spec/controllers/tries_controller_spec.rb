require 'rails_helper'

RSpec.describe TriesController, type: :controller do
  describe "GET #new" do
    fixtures :games
    let(:game) { games(:game) }

    context "guess is good" do
      it "redirects to the game's page" do
        get :new, params: { guess: 'e', game_id: game.id }
        expect(response).to redirect_to game
      end
    end

    context "guess is bad input" do
      before do
        get :new, params: { guess: '!', game_id: game.id }
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
      let(:letter) { 'e' }

      before do
        2.times { get :new, params: { guess: letter, game_id: game.id } }
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
