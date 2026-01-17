# frozen_string_literal: true

# Seed para popular o banco com dados iniciais
# Execute: rails db:seed

puts '🌱 Iniciando seed do banco de dados...'

# ====================
# Usuários
# ====================
puts '👤 Criando usuários...'

# Admin principal
admin = User.find_or_create_by!(email: 'admin@ecommerce.com') do |u|
  u.name = 'Administrador'
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.profile = :admin
end
puts "   ✓ Admin: #{admin.email}"

# Cliente de teste
client = User.find_or_create_by!(email: 'cliente@teste.com') do |u|
  u.name = 'Cliente Teste'
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.profile = :client
end
puts "   ✓ Cliente: #{client.email}"

# ====================
# Categorias
# ====================
puts '📁 Criando categorias...'

categories = [
  { name: 'Eletrônicos', description: 'Dispositivos eletrônicos e gadgets' },
  { name: 'Roupas', description: 'Vestuário masculino e feminino' },
  { name: 'Livros', description: 'Livros físicos e digitais' },
  { name: 'Casa e Jardim', description: 'Itens para casa e decoração' },
  { name: 'Esportes', description: 'Artigos esportivos e fitness' }
]

created_categories = categories.map do |cat|
  Category.find_or_create_by!(name: cat[:name]) do |c|
    c.description = cat[:description]
    c.active = true
  end
end
puts "   ✓ #{created_categories.count} categorias criadas"

# Subcategorias
eletronicos = created_categories[0]
['Smartphones', 'Notebooks', 'Tablets'].each do |sub|
  Category.find_or_create_by!(name: sub) do |c|
    c.parent = eletronicos
    c.active = true
  end
end

# ====================
# Produtos
# ====================
puts '📦 Criando produtos...'

products_data = [
  { name: 'iPhone 15 Pro', description: 'Smartphone Apple com chip A17 Pro', price: 8999.00, stock: 50, category: 'Eletrônicos', sku: 'IPHONE15PRO' },
  { name: 'MacBook Air M2', description: 'Notebook ultrafino com chip M2', price: 12999.00, stock: 30, category: 'Eletrônicos', sku: 'MACBOOK-M2' },
  { name: 'Camiseta Básica', description: 'Camiseta 100% algodão', price: 49.90, stock: 200, category: 'Roupas', sku: 'CAM-BASIC' },
  { name: 'Calça Jeans Slim', description: 'Calça jeans masculina slim fit', price: 159.90, stock: 100, category: 'Roupas', sku: 'CAL-SLIM' },
  { name: 'Clean Code', description: 'Livro sobre boas práticas de programação', price: 89.90, stock: 75, category: 'Livros', sku: 'BOOK-CLEAN' },
  { name: 'O Programador Pragmático', description: 'Clássico da literatura técnica', price: 79.90, stock: 60, category: 'Livros', sku: 'BOOK-PRAG' },
  { name: 'Luminária LED', description: 'Luminária de mesa com luz ajustável', price: 129.90, stock: 45, category: 'Casa e Jardim', sku: 'LUM-LED' },
  { name: 'Haltere 10kg', description: 'Par de halteres emborrachados', price: 199.90, stock: 80, category: 'Esportes', sku: 'HALT-10KG' },
  { name: 'Tênis Running', description: 'Tênis para corrida com amortecimento', price: 349.90, stock: 65, category: 'Esportes', sku: 'TEN-RUN' },
  { name: 'Kindle Paperwhite', description: 'Leitor digital com tela antirreflexo', price: 599.00, stock: 40, category: 'Eletrônicos', sku: 'KINDLE-PW' }
]

products_data.each do |prod|
  category = Category.find_by(name: prod[:category])
  Product.find_or_create_by!(sku: prod[:sku]) do |p|
    p.name = prod[:name]
    p.description = prod[:description]
    p.price = prod[:price]
    p.stock_quantity = prod[:stock]
    p.category = category
    p.active = true
  end
end
puts "   ✓ #{Product.count} produtos criados"

# ====================
# Pedido de exemplo
# ====================
puts '🛒 Criando pedido de exemplo...'

order = Order.find_or_create_by!(user: client, status: :pending) do |o|
  o.order_items.build(
    product: Product.find_by(sku: 'BOOK-CLEAN'),
    quantity: 1,
    unit_price: 89.90
  )
  o.order_items.build(
    product: Product.find_by(sku: 'CAM-BASIC'),
    quantity: 2,
    unit_price: 49.90
  )
end
order.save! if order.new_record?
puts "   ✓ Pedido ##{order.id} criado (Total: R$ #{order.total})"

puts ''
puts '✅ Seed concluído com sucesso!'
puts ''
puts '📋 Resumo:'
puts "   - Usuários: #{User.count}"
puts "   - Categorias: #{Category.count}"
puts "   - Produtos: #{Product.count}"
puts "   - Pedidos: #{Order.count}"
puts ''
puts '🔐 Credenciais de acesso:'
puts '   Admin:   admin@ecommerce.com / password123'
puts '   Cliente: cliente@teste.com / password123'
