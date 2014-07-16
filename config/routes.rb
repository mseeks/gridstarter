Gridstarter::Application.routes.draw do
  get 'workers/index'

  root to: "static_pages#home"
  
  resources :workers
  
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
end
