Rails.application.routes.draw do
  namespace :dashboard do
    get "overview"
    get "settings"
    get "progress"
    get "admin"
  end

  resources :journal_entries, path: "/dashboard/journal"

  devise_for :users

  get "/:category/experiments", to: "categories#show", as: "category"
  resources :categories, except: [:show]

  resources :experiments, only: [:new, :create]
  resources :experiments, path: "/:category/experiments", except: [:new, :create]

  root "pages#home", as: "home"
end
