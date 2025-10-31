Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users,
    controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions',

      
    }
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"


  # namespace :api do
  #   namespace :v1 do
  #     post "auth/login", to: "auth#login"
  #     post "auth/signup", to: "auth#signup"
  #     resources :screens, only: [:index, :show, :create, :update, :destroy]
  #     resources :contents, only: [:index, :show, :create, :destroy]
  #     post "assignments", to: "assignments#create"
  #     get "screen_contents/:screen_id", to: "screen_contents#show"
  #   end
  # end


  namespace :api do
  namespace :v1 do
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }
      # resources :screens, only: [:index, :show, :create, :update, :destroy]

      resources :screens do
        member do
          post :upload_background
        end
      end

      resources :screen_containers do
        member do
          post :assign_screen
          delete :unassign_screen
        end
      end

      resources :contents, only: [:index, :show, :create, :destroy]
      resources :assignments, only: [:index, :show, :create, :update, :destroy]
      # post "assignments", to: "assignments#create"
      get "screen_contents/:screen_id", to: "screen_contents#show"
    end
  end


end
