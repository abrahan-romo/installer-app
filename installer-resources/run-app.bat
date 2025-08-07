@echo off
REM Script para ejecutar la aplicacion Java

REM Cambiar al directorio de la aplicacion
cd /d "%~dp0"

REM Verificar que Java este instalado
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Java no esta instalado en este sistema.
    echo Por favor, instala Java desde https://adoptium.net/
    echo.
    pause
    exit /b 1
)

REM Ejecutar la aplicacion
echo Iniciando InstallerApp...
java -jar "InstallerApp-1.0.2.jar"

echo.
echo Aplicacion terminada. Presiona cualquier tecla para cerrar...
pause >nul
