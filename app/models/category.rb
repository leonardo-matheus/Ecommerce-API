# frozen_string_literal: true

# Model de Categoria para organização de produtos
# Suporta hierarquia com categorias pai/filho
class Category < ApplicationRecord
  # Associações
  has_many :products, dependent: :nullify
  
  # Self-referencing para subcategorias
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: :parent_id, dependent: :destroy

  # Validações
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true

  # Scopes para consultas comuns
  scope :active, -> { where(active: true) }
  scope :root_categories, -> { where(parent_id: nil) }

  # Verifica se é categoria raiz (sem pai)
  def root?
    parent_id.nil?
  end
end
