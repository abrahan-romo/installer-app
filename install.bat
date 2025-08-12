@echo off
title InstallerApp - Sistema de Instalacion
color 0A

echo ========================================
echo    InstallerApp - TGCS Installation
echo ========================================
echo.
echo Instalando InstallerApp v1.0.7-v11...
echo.

REM Verificar que Java este instalado
java -version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java no esta instalado en este sistema.
    echo Por favor, instala Java desde https://adoptium.net/
    echo.
    pause
    exit /b 1
)

REM Crear directorio de instalacion
set "INSTALL_DIR=C:\Program Files\InstallerApp\TGCS"
if not exist "%INSTALL_DIR%" (
    echo Creando directorio de instalacion...
    mkdir "%INSTALL_DIR%" 2>nul
    if errorlevel 1 (
        echo ERROR: No se pudo crear el directorio de instalacion.
        echo Es posible que necesite ejecutar como administrador.
        echo.
        pause
        exit /b 1
    )
)

REM Copiar JAR principal
echo Copiando archivos de aplicacion...
copy /Y "InstallerApp-1.0.7-v11.jar" "%INSTALL_DIR%\" >nul
if errorlevel 1 (
    echo ERROR: No se pudo copiar el archivo principal.
    echo Verifique permisos de escritura.
    echo.
    pause
    exit /b 1
)

REM Crear script de ejecucion
echo @echo off > "%INSTALL_DIR%\run-app.bat"
echo REM Script para ejecutar la aplicacion Java >> "%INSTALL_DIR%\run-app.bat"
echo. >> "%INSTALL_DIR%\run-app.bat"
echo REM Cambiar al directorio de la aplicacion >> "%INSTALL_DIR%\run-app.bat"
echo cd /d "%%~dp0" >> "%INSTALL_DIR%\run-app.bat"
echo. >> "%INSTALL_DIR%\run-app.bat"
echo REM Verificar que Java este instalado >> "%INSTALL_DIR%\run-app.bat"
echo java -version ^>nul 2^>^&1 >> "%INSTALL_DIR%\run-app.bat"
echo if %%errorlevel%% neq 0 ( >> "%INSTALL_DIR%\run-app.bat"
echo     echo Error: Java no esta instalado en este sistema. >> "%INSTALL_DIR%\run-app.bat"
echo     echo Por favor, instala Java desde https://adoptium.net/ >> "%INSTALL_DIR%\run-app.bat"
echo     echo. >> "%INSTALL_DIR%\run-app.bat"
echo     pause >> "%INSTALL_DIR%\run-app.bat"
echo     exit /b 1 >> "%INSTALL_DIR%\run-app.bat"
echo ) >> "%INSTALL_DIR%\run-app.bat"
echo. >> "%INSTALL_DIR%\run-app.bat"
echo REM Ejecutar la aplicacion >> "%INSTALL_DIR%\run-app.bat"
echo echo Iniciando InstallerApp v1.0.7-v11... >> "%INSTALL_DIR%\run-app.bat"
echo java -jar "InstallerApp-1.0.7-v11.jar" >> "%INSTALL_DIR%\run-app.bat"
echo. >> "%INSTALL_DIR%\run-app.bat"
echo echo Aplicacion terminada. Presiona cualquier tecla para cerrar... >> "%INSTALL_DIR%\run-app.bat"
echo pause ^>nul >> "%INSTALL_DIR%\run-app.bat"

REM Crear acceso directo en el escritorio (opcional)
echo Instalacion completada!
echo.
echo Ubicacion: %INSTALL_DIR%
echo Para ejecutar: Ejecute run-app.bat en el directorio de instalacion
echo.
echo ========================================
echo   Instalacion exitosa!
echo ========================================
echo.
pause
