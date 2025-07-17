Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "demo_partials/new", to: "demo_partials#new", as: :new_demo_partial
    get "demo_partials/edit", to: "demo_partials#edit", as: :edit_demo_partial
    get "static_pages/home", to: "static_pages#home", as: :static_pages_home
    get "static_pages/help", to: "static_pages#help", as: :static_pages_help
    get "static_pages/contact", to: "static_pages#contact", as: :static_pages_contact
    resources :products
    resources :microposts
    resources :demo_partials
    root "microposts#index"
  end
end
