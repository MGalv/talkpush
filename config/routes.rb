Rails.application.routes.draw do

  resources :candidates, only: [:index]

  post "/talkpush/load_candidates", to: 'talkpush#load_candidates'
  root 'candidates#index'
end
