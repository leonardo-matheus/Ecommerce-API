# frozen_string_literal: true

module Storefront
  module V1
    # Controller público para listagem de produtos na loja
    # Não requer autenticação
    class ProductsController < ApiController
      # Rotas públicas - não requerem login
      skip_before_action :authenticate_user!

      # GET /storefront/v1/products
      # Lista produtos ativos e disponíveis
      def index
        @products = Product.active
                           .includes(:category)
        
        @products = apply_filters(@products)
        @products = @products.order(created_at: :desc)
                             .page(params[:page])
                             .per(params[:per_page] || 12)

        render json: {
          products: @products.as_json(
            only: %i[id name description price stock_quantity],
            include: { category: { only: %i[id name] } }
          ),
          meta: pagination_meta(@products)
        }
      end

      # GET /storefront/v1/products/:id
      # Exibe detalhes de um produto
      def show
        @product = Product.active.find(params[:id])
        
        render json: @product.as_json(
          only: %i[id name description price stock_quantity sku],
          include: { category: { only: %i[id name] } },
          methods: [:available?, :formatted_price]
        )
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Produto não encontrado' }, status: :not_found
      end

      private

      # Aplica filtros de busca e categoria
      def apply_filters(scope)
        scope = scope.by_category(params[:category_id]) if params[:category_id].present?
        scope = scope.search(params[:search]) if params[:search].present?
        scope = scope.in_stock if params[:available] == 'true'
        scope
      end

      # Metadados de paginação
      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      rescue NoMethodError
        { total_count: collection.size }
      end
    end
  end
end
