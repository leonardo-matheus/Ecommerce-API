# frozen_string_literal: true

# Migration para criar tabela de itens do pedido
class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, precision: 10, scale: 2, null: false

      # Relacionamentos
      t.references :order, null: false, foreign_key: true, index: true
      t.references :product, null: false, foreign_key: true, index: true

      t.timestamps
    end

    # Índice único para evitar duplicatas
    add_index :order_items, %i[order_id product_id], unique: true
  end
end
