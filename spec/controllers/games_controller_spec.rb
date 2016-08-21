require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "GET #index" do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it 'redirects to the main page' do
      expect{ get :new }.to change{ Game.count }.by(1)
      expect(response).to redirect_to games_path
    end
  end

  describe "GET #show" do
    fixtures :games

    it 'renders the show template' do
      game = games(:game)
      get :show, id: game.id
      expect(response).to render_template(:show)
    end
  end
end
