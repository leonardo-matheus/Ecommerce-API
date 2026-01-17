# frozen_string_literal: true

module Admin
  module V1
    # Controller base para rotas administrativas
    # Requer autenticação e verifica se usuário é admin
    class ApiController < ApplicationController
      include Authenticable

      before_action :require_admin!

      private

      # Verifica se o usuário autenticado é administrador
      def require_admin!
        return if current_user&.admin?

        render json: { error: 'Acesso não autorizado. Apenas administradores.' }, status: :forbidden
      end
    end
  end
end
