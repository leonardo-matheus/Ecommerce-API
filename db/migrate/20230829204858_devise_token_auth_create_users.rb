# frozen_string_literal: true

# Migration para criar tabela de usuários com Devise Token Auth
# Compatível com SQLite
class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table(:users) do |t|
      # Campos obrigatórios do Devise Token Auth
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''

      # Autenticação
      t.string :encrypted_password, null: false, default: ''

      # Recuperação de senha
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean  :allow_password_change, default: false

      # Lembrar sessão
      t.datetime :remember_created_at

      # Confirmação de email (opcional)
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Dados do usuário
      t.string  :name
      t.string  :email
      t.integer :profile, default: 1 # 0: admin, 1: client

      # Tokens de autenticação (armazenados como texto para SQLite)
      t.text :tokens

      t.timestamps
    end

    # Índices para performance
    add_index :users, :email,                unique: true
    add_index :users, %i[uid provider],      unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
  end
end
