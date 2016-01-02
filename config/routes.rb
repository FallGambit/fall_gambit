FallGambit::Application.routes.draw do

  devise_for :users
  put "games/:id/move", to: "games#move"
  resources :games, :only => [:new, :create, :show, :update]
  resources :pieces, :only => [:show, :update]
  resources :users, :only => :show

  # Custom actions for Forfeit and Draw functionality
  resources :games do
    member do
      put :forfeit, to: "games#forfeit"
      put :request_draw, to: "games#request_draw"
      put :accept_draw, to: "games#accept_draw"
      put :reject_draw, to: "games#reject_draw"
    end
  end

  resources :pieces do
    member do
      get 'promotion_choice', :action => :promotion_choice
      put 'promotion_choice', :action => :promotion_choice
      patch 'promote_pawn', :action => :promote_pawn
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
