Rails.application.routes.draw do

  resources :tags, only: [:index]
  resources :withdraws, only: [:new, :create]

  get 'qr_codes/:id' => "qr_codes#show", :as => "qr_code"

  root :to => 'passthrough#index'
  get 'home' => 'home#index'

  match 'weixin_callback' => 'home#weixin_callback', via: [:get, :post]

  get 'recruiters' => 'recruiters/base#show'
  get 'suppliers' => 'suppliers/base#show'
  get 'admins' => 'admins/base#show'
  get 'signup_redirection' => 'home#signup_redirection'
  get 'forget_password_redirection' => 'home#forget_password_redirection'

  get "/suppliers/sign_in", to: redirect("users/sign_in")
  get "/recruiters/sign_in", to: redirect("users/sign_in")

  devise_for :recruiters, controllers: {
    registrations: 'authentication/recruiters/registrations',
  }

  devise_for :suppliers, controllers: {
    registrations: 'authentication/suppliers/registrations',
  }

  devise_for :users, controllers: {
    sessions: 'authentication/sessions',
    passwords: 'authentication/passwords',
    confirmations: 'authentication/confirmations'
  }

  namespace :admins do
    get 'statistics' => 'statistics#index'
    resources :resumes, only: [:index, :show, :edit, :update] do
      member do
        get :download
        get :pdf_download
      end
    end
    resources :jobs, only: [:index, :show, :edit, :update, :destroy] do
      resources :deliveries, only: [:index, :edit, :update]
    end
    match 'deliveries' => 'deliveries#index', :via => :get, :as => "deliveries"

    resources :money_transfers, only: [:update] do
      collection do
        get :deposits
        get :final_payments
        get :withdraws
      end
    end
    resources :users, only: [:index, :destroy]
    resources :companies, only: [:show]
    resources :refund_requests, only: [:index, :show] do
      member do
        put :agree
        put :refuse
      end
    end
  end

  namespace :recruiters do
    resources :jobs, except: [:destroy]
    resources :companies, only: [:edit, :update]
    resources :resumes, only: [:download] do
      member do
        get :download
      end
    end
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
      collection do
        get :select_list
      end
      member do
        get :download
      end
    end
    resources :watchings, only: [:create]
    resources :deliveries, only: [:index, :new, :create]
  end

  get 'good_job_description' => 'home#good_job_description'
  get 'custom_agreement' => 'home#custom_agreement'
end
