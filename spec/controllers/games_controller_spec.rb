require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "GET #index" do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it 'creates a new game' do
      expect{ get :new }.to change{ Game.count }.by(1)
    end

    it 'redirects to the game\'s page' do
      get :new
      expect(response).to redirect_to Game.last
    end
  end

  describe "GET #show" do
    fixtures :games

    it 'renders the show template' do
      get :show, id: games(:game).id
      expect(response).to render_template(:show)
    end
  end
end
