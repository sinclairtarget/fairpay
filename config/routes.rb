Rails.application.routes.draw do
  root "welcome#welcome"
  resources :groups, except: [:edit, :update]
  resources :salaries, only: [:new, :create, :destroy]
end
