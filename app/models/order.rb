# frozen_string_literal: true

# Model de Pedido - Representa uma compra do usuário
class Order < ApplicationRecord
  # Associações
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Aceita atributos aninhados para itens do pedido
  accepts_nested_attributes_for :order_items, allow_destroy: true

  # Enum para status do pedido
  enum status: {
    pending: 0,      # Aguardando pagamento
    paid: 1,         # Pago
    processing: 2,   # Em processamento
    shipped: 3,      # Enviado
    delivered: 4,    # Entregue
    cancelled: 5     # Cancelado
  }

  # Validações
  validates :status, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }

  # Callbacks
  before_save :calculate_total

  # Calcula total do pedido baseado nos itens
  def calculate_total
    self.total = order_items.sum { |item| item.quantity * item.unit_price }
  end

  # Marca pedido como cancelado e restaura estoque
  def cancel!
    return false if cancelled? || delivered?

    transaction do
      order_items.each do |item|
        item.product.increment!(:stock_quantity, item.quantity)
      end
      cancelled!
    end
    true
  end
end
