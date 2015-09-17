Rails.application.routes.draw do
  resources :withdraws
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
    resources :drawings, only: [:index] do
      member do
        put :review
      end
    end
  end

  namespace :recruiters do
    resources :jobs, except: [:destroy] do
      member do
        get :deposit_pay_new
        put :deposit_pay
        put :complete
        put :freeze
        put :active
      end
    end
    resources :companies, only: [:show, :edit, :update]
    resources :deliveries, only: [:index, :show] do
      member do
        put :pay
        put :final_pay
      end
    end
    resources :refund_requests, only: [:index, :new, :create]
    resources :rejections, only: [:new, :create]
  end

  namespace :suppliers do
    resources :jobs, only: [:index, :show]
    resources :resumes, only: [:index, :create]
    resources :attentions, only: [:create]
    resources :deliveries, only: [:index, :new, :create]
    resources :users, only: [:show]
    resources :drawings, only: [:index,:create]
  end
end
