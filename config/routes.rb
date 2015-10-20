Rails.application.routes.draw do

  resources :tags, only: [:index]
  resources :withdraws, only: [:new, :create]

  get 'qr_codes/:id' => "qr_codes#show", :as => "qr_code"

  root :to => 'passthrough#index'
  get 'home' => 'home#index'

  # remove later
  match 'check_signature' => 'home#check_signature', via: [:get, :post]
  match 'weixin_callback' => 'home#weixin_callback', via: [:get, :post]

  get 'recruiters' => 'recruiters/base#show'
  get 'suppliers' => 'suppliers/base#show'
  get 'admins' => 'admins/base#show'

  devise_for :recruiters, controllers: {
    sessions: 'authentication/recruiters/sessions',
    registrations: 'authentication/recruiters/registrations',
    passwords: 'authentication/recruiters/passwords',
    confirmations: 'authentication/recruiters/confirmations'
  }

  devise_for :suppliers, controllers: {
    sessions: 'authentication/suppliers/sessions',
    registrations: 'authentication/suppliers/registrations',
    passwords: 'authentication/suppliers/passwords',
    confirmations: 'authentication/suppliers/confirmations'
  }

  devise_for :admins, controllers: {
    sessions: 'authentication/admins/sessions',
  }

  namespace :admins do
    resources :resumes, only: [:index, :edit, :update] do
      member do
        get :download
      end
    end

    resources :deliveries, only: [:index]

    resources :money_transfers, only: [:index, :update]

    resources :users, only: [:index]
    resources :suppliers, only: [:index]
    resources :companies, only: [:index, :show]
    resources :jobs, only: [:index, :show, :edit, :update]
    resources :refund_requests, only: [:index, :show] do
      member do
        put :agree
        put :refuse
      end
    end
  end

  namespace :recruiters do
    resources :jobs, except: [:destroy] do
      member do
        put :freeze
        put :active
      end
    end
    resources :companies, only: [:edit, :update]
    resources :deliveries, only: [:index, :show] do
      member do
        put :pay
      end
    end
    resources :refund_requests, only: [:index, :new, :create]
    resources :rejections, only: [:new, :create]
    resources :deposits, only: [:new, :create]
    resources :final_payments, only: [:new, :create] do
      collection do
        get :deliveries_list
      end
    end
  end

  namespace :suppliers do
    resources :jobs, only: [:index, :show]
    resources :resumes, only: [:index, :new, :create] do
      member do
        get :download
      end
    end
    resources :watchings, only: [:create]
    resources :deliveries, only: [:index, :new, :create]
  end
end
