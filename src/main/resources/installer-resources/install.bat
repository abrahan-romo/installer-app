@echo off
setlocal enabledelayedexpansion

title InstallerApp - Instalador v1.0.7-v11
color 0A

echo ========================================
echo    InstallerApp - Instalador v1.0.7-v11
echo ========================================
echo.

REM Definir directorio de instalación
set "INSTALL_DIR=%USERPROFILE%\Desktop\InstallerApp-1.0.7-v11"

echo Creando directorio de instalacion...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

echo Copiando archivos...
copy "InstallerApp-1.0.7-v11.jar" "%INSTALL_DIR%\" >nul

REM Crear script run-app.bat
echo @echo off > "%INSTALL_DIR%\run-app.bat"
echo title InstallerApp v1.0.7-v11 >> "%INSTALL_DIR%\run-app.bat"
echo color 0A >> "%INSTALL_DIR%\run-app.bat"
echo echo ======================================== >> "%INSTALL_DIR%\run-app.bat"
echo echo     InstallerApp v1.0.7-v11 >> "%INSTALL_DIR%\run-app.bat"
echo echo ======================================== >> "%INSTALL_DIR%\run-app.bat"
echo echo. >> "%INSTALL_DIR%\run-app.bat"
echo REM Verificar Java >> "%INSTALL_DIR%\run-app.bat"
echo java -version ^>nul 2^>^&1 >> "%INSTALL_DIR%\run-app.bat"
echo if %%errorlevel%% neq 0 ( >> "%INSTALL_DIR%\run-app.bat"
echo     echo Error: Java no esta instalado en este sistema. >> "%INSTALL_DIR%\run-app.bat"
echo     echo Por favor, instala Java desde https://adoptium.net/ >> "%INSTALL_DIR%\run-app.bat"
echo     echo. >> "%INSTALL_DIR%\run-app.bat"
echo     pause >> "%INSTALL_DIR%\run-app.bat"
echo     call exit /b 1 >> "%INSTALL_DIR%\run-app.bat"
echo ) >> "%INSTALL_DIR%\run-app.bat"
echo. >> "%INSTALL_DIR%\run-app.bat"
echo REM Ejecutar la aplicacion >> "%INSTALL_DIR%\run-app.bat"
echo echo Iniciando InstallerApp v1.0.7-v11... >> "%INSTALL_DIR%\run-app.bat"
echo java -jar "InstallerApp-1.0.7-v11.jar" >> "%INSTALL_DIR%\run-app.bat"
echo. >> "%INSTALL_DIR%\run-app.bat"
echo echo Aplicacion terminada. Presiona cualquier tecla para cerrar... >> "%INSTALL_DIR%\run-app.bat"
echo pause ^>nul >> "%INSTALL_DIR%\run-app.bat"

echo.
echo ========================================
echo  Instalacion completada exitosamente!
echo ========================================
echo.
echo Ubicacion: %INSTALL_DIR%
echo.
echo Para ejecutar la aplicacion:
echo - Navega a: %INSTALL_DIR%
echo - Ejecuta: run-app.bat
echo.
pause
