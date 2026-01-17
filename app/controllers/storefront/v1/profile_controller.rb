# frozen_string_literal: true

module Storefront
  module V1
    # Controller para perfil do usuário logado
    # Permite visualizar e atualizar dados pessoais
    class ProfileController < ApiController
      # GET /storefront/v1/profile
      # Retorna dados do usuário logado
      def show
        render json: current_user.as_json(
          only: %i[id name email profile created_at],
          include: {
            orders: {
              only: %i[id status total created_at],
              limit: 5
            }
          }
        )
      end

      # PATCH /storefront/v1/profile
      # Atualiza dados do perfil
      def update
        if current_user.update(profile_params)
          render json: current_user.as_json(only: %i[id name email])
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # Parâmetros permitidos para atualização de perfil
      def profile_params
        params.permit(:name)
      end
    end
  end
end
