Rails.application.routes.draw do
  get 'qr_codes/show'

  root :to => 'passthrough#index'
  get 'front_page' => 'front_page#index'
  post 'check_signature' => 'front_page#check_signature'
  get 'check_signature' => 'front_page#check_signature'

  devise_for :recruiters, controllers: {
    sessions: 'authentication/recruiters/sessions',
    registrations: 'authentication/recruiters/registrations',
    passwords: 'authentication/recruiters/passwords',
  }

  devise_for :suppliers, controllers: {
    sessions: 'authentication/suppliers/sessions',
    registrations: 'authentication/suppliers/registrations',
    passwords: 'authentication/suppliers/passwords',
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
    resources :jobs, only: [:index, :show, :edit, :update]
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
        get :pay
      end
    end
    resources :refund_requests, only: [:index, :new, :create]
  end

  namespace :suppliers do
    resources :jobs, only: [:index, :show]
    resources :resumes, only: [:index, :create]
    resources :attentions, only: [:create]
    resources :deliveries, only: [:new, :create]
    resources :users, only: [:show]
    resources :drawings, only: [:index,:create]
  end

  resources :deliveries, only: []

  resources :resumes, except: [:new] do
    collection do
      get 'download'
    end

    member do
      get 'download'
    end
  end
end
