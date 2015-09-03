Rails.application.routes.draw do

  resources :deliveries
  namespace :recruiters do
    resources :jobs do
    end

    resources :companies do
    end
  end

  namespace :suppliers do
    resources :jobs do
    end
  end

  resources :jobs do
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


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

  resources :resumes do
    collection do
      get 'download'
    end

    member do
      get 'download'
      post 'create_and_deliver'
    end
  end

  namespace :admins do
    resources :resumes, only: [:index, :check_and_update, :edit, :original_resume_download] do
      member do
        put :check_and_update
        get :original_resume_download
      end
    end

    resources :users, only: [:index]
  end

  root :to => 'passthrough#index'

  get 'front_page' => 'front_page#index'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
