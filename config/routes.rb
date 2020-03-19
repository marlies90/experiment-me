# frozen_string_literal: true

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
  resources :benefits

  devise_for :users

  get "/:category/experiments", to: "categories#show", as: "category_show"
  resources :categories, except: [:show]

  resources :experiments, only: %i[new create]
  resources :experiments, path: "/:category/experiments", except: %i[new create]

  resources :experiment_users, path: "/my-experiments", only: %i[new create edit update]

  root "pages#home", as: "home"
end
