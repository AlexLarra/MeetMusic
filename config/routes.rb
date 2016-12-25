MeetMusic::Application.routes.draw do

  root :to => "sessions#new"

  resources :sessions
  get "log_in" => "sessions#new"
  get "log_out" => "sessions#destroy"

  resources :users
  get "sign_up" => "users#new"

  resources :songs, except: [:show] do
    member do
       get :download
    end
    collection do
      get :play
      get :download_all
    end
  end
end
