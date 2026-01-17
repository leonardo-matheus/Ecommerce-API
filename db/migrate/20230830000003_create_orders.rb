# frozen_string_literal: true

# Migration para criar tabela de pedidos
class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0, null: false # pending
      t.decimal :total, precision: 10, scale: 2, default: 0

      # Relacionamento com usuário
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end

    # Índices para filtros comuns
    add_index :orders, :status
    add_index :orders, :created_at
  end
end
