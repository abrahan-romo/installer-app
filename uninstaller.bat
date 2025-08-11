@echo off
chcp 65001 >nul
REM Verificar permisos de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ======================================================
    echo   ERROR: Se requieren permisos de administrador
    echo ======================================================
    echo Este desinstalador necesita ejecutarse como administrador
    echo para eliminar archivos de C:\Program Files
    echo.
    echo Haga clic derecho en uninstall.bat y seleccione:
    echo "Ejecutar como administrador"
    echo.
    pause
    exit /b 1
)
echo ======================================================
echo   InstallerApp v1.0.7-v11 - DESINSTALADOR FINAL
echo   URL GitHub: abrahan-romo/installer-app
echo   Eliminando: C:\Program Files\InstallerApp\TGCS
echo ======================================================
set "INSTALL_DIR=C:\Program Files\InstallerApp\TGCS"
REM Confirmar desinstalacion
echo Esta accion eliminara todos los archivos en:
echo   %INSTALL_DIR%
echo.
set /p CONFIRM="¿Desea continuar? (S/N): "
if /I not "%CONFIRM%"=="S" (
    echo Operacion cancelada.
    exit /b 0
)
REM Eliminar archivos y directorio
echo Eliminando archivos...
del /F /Q "%INSTALL_DIR%\InstallerApp-1.0.7-v11.jar" >nul 2>&1
del /F /Q "%INSTALL_DIR%\run-app.bat" >nul 2>&1
REM Eliminar directorio si esta vacio
rmdir "%INSTALL_DIR%" 2>nul
REM Confirmar eliminacion
echo.
if exist "%INSTALL_DIR%\InstallerApp-1.0.7-v11.jar" (
    echo ERROR: No se pudo eliminar InstallerApp-1.0.7-v11.jar
    pause
    exit /b 1
)
if exist "%INSTALL_DIR%\run-app.bat" (
    echo ERROR: No se pudo eliminar run-app.bat
    pause
    exit /b 1
)
if exist "%INSTALL_DIR%" (
    echo ADVERTENCIA: El directorio %INSTALL_DIR% no esta vacio o no se pudo eliminar.
    pause
    exit /b 1
)
echo ======================================================
echo   DESINSTALACION COMPLETADA EXITOSAMENTE
echo ======================================================
echo Archivos eliminados de: %INSTALL_DIR%
echo URL del repositorio: https://github.com/abrahan-romo/installer-app
echo.
pause
