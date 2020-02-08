Rails.application.routes.draw do
  namespace :dashboard do
    get "overview"
    get "settings"
    get "progress"
    get "experiments"
    get "admin"
  end

  resources :journal_entries, path: "/dashboard/journal"
  resources :journal_statements

  devise_for :users

  get "/:category/experiments", to: "categories#show", as: "category"
  resources :categories, except: [:show]

  resources :experiments, only: [:new, :create]
  resources :experiments, path: "/:category/experiments", except: [:new, :create]

  resources :experiment_users, path: "/my-experiments/:id", only: [:new, :create, :update]

  root "pages#home", as: "home"
end
