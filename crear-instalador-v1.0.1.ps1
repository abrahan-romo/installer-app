# Crear Instalador v1.0.1-v4 con Nueva Versión
# Fecha: 2025-08-04

Write-Host "=== Creador de Instalador InstallerApp v1.0.1-v4 ===" -ForegroundColor Green
Write-Host "Nueva versión con método rest() agregado" -ForegroundColor Yellow
Write-Host ""

# Variables
$version = "1.0.1-v4"
$installerDir = "target\installer-v$version-TGCS"
$jarFile = "target\InstallerApp-1.0.1.jar"
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
Copy-Item $jarFile "$installerDir\InstallerApp-1.0.1.jar"
Copy-Item "installer-resources\run-app.bat" "$installerDir\"

Write-Host "[3/5] Creando instalador..." -ForegroundColor Cyan
$installerContent = @'
@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

REM ===============================================
REM Instalador de InstallerApp v1.0.1-v4
REM DIRECTORIO: C:\Program Files\InstallerApp\TGCS
REM Con Sistema de Actualizaciones Automáticas
REM Nueva versión con método rest() agregado
REM Fecha: 2025-08-04
REM ===============================================

echo.
echo ======================================================
echo   InstallerApp v1.0.1-v4 - Instalador de Aplicación
echo   INSTALACIÓN EN: C:\Program Files\InstallerApp\TGCS
echo   Nueva versión con método rest() agregado
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
if not exist "%SCRIPT_DIR%InstallerApp-1.0.1.jar" (
    echo [ERROR] No se encontró el archivo InstallerApp-1.0.1.jar
    echo.
    echo Verifique que todos los archivos estén en el directorio del instalador.
    echo.
    pause
    exit /b 1
)
echo [OK] Archivo JAR encontrado.
echo.

REM Crear directorio de instalación
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
copy "%SCRIPT_DIR%InstallerApp-1.0.1.jar" "%INSTALL_DIR%\" >nul 2>&1
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
echo echo   Desinstalador de InstallerApp v1.0.1-v4 >> "%UNINSTALLER%"
echo echo ============================================== >> "%UNINSTALLER%"
echo echo. >> "%UNINSTALLER%"
echo echo ¿Desea desinstalar InstallerApp? ^(S/N^) >> "%UNINSTALLER%"
echo set /p "confirm=Opción: " >> "%UNINSTALLER%"
echo if /i "%%confirm%%"=="S" ^( >> "%UNINSTALLER%"
echo     echo Cerrando aplicación... >> "%UNINSTALLER%"
echo     taskkill /f /im java.exe /fi "WINDOWTITLE eq InstallerApp*" ^>nul 2^>^&1 >> "%UNINSTALLER%"
echo     timeout /t 2 ^>nul >> "%UNINSTALLER%"
echo     echo Eliminando accesos directos... >> "%UNINSTALLER%"
echo     del "%%USERPROFILE%%\Desktop\InstallerApp v1.0.1-v4.lnk" ^>nul 2^>^&1 >> "%UNINSTALLER%"
echo     del "%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\InstallerApp v1.0.1-v4.lnk" ^>nul 2^>^&1 >> "%UNINSTALLER%"
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
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\InstallerApp v1.0.1-v4.lnk" >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
echo oLink.TargetPath = "java" >> "%VBS_SCRIPT%"
echo oLink.Arguments = "-jar ""%INSTALL_DIR%\InstallerApp-1.0.1.jar""" >> "%VBS_SCRIPT%"
echo oLink.WorkingDirectory = "%INSTALL_DIR%" >> "%VBS_SCRIPT%"
echo oLink.Description = "InstallerApp v1.0.1-v4 con Actualizaciones Automáticas" >> "%VBS_SCRIPT%"
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
echo sLinkFile = "%START_MENU_DIR%\InstallerApp v1.0.1-v4.lnk" >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
echo oLink.TargetPath = "java" >> "%VBS_SCRIPT%"
echo oLink.Arguments = "-jar ""%INSTALL_DIR%\InstallerApp-1.0.1.jar""" >> "%VBS_SCRIPT%"
echo oLink.WorkingDirectory = "%INSTALL_DIR%" >> "%VBS_SCRIPT%"
echo oLink.Description = "InstallerApp v1.0.1-v4 con Actualizaciones Automáticas" >> "%VBS_SCRIPT%"
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
echo 1. Use el acceso directo del escritorio: "InstallerApp v1.0.1-v4"
echo 2. Use el menú inicio: Programas ^> InstallerApp v1.0.1-v4
echo 3. Ejecute directamente: "%INSTALL_DIR%\InstallerApp-1.0.1.jar"
echo.
echo Para desinstalar: "%INSTALL_DIR%\desinstalar.bat"
echo.
echo NUEVA VERSIÓN: v1.0.1-v4
echo ✅ Sistema de Actualizaciones Automáticas incluido
echo ✅ Método rest() agregado para calcular restas
echo ✅ Compatible con GitHub Releases
echo.
echo ¿Desea ejecutar la aplicación ahora? (S/N)
set /p "choice=Opción: "

if /i "%choice%"=="S" (
    echo.
    echo Iniciando InstallerApp v1.0.1-v4...
    start "" java -jar "%INSTALL_DIR%\InstallerApp-1.0.1.jar"
    echo.
    echo ¡Aplicación iniciada! Puede cerrar esta ventana.
    timeout /t 3 >nul
) else (
    echo.
    echo Puede ejecutar la aplicación más tarde usando los accesos directos creados.
)

echo.
echo ¡Gracias por usar InstallerApp v1.0.1!
echo.
pause
'@

$installerContent | Out-File -FilePath "$installerDir\instalar.bat" -Encoding ASCII

Write-Host "[4/5] Creando LEEME.txt..." -ForegroundColor Cyan
$leemeContent = @'
# LEEME - InstallerApp v1.0.1-v4

## 📦 InstallerApp v1.0.1-v4 - Nueva Versión

**NUEVA VERSIÓN**: v1.0.1-v4 con mejoras y nuevas funcionalidades

**Fecha**: 4 de Agosto, 2025  
**Versión**: 1.0.1-v4 (Nueva versión con método rest())

## 🆕 Novedades en v1.0.1-v4

### ✅ NUEVO: Método rest() agregado
- ✅ Calculadora ahora incluye operación de resta
- ✅ Interfaz actualizada con nueva funcionalidad
- ✅ Mantiene compatibilidad con versión anterior

### ✅ MANTIENE: Sistema de Actualizaciones
- ✅ Sistema de actualizaciones automáticas
- ✅ Compatible con GitHub Releases
- ✅ Detección automática de nuevas versiones

## 🚀 Instalación

1. **Extraer archivos**: Descomprimir este ZIP en una carpeta temporal
2. **Ejecutar instalador**: Hacer doble clic derecho en `instalar.bat` → "Ejecutar como administrador"
3. **Seguir instrucciones**: El instalador copiará archivos a C:\Program Files\InstallerApp\TGCS
4. **Ejecutar aplicación**: Usar accesos directos creados

## 📍 Ubicaciones:
- **Aplicación**: `C:\Program Files\InstallerApp\TGCS\`
- **Desinstalador**: `C:\Program Files\InstallerApp\TGCS\desinstalar.bat`
- **Acceso directo (Escritorio)**: `InstallerApp v1.0.1-v4`
- **Acceso directo (Menú Inicio)**: `Programas > InstallerApp v1.0.1-v4`

## 🔄 Sistema de Actualizaciones Automáticas

Para probar el sistema de actualizaciones:
1. Instalar esta versión v1.0.1-v4
2. Cuando haya una nueva versión v1.0.2 en GitHub
3. La aplicación detectará automáticamente la actualización
4. Te notificará y permitirá descargar/instalar

**URL del Repositorio**: https://github.com/TU_USUARIO/installer-app
- Reemplazar "TU_USUARIO" por tu usuario real de GitHub
- El sistema buscará releases en este repositorio

## 🗑️ Desinstalación

Para desinstalar completamente:
1. Ejecutar: `C:\Program Files\InstallerApp\TGCS\desinstalar.bat`
2. Confirmar con 'S' cuando se solicite
3. El proceso eliminará todo completamente

## 🛠️ Resolución de Problemas

### ¿La aplicación no inicia?
1. Verificar Java: `java -version` en línea de comandos
2. Verificar instalación en: `C:\Program Files\InstallerApp\TGCS`
3. Reinstalar como administrador si es necesario

### ¿Actualizaciones no funcionan?
1. Actualizar la URL en UpdateChecker.java con tu usuario GitHub real
2. Crear releases en GitHub con formato: v1.0.2, v1.0.3, etc.
3. Subir ZIP con formato: InstallerApp-1.0.2-v5-Windows-Installer-TGCS.zip

## 📁 Archivos para Subir a GitHub Release

Para crear una nueva versión, subir estos archivos al GitHub Release:

**Archivos requeridos**:
- `InstallerApp-1.0.1-v4-Windows-Installer-TGCS.zip` (este archivo)
- `InstallerApp-1.0.1.jar` (opcional, para desarrolladores)

**Tag del Release**: `v1.0.1`
**Título**: `InstallerApp v1.0.1-v4`

## 📞 Información de Versión

- **Versión App**: 1.0.1
- **Build**: v4
- **Funcionalidades**: sum() + rest()
- **Sistema**: Windows 7/8/10/11
- **Java**: 8 o superior

---

¡Gracias por usar InstallerApp v1.0.1-v4!

*Instalador creado el 4 de Agosto, 2025*
*InstallerApp v1.0.1-v4 - Nueva versión con método rest()*
'@

$leemeContent | Out-File -FilePath "$installerDir\LEEME.txt" -Encoding UTF8

Write-Host "[5/5] Comprimiendo instalador..." -ForegroundColor Cyan
if (Test-Path $zipFile) {
    Remove-Item $zipFile
}

Compress-Archive -Path "$installerDir\*" -DestinationPath $zipFile -CompressionLevel Optimal

Write-Host ""
Write-Host "=== ¡Instalador v1.0.1-v4 creado exitosamente! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Archivo creado: $zipFile" -ForegroundColor Yellow
Write-Host "Directorio temporal: $installerDir" -ForegroundColor Gray
Write-Host ""
Write-Host "NUEVA VERSIÓN v1.0.1-v4:" -ForegroundColor Cyan
Write-Host "- Método rest() agregado a Calculator.java"
Write-Host "- JAR actualizado: InstallerApp-1.0.1.jar"
Write-Host "- Sistema de actualizaciones incluido"
Write-Host "- Directorio TGCS mantenido"
Write-Host ""

# Verificar archivos creados
Write-Host "Contenido del instalador:" -ForegroundColor White
Get-ChildItem $installerDir | ForEach-Object {
    Write-Host "  📄 $($_.Name)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "PASOS SIGUIENTES:" -ForegroundColor Yellow
Write-Host "1. Subir a GitHub Release con tag: v1.0.1"
Write-Host "2. Título del release: 'InstallerApp v1.0.1-v4'"
Write-Host "3. Actualizar URL en UpdateChecker.java con tu usuario GitHub"
Write-Host "4. Archivo principal: $zipFile"
Write-Host ""
Write-Host "Listo para distribucion en GitHub!" -ForegroundColor Green
