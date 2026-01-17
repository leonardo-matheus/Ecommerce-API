# frozen_string_literal: true

module Storefront
  module V1
    # Controller para pedidos do cliente
    # Requer autenticação - cada cliente vê apenas seus pedidos
    class OrdersController < ApiController
      before_action :set_order, only: %i[show cancel]

      # GET /storefront/v1/orders
      # Lista pedidos do usuário logado
      def index
        @orders = current_user.orders
                              .includes(order_items: :product)
                              .recent
                              .page(params[:page])
                              .per(params[:per_page] || 10)

        render json: {
          orders: @orders.as_json(
            only: %i[id status total created_at],
            include: {
              order_items: {
                only: %i[quantity unit_price],
                include: { product: { only: %i[id name] } }
              }
            }
          ),
          meta: pagination_meta(@orders)
        }
      end

      # GET /storefront/v1/orders/:id
      # Exibe detalhes de um pedido específico
      def show
        render json: @order.as_json(
          only: %i[id status total created_at updated_at],
          include: {
            order_items: {
              only: %i[quantity unit_price],
              methods: [:subtotal],
              include: { product: { only: %i[id name description] } }
            }
          }
        )
      end

      # POST /storefront/v1/orders
      # Cria novo pedido
      def create
        @order = current_user.orders.build(status: :pending)
        
        # Processa itens do carrinho
        if add_items_to_order
          if @order.save
            render json: @order.as_json(include: :order_items), status: :created
          else
            render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { errors: @errors }, status: :unprocessable_entity
        end
      end

      # POST /storefront/v1/orders/:id/cancel
      # Cancela pedido (apenas se pending)
      def cancel
        unless @order.pending?
          render json: { error: 'Apenas pedidos pendentes podem ser cancelados' }, status: :unprocessable_entity
          return
        end

        if @order.cancel!
          render json: { message: 'Pedido cancelado com sucesso' }
        else
          render json: { error: 'Erro ao cancelar pedido' }, status: :unprocessable_entity
        end
      end

      private

      # Define pedido do usuário atual
      def set_order
        @order = current_user.orders.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Pedido não encontrado' }, status: :not_found
      end

      # Adiciona itens ao pedido e valida estoque
      def add_items_to_order
        @errors = []
        items = params.require(:items)

        items.each do |item|
          product = Product.active.find_by(id: item[:product_id])
          
          unless product
            @errors << "Produto #{item[:product_id]} não encontrado"
            next
          end

          quantity = item[:quantity].to_i
          
          unless product.stock_quantity >= quantity
            @errors << "Estoque insuficiente para #{product.name}"
            next
          end

          # Reduz estoque
          product.reduce_stock!(quantity)
          
          # Adiciona item ao pedido
          @order.order_items.build(
            product: product,
            quantity: quantity,
            unit_price: product.price
          )
        end

        @errors.empty?
      rescue ActionController::ParameterMissing
        @errors << 'Items são obrigatórios'
        false
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
