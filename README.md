# 🛒 Ecommerce API

API RESTful completa para e-commerce construída com Ruby on Rails.

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Tecnologias](#-tecnologias)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Instalação](#-instalação)
- [Autenticação](#-autenticação)
- [Endpoints](#-endpoints)
- [Exemplos de Uso](#-exemplos-de-uso)
- [Modelos de Dados](#-modelos-de-dados)

---

## 📖 Sobre o Projeto

Esta API fornece funcionalidades completas para um e-commerce, incluindo:

- ✅ **Autenticação JWT** via Devise Token Auth
- ✅ **Gestão de Produtos** com categorias hierárquicas
- ✅ **Gestão de Pedidos** com controle de estoque automático
- ✅ **Área Administrativa** para gerenciamento completo
- ✅ **Área do Cliente (Storefront)** para navegação e compras
- ✅ **Paginação** em todas as listagens

---

## 🛠 Tecnologias

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| Ruby | 3.2.2 | Linguagem de programação |
| Rails | 7.0.x | Framework web (API mode) |
| SQLite3 | 1.6.x | Banco de dados |
| Devise Token Auth | 1.2.x | Autenticação JWT |
| Kaminari | 1.2.x | Paginação |
| Rack CORS | 2.0.x | Cross-Origin Resource Sharing |

---

## 📦 Estrutura do Projeto

```
app/
├── controllers/
│   ├── admin/v1/              # Controllers administrativos
│   │   ├── api_controller.rb      # Base com auth + verificação admin
│   │   ├── categories_controller.rb
│   │   ├── home_controller.rb     # Dashboard
│   │   ├── orders_controller.rb
│   │   ├── products_controller.rb
│   │   └── users_controller.rb
│   ├── storefront/v1/         # Controllers da loja
│   │   ├── api_controller.rb      # Base com auth opcional
│   │   ├── categories_controller.rb
│   │   ├── home_controller.rb     # Página inicial
│   │   ├── orders_controller.rb   # Pedidos do cliente
│   │   ├── products_controller.rb # Catálogo
│   │   └── profile_controller.rb  # Perfil do usuário
│   ├── concerns/
│   │   └── authenticable.rb   # Concern de autenticação
│   └── application_controller.rb
├── models/
│   ├── category.rb            # Categorias (hierárquicas)
│   ├── order.rb               # Pedidos
│   ├── order_item.rb          # Itens do pedido
│   ├── product.rb             # Produtos
│   └── user.rb                # Usuários (admin/client)
config/
├── database.yml               # Configuração SQLite
├── routes.rb                  # Rotas da API
└── initializers/
    ├── cors.rb                # Configuração CORS
    └── devise_token_auth.rb   # Configuração auth
db/
├── migrate/                   # Migrations
├── schema.rb                  # Schema do banco
└── seeds.rb                   # Dados iniciais
```

---

## 🚀 Instalação

### Pré-requisitos

- Ruby 3.2.x
- Bundler
- SQLite3

### Passo a Passo

```bash
# 1. Clonar repositório
git clone <repo-url>
cd Ecommerce-API

# 2. Instalar dependências
bundle install

# 3. Criar banco de dados
rails db:create

# 4. Executar migrations
rails db:migrate

# 5. Popular com dados de exemplo
rails db:seed

# 6. Iniciar servidor
rails server
```

### Docker (Alternativa)

```bash
# Construir imagem
docker build -t ecommerce-api .

# Executar
docker run -p 3000:3000 ecommerce-api
```

---

## 🔐 Autenticação

A API usa **Devise Token Auth** para autenticação baseada em tokens.

### Registro de Usuário

```http
POST /auth/v1/user
Content-Type: application/json

{
  "name": "Seu Nome",
  "email": "email@exemplo.com",
  "password": "senha123",
  "password_confirmation": "senha123"
}
```

### Login

```http
POST /auth/v1/user/sign_in
Content-Type: application/json

{
  "email": "email@exemplo.com",
  "password": "senha123"
}
```

### Headers de Autenticação

Após login, a resposta inclui headers que devem ser enviados em requisições autenticadas:

```
access-token: <token>
client: <client_id>
uid: <email>
```

---

## 📍 Endpoints

### Autenticação (`/auth/v1/user`)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/auth/v1/user` | Registrar usuário |
| `POST` | `/auth/v1/user/sign_in` | Login |
| `DELETE` | `/auth/v1/user/sign_out` | Logout |
| `PUT` | `/auth/v1/user` | Atualizar conta |
| `DELETE` | `/auth/v1/user` | Deletar conta |

### Admin (`/admin/v1`) - Requer Autenticação + Perfil Admin

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/home` | Dashboard com estatísticas |
| `GET` | `/categories` | Listar categorias |
| `POST` | `/categories` | Criar categoria |
| `GET` | `/categories/:id` | Ver categoria |
| `PUT` | `/categories/:id` | Atualizar categoria |
| `DELETE` | `/categories/:id` | Remover categoria |
| `GET` | `/products` | Listar produtos |
| `POST` | `/products` | Criar produto |
| `GET` | `/products/:id` | Ver produto |
| `PUT` | `/products/:id` | Atualizar produto |
| `DELETE` | `/products/:id` | Remover produto |
| `GET` | `/orders` | Listar todos pedidos |
| `GET` | `/orders/:id` | Ver pedido |
| `PUT` | `/orders/:id` | Atualizar status |
| `POST` | `/orders/:id/cancel` | Cancelar pedido |
| `GET` | `/users` | Listar usuários |
| `GET` | `/users/:id` | Ver usuário |
| `PUT` | `/users/:id` | Atualizar usuário |
| `DELETE` | `/users/:id` | Remover usuário |

### Storefront (`/storefront/v1`) - Loja

| Método | Endpoint | Auth | Descrição |
|--------|----------|:----:|-----------|
| `GET` | `/home` | ❌ | Página inicial (destaques) |
| `GET` | `/products` | ❌ | Catálogo de produtos |
| `GET` | `/products/:id` | ❌ | Detalhes do produto |
| `GET` | `/categories` | ❌ | Listar categorias |
| `GET` | `/categories/:id` | ❌ | Categoria com produtos |
| `GET` | `/profile` | ✅ | Ver perfil |
| `PATCH` | `/profile` | ✅ | Atualizar perfil |
| `GET` | `/orders` | ✅ | Meus pedidos |
| `GET` | `/orders/:id` | ✅ | Ver meu pedido |
| `POST` | `/orders` | ✅ | Criar pedido |
| `POST` | `/orders/:id/cancel` | ✅ | Cancelar pedido |

### Utilitários

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/health` | Health check |

---

## 📝 Exemplos de Uso

### Criar Produto (Admin)

```bash
curl -X POST http://localhost:3000/admin/v1/products \
  -H "Content-Type: application/json" \
  -H "access-token: <token>" \
  -H "client: <client>" \
  -H "uid: <email>" \
  -d '{
    "product": {
      "name": "Notebook Gamer",
      "description": "Notebook para jogos com RTX 4060",
      "price": 5999.90,
      "stock_quantity": 25,
      "sku": "NB-GAMER-01",
      "category_id": 1,
      "active": true
    }
  }'
```

### Criar Pedido (Cliente)

```bash
curl -X POST http://localhost:3000/storefront/v1/orders \
  -H "Content-Type: application/json" \
  -H "access-token: <token>" \
  -H "client: <client>" \
  -H "uid: <email>" \
  -d '{
    "items": [
      {"product_id": 1, "quantity": 2},
      {"product_id": 3, "quantity": 1}
    ]
  }'
```

### Buscar Produtos

```bash
# Busca por nome
curl "http://localhost:3000/storefront/v1/products?search=notebook"

# Filtrar por categoria
curl "http://localhost:3000/storefront/v1/products?category_id=1"

# Apenas disponíveis
curl "http://localhost:3000/storefront/v1/products?available=true"
```

---

## 👤 Credenciais de Teste

Após `rails db:seed`:

| Tipo | Email | Senha |
|------|-------|-------|
| **Admin** | admin@ecommerce.com | password123 |
| **Cliente** | cliente@teste.com | password123 |

---

## 🔄 Status de Pedido

| Código | Status | Descrição |
|--------|--------|-----------|
| 0 | `pending` | Aguardando pagamento |
| 1 | `paid` | Pago |
| 2 | `processing` | Em processamento |
| 3 | `shipped` | Enviado |
| 4 | `delivered` | Entregue |
| 5 | `cancelled` | Cancelado |

---

## 🗂 Modelos de Dados

### User (Usuário)

```ruby
# Perfis disponíveis
enum profile: { admin: 0, client: 1 }

# Associações
has_many :orders

# Validações
validates :name, presence: true
validates :email, presence: true, uniqueness: true
```

### Category (Categoria)

```ruby
# Hierarquia
belongs_to :parent, class_name: 'Category', optional: true
has_many :subcategories, class_name: 'Category'
has_many :products

# Scopes
scope :active, -> { where(active: true) }
scope :root_categories, -> { where(parent_id: nil) }
```

### Product (Produto)

```ruby
# Associações
belongs_to :category
has_many :order_items

# Scopes
scope :active, -> { where(active: true) }
scope :in_stock, -> { where('stock_quantity > 0') }
scope :by_category, ->(id) { where(category_id: id) }
scope :search, ->(term) { where('name LIKE ?', "%#{term}%") }

# Métodos
def available?
def reduce_stock!(quantity)
def formatted_price
```

### Order (Pedido)

```ruby
# Status
enum status: { pending: 0, paid: 1, processing: 2, shipped: 3, delivered: 4, cancelled: 5 }

# Associações
belongs_to :user
has_many :order_items
has_many :products, through: :order_items

# Métodos
def calculate_total
def cancel!
```

### OrderItem (Item do Pedido)

```ruby
# Associações
belongs_to :order
belongs_to :product

# Métodos
def subtotal
```

---

## 📄 Licença

Este projeto está sob a licença MIT.

* Deployment instructions

* ...
