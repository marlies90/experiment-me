# frozen_string_literal: true

Rails.application.routes.draw do
  require "sidekiq/web"

  namespace :dashboard do
    get "lab"
    get "charts"
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

  resources :observations, path: "/dashboard/observations"
  resources :benefits
  resources :images

  devise_scope :user do
    get "/dashboard/settings" => "users/registrations#edit", as: "edit_user_registration"
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    unlocks: "users/unlocks"
  }

  get "/:category/experiments", to: "categories#show", as: "category_show"
  resources :categories, except: [:show]

  resources :experiments, only: %i[new create]
  resources :experiments, path: "/:category/experiments", except: %i[new create]

  resources :experiment_users, path: "/my-experiments", only: %i[new create edit update show]

  resources :blog_posts, path: "/blog" do
    resources :blog_comments, only: [:create]
  end

  resources :blog_comments do
    resources :blog_comments
  end

  get "/about", to: "pages#about"
  get "/privacy-statement", to: "pages#privacy_statement"
  get "/terms-conditions", to: "pages#terms_conditions"
  get "/contact", to: "pages#contact"
  get "/newest-blog-post", to: "pages#newest_blog_post"
  get "/newest-experiment", to: "pages#newest_experiment"

  get "/sitemap", to: "sitemaps#index"

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root "pages#home"
end
