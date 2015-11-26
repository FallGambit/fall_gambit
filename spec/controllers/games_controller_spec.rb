require 'rails_helper'
RSpec.describe GamesController, type: :controller do
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
      it "assigns the requested game to @game" do
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
    context 'with logged in user' do
      login_user
      context 'with valid params' do
        context 'with white player creating the game' do
          it 'redirects to show page' do
            white_player = create(:user)
            post :create, game: { game_name: "Test White",
                                  white_user_id: white_player.id }
            expect(response).to redirect_to(Game.last)
          end
        end
        context 'with black player creating the game' do
          it 'redirects to show page' do
            black_player = create(:user)
            post :create, game: { game_name: "Test Black",
                                  black_user_id: black_player.id }
            expect(response).to redirect_to(Game.last)
          end
        end
      end
      context 'with invalid params' do
        it 're-renders #new form' do
          post :create, game: { game_name: "" }
          expect(response).to render_template(:new)
        end
      end
    end
    context 'without being logged in' do
      it 'redirects to sign-in page' do
        post :create, game: attributes_for(:game)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with logged in user' do
      login_user
      context 'with white player joining game' do
        it 'redirects to show page' do
          black_player = create(:user)
          game_to_update = Game.create(game_name: "Test",
                                       black_user_id: black_player.id)
          white_player = create(:user)
          put :update, id: game_to_update.id, game: {
            white_user_id: white_player.id }
          expect(response).to redirect_to(game_to_update)
        end
      end
      context 'with black player joining game' do
        it 'redirects to show page' do
          white_player = create(:user)
          game_to_update = Game.create(game_name: "Test",
                                       white_user_id: white_player.id)
          black_player = create(:user)
          put :update, id: game_to_update.id, game: {
            black_user_id: black_player.id }
          expect(response).to redirect_to(game_to_update)
        end
      end
      it 'won\'t let player join full game' do
        game = create(:game)
        new_player = create(:user)
        # game_to_update = Game.create(game_name: "Test",
        #                             black_user_id: new_player.id)
        put :update, id: game.id, game: {
          white_user_id: new_player.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to eq('Game is full!')
      end
    end
    context 'without being logged in' do
      it 'redirects to sign-in page' do
        game_to_update = create(:game)
        put :update, id: game_to_update.id, game: attributes_for(:game)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
