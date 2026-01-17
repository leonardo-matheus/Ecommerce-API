# frozen_string_literal: true

# Este arquivo é gerado automaticamente. NÃO EDITE MANUALMENTE.
# Use as migrations para modificar o schema.
#
# Compatível com SQLite3

ActiveRecord::Schema.define(version: 2023_08_30_000004) do
  # Tabela de Usuários (Devise Token Auth)
  create_table 'users', force: :cascade do |t|
    t.string 'provider', null: false, default: 'email'
    t.string 'uid', null: false, default: ''
    t.string 'encrypted_password', null: false, default: ''
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.boolean 'allow_password_change', default: false
    t.datetime 'remember_created_at'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.string 'name'
    t.string 'email'
    t.integer 'profile', default: 1
    t.text 'tokens'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index %w[uid provider], name: 'index_users_on_uid_and_provider', unique: true
  end

  # Tabela de Categorias
  create_table 'categories', force: :cascade do |t|
    t.string 'name', null: false
    t.text 'description'
    t.boolean 'active', default: true, null: false
    t.integer 'parent_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['active'], name: 'index_categories_on_active'
    t.index ['name'], name: 'index_categories_on_name', unique: true
    t.index ['parent_id'], name: 'index_categories_on_parent_id'
  end

  # Tabela de Produtos
  create_table 'products', force: :cascade do |t|
    t.string 'name', null: false
    t.text 'description'
    t.decimal 'price', precision: 10, scale: 2, null: false, default: 0
    t.integer 'stock_quantity', null: false, default: 0
    t.string 'sku'
    t.boolean 'active', default: true, null: false
    t.integer 'category_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['active'], name: 'index_products_on_active'
    t.index ['category_id'], name: 'index_products_on_category_id'
    t.index ['name'], name: 'index_products_on_name'
    t.index ['sku'], name: 'index_products_on_sku', unique: true
    t.index ['stock_quantity'], name: 'index_products_on_stock_quantity'
  end

  # Tabela de Pedidos
  create_table 'orders', force: :cascade do |t|
    t.integer 'status', default: 0, null: false
    t.decimal 'total', precision: 10, scale: 2, default: 0
    t.integer 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['created_at'], name: 'index_orders_on_created_at'
    t.index ['status'], name: 'index_orders_on_status'
    t.index ['user_id'], name: 'index_orders_on_user_id'
  end

  # Tabela de Itens do Pedido
  create_table 'order_items', force: :cascade do |t|
    t.integer 'quantity', null: false, default: 1
    t.decimal 'unit_price', precision: 10, scale: 2, null: false
    t.integer 'order_id', null: false
    t.integer 'product_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[order_id product_id], name: 'index_order_items_on_order_id_and_product_id', unique: true
    t.index ['order_id'], name: 'index_order_items_on_order_id'
    t.index ['product_id'], name: 'index_order_items_on_product_id'
  end

  # Foreign Keys
  add_foreign_key 'categories', 'categories', column: 'parent_id'
  add_foreign_key 'order_items', 'orders'
  add_foreign_key 'order_items', 'products'
  add_foreign_key 'orders', 'users'
  add_foreign_key 'products', 'categories'
end
