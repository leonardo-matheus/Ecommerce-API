#!/bin/bash
# Script de setup para WSL/Linux
# Execute: chmod +x setup.sh && ./setup.sh

set -e

echo "🚀 Iniciando setup da Ecommerce API..."

# Verifica Ruby
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby não encontrado. Instalando via rbenv..."
    
    # Instalar dependências
    sudo apt-get update
    sudo apt-get install -y git curl libssl-dev libreadline-dev zlib1g-dev \
        autoconf bison build-essential libyaml-dev libreadline-dev \
        libncurses5-dev libffi-dev libgdbm-dev libsqlite3-dev sqlite3
    
    # Instalar rbenv
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    
    # Instalar ruby-build
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    
    # Recarregar shell
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    
    # Instalar Ruby 3.2.2
    rbenv install 3.2.2
    rbenv global 3.2.2
fi

echo "✅ Ruby $(ruby --version)"

# Instalar bundler
gem install bundler

# Instalar dependências
echo "📦 Instalando gems..."
bundle install

# Configurar banco de dados
echo "🗄️ Configurando banco de dados..."
rails db:create
rails db:migrate
rails db:seed

echo ""
echo "✅ Setup concluído!"
echo ""
echo "🔐 Credenciais de teste:"
echo "   Admin:   admin@ecommerce.com / password123"
echo "   Cliente: cliente@teste.com / password123"
echo ""
echo "🚀 Para iniciar o servidor:"
echo "   rails server"
echo ""
echo "📍 API disponível em: http://localhost:3000"
