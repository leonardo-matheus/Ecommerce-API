# frozen_string_literal: true

# Controller base da aplicação
# Configura parâmetros permitidos para autenticação Devise
class ApplicationController < ActionController::API
  # Configura parâmetros adicionais permitidos no Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Permite campos adicionais (name) no signup e update de conta
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end
end
