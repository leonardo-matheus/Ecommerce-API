# frozen_string_literal: true

# Migration para criar tabela de produtos
class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string  :name, null: false
      t.text    :description
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.integer :stock_quantity, null: false, default: 0
      t.string  :sku
      t.boolean :active, default: true, null: false

      # Relacionamento com categoria
      t.references :category, foreign_key: true, index: true

      t.timestamps
    end

    # Índices para performance
    add_index :products, :name
    add_index :products, :sku, unique: true
    add_index :products, :active
    add_index :products, :stock_quantity
  end
end
