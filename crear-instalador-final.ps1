# Crear Instalador v1.0.2-v6 - NUEVA VERSION CON METODO RESTA
Write-Host "if not exist "%SCRIPT_DIR%InstallerApp-1.0.2.jar" (
    echo ERROR: No se encontro InstallerApp-1.0.2.jar en %SCRIPT_DIR%
    echo Archivos disponibles:
    dir "%SCRIPT_DIR%*.jar" 2>nul
    pause
    exit /b 1
)

copy "%SCRIPT_DIR%InstallerApp-1.0.2.jar" "%INSTALL_DIR%\" >nul 2>&1
if errorlevel 1 (
    echo ERROR: No se pudo copiar InstallerApp-1.0.2.jar
    echo Origen: %SCRIPT_DIR%InstallerApp-1.0.2.jarde Instalador InstallerApp v1.0.2-v6 ===" -ForegroundColor Green
Write-Host "URL de GitHub actualizada: abrahan-romo/installer-app" -ForegroundColor Yellow

# Variables
$version = "1.0.2-v6"
$installerDir = "target\installer-v$version-TGCS"
$jarFile = "target\InstallerApp-1.0.2.jar"
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
Copy-Item $jarFile "$installerDir\InstallerApp-1.0.2.jar"
Copy-Item "installer-resources\run-app.bat" "$installerDir\"
Copy-Item "installer-resources\desinstalar.bat" "$installerDir\"

Write-Host "[3/4] Creando archivos del instalador..." -ForegroundColor Cyan

# Crear instalar.bat
$installerBat = @"
@echo off
chcp 65001 >nul

REM Verificar permisos de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ======================================================
    echo   ERROR: Se requieren permisos de administrador
    echo ======================================================
    echo Este instalador necesita ejecutarse como administrador
    echo para instalar en C:\Program Files
    echo.
    echo Haga clic derecho en instalar.bat y seleccione:
    echo "Ejecutar como administrador"
    echo.
    pause
    exit /b 1
)

echo ======================================================
echo   InstallerApp v1.0.2-v6 - Instalador FINAL
echo   URL GitHub: abrahan-romo/installer-app
echo   Instalacion en: C:\Program Files\InstallerApp\TGCS
echo ======================================================

set "INSTALL_DIR=C:\Program Files\InstallerApp\TGCS"
echo Instalando en: %INSTALL_DIR%

REM Crear directorios con manejo de errores
echo Creando directorios...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" 2>nul
    if errorlevel 1 (
        echo ERROR: No se pudo crear el directorio %INSTALL_DIR%
        pause
        exit /b 1
    )
)

REM Obtener directorio del script
set "SCRIPT_DIR=%~dp0"

REM Copiar archivos con verificacion y ruta absoluta
echo Copiando archivos...
if not exist "%SCRIPT_DIR%InstallerApp-1.0.1.jar" (
    echo ERROR: No se encontro InstallerApp-1.0.1.jar en %SCRIPT_DIR%
    echo Archivos disponibles:
    dir "%SCRIPT_DIR%*.jar" 2>nul
    pause
    exit /b 1
)

copy "%SCRIPT_DIR%InstallerApp-1.0.1.jar" "%INSTALL_DIR%\" >nul 2>&1
if errorlevel 1 (
    echo ERROR: No se pudo copiar InstallerApp-1.0.1.jar
    echo Origen: %SCRIPT_DIR%InstallerApp-1.0.1.jar
    echo Destino: %INSTALL_DIR%\
    pause
    exit /b 1
)

copy "%SCRIPT_DIR%run-app.bat" "%INSTALL_DIR%\" >nul 2>&1
if errorlevel 1 (
    echo ERROR: No se pudo copiar run-app.bat
    echo Origen: %SCRIPT_DIR%run-app.bat
    echo Destino: %INSTALL_DIR%\
    pause
    exit /b 1
)

echo.
echo ======================================================
echo   INSTALACION COMPLETADA EXITOSAMENTE
echo ======================================================
echo Ubicacion: %INSTALL_DIR%
echo URL del repositorio: https://github.com/abrahan-romo/installer-app
echo Sistema de actualizaciones: CONFIGURADO
echo.
echo Para ejecutar: java -jar "%INSTALL_DIR%\InstallerApp-1.0.2.jar"
echo.
pause
"@

$installerBat | Out-File -FilePath "$installerDir\instalar.bat" -Encoding ASCII

# Crear LEEME.txt
$leeme = @"
InstallerApp v1.0.2-v6 - NUEVA VERSION CON METODO RESTA
======================================================

*** URL DE GITHUB CORREGIDA ***
Repositorio: https://github.com/abrahan-romo/installer-app

INSTALACION:
1. Ejecutar instalar.bat como administrador
2. La aplicacion se instalara en: C:\Program Files\InstallerApp\TGCS

DESINSTALACION:
1. Ejecutar desinstalar.bat como administrador
2. Eliminara completamente InstallerApp del sistema
3. Incluye limpieza de enlaces y archivos temporales

NOVEDADES v1.0.2-v6:
- NUEVO: Metodo resta() agregado a Calculator.java
- Operacion de resta (a - b) implementada
- URL de GitHub corregida: abrahan-romo/installer-app
- Sistema de actualizaciones automaticas FUNCIONAL
- Compatible con directorio TGCS
- Desinstalador completo incluido

SISTEMA DE ACTUALIZACIONES:
- Conecta automaticamente a: https://github.com/abrahan-romo/installer-app
- Busca releases con formato: v1.0.3, v1.0.4, etc.
- Descarga automaticamente nuevas versiones
- Instala y reinicia la aplicacion

PARA CREAR SIGUIENTE VERSION:
1. Subir este instalador como Release v1.0.2
2. Para la siguiente version (v1.0.3):
   - Crear nuevo release con tag: v1.0.3
   - Subir: InstallerApp-1.0.3-v7-Windows-Installer-TGCS.zip
   - El sistema detectara automaticamente la actualizacion

REPOSITORIO GITHUB:
- URL: https://github.com/abrahan-romo/installer-app
- API: https://api.github.com/repos/abrahan-romo/installer-app/releases/latest
- Tag para este release: v1.0.2
- Archivo para subir: InstallerApp-1.0.2-v6-Windows-Installer-TGCS.zip

REQUISITOS:
- Windows 7/8/10/11
- Java 8 o superior
- Conexion a internet (para actualizaciones)

VERSION FINAL LISTA PARA PRODUCCION!
====================================
"@

$leeme | Out-File -FilePath "$installerDir\LEEME.txt" -Encoding UTF8

Write-Host "[4/4] Comprimiendo..." -ForegroundColor Cyan
if (Test-Path $zipFile) {
    Remove-Item $zipFile
}
Compress-Archive -Path "$installerDir\*" -DestinationPath $zipFile -CompressionLevel Optimal

Write-Host ""
Write-Host "INSTALADOR FINAL GENERADO EXITOSAMENTE!" -ForegroundColor Green
Write-Host "Archivo: $zipFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "URL GitHub configurada:" -ForegroundColor Cyan
Write-Host "  https://github.com/abrahan-romo/installer-app" -ForegroundColor White
Write-Host ""
Write-Host "Contenido:" -ForegroundColor White
Get-ChildItem $installerDir | ForEach-Object {
    Write-Host "  $($_.Name)" -ForegroundColor Gray
}
Write-Host ""
Write-Host "PASOS FINALES:" -ForegroundColor Yellow
Write-Host "1. Subir a GitHub Release con tag: v1.0.2"
Write-Host "2. Titulo: InstallerApp v1.0.2-v6 - Nueva Version con Metodo Resta"
Write-Host "3. Archivo: InstallerApp-1.0.2-v6-Windows-Installer-TGCS.zip"
Write-Host "4. Probar actualizaciones automaticas!"
Write-Host ""
Write-Host "VERSION FINAL LISTA!" -ForegroundColor Green
