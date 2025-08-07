# Crear Instalador v1.0.0-v3 con Correcciones
# Fecha: 2025-08-03

Write-Host "=== Creador de Instalador InstallerApp v1.0.0-v3 ===" -ForegroundColor Green
Write-Host "Con Directorio TGCS y Desinstalador" -ForegroundColor Yellow
Write-Host ""

# Variables
$version = "1.0.0-v3"
$installerDir = "target\installer-v$version-TGCS"
$jarFile = "target\InstallerApp-1.0.0.jar"
$zipFile = "target\InstallerApp-$version-Windows-Installer-TGCS.zip"

# Verificar que el JAR existe
if (-not (Test-Path $jarFile)) {
    Write-Host "ERROR: No se encontró $jarFile" -ForegroundColor Red
    Write-Host "Ejecute 'mvn clean package' primero" -ForegroundColor Yellow
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host "[1/5] Limpiando directorio anterior..." -ForegroundColor Cyan
if (Test-Path $installerDir) {
    Remove-Item -Recurse -Force $installerDir
}
New-Item -ItemType Directory -Path $installerDir -Force | Out-Null

Write-Host "[2/5] Copiando archivos..." -ForegroundColor Cyan
Copy-Item $jarFile "$installerDir\InstallerApp-1.0.0.jar"
Copy-Item "installer-resources\run-app.bat" "$installerDir\"

Write-Host "[3/5] Creando instalador..." -ForegroundColor Cyan
$installerContent = @'
@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

REM ===============================================
REM Instalador de InstallerApp v1.0.0-v3
REM DIRECTORIO CORREGIDO: C:\Program Files\InstallerApp\TGCS
REM Con Sistema de Actualizaciones Automáticas
REM Fecha: 2025-08-03
REM ===============================================

echo.
echo ======================================================
echo   InstallerApp v1.0.0-v3 - Instalador de Aplicación
echo   INSTALACIÓN EN: C:\Program Files\InstallerApp\TGCS
echo   Con Sistema de Actualizaciones Automáticas
echo ======================================================
echo.

REM Obtener directorio actual del script
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo [INFO] Directorio del instalador: %SCRIPT_DIR%
echo.

REM Verificar que Java esté instalado
echo [1/7] Verificando Java...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java no está instalado o no está en el PATH del sistema.
    echo.
    echo Descargue e instale Java desde: https://www.java.com/
    echo.
    pause
    exit /b 1
)
echo [OK] Java detectado correctamente.
echo.

REM Verificar que el archivo JAR existe
echo [2/7] Verificando archivos de la aplicación...
if not exist "%SCRIPT_DIR%InstallerApp-1.0.0.jar" (
    echo [ERROR] No se encontró el archivo InstallerApp-1.0.0.jar
    echo.
    echo Verifique que todos los archivos estén en el directorio del instalador.
    echo.
    pause
    exit /b 1
)
echo [OK] Archivo JAR encontrado.
echo.

REM Crear directorio de instalación (CORREGIDO)
echo [3/7] Creando directorio de instalación...
set "INSTALL_DIR=C:\Program Files\InstallerApp\TGCS"

if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" 2>nul
    if %errorlevel% neq 0 (
        echo [ERROR] No se pudo crear el directorio de instalación.
        echo.
        echo Ejecute este instalador como administrador.
        echo.
        pause
        exit /b 1
    )
)
echo [OK] Directorio de instalación: %INSTALL_DIR%
echo.

REM Copiar archivos de la aplicación
echo [4/7] Copiando archivos de la aplicación...
copy "%SCRIPT_DIR%InstallerApp-1.0.0.jar" "%INSTALL_DIR%\" >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] No se pudo copiar el archivo JAR.
    echo.
    echo Verifique que:
    echo - Tiene permisos de administrador
    echo - El directorio de destino es accesible
    echo - No hay otra instancia de la aplicación ejecutándose
    echo.
    pause
    exit /b 1
)

copy "%SCRIPT_DIR%run-app.bat" "%INSTALL_DIR%\" >nul 2>&1
if %errorlevel% neq 0 (
    echo [ADVERTENCIA] No se pudo copiar run-app.bat. Continuando...
) else (
    echo [OK] Script de ejecución copiado.
)

echo [OK] Archivos copiados exitosamente.
echo.

REM Crear desinstalador
echo [5/7] Creando desinstalador...
set "UNINSTALLER=%INSTALL_DIR%\desinstalar.bat"
echo @echo off > "%UNINSTALLER%"
echo chcp 65001 ^>nul >> "%UNINSTALLER%"
echo echo ============================================== >> "%UNINSTALLER%"
echo echo   Desinstalador de InstallerApp v1.0.0-v3 >> "%UNINSTALLER%"
echo echo ============================================== >> "%UNINSTALLER%"
echo echo. >> "%UNINSTALLER%"
echo echo ¿Desea desinstalar InstallerApp? ^(S/N^) >> "%UNINSTALLER%"
echo set /p "confirm=Opción: " >> "%UNINSTALLER%"
echo if /i "%%confirm%%"=="S" ^( >> "%UNINSTALLER%"
echo     echo Cerrando aplicación... >> "%UNINSTALLER%"
echo     taskkill /f /im java.exe /fi "WINDOWTITLE eq InstallerApp*" ^>nul 2^>^&1 >> "%UNINSTALLER%"
echo     timeout /t 2 ^>nul >> "%UNINSTALLER%"
echo     echo Eliminando accesos directos... >> "%UNINSTALLER%"
echo     del "%%USERPROFILE%%\Desktop\InstallerApp v1.0.0-v3.lnk" ^>nul 2^>^&1 >> "%UNINSTALLER%"
echo     del "%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\InstallerApp v1.0.0-v3.lnk" ^>nul 2^>^&1 >> "%UNINSTALLER%"
echo     echo Eliminando archivos... >> "%UNINSTALLER%"
echo     cd /d "C:\" >> "%UNINSTALLER%"
echo     rmdir /s /q "C:\Program Files\InstallerApp\TGCS" ^>nul 2^>^&1 >> "%UNINSTALLER%"
echo     rmdir "C:\Program Files\InstallerApp" ^>nul 2^>^&1 >> "%UNINSTALLER%"
echo     echo ¡Desinstalación completada! >> "%UNINSTALLER%"
echo ^) else ^( >> "%UNINSTALLER%"
echo     echo Desinstalación cancelada. >> "%UNINSTALLER%"
echo ^) >> "%UNINSTALLER%"
echo pause >> "%UNINSTALLER%"

echo [OK] Desinstalador creado en: %INSTALL_DIR%\desinstalar.bat
echo.

REM Crear acceso directo en el escritorio
echo [6/7] Creando accesos directos...

REM Crear script VBS para acceso directo del escritorio
set "VBS_SCRIPT=%TEMP%\create_shortcut.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\InstallerApp v1.0.0-v3.lnk" >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
echo oLink.TargetPath = "java" >> "%VBS_SCRIPT%"
echo oLink.Arguments = "-jar ""%INSTALL_DIR%\InstallerApp-1.0.0.jar""" >> "%VBS_SCRIPT%"
echo oLink.WorkingDirectory = "%INSTALL_DIR%" >> "%VBS_SCRIPT%"
echo oLink.Description = "InstallerApp v1.0.0-v3 con Actualizaciones Automáticas" >> "%VBS_SCRIPT%"
echo oLink.Save >> "%VBS_SCRIPT%"

cscript //nologo "%VBS_SCRIPT%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Acceso directo creado en el escritorio.
) else (
    echo [ADVERTENCIA] No se pudo crear el acceso directo del escritorio.
)

del "%VBS_SCRIPT%" >nul 2>&1

REM Crear acceso directo en el menú inicio
set "START_MENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
if not exist "%START_MENU_DIR%" mkdir "%START_MENU_DIR%"

set "VBS_SCRIPT=%TEMP%\create_start_shortcut.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo sLinkFile = "%START_MENU_DIR%\InstallerApp v1.0.0-v3.lnk" >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
echo oLink.TargetPath = "java" >> "%VBS_SCRIPT%"
echo oLink.Arguments = "-jar ""%INSTALL_DIR%\InstallerApp-1.0.0.jar""" >> "%VBS_SCRIPT%"
echo oLink.WorkingDirectory = "%INSTALL_DIR%" >> "%VBS_SCRIPT%"
echo oLink.Description = "InstallerApp v1.0.0-v3 con Actualizaciones Automáticas" >> "%VBS_SCRIPT%"
echo oLink.Save >> "%VBS_SCRIPT%"

cscript //nologo "%VBS_SCRIPT%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Acceso directo creado en el menú inicio.
) else (
    echo [ADVERTENCIA] No se pudo crear el acceso directo del menú inicio.
)

del "%VBS_SCRIPT%" >nul 2>&1

echo.

REM Probar la instalación
echo [7/7] Finalizando instalación...
cd /d "%INSTALL_DIR%"
timeout /t 2 >nul

echo.
echo ======================================================
echo   ¡Instalación completada exitosamente!
echo ======================================================
echo.
echo Ubicación de instalación: %INSTALL_DIR%
echo.
echo Para ejecutar la aplicación:
echo 1. Use el acceso directo del escritorio: "InstallerApp v1.0.0-v3"
echo 2. Use el menú inicio: Programas ^> InstallerApp v1.0.0-v3
echo 3. Ejecute directamente: "%INSTALL_DIR%\InstallerApp-1.0.0.jar"
echo.
echo Para desinstalar: "%INSTALL_DIR%\desinstalar.bat"
echo.
echo NUEVO: Sistema de Actualizaciones Automáticas incluido
echo - Verifica automáticamente nuevas versiones cada 24 horas
echo - Te notifica cuando hay actualizaciones disponibles
echo - Descarga e instala actualizaciones con tu confirmación
echo.
echo ¿Desea ejecutar la aplicación ahora? (S/N)
set /p "choice=Opción: "

if /i "%choice%"=="S" (
    echo.
    echo Iniciando InstallerApp v1.0.0-v3...
    start "" java -jar "%INSTALL_DIR%\InstallerApp-1.0.0.jar"
    echo.
    echo ¡Aplicación iniciada! Puede cerrar esta ventana.
    timeout /t 3 >nul
) else (
    echo.
    echo Puede ejecutar la aplicación más tarde usando los accesos directos creados.
)

echo.
echo ¡Gracias por usar InstallerApp!
echo.
pause
'@

$installerContent | Out-File -FilePath "$installerDir\instalar.bat" -Encoding ASCII

Write-Host "[4/5] Creando LEEME.txt..." -ForegroundColor Cyan
$leemeContent = @'
# LEEME - InstallerApp v1.0.0-v3 (DIRECTORIO CORREGIDO)

## 📦 InstallerApp v1.0.0-v3 con TGCS

**IMPORTANTE**: Esta versión corrige el directorio de instalación:
- ✅ DIRECTORIO CORRECTO: C:\Program Files\InstallerApp\TGCS
- ✅ Incluye desinstalador: desinstalar.bat
- ✅ Sistema de Actualizaciones Automáticas

**Fecha**: 3 de Agosto, 2025  
**Versión**: 1.0.0-v3 (Directorio TGCS + Desinstalador)

## 🚀 Instalación

1. **Extraer archivos**: Descomprimir este ZIP en una carpeta temporal
2. **Ejecutar instalador**: Hacer doble clic derecho en `instalar.bat` → "Ejecutar como administrador"
3. **Seguir instrucciones**: El instalador copiará archivos a C:\Program Files\InstallerApp\TGCS
4. **Ejecutar aplicación**: Usar accesos directos creados

## 📍 Ubicaciones Correctas:
- **Aplicación**: `C:\Program Files\InstallerApp\TGCS\`
- **Desinstalador**: `C:\Program Files\InstallerApp\TGCS\desinstalar.bat`
- **Acceso directo (Escritorio)**: `InstallerApp v1.0.0-v3`
- **Acceso directo (Menú Inicio)**: `Programas > InstallerApp v1.0.0-v3`

## 🗑️ Desinstalación

Para desinstalar completamente:
1. Ejecutar: `C:\Program Files\InstallerApp\TGCS\desinstalar.bat`
2. Confirmar con 'S' cuando se solicite
3. El proceso eliminará:
   - Todos los archivos de aplicación
   - Accesos directos del escritorio y menú inicio
   - Archivos temporales de actualizaciones
   - Directorio TGCS completo

## 🔄 Sistema de Actualizaciones Automáticas

- ✅ Verifica automáticamente nuevas versiones cada 24 horas
- ✅ Notifica cuando hay actualizaciones disponibles  
- ✅ Descarga e instala con confirmación del usuario
- ✅ Mantiene backup automático para rollback
- ✅ Usa GitHub Releases como servidor de actualizaciones

## ⚡ Correcciones en esta Versión

### ✅ PROBLEMA SOLUCIONADO: Directorio de Instalación
- **Anterior**: C:\Program Files\InstallerApp (INCORRECTO)
- **Actual**: C:\Program Files\InstallerApp\TGCS (CORRECTO)

### ✅ AGREGADO: Desinstalador Completo
- Script de desinstalación incluido en la instalación
- Elimina completamente la aplicación y configuraciones
- Accessible desde el directorio de instalación

### ✅ CORREGIDO: UpdateChecker
- Actualizado para usar la ruta correcta TGCS
- Fallback corregido para instalación estándar
- Compatible con actualizaciones automáticas

## 🛠️ Resolución de Problemas

### ¿La aplicación no inicia?
1. Verificar Java: `java -version` en línea de comandos
2. Verificar instalación en: `C:\Program Files\InstallerApp\TGCS`
3. Reinstalar como administrador si es necesario

### ¿Error durante desinstalación?
1. Cerrar InstallerApp completamente
2. Ejecutar desinstalar.bat como administrador
3. Si persiste, eliminar manualmente el directorio TGCS

### ¿Actualizaciones no funcionan?
1. Verificar conexión a internet
2. Reiniciar aplicación para forzar verificación
3. Las actualizaciones usan la ruta TGCS corregida

## 📞 Soporte

Para problemas reportar:
- Versión: InstallerApp v1.0.0-v3
- Directorio: C:\Program Files\InstallerApp\TGCS
- Sistema: Windows 7/8/10/11
- Java: Versión instalada

---

¡Gracias por usar InstallerApp v1.0.0-v3 con directorios corregidos!

*Instalador creado el 3 de Agosto, 2025*
*InstallerApp v1.0.0-v3 - Directorio TGCS + Desinstalador*
'@

$leemeContent | Out-File -FilePath "$installerDir\LEEME.txt" -Encoding UTF8

Write-Host "[5/5] Comprimiendo instalador..." -ForegroundColor Cyan
if (Test-Path $zipFile) {
    Remove-Item $zipFile
}

Compress-Archive -Path "$installerDir\*" -DestinationPath $zipFile -CompressionLevel Optimal

Write-Host ""
Write-Host "=== ¡Instalador creado exitosamente! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Archivo creado: $zipFile" -ForegroundColor Yellow
Write-Host "Directorio temporal: $installerDir" -ForegroundColor Gray
Write-Host ""
Write-Host "CORRECCIONES APLICADAS:" -ForegroundColor Cyan
Write-Host "✅ Directorio de instalación corregido: C:\Program Files\InstallerApp\TGCS"
Write-Host "✅ Desinstalador incluido en la instalación"
Write-Host "✅ UpdateChecker actualizado con ruta correcta"
Write-Host "✅ Documentación actualizada"
Write-Host ""

# Verificar archivos creados
Write-Host "Contenido del instalador:" -ForegroundColor White
Get-ChildItem $installerDir | ForEach-Object {
    Write-Host "  📄 $($_.Name)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "¡Listo para distribución!" -ForegroundColor Green
