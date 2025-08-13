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
    echo Haga clic derecho en install.bat y seleccione:
    echo "Ejecutar como administrador"
    echo.
    pause
    exit /b 1
)

echo ======================================================
echo   InstallerApp v1.0.9-v13 - Instalador FINAL
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
if not exist "%SCRIPT_DIR%InstallerApp-1.0.9-v13.jar" (
    echo ERROR: No se encontro InstallerApp-1.0.9-v13.jar en %SCRIPT_DIR%
    echo Archivos disponibles:
    dir "%SCRIPT_DIR%*.jar" 2>nul
    pause
    exit /b 1
)

copy "%SCRIPT_DIR%InstallerApp-1.0.9-v13.jar" "%INSTALL_DIR%\" >nul 2>&1
if errorlevel 1 (
    echo ERROR: No se pudo copiar InstallerApp-1.0.9-v13.jar
    echo Origen: %SCRIPT_DIR%InstallerApp-1.0.9-v13.jar
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
echo Para ejecutar: java -jar "%INSTALL_DIR%\InstallerApp-1.0.9-v13.jar"
echo.
pause
