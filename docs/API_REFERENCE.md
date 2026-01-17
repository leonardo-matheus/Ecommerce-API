# 📚 Documentação da API

## Visão Geral

Esta é uma API RESTful para e-commerce construída com Ruby on Rails.

## Arquitetura

```
┌──────────────────────────────────────────────────────────────┐
│                         Cliente                              │
│                    (React, Mobile, etc)                      │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                      Rails API (JSON)                        │
│                                                              │
│  ┌─────────────────┐  ┌─────────────────┐                   │
│  │   /auth/v1      │  │   /health       │                   │
│  │   (Devise Auth) │  │   (Health Check)│                   │
│  └─────────────────┘  └─────────────────┘                   │
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                    /admin/v1                            ││
│  │  (Requer autenticação + perfil admin)                   ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────────┐ ││
│  │  │Categories│ │Products  │ │Orders    │ │Users        │ ││
│  │  └──────────┘ └──────────┘ └──────────┘ └─────────────┘ ││
│  └─────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                  /storefront/v1                         ││
│  │  (Público + área do cliente autenticado)                ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────────┐ ││
│  │  │Products  │ │Categories│ │Orders    │ │Profile      │ ││
│  │  │(público) │ │(público) │ │(auth)    │ │(auth)       │ ││
│  │  └──────────┘ └──────────┘ └──────────┘ └─────────────┘ ││
│  └─────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                    SQLite Database                           │
│  ┌──────┐ ┌──────────┐ ┌────────┐ ┌───────┐ ┌────────────┐  │
│  │Users │ │Categories│ │Products│ │Orders │ │Order Items │  │
│  └──────┘ └──────────┘ └────────┘ └───────┘ └────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

## Fluxo de Autenticação

```
1. Cliente envia POST /auth/v1/user/sign_in
   {
     "email": "user@example.com",
     "password": "senha123"
   }

2. Servidor valida credenciais

3. Se válido, retorna headers:
   access-token: xyz123...
   client: abc456...
   uid: user@example.com
   expiry: 1234567890

4. Cliente armazena os headers

5. Em cada requisição autenticada, envia:
   GET /admin/v1/home
   Headers:
     access-token: xyz123...
     client: abc456...
     uid: user@example.com

6. Servidor valida token e processa requisição
```

## Perfis de Usuário

| Perfil | Valor | Acesso |
|--------|-------|--------|
| admin | 0 | Acesso total (/admin/v1 + /storefront/v1) |
| client | 1 | Apenas /storefront/v1 (loja) |

## Hierarquia de Controllers

```
ApplicationController
├── DeviseTokenAuthController (via mount)
│
├── Admin::V1::ApiController (inclui Authenticable + require_admin!)
│   ├── Admin::V1::HomeController
│   ├── Admin::V1::CategoriesController
│   ├── Admin::V1::ProductsController
│   ├── Admin::V1::OrdersController
│   └── Admin::V1::UsersController
│
└── Storefront::V1::ApiController (inclui Authenticable)
    ├── Storefront::V1::HomeController (skip auth)
    ├── Storefront::V1::CategoriesController (skip auth)
    ├── Storefront::V1::ProductsController (skip auth)
    ├── Storefront::V1::OrdersController (requer auth)
    └── Storefront::V1::ProfileController (requer auth)
```

## Modelo de Dados

### Relacionamentos

```
User (1) ────────── (N) Order
                         │
                         │
                         └── (1) ────── (N) OrderItem (N) ────── (1) Product
                                                                      │
                                                                      │
Category (1) ────────────────────────────────────────────────── (N) ──┘
    │
    └── (1) ────── (N) Category (subcategorias)
```

### Tabelas

#### users
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | integer | PK |
| name | string | Nome do usuário |
| email | string | Email único |
| encrypted_password | string | Senha criptografada |
| profile | integer | 0=admin, 1=client |
| tokens | text | Tokens JWT |

#### categories
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | integer | PK |
| name | string | Nome único |
| description | text | Descrição |
| active | boolean | Ativa? |
| parent_id | integer | FK (self-referencing) |

#### products
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | integer | PK |
| name | string | Nome do produto |
| description | text | Descrição |
| price | decimal | Preço |
| stock_quantity | integer | Quantidade em estoque |
| sku | string | SKU único |
| active | boolean | Ativo? |
| category_id | integer | FK para categories |

#### orders
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | integer | PK |
| status | integer | 0-5 (enum) |
| total | decimal | Total calculado |
| user_id | integer | FK para users |

#### order_items
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | integer | PK |
| quantity | integer | Quantidade |
| unit_price | decimal | Preço no momento |
| order_id | integer | FK para orders |
| product_id | integer | FK para products |

## Status de Pedido

```
pending (0) ──► paid (1) ──► processing (2) ──► shipped (3) ──► delivered (4)
     │
     └────────────────────────────────────────────────────────► cancelled (5)
```

## Códigos de Resposta

| Código | Significado |
|--------|-------------|
| 200 | OK - Requisição bem sucedida |
| 201 | Created - Recurso criado |
| 204 | No Content - Deletado com sucesso |
| 400 | Bad Request - Erro na requisição |
| 401 | Unauthorized - Não autenticado |
| 403 | Forbidden - Sem permissão |
| 404 | Not Found - Recurso não encontrado |
| 422 | Unprocessable Entity - Erro de validação |
