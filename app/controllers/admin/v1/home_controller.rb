# frozen_string_literal: true

module Admin
  module V1
    # Controller inicial do painel admin
    # Retorna informações básicas do dashboard
    class HomeController < ApiController
      # GET /admin/v1/home
      # Retorna mensagem de boas-vindas e stats básicos
      def index
        render json: {
          message: 'Bem-vindo ao painel administrativo!',
          user: current_user.name,
          stats: dashboard_stats
        }
      end

      private

      # Estatísticas básicas do dashboard
      def dashboard_stats
        {
          total_users: User.count,
          total_products: Product.count,
          total_orders: Order.count,
          pending_orders: Order.pending.count
        }
      end
    end
  end
end 