Rails.application.routes.draw do

  resources :shortened_urls, only: [:create]
  resources :api_credentials, only: [:create]
  root 'dashboards#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 's/:short_code', to: 'shortened_urls#show', as: :shortened_url
  get 'api_credentials/:api_key', to: 'api_credentials#show'
end
