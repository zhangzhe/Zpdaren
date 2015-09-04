Rails.application.routes.draw do
  root :to => 'passthrough#index'
  get 'front_page' => 'front_page#index'

  devise_for :recruiters, controllers: {
    sessions: 'authentication/recruiters/sessions',
    registrations: 'authentication/recruiters/registrations',
  }

  devise_for :suppliers, controllers: {
    sessions: 'authentication/suppliers/sessions',
    registrations: 'authentication/suppliers/registrations',
  }

  devise_for :admins, controllers: {
    sessions: 'authentication/admins/sessions',
  }

  namespace :admins do
    resources :resumes, only: [:index, :check_and_update, :edit, :original_resume_download] do
      member do
        put :check_and_update
        get :original_resume_download
      end
    end

    resources :users, only: [:index]
    resources :companies, only: [:index, :show]
    resources :jobs, only: [:index, :show, :edit, :update]
  end

  namespace :recruiters do
    resources :jobs do
      member do
        get :deposit_pay_new
        put :deposit_pay
        put :complete
      end
    end
    resources :companies
    resources :deliveries, only: [:index, :show, :pay] do
      member do
        get :pay
      end
    end
  end

  namespace :suppliers do
    resources :jobs
    resources :resumes, only: [:index]
  end

  resources :deliveries
  resources :jobs

  resources :resumes do
    collection do
      get 'download'
    end

    member do
      get 'download'
      post 'create_and_deliver'
    end
  end
end
