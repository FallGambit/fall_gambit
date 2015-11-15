require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  #it "should have a current_user" do
      # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
      #subject.current_user.should_not be_nil
  #end
  #it "should get index" do
      # Note, rails 3.x scaffolding may add lines like get :index, {}, valid_session
      # the valid_session overrides the devise login. Remove the valid_session from your specs
      #get 'index'
      #response.should be_success
  #end
  describe "GET new" do 
    it "creates new game" do
      get :new
      expect(assigns(:game)).to be_a_new(Game)
    end
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET show" do 
    context 'with valid params' do
      it "assigns the requested contact to @game" do
          game = create(:game)
          get :show, id: game
          expect(assigns(:game)).to eq(game)
        end
      it "has a 200 status code for an existing game" do
        desired_game = create(:game)
        get :show, id: desired_game.id
        (expect(response.status).to eq(200))
      end
      it "renders the show view" do
        desired_game = create(:game)
        get :show, id: desired_game.id
        expect(response).to render_template("show")
      end
    end
    context 'with invalid params' do
      it "has a 404 status code for an non-existant game" do
        get :show, id: "LOL"
        (expect(response.status).to eq(404))
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'redirects to show page' do
        post :create, game: attributes_for(:game)
        expect(response).to redirect_to(Game.last)
      end
    end
    context 'with invalid params' do
      it 're-renders #new form' do
        post :create, game: {game_name: ""}
        expect(response).to render_template(:new)
      end
    end
  end

end
