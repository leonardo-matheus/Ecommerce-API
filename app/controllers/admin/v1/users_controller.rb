# frozen_string_literal: true

module Admin
  module V1
    # Controller para gerenciamento de usuários (Admin)
    # Listagem e atualização de perfis
    class UsersController < ApiController
      before_action :set_user, only: %i[show update destroy]

      # GET /admin/v1/users
      # Lista todos os usuários
      def index
        @users = User.order(:name)
                     .page(params[:page])
                     .per(params[:per_page] || 20)

        # Aplica filtro por perfil se especificado
        @users = @users.where(profile: params[:profile]) if params[:profile].present?

        render json: {
          users: @users.as_json(except: %i[encrypted_password tokens]),
          meta: pagination_meta(@users)
        }
      end

      # GET /admin/v1/users/:id
      # Exibe detalhes de um usuário
      def show
        render json: @user.as_json(
          except: %i[encrypted_password tokens],
          include: { orders: { only: %i[id status total created_at] } }
        )
      end

      # PATCH/PUT /admin/v1/users/:id
      # Atualiza perfil do usuário
      def update
        if @user.update(user_params)
          render json: @user.as_json(except: %i[encrypted_password tokens])
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /admin/v1/users/:id
      # Remove usuário (apenas se não for o próprio admin logado)
      def destroy
        if @user == current_user
          render json: { error: 'Não é possível remover seu próprio usuário' }, status: :unprocessable_entity
          return
        end

        @user.destroy
        head :no_content
      end

      private

      # Define usuário pelo ID da URL
      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Usuário não encontrado' }, status: :not_found
      end

      # Parâmetros permitidos (admin pode alterar perfil)
      def user_params
        params.require(:user).permit(:name, :profile)
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
