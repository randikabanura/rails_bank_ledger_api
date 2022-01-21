Rails.application.routes.draw do

  scope :api do
    scope :v1 do
      mount_devise_token_auth_for 'Customer', at: 'auth', skip: [:omniauth_callbacks]
      resources :accounts, controller: 'api/v1/accounts' do
        member do
          get :transactions
        end
      end
      resources :transactions, controller: 'api/v1/transactions', except: %i[update destroy]
    end
  end
end
