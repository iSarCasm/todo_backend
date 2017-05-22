Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  scope module: :v1, constraints: ApiConstraint.new(version: 1) do
    resources :users, only: [:show]
    resources :projects, only: [:show, :create, :update]
    resources :tasks, only: [:create, :update]
    resources :comments, only: [:create, :update]
  end
end
