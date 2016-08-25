require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    fixtures :games

    it "renders the show template" do
      get :show, id: games(:game).id
      expect(response).to render_template(:show)
    end
  end

  describe "POST #create" do
    let(:create_request) { post :create, game: { :player_ids => [1] } }
    let(:game) { Game.new }

    before do
      expect(Game).to receive(:new).and_return(game)
      expect(game).to receive(:add_player)
      expect(game).to receive(:set_first_player!)
    end

    it "creates a new game" do
      expect{ create_request }.to change{ Game.count }.by(1)
    end

    it "redirects to the game's page" do
      create_request
      expect(response).to redirect_to Game.last
    end
  end
end
