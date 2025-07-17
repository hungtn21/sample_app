Rails.application.routes.draw do
  resources :microposts
  resources :products
  get "demo_partials/new"
  get "demo_partials/edit"
  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/contact"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "microposts#index"
end
