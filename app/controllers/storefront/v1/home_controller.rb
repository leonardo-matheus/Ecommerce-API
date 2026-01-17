# frozen_string_literal: true

module Storefront
  module V1
    # Controller para página inicial da loja
    # Retorna produtos em destaque e categorias
    class HomeController < ApiController
      # Rota pública
      skip_before_action :authenticate_user!

      # GET /storefront/v1/home
      # Retorna dados da página inicial
      def index
        render json: {
          featured_products: featured_products,
          categories: active_categories,
          stats: public_stats
        }
      end

      private

      # Produtos em destaque (mais recentes e em estoque)
      def featured_products
        Product.active
               .in_stock
               .order(created_at: :desc)
               .limit(8)
               .as_json(only: %i[id name description price])
      end

      # Categorias ativas
      def active_categories
        Category.active
                .root_categories
                .limit(10)
                .as_json(only: %i[id name])
      end

      # Estatísticas públicas
      def public_stats
        {
          total_products: Product.active.count,
          total_categories: Category.active.count
        }
      end
    end
  end
end
