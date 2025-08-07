@echo off
echo === Creando instalador de aplicacion Java ===

REM Verificar que Maven este instalado
echo Verificando Maven...
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Maven no esta instalado o no esta en el PATH
    pause
    exit /b 1
)

REM Verificar que Java este instalado
echo Verificando Java...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Java no esta instalado o no esta en el PATH
    pause
    exit /b 1
)

REM Limpiar construcciones anteriores
echo Limpiando construcciones anteriores...
mvn clean

REM Compilar el proyecto
echo Compilando el proyecto...
mvn compile
if %errorlevel% neq 0 (
    echo Error en la compilacion
    pause
    exit /b 1
)

REM Crear el JAR ejecutable
echo Creando JAR ejecutable...
mvn package
if %errorlevel% neq 0 (
    echo Error creando el JAR
    pause
    exit /b 1
)

REM Verificar que el JAR se haya creado
if exist "target\InstallerApp-1.0.0.jar" (
    echo JAR creado exitosamente: target\InstallerApp-1.0.0.jar
) else (
    echo Error: No se pudo crear el JAR
    pause
    exit /b 1
)

REM Crear el instalador de Windows
echo Creando instalador de Windows...
mvn jpackage:jpackage
if %errorlevel% neq 0 (
    echo Error creando el instalador
    pause
    exit /b 1
)

REM Verificar que el instalador se haya creado
if exist "target\installer\*.msi" (
    echo.
    echo ¡Instalador creado exitosamente!
    echo Ubicacion: target\installer\
    echo Puedes instalar la aplicacion ejecutando el archivo .msi
) else (
    echo Error: No se pudo crear el instalador
)

echo.
echo === Proceso completado ===
pause
