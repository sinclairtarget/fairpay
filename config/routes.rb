Rails.application.routes.draw do
  root "welcome#welcome"
  resources :groups, except: [:edit, :update] do
    member do
      get 'invite'
      post 'invite', to: 'groups#send_invites'
    end
  end

  resources :salaries, only: [:new, :create, :destroy]

  resources :users, only: [:new, :create] do
    member do
      get 'verification'
      get 'resend_verification'
      get 'verify'
    end
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
end
