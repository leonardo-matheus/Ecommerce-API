# Dockerfile para Ecommerce API Rails
# Uso: docker build -t ecommerce-api . && docker run -p 3000:3000 ecommerce-api

FROM ruby:3.2.2-slim

# Instalar dependências do sistema
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libsqlite3-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /app

# Copiar Gemfile primeiro (cache de dependências)
COPY Gemfile Gemfile.lock* ./

# Instalar gems
RUN bundle install --jobs 4 --retry 3

# Copiar código da aplicação
COPY . .

# Criar banco de dados e executar migrations
RUN rails db:create db:migrate db:seed

# Expor porta
EXPOSE 3000

# Comando para iniciar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]
