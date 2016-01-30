Rails.application.routes.draw do
  root "welcome#welcome"
  resources :groups, except: [:edit, :update]
  resources :salaries, only: [:new, :create, :destroy]

  resources :users, only: [:new, :create] do
    member do
      get 'verify_notice'
      get 'verify'
    end
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
end
