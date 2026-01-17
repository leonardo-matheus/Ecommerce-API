# frozen_string_literal: true

module Storefront
  module V1
    # Controller base para rotas do storefront (loja)
    # Algumas rotas são públicas, outras requerem autenticação
    class ApiController < ApplicationController
      include Authenticable

      # Permite acesso público a algumas actions (definir nos controllers filhos)
      skip_before_action :authenticate_user!, only: [], raise: false
    end
  end
end
