Rails.application.routes.draw do
  scope module: :v1, constraints: ApiConstraint.new(version: 1) do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations:  'overrides/registrations'
    }

    resources :stats, only: [:index]

    resources :users, only: [:show]

    resources :projects, only: [:show, :create, :update, :destroy] do
      member do
        patch :archive
        patch :activate
      end
    end

    resources :tasks, only: [:create, :update, :destroy] do
      member do
        patch :finish
        patch :to_progress
      end
    end

    resources :comments, only: [:create, :update, :destroy]
  end
end
