Rails.application.routes.draw do
  get "dashboard/overview"
  get "dashboard/settings"
  get "dashboard/progress"
  get "dashboard/journal"
  get "dashboard/admin"

  devise_for :users

  get "/:category/experiments", to: "categories#show", as: "category"
  resources :categories, except: [:show]

  resources :experiments, only: [:new, :create]
  resources :experiments, path: "/:category/experiments", except: [:new, :create]

  root "pages#home", as: "home"
end
