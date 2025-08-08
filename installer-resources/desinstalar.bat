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
    echo Haga clic derecho en desinstalar.bat y seleccione:
    echo "Ejecutar como administrador"
    echo.
    pause
    exit /b 1
)

echo ======================================================
echo   InstallerApp v1.0.3-v7 - Desinstalador
echo   URL GitHub: abrahan-romo/installer-app
echo ======================================================
echo.
echo Esta accion eliminara completamente InstallerApp
echo de su sistema, incluyendo:
echo.
echo - Archivos del programa en C:\Program Files\InstallerApp\TGCS
echo - Enlaces del escritorio (si existen)
echo - Entradas del menu Inicio (si existen)
echo - Configuraciones y datos temporales
echo.
echo Esta accion NO se puede deshacer.
echo.

set /p "CONFIRM=¿Esta seguro que desea desinstalar InstallerApp? (S/N): "
if /i not "%CONFIRM%"=="S" (
    echo.
    echo Desinstalacion cancelada por el usuario.
    pause
    exit /b 0
)

echo.
echo ======================================================
echo   INICIANDO DESINSTALACION...
echo ======================================================

set "INSTALL_DIR=C:\Program Files\InstallerApp\TGCS"
set "PARENT_DIR=C:\Program Files\InstallerApp"
set "DESKTOP_LINK=%USERPROFILE%\Desktop\InstallerApp.lnk"
set "START_MENU_LINK=%APPDATA%\Microsoft\Windows\Start Menu\Programs\InstallerApp.lnk"

REM 1. Terminar procesos de InstallerApp si están ejecutándose
echo [1/6] Terminando procesos de InstallerApp...
taskkill /f /im java.exe /fi "WINDOWTITLE eq InstallerApp*" >nul 2>&1
timeout /t 2 /nobreak >nul

REM 2. Eliminar archivos del programa
echo [2/6] Eliminando archivos del programa...
if exist "%INSTALL_DIR%" (
    echo   Eliminando: %INSTALL_DIR%
    rd /s /q "%INSTALL_DIR%" >nul 2>&1
    if errorlevel 1 (
        echo   ADVERTENCIA: No se pudieron eliminar algunos archivos
        echo   Puede que algunos archivos esten en uso
    ) else (
        echo   ✓ Archivos del programa eliminados
    )
) else (
    echo   ✓ Directorio del programa no encontrado
)

REM 3. Eliminar directorio padre si está vacío
echo [3/6] Limpiando directorios...
if exist "%PARENT_DIR%" (
    rmdir "%PARENT_DIR%" >nul 2>&1
    if errorlevel 1 (
        echo   ✓ Directorio padre conservado (contiene otros archivos)
    ) else (
        echo   ✓ Directorio padre eliminado
    )
)

REM 4. Eliminar enlace del escritorio
echo [4/6] Eliminando enlaces del escritorio...
if exist "%DESKTOP_LINK%" (
    del "%DESKTOP_LINK%" >nul 2>&1
    if errorlevel 1 (
        echo   ADVERTENCIA: No se pudo eliminar enlace del escritorio
    ) else (
        echo   ✓ Enlace del escritorio eliminado
    )
) else (
    echo   ✓ No se encontró enlace en el escritorio
)

REM 5. Eliminar enlace del menú inicio
echo [5/6] Eliminando enlaces del menú inicio...
if exist "%START_MENU_LINK%" (
    del "%START_MENU_LINK%" >nul 2>&1
    if errorlevel 1 (
        echo   ADVERTENCIA: No se pudo eliminar enlace del menú inicio
    ) else (
        echo   ✓ Enlace del menú inicio eliminado
    )
) else (
    echo   ✓ No se encontró enlace en el menú inicio
)

REM 6. Limpiar archivos temporales de actualizaciones
echo [6/6] Limpiando archivos temporales...
set "TEMP_UPDATE_DIR=%TEMP%\installerapp-updates"
if exist "%TEMP_UPDATE_DIR%" (
    rd /s /q "%TEMP_UPDATE_DIR%" >nul 2>&1
    if errorlevel 1 (
        echo   ADVERTENCIA: No se pudieron eliminar algunos archivos temporales
    ) else (
        echo   ✓ Archivos temporales eliminados
    )
) else (
    echo   ✓ No se encontraron archivos temporales
)

echo.
echo ======================================================
echo   DESINSTALACION COMPLETADA EXITOSAMENTE
echo ======================================================
echo.
echo InstallerApp ha sido eliminado completamente del sistema.
echo.
echo Resumen de la desinstalación:
echo ✓ Programa eliminado de: C:\Program Files\InstallerApp\TGCS
echo ✓ Enlaces eliminados del escritorio y menú inicio
echo ✓ Archivos temporales limpiados
echo ✓ Procesos terminados
echo.
echo Gracias por usar InstallerApp!
echo.
echo Repositorio GitHub: https://github.com/abrahan-romo/installer-app
echo.
pause
