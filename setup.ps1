# Script de setup para Windows (PowerShell)
# Execute como Administrador

Write-Host "🚀 Ecommerce API - Setup para Windows" -ForegroundColor Cyan
Write-Host ""

# Opção 1: Docker (Recomendado)
Write-Host "📋 OPÇÃO 1: Docker (Recomendado)" -ForegroundColor Green
Write-Host "   1. Instale Docker Desktop: https://www.docker.com/products/docker-desktop"
Write-Host "   2. Execute: docker-compose up"
Write-Host "   3. Acesse: http://localhost:3000"
Write-Host ""

# Opção 2: WSL
Write-Host "📋 OPÇÃO 2: WSL (Windows Subsystem for Linux)" -ForegroundColor Green
Write-Host "   1. Habilite WSL: wsl --install"
Write-Host "   2. Abra Ubuntu e navegue até o projeto"
Write-Host "   3. Execute: chmod +x setup.sh && ./setup.sh"
Write-Host "   4. Execute: rails server"
Write-Host ""

# Verificar se WSL está disponível
Write-Host "🔍 Verificando WSL..." -ForegroundColor Yellow
try {
    $wslStatus = wsl --list --verbose 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ WSL está instalado" -ForegroundColor Green
        Write-Host "   Distribuições disponíveis:"
        wsl --list
        Write-Host ""
        Write-Host "   Para rodar o projeto via WSL:" -ForegroundColor Cyan
        Write-Host "   wsl -d Ubuntu"
        Write-Host "   cd /mnt/c/Users/Windows/Desktop/Ecommerce-API"
        Write-Host "   ./setup.sh"
    }
} catch {
    Write-Host "❌ WSL não está disponível" -ForegroundColor Red
    Write-Host "   Instale com: wsl --install" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📖 Para mais informações, consulte o README.md" -ForegroundColor Gray
