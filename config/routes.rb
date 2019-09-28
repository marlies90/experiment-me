Rails.application.routes.draw do
  get "/:category/experiments", to: "categories#show", as: 'category'
  resources :categories, except: [:show]
  resources :experiments, except: [:index], path: "/:category/experiments"
  # Use 'as', to rename the path
end
