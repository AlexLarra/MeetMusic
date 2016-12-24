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
       get :play
    end
    collection do
      get :download_all
      get :latests
    end
  end
end
