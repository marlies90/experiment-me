Rails.application.routes.draw do
  devise_for :users
  get "/:category/experiments", to: "categories#show", as: "category"
  resources :categories, except: [:show]
  resources :experiments, path: "/:category/experiments"

  root "pages#home", as: "home"
end
