# Crear Instalador v1.0.4-v8 - NUEVA VERSION CON METODO DIVISION
Write-Host "=== Creador de Instalador InstallerApp v1.0.4-v8 ===" -ForegroundColor Green
Write-Host "URL de GitHub actualizada: abrahan-romo/installer-app" -ForegroundColor Yellow

# Variables
$version = "1.0.4-v8"
$installerDir = "target\installer-v$version-TGCS"
$jarFile = "target\InstallerApp-$version.jar"
$zipFile = "target\InstallerApp-$version-Windows-Installer-TGCS.zip"

Write-Host "[DEBUG] Variables inicializadas:"
Write-Host "  version: $version"
Write-Host "  installerDir: $installerDir"
Write-Host "  jarFile: $jarFile"
Write-Host "  zipFile: $zipFile"

if (-not (Test-Path $jarFile)) {
    Write-Host "[ERROR] No se encontro $jarFile" -ForegroundColor Red
    exit 1
} else {
    Write-Host "[DEBUG] JAR encontrado: $jarFile"
}

Write-Host "[1/4] Limpiando directorio..." -ForegroundColor Cyan
if (Test-Path $installerDir) {
    Write-Host "[DEBUG] Eliminando directorio existente: $installerDir"
    Remove-Item -Recurse -Force $installerDir
}
$dirResult = New-Item -ItemType Directory -Path $installerDir -Force -ErrorAction SilentlyContinue
if ($dirResult -eq $null -or -not (Test-Path $installerDir)) {
    Write-Host "[ERROR] No se pudo crear el directorio: $installerDir" -ForegroundColor Red
    exit 1
} else {
    Write-Host "[DEBUG] Directorio creado: $installerDir"
}

Write-Host "[2/4] Copiando archivos..." -ForegroundColor Cyan
try {
    Copy-Item $jarFile "$installerDir\InstallerApp-$version.jar" -ErrorAction Stop
    Write-Host "[DEBUG] Copiado: $jarFile -> $installerDir\InstallerApp-$version.jar"
    Copy-Item "installer-resources\run-app.bat" "$installerDir\" -ErrorAction Stop
    Write-Host "[DEBUG] Copiado: run-app.bat"
    Copy-Item "installer-resources\desinstalar.bat" "$installerDir\" -ErrorAction Stop
    Write-Host "[DEBUG] Copiado: desinstalar.bat"
} catch {
    Write-Host "[ERROR] Error al copiar archivos: $_" -ForegroundColor Red
    exit 1
}

Write-Host "[3/4] Creando archivos del instalador..." -ForegroundColor Cyan

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
echo   InstallerApp v1.0.4-v8 - Instalador FINAL
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
if not exist "%SCRIPT_DIR%InstallerApp-$version.jar" (
    echo ERROR: No se encontro InstallerApp-$version.jar en %SCRIPT_DIR%
    echo Archivos disponibles:
    dir "%SCRIPT_DIR%*.jar" 2>nul
    pause
    exit /b 1
)

copy "%SCRIPT_DIR%InstallerApp-$version.jar" "%INSTALL_DIR%\" >nul 2>&1
if errorlevel 1 (
    echo ERROR: No se pudo copiar InstallerApp-$version.jar
    echo Origen: %SCRIPT_DIR%InstallerApp-$version.jar
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
echo Para ejecutar: java -jar "%INSTALL_DIR%\InstallerApp-$version.jar"
echo.
pause
"@
$installerBat | Out-File -FilePath "$installerDir\instalar.bat" -Encoding ASCII

$leeme = @"
InstallerApp v1.0.4-v8 - NUEVA VERSION CON METODO DIVISION
===============================================================
- NUEVO: Metodo division() agregado a Calculator.java
- Operacion de division (a / b) implementada
- Metodos suma(), resta() y multiplicacion() disponibles
- URL de GitHub: abrahan-romo/installer-app
- Sistema de actualizaciones automaticas FUNCIONAL
- Compatible con directorio TGCS
- Desinstalador completo incluido
- Version del instalador: v8
"@
$leeme | Out-File -FilePath "$installerDir\LEEME.txt" -Encoding UTF8

Write-Host "[4/4] Comprimiendo..." -ForegroundColor Cyan
if (Test-Path $zipFile) {
    Write-Host "[DEBUG] Eliminando ZIP existente: $zipFile"
    Remove-Item $zipFile
}
try {
    Compress-Archive -Path "$installerDir\*" -DestinationPath $zipFile -CompressionLevel Optimal -ErrorAction Stop
    Write-Host "[DEBUG] ZIP creado: $zipFile"
} catch {
    Write-Host "[ERROR] Error al comprimir archivos: $_" -ForegroundColor Red
    exit 1
}

Write-Host "INSTALADOR FINAL GENERADO EXITOSAMENTE!" -ForegroundColor Green
Write-Host "Archivo: $zipFile" -ForegroundColor Yellow
