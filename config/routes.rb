Rails.application.routes.draw do
  resources :votes do
    post 'answer' => 'votes#answer'
    delete 'answers' => 'votes#clear_answers'
  end
  resources :online_competitions
  get 'online_competitions/:id/admin' => 'online_competitions#admin', :as => :admin_results
  resources :clubs, except: [:show]
  resources :external_resources, except: [:show], path: 'ressources'
  resources :calendar_events
  resources :bags
  root 'posts#home'

  resources :users, only: [:index, :edit, :update]
  get 'users/import' => 'users#import'
  post 'users/import' => 'users#import_from_wca'

  # To not ruin our pagerank, we need a "/news" routes with slugs, so that old links keep working
  resources :news, :controller => "posts"
  get '/news/tag/:tag' => 'posts#tag_index', :as => :posts_by_tag
  # Some slug have slashes, we need a globbing routes (and an appropriate path helper too)
  get '/news/*id' => 'posts#show', :as => 'news_slug', :format => false
  resources :subscriptions, only: [:index, :edit, :update, :destroy]
  resources :tags, only: [:index, :edit, :update]
  resources :hardwares

  post '/subscriptions/review_csv' => 'subscriptions#review_csv'
  post '/subscriptions/import' => 'subscriptions#import'
  get '/subscriptions/list' => 'subscriptions#subscriptions_list'

  get '/my_competitions' => 'competitions#my_competitions'
  get '/upcoming_comps' => 'competitions#upcoming_comps'
  get '/upcoming_champs' => 'competitions#manage_big_champs'
  post '/update_champs' => 'competitions#update_big_champs'

  resources :competitions, only: [:index]
  get 'competitions/official/:competition_id/registrations' => 'competitions#show_registrations', :as => :competition_registrations
  get 'competitions/historique' => 'competitions#old_competitions_list'
  get 'competitions/:slug' => 'competitions#show_competition_page', :as => 'old_competitions'

  get '/profile' => 'users#edit'
  get '/self-id' => 'results#self_wca_id', :as => :self_info

  get '/wca_callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  post '/signin_with_wca' => 'sessions#signin_with_wca', :as => :signin_with_wca
  get '/signout' => 'sessions#destroy', :as => :signout
  patch '/update_locale/:locale' => 'application#update_locale', as: :update_locale

  get 'results/index/:event_id/:competition_id' => 'results#index_for_comp', :as => :results_for_comp
  get 'results/:event_id/:competition_id' => 'results#show', :as => :show_result
  patch 'results/:event_id/:competition_id' => 'results#create_or_update', :as => :submit_result
  delete 'results/:id' => 'results#destroy', :as => :destroy_result
end
