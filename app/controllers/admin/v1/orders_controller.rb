# frozen_string_literal: true

module Admin
  module V1
    # Controller para gerenciamento de pedidos (Admin)
    # Listagem, visualização e atualização de status
    class OrdersController < ApiController
      before_action :set_order, only: %i[show update]

      # GET /admin/v1/orders
      # Lista pedidos com filtros e paginação
      def index
        @orders = Order.includes(:user, order_items: :product)
        @orders = apply_filters(@orders)
        @orders = @orders.recent
                         .page(params[:page])
                         .per(params[:per_page] || 20)

        render json: {
          orders: @orders.as_json(include: [:user, { order_items: { include: :product } }]),
          meta: pagination_meta(@orders)
        }
      end

      # GET /admin/v1/orders/:id
      # Exibe detalhes completos de um pedido
      def show
        render json: @order.as_json(
          include: [
            :user,
            { order_items: { include: :product } }
          ]
        )
      end

      # PATCH/PUT /admin/v1/orders/:id
      # Atualiza status do pedido
      def update
        if @order.update(order_params)
          render json: @order
        else
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /admin/v1/orders/:id/cancel
      # Cancela um pedido e restaura estoque
      def cancel
        @order = Order.find(params[:id])
        
        if @order.cancel!
          render json: { message: 'Pedido cancelado com sucesso', order: @order }
        else
          render json: { error: 'Não foi possível cancelar o pedido' }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Pedido não encontrado' }, status: :not_found
      end

      private

      # Define pedido pelo ID da URL
      def set_order
        @order = Order.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Pedido não encontrado' }, status: :not_found
      end

      # Parâmetros permitidos (apenas status pode ser alterado pelo admin)
      def order_params
        params.require(:order).permit(:status)
      end

      # Aplica filtros à consulta
      def apply_filters(scope)
        scope = scope.by_status(params[:status]) if params[:status].present?
        scope = scope.by_user(params[:user_id]) if params[:user_id].present?
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
