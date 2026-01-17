# frozen_string_literal: true

module Admin
  module V1
    # Controller para gerenciamento de categorias (Admin)
    # CRUD completo com validações e tratamento de erros
    class CategoriesController < ApiController
      before_action :set_category, only: %i[show update destroy]

      # GET /admin/v1/categories
      # Lista todas as categorias com paginação
      def index
        @categories = Category.includes(:parent)
                              .order(:name)
                              .page(params[:page])
                              .per(params[:per_page] || 20)

        render json: {
          categories: @categories,
          meta: pagination_meta(@categories)
        }
      end

      # GET /admin/v1/categories/:id
      # Exibe detalhes de uma categoria
      def show
        render json: @category.as_json(include: :subcategories)
      end

      # POST /admin/v1/categories
      # Cria nova categoria
      def create
        @category = Category.new(category_params)

        if @category.save
          render json: @category, status: :created
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /admin/v1/categories/:id
      # Atualiza categoria existente
      def update
        if @category.update(category_params)
          render json: @category
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /admin/v1/categories/:id
      # Remove categoria
      def destroy
        @category.destroy
        head :no_content
      rescue ActiveRecord::RecordNotDestroyed => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      # Define categoria pelo ID da URL
      def set_category
        @category = Category.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Categoria não encontrada' }, status: :not_found
      end

      # Parâmetros permitidos para criação/atualização
      def category_params
        params.require(:category).permit(:name, :description, :active, :parent_id)
      end

      # Metadados de paginação
      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      rescue NoMethodError
        # Fallback se kaminari não estiver disponível
        { total_count: collection.size }
      end
    end
  end
end
