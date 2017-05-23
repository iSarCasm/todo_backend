Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations:  'overrides/registrations'
  }

  scope module: :v1, constraints: ApiConstraint.new(version: 1) do
    resources :users, only: [:show]
    resources :projects, only: [:show, :create, :update, :destroy]
    resources :tasks, only: [:create, :update, :destroy]
    resources :comments, only: [:create, :update, :destroy]
  end
end
