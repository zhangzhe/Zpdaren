Rails.application.routes.draw do

  namespace :api do
    resources :tags, only: [:index]
  end

  resources :withdraws, only: [:new, :create]

  get 'qr_codes/show'

  root :to => 'passthrough#index'
  get 'home' => 'home#index'
  post 'check_signature' => 'home#check_signature'
  get 'check_signature' => 'home#check_signature'

  get 'recruiters' => 'recruiters/base#show'
  get 'suppliers' => 'suppliers/base#show'

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

  resources :qr_codes, only: [:show]

  namespace :admins do
    resources :resumes, only: [:index, :edit] do
      member do
        put :check_and_update
        get :original_resume_download
      end
    end

    resources :money_transfers, only: [:index, :update]

    resources :users, only: [:index]
    resources :companies, only: [:index, :show]
    resources :jobs, only: [:index, :show, :edit, :update] do
      member do
        put :complete
      end
    end
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
        put :complete
        put :freeze
        put :active
      end
    end
    resources :companies, only: [:show, :edit, :update]
    resources :deliveries, only: [:index, :show] do
      collection do
        get :paid_index
      end
      member do
        put :pay
        put :final_pay
      end
    end
    resources :refund_requests, only: [:index, :new, :create]
    resources :rejections, only: [:new, :create]
    resources :deposits, only: [:new, :create]
    resources :final_payments, only: [:index, :new, :create]
  end

  namespace :suppliers do
    resources :jobs, only: [:index, :show]
    resources :resumes, only: [:index, :new, :create, :download] do
      member do
        get :download
      end
    end
    resources :attentions, only: [:create]
    resources :deliveries, only: [:index, :new, :create]
  end
end
