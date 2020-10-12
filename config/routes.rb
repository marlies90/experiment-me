# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :dashboard do
    get "overview"
    get "progress"
    get "experiments"
    get "admin"
  end

  namespace :api do
    resources :progress_data, only: [:create] do
      collection do
        get "filtered"
      end
    end
  end

  resources :journal_entries, path: "/dashboard/journal"
  resources :benefits

  devise_scope :user do
    get "/dashboard/settings" => "devise/registrations#edit", as: "edit_user_registration"
  end

  devise_for :users

  get "/:category/experiments", to: "categories#show", as: "category_show"
  resources :categories, except: [:show]

  resources :experiments, only: %i[new create]
  resources :experiments, path: "/:category/experiments", except: %i[new create]

  resources :experiment_users, path: "/my-experiments", only: %i[new create edit update show]

  get "/privacy-statement", to: "pages#privacy_statement"
  get "/terms-conditions", to: "pages#terms_conditions"
  get "/contact", to: "pages#contact"

  get "/sitemap", to: "sitemaps#index"

  root "pages#home", as: "home"
end
