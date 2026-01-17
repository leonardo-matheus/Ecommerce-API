# frozen_string_literal: true

module Storefront
  module V1
    # Controller público para listagem de categorias
    # Não requer autenticação
    class CategoriesController < ApiController
      # Rotas públicas
      skip_before_action :authenticate_user!

      # GET /storefront/v1/categories
      # Lista categorias ativas
      def index
        @categories = Category.active
                              .includes(:subcategories)
                              .root_categories
                              .order(:name)

        render json: @categories.as_json(
          only: %i[id name description],
          include: { subcategories: { only: %i[id name] } }
        )
      end

      # GET /storefront/v1/categories/:id
      # Exibe categoria com seus produtos
      def show
        @category = Category.active.find(params[:id])
        
        render json: @category.as_json(
          only: %i[id name description],
          include: {
            subcategories: { only: %i[id name] },
            products: {
              only: %i[id name description price stock_quantity],
              conditions: { active: true }
            }
          }
        )
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Categoria não encontrada' }, status: :not_found
      end
    end
  end
end
