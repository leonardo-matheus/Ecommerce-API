# frozen_string_literal: true

# Model de Produto - Item principal do e-commerce
class Product < ApplicationRecord
  # Associações
  belongs_to :category, optional: true
  has_many :order_items, dependent: :restrict_with_error
  has_many :orders, through: :order_items

  # Validações
  validates :name, presence: true, length: { minimum: 2, maximum: 200 }
  validates :description, length: { maximum: 2000 }, allow_blank: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: true, allow_blank: true

  # Scopes úteis
  scope :active, -> { where(active: true) }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :out_of_stock, -> { where(stock_quantity: 0) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :search, ->(term) { where('name LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%") }

  # Verifica disponibilidade do produto
  def available?
    active? && stock_quantity.positive?
  end

  # Reduz estoque após venda
  def reduce_stock!(quantity)
    raise 'Estoque insuficiente' if stock_quantity < quantity

    decrement!(:stock_quantity, quantity)
  end

  # Formata preço em reais
  def formatted_price
    "R$ #{format('%.2f', price)}"
  end
end
