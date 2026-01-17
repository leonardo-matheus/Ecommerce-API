# frozen_string_literal: true

# Model de usuário com autenticação via Devise Token Auth
# Suporta dois perfis: admin e client
class User < ApplicationRecord
  # Módulos Devise para autenticação
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Token Auth concern para APIs
  include DeviseTokenAuth::Concerns::User

  # Enum para tipos de perfil de usuário
  enum profile: { admin: 0, client: 1 }

  # Associações - Usuário pode ter pedidos e produtos (se admin)
  has_many :orders, dependent: :destroy

  # Validações
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :profile, presence: true

  # Callback para definir perfil padrão
  after_initialize :set_default_profile, if: :new_record?

  private

  # Define perfil client como padrão para novos usuários
  def set_default_profile
    self.profile ||= :client
  end
end
