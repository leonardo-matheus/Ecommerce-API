# frozen_string_literal: true

# Configuração de CORS para permitir requisições cross-origin
# Necessário para aplicações frontend (React, Vue, etc.)

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Em produção, altere para o domínio específico do frontend
    origins '*'

    resource '*',
             headers: :any,
             expose: %w[access-token expiry token-type uid client], # Headers do Devise Token Auth
             methods: %i[get post put patch delete options head]
  end
end
