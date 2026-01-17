# frozen_string_literal: true

Rails.application.routes.draw do
  # ====================
  # Autenticação (Devise Token Auth)
  # ====================
  # Endpoints: POST /auth/v1/user (signup), POST /auth/v1/user/sign_in (login), etc.
  mount_devise_token_auth_for 'User', at: 'auth/v1/user'

  # ====================
  # Admin API (v1) - Requer autenticação + perfil admin
  # ====================
  namespace :admin do
    namespace :v1 do
      # Dashboard
      get 'home', to: 'home#index'

      # CRUD de recursos
      resources :categories
      resources :products
      resources :users, only: %i[index show update destroy]
      
      # Pedidos (admin pode visualizar todos e alterar status)
      resources :orders, only: %i[index show update] do
        member do
          post :cancel
        end
      end
    end
  end

  # ====================
  # Storefront API (v1) - Loja pública + área do cliente
  # ====================
  namespace :storefront do
    namespace :v1 do
      # Páginas públicas (não requerem login)
      get 'home', to: 'home#index'
      resources :products, only: %i[index show]
      resources :categories, only: %i[index show]

      # Área do cliente (requer login)
      resource :profile, only: %i[show update]
      resources :orders, only: %i[index show create] do
        member do
          post :cancel
        end
      end
    end
  end

  # ====================
  # Health Check
  # ====================
  get 'health', to: proc { [200, {}, ['OK']] }
end


