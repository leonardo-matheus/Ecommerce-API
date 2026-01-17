# frozen_string_literal: true

module Admin
  module V1
    # Controller para gerenciamento de produtos (Admin)
    # CRUD completo com busca e filtros
    class ProductsController < ApiController
      before_action :set_product, only: %i[show update destroy]

      # GET /admin/v1/products
      # Lista produtos com filtros e paginação
      def index
        @products = Product.includes(:category)
        @products = apply_filters(@products)
        @products = @products.order(created_at: :desc)
                             .page(params[:page])
                             .per(params[:per_page] || 20)

        render json: {
          products: @products.as_json(include: :category),
          meta: pagination_meta(@products)
        }
      end

      # GET /admin/v1/products/:id
      # Exibe detalhes de um produto
      def show
        render json: @product.as_json(include: :category)
      end

      # POST /admin/v1/products
      # Cria novo produto
      def create
        @product = Product.new(product_params)

        if @product.save
          render json: @product, status: :created
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /admin/v1/products/:id
      # Atualiza produto existente
      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /admin/v1/products/:id
      # Remove produto (apenas se não tiver pedidos)
      def destroy
        @product.destroy
        head :no_content
      rescue ActiveRecord::DeleteRestrictionError
        render json: { error: 'Não é possível remover produto com pedidos associados' }, status: :unprocessable_entity
      end

      private

      # Define produto pelo ID da URL
      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Produto não encontrado' }, status: :not_found
      end

      # Parâmetros permitidos para criação/atualização
      def product_params
        params.require(:product).permit(
          :name, :description, :price, :stock_quantity,
          :sku, :category_id, :active
        )
      end

      # Aplica filtros à consulta
      def apply_filters(scope)
        scope = scope.by_category(params[:category_id]) if params[:category_id].present?
        scope = scope.search(params[:search]) if params[:search].present?
        scope = scope.active if params[:active] == 'true'
        scope = scope.in_stock if params[:in_stock] == 'true'
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
