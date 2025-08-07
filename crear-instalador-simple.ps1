# Crear Instalador v1.0.1-v4
Write-Host "=== Creador de Instalador InstallerApp v1.0.1-v4 ===" -ForegroundColor Green

# Variables
$version = "1.0.1-v4"
$installerDir = "target\installer-v$version-TGCS"
$jarFile = "target\InstallerApp-1.0.1.jar"
$zipFile = "target\InstallerApp-$version-Windows-Installer-TGCS.zip"

# Verificar JAR
if (-not (Test-Path $jarFile)) {
    Write-Host "ERROR: No se encontro $jarFile" -ForegroundColor Red
    exit 1
}

Write-Host "[1/4] Limpiando directorio..." -ForegroundColor Cyan
if (Test-Path $installerDir) {
    Remove-Item -Recurse -Force $installerDir
}
New-Item -ItemType Directory -Path $installerDir -Force | Out-Null

Write-Host "[2/4] Copiando archivos..." -ForegroundColor Cyan
Copy-Item $jarFile "$installerDir\InstallerApp-1.0.1.jar"
Copy-Item "installer-resources\run-app.bat" "$installerDir\"

Write-Host "[3/4] Creando archivos del instalador..." -ForegroundColor Cyan

# Crear instalar.bat
$installerBat = @"
@echo off
chcp 65001 >nul
echo InstallerApp v1.0.1-v4 - Instalador

set "INSTALL_DIR=C:\Program Files\InstallerApp\TGCS"
echo Instalando en: %INSTALL_DIR%

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
copy "InstallerApp-1.0.1.jar" "%INSTALL_DIR%\" >nul
copy "run-app.bat" "%INSTALL_DIR%\" >nul

echo Instalacion completada
echo Ejecutar desde: %INSTALL_DIR%\InstallerApp-1.0.1.jar
pause
"@

$installerBat | Out-File -FilePath "$installerDir\instalar.bat" -Encoding ASCII

# Crear LEEME.txt
$leeme = @"
InstallerApp v1.0.1-v4
======================

Nueva version con metodo rest() agregado.

Instalacion:
1. Ejecutar instalar.bat como administrador
2. La aplicacion se instalara en: C:\Program Files\InstallerApp\TGCS

Novedades v1.0.1-v4:
- Metodo rest() agregado para restas
- Sistema de actualizaciones automaticas
- Compatible con GitHub Releases

Para actualizar la URL del repositorio:
- Editar UpdateChecker.java
- Cambiar TU_USUARIO por tu usuario real de GitHub
- El sistema buscara releases en: https://github.com/TU_USUARIO/installer-app

Tag para GitHub Release: v1.0.1
Archivo a subir: InstallerApp-1.0.1-v4-Windows-Installer-TGCS.zip
"@

$leeme | Out-File -FilePath "$installerDir\LEEME.txt" -Encoding UTF8

Write-Host "[4/4] Comprimiendo..." -ForegroundColor Cyan
if (Test-Path $zipFile) {
    Remove-Item $zipFile
}
Compress-Archive -Path "$installerDir\*" -DestinationPath $zipFile -CompressionLevel Optimal

Write-Host ""
Write-Host "Instalador creado exitosamente!" -ForegroundColor Green
Write-Host "Archivo: $zipFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "Contenido:" -ForegroundColor White
Get-ChildItem $installerDir | ForEach-Object {
    Write-Host "  $($_.Name)" -ForegroundColor Gray
}
Write-Host ""
Write-Host "Pasos siguientes:" -ForegroundColor Cyan
Write-Host "1. Subir a GitHub Release con tag: v1.0.1"
Write-Host "2. Actualizar URL en UpdateChecker.java"
Write-Host "3. Crear release con titulo: InstallerApp v1.0.1-v4"
