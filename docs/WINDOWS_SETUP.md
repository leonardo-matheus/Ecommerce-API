# 🔧 Guia de Instalação no Windows

Este guia ajuda a resolver problemas de instalação no Windows.

## Problema: Erro ao compilar gems nativas

Se você encontrar erros como "Permission denied" ou "incompatible pointer type" ao rodar `bundle install`, siga uma das soluções abaixo.

---

## Solução 1: Docker (Recomendado) ⭐

A forma mais simples e confiável de rodar Rails no Windows.

### Pré-requisitos
1. Instale [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Habilite a virtualização na BIOS (se necessário)

### Executar

```powershell
# Na pasta do projeto
docker-compose up
```

A API estará disponível em `http://localhost:3000`

---

## Solução 2: WSL (Windows Subsystem for Linux)

### Instalar WSL

```powershell
# PowerShell como Administrador
wsl --install
```

Reinicie o computador.

### Configurar projeto no WSL

```bash
# Abra o terminal Ubuntu/WSL
cd /mnt/c/Users/Windows/Desktop/Ecommerce-API

# Execute o script de setup
chmod +x setup.sh
./setup.sh

# Inicie o servidor
rails server -b 0.0.0.0
```

A API estará disponível em `http://localhost:3000`

---

## Solução 3: Reinstalar RubyInstaller

1. Baixe [RubyInstaller+DevKit 3.2.x](https://rubyinstaller.org/downloads/)
2. Desinstale a versão atual do Ruby
3. Instale a nova versão marcando "MSYS2 development toolchain"
4. No prompt final, escolha opção 3 para instalar o toolchain
5. Execute:

```powershell
cd C:\Users\Windows\Desktop\Ecommerce-API
bundle install
rails db:create db:migrate db:seed
rails server
```

---

## Solução 4: Reparar MSYS2 (Avançado)

Se o MSYS2 estiver com lock ou corrompido:

1. Feche todas as janelas de terminal
2. Execute como Administrador:

```powershell
# Remover lock do pacman
Remove-Item "C:\Ruby32-x64\msys64\var\lib\pacman\db.lck" -Force

# Abrir MSYS2 diretamente
& "C:\Ruby32-x64\msys64\msys2.exe"
```

3. No terminal MSYS2, execute:

```bash
pacman -Syu
```

4. Feche e abra novamente, depois:

```bash
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
```

5. Volte ao PowerShell e tente novamente:

```powershell
bundle install
```

---

## Verificar Instalação

Para testar se tudo está funcionando:

```powershell
# Versões
ruby --version
rails --version

# Banco de dados
rails db:migrate:status

# Servidor
rails server
```

## Credenciais de Teste

Após `rails db:seed`:

| Tipo | Email | Senha |
|------|-------|-------|
| Admin | admin@ecommerce.com | password123 |
| Cliente | cliente@teste.com | password123 |
