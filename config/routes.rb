MeetMusic::Application.routes.draw do

  root :to => "sessions#new"

  resources :sessions
  get "log_in" => "sessions#new"
  get "log_out" => "sessions#destroy"

  resources :users
  get "sign_up" => "users#new"
  get "user" => "users#show"
  get "cuenta" => "users#cuenta"
  get "borrar_cuenta" => "users#destroy"

  resources :songs do
    member do
       get "descargar" => "songs#song_download"
       get "play" => "songs#play"
    end
    collection do
      get "descargar_todas" => "songs#all_songs_download"
      get "recientes" => "songs#recientes"
    end
  end
end
