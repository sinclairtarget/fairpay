Rails.application.routes.draw do
  root "welcome#welcome"
  resources :groups, except: [:edit, :update]
  resources :salaries, only: [:new, :create, :destroy]

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
end
