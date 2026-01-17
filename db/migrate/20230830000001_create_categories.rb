# frozen_string_literal: true

# Migration para criar tabela de categorias
class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string  :name, null: false
      t.text    :description
      t.boolean :active, default: true, null: false
      
      # Self-referencing para subcategorias
      t.references :parent, foreign_key: { to_table: :categories }, index: true

      t.timestamps
    end

    # Índice para busca por nome
    add_index :categories, :name, unique: true
    add_index :categories, :active
  end
end
