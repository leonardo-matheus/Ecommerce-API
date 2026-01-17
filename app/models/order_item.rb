# frozen_string_literal: true

# Model de Item do Pedido - Relacionamento entre Order e Product
class OrderItem < ApplicationRecord
  # Associações
  belongs_to :order
  belongs_to :product

  # Validações
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_id, uniqueness: { scope: :order_id, message: 'já está no pedido' }

  # Callbacks
  before_validation :set_unit_price, on: :create

  # Calcula subtotal do item
  def subtotal
    quantity * unit_price
  end

  private

  # Define preço unitário baseado no produto
  def set_unit_price
    self.unit_price = product&.price if unit_price.blank? && product.present?
  end
end
