# Script para crear un instalador simple de la aplicación Java
# Compatible con Java 8+

Write-Host "=== Creando instalador de aplicación Java ===" -ForegroundColor Green

# Verificar que Maven esté instalado
Write-Host "Verificando Maven..." -ForegroundColor Yellow
try {
    $mavenVersion = mvn -version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Maven encontrado" -ForegroundColor Green
    } else {
        throw "Maven no encontrado"
    }
} catch {
    Write-Host "Error: Maven no está instalado o no está en el PATH" -ForegroundColor Red
    Read-Host "Presiona Enter para continuar"
    exit 1
}

# Verificar que Java esté instalado
Write-Host "Verificando Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Java encontrado" -ForegroundColor Green
    } else {
        throw "Java no encontrado"
    }
} catch {
    Write-Host "Error: Java no está instalado o no está en el PATH" -ForegroundColor Red
    Read-Host "Presiona Enter para continuar"
    exit 1
}

# Limpiar construcciones anteriores
Write-Host "Limpiando construcciones anteriores..." -ForegroundColor Yellow
mvn clean

# Compilar el proyecto
Write-Host "Compilando el proyecto..." -ForegroundColor Yellow
mvn compile
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error en la compilación" -ForegroundColor Red
    Read-Host "Presiona Enter para continuar"
    exit 1
}

# Crear el JAR ejecutable
Write-Host "Creando JAR ejecutable..." -ForegroundColor Yellow
mvn package
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error creando el JAR" -ForegroundColor Red
    Read-Host "Presiona Enter para continuar"
    exit 1
}

# Verificar que el JAR se haya creado
$jarFile = "target\InstallerApp-1.0.0.jar"
if (Test-Path $jarFile) {
    Write-Host "JAR creado exitosamente: $jarFile" -ForegroundColor Green
} else {
    Write-Host "Error: No se pudo crear el JAR" -ForegroundColor Red
    Read-Host "Presiona Enter para continuar"
    exit 1
}

# Crear directorio del instalador
$installerDir = "target\installer"
if (!(Test-Path $installerDir)) {
    New-Item -ItemType Directory -Path $installerDir -Force | Out-Null
}

# Crear un instalador ZIP simple
Write-Host "Creando paquete de instalación..." -ForegroundColor Yellow

# Crear directorio temporal para el instalador
$tempDir = "target\installer-temp"
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Copiar archivos necesarios
Copy-Item -Path $jarFile -Destination $tempDir
Copy-Item -Path "installer-resources\run-app.bat" -Destination $tempDir
Copy-Item -Path "installer-resources\*" -Destination $tempDir -Recurse -ErrorAction SilentlyContinue

# Crear un script de instalación
$installScript = @"
@echo off
echo === Instalador de InstallerApp ===
echo.

REM Crear directorio de instalación
set INSTALL_DIR=%PROGRAMFILES%\TGCS\InstallerApp
echo Creando directorio de instalacion: %INSTALL_DIR%
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

REM Copiar archivos
echo Copiando archivos...
copy "InstallerApp-1.0.0.jar" "%INSTALL_DIR%\"
copy "run-app.bat" "%INSTALL_DIR%\"

REM Crear acceso directo en el escritorio
echo Creando acceso directo en el escritorio...
powershell -Command "`$WshShell = New-Object -comObject WScript.Shell; `$Shortcut = `$WshShell.CreateShortcut('%USERPROFILE%\Desktop\InstallerApp.lnk'); `$Shortcut.TargetPath = '%INSTALL_DIR%\run-app.bat'; `$Shortcut.WorkingDirectory = '%INSTALL_DIR%'; `$Shortcut.Save()"

REM Crear acceso directo en el menú de inicio
echo Creando acceso directo en el menu de inicio...
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\TGCS" mkdir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\TGCS"
powershell -Command "`$WshShell = New-Object -comObject WScript.Shell; `$Shortcut = `$WshShell.CreateShortcut('%APPDATA%\Microsoft\Windows\Start Menu\Programs\TGCS\InstallerApp.lnk'); `$Shortcut.TargetPath = '%INSTALL_DIR%\run-app.bat'; `$Shortcut.WorkingDirectory = '%INSTALL_DIR%'; `$Shortcut.Save()"

echo.
echo === Instalacion completada ===
echo La aplicacion se ha instalado en: %INSTALL_DIR%
echo Accesos directos creados en el escritorio y menu de inicio.
echo.
pause
"@

$installScript | Out-File -FilePath "$tempDir\instalar.bat" -Encoding ASCII

# Crear un script de desinstalación
$uninstallScript = @"
@echo off
echo === Desinstalador de InstallerApp ===
echo.

set INSTALL_DIR=%PROGRAMFILES%\TGCS\InstallerApp

echo Eliminando archivos de aplicacion...
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%"
    echo Archivos eliminados: %INSTALL_DIR%
)

echo Eliminando accesos directos...
if exist "%USERPROFILE%\Desktop\InstallerApp.lnk" del "%USERPROFILE%\Desktop\InstallerApp.lnk"
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\TGCS\InstallerApp.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\TGCS\InstallerApp.lnk"
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\TGCS" rmdir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\TGCS" 2>nul

echo.
echo === Desinstalacion completada ===
echo.
pause
"@

$uninstallScript | Out-File -FilePath "$tempDir\desinstalar.bat" -Encoding ASCII

# Crear archivo README para el instalador
$readmeContent = @"
=== InstallerApp - Aplicación Java con Calculadora ===

INSTRUCCIONES DE INSTALACIÓN:

1. Asegúrate de tener Java instalado en tu sistema
   - Verifica ejecutando: java -version
   - Si no tienes Java, descárgalo desde: https://adoptium.net/

2. Ejecuta "instalar.bat" como administrador para instalar la aplicación

3. Una vez instalada, podrás ejecutar la aplicación desde:
   - Acceso directo en el escritorio
   - Menú de inicio > TGCS > InstallerApp
   - Directamente desde: C:\Program Files\TGCS\InstallerApp\run-app.bat

DESINSTALACIÓN:

- Ejecuta "desinstalar.bat" como administrador para eliminar completamente la aplicación

CONTENIDO DE LA APLICACIÓN:

- Aplicación Java que demuestra el uso de una calculadora
- Clase Calculator con método sum() para sumar números enteros
- Interfaz de consola con ejemplos de uso

REQUISITOS DEL SISTEMA:

- Windows 7 o superior
- Java 8 o superior
- 50 MB de espacio libre en disco

SOPORTE:

Para problemas o preguntas, contacta al equipo de desarrollo de TGCS.
"@

$readmeContent | Out-File -FilePath "$tempDir\LEEME.txt" -Encoding UTF8

# Crear el paquete ZIP
$zipPath = "$installerDir\InstallerApp-1.0.0-Windows.zip"
Write-Host "Creando paquete ZIP: $zipPath" -ForegroundColor Yellow

try {
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipPath -Force
    Write-Host "¡Paquete de instalación creado exitosamente!" -ForegroundColor Green
    Write-Host "Ubicación: $zipPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "INSTRUCCIONES:" -ForegroundColor Yellow
    Write-Host "1. Extrae el archivo ZIP en cualquier ubicación" -ForegroundColor White
    Write-Host "2. Ejecuta 'instalar.bat' como administrador" -ForegroundColor White
    Write-Host "3. La aplicación se instalará en C:\Program Files\TGCS\InstallerApp" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host "Error creando el paquete ZIP: $($_.Exception.Message)" -ForegroundColor Red
}

# Limpiar directorio temporal
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# Probar el JAR ejecutable
Write-Host "Probando la aplicación..." -ForegroundColor Yellow
Write-Host "=== SALIDA DE LA APLICACIÓN ===" -ForegroundColor Cyan
try {
    & java -jar $jarFile
    Write-Host "=== FIN DE LA SALIDA ===" -ForegroundColor Cyan
    Write-Host "¡Aplicación ejecutada exitosamente!" -ForegroundColor Green
} catch {
    Write-Host "Error ejecutando la aplicación: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Proceso completado ===" -ForegroundColor Green
Read-Host "Presiona Enter para continuar"
