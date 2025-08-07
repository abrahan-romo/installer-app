# Documentación del Proyecto InstallerApp v1.0.1-v5

## 🎯 Resumen de la Versión Actual
**InstallerApp v1.0.1-v5** es la versión más completa y estable del proyecto, incluyendo **desinstalador completo**, **sistema de actualizaciones automáticas funcional** y **correcciones de estabilidad críticas**. Esta versión está lista para producción.

## 📋 Índice
1. [Características principales](#características-principales)
2. [Creación de la clase Calculator](#creación-de-la-clase-calculator)
3. [Sistema de actualizaciones automáticas](#sistema-de-actualizaciones-automáticas)
4. [Desinstalador completo](#desinstalador-completo)
5. [Creación del instalador de Windows](#creación-del-instalador-de-windows)
6. [Problemas encontrados y soluciones](#problemas-encontrados-y-soluciones)
7. [Estructura del proyecto](#estructura-del-proyecto)
8. [Archivos generados](#archivos-generados)
9. [Instrucciones de uso](#instrucciones-de-uso)
10. [Notas para desarrolladores](#notas-para-desarrolladores)

---

## Características Principales

### ✅ **Sistema Completo de Gestión**
- 📦 **Instalación**: `instalar.bat` con verificación de permisos administrativos
- ▶️ **Ejecución**: `run-app.bat` + accesos directos automáticos  
- 🔄 **Actualización**: Sistema automático cada 24h desde GitHub Releases
- 🗑️ **Desinstalación**: `desinstalar.bat` con limpieza completa del sistema

### ✅ **Componentes Técnicos**
- **Aplicación Java**: GUI con Swing + calculadora interactiva
- **Sistema de Updates**: UpdateChecker.java (600+ líneas) integrado
- **GitHub Integration**: Repositorio `abrahan-romo/installer-app`
- **Windows Scripts**: Batch files con manejo robusto de errores

---

## Creación de la clase Calculator

### Pregunta:
> crear una nueva java class bajo la src\main\java\ directory de este proyecto con el package name com.tgcs.impl el java class name es Calculator.java y include el sum method only que receives two int parameters it returns the sum of both of them

### Respuesta:
Se creó exitosamente la clase `Calculator.java` en el directorio `src\main\java\com\tgcs\impl\` con las siguientes características:

- **Ubicación**: `src\main\java\com\tgcs\impl\Calculator.java`
- **Paquete**: `com.tgcs.impl`
- **Método**: `sum(int a, int b)` que retorna la suma de dos enteros
- **Documentación**: Incluye JavaDoc completo

```java
package com.tgcs.impl;

public class Calculator {
    
    /**
     * Calculates the sum of two integers.
     * 
     * @param a the first integer
     * @param b the second integer
     * @return the sum of a and b
     */
    public int sum(int a, int b) {
        return a + b;
    }
}
```

---

## Sistema de Actualizaciones Automáticas

### 🔄 **Funcionalidades Implementadas**
El sistema de actualizaciones automáticas está completamente integrado y funcional:

- **✅ Verificación Automática**: Cada 24 horas + al inicio de la aplicación
- **✅ GitHub Releases Integration**: Conecta a `abrahan-romo/installer-app`
- **✅ Descarga Automática**: Downloads desde GitHub a directorio temporal
- **✅ Instalación Transparente**: Backup → Reemplazo → Reinicio automático
- **✅ Control del Usuario**: "Actualizar Ahora", "Más Tarde", "Saltar Versión"

### 🏗️ **Arquitectura Técnica**
```java
// UpdateChecker.java - Configuración Principal
private static final String GITHUB_API_URL = 
    "https://api.github.com/repos/abrahan-romo/installer-app/releases/latest";
private static final String CURRENT_VERSION = "1.0.1";
private static final long CHECK_INTERVAL_HOURS = 24;
```

### 📁 **Flujo del Sistema**
1. **Detección**: API call a GitHub para obtener última versión
2. **Comparación**: Versión local vs remota usando semantic versioning  
3. **Notificación**: Dialog al usuario cuando hay actualizaciones disponibles
4. **Descarga**: Archivo JAR a `%TEMP%\installerapp-updates\`
5. **Instalación**: Script automático con backup y rollback
6. **Reinicio**: Aplicación se reinicia con nueva versión

---

## Desinstalador Completo

### 🗑️ **Funcionalidades del Desinstalador** 
Se implementó un desinstalador completo con las siguientes características:

- **✅ Verificación de Permisos**: Requiere ejecución como administrador
- **✅ Confirmación de Usuario**: Solicita confirmación explícita antes de proceder  
- **✅ Terminación de Procesos**: Cierra InstallerApp si está ejecutándose
- **✅ Eliminación Completa**: Remueve todos los archivos del programa
- **✅ Limpieza de Enlaces**: Elimina shortcuts del escritorio y menú inicio
- **✅ Archivos Temporales**: Limpia cache de actualizaciones
- **✅ Reporte Detallado**: Muestra progreso paso a paso

### 📋 **Proceso de Desinstalación**
```bat
[1/6] Terminando procesos de InstallerApp...
[2/6] Eliminando archivos del programa...
[3/6] Limpiando directorios...
[4/6] Eliminando enlaces del escritorio...
[5/6] Eliminando enlaces del menú inicio...
[6/6] Limpiando archivos temporales...
```

### 🎯 **Directorios Limpiados**
- `C:\Program Files\InstallerApp\TGCS\` (archivos del programa)
- `%USERPROFILE%\Desktop\InstallerApp.lnk` (enlace escritorio)  
- `%APPDATA%\Microsoft\Windows\Start Menu\Programs\InstallerApp.lnk` (menú inicio)
- `%TEMP%\installerapp-updates\` (archivos temporales de actualizaciones)

---

## Problemas encontrados y soluciones

### Problema 1: Error Crítico de Versión en JAR (v1.0.1-v5)
**Descripción**: El archivo `run-app.bat` estaba intentando ejecutar `InstallerApp-1.0.0.jar` pero el JAR real era `InstallerApp-1.0.1.jar`, causando el error "Unable to access jarfile".

**Solución Implementada**:
- ✅ Corregido `installer-resources/run-app.bat` para usar versión correcta  
- ✅ Sincronización completa de versiones en todos los componentes
- ✅ Recompilación completa del proyecto desde cero
- ✅ Regeneración del instalador con versión correcta

### Problema 2: Incompatibilidad de versiones de Java
**Descripción**: Inicialmente se configuró para Java 17+ para usar `jpackage`, pero el entorno tenía Java 8.

**Solución**: 
- Se adaptó el `pom.xml` para Java 8
- Se cambió la estrategia de `jpackage` a scripts `.bat` personalizados
- Se mantuvieron todas las funcionalidades del instalador

### Problema 3: Rutas relativas en el instalador (Crítico)
**Descripción**: Durante las pruebas de instalación, el usuario reportó el error:
```
Creando directorios de instalacion...
Copiando archivos de la aplicacion...
ERROR: No se pudo copiar el archivo JAR.
```

**Causa raíz**: El script `instalar.bat` usaba rutas relativas:
```bat
copy "InstallerApp-1.0.0.jar" "%INSTALL_DIR%\" >nul
copy "run-app.bat" "%INSTALL_DIR%\" >nul
```

Cuando se ejecuta como administrador, Windows puede cambiar el directorio de trabajo actual, causando que los archivos no se encuentren.

**Solución implementada**:
1. **Uso de rutas absolutas**: Se modificó el script para usar `%~dp0` (ubicación del script):
   ```bat
   set "SCRIPT_DIR=%~dp0"
   copy "%SCRIPT_DIR%InstallerApp-1.0.0.jar" "%INSTALL_DIR%\" >nul
   copy "%SCRIPT_DIR%run-app.bat" "%INSTALL_DIR%\" >nul
   ```

2. **Verificación previa de archivos**:
   ```bat
   if not exist "%SCRIPT_DIR%InstallerApp-1.0.0.jar" (
       echo ERROR: No se encuentra el archivo InstallerApp-1.0.0.jar en %SCRIPT_DIR%
       pause
       exit /b 1
   )
   ```

3. **Mensajes informativos mejorados**: Se agregaron mensajes que muestran las rutas específicas para facilitar el debugging.

**Resultado**: Se creó `InstallerApp-1.0.0-Windows-Installer-Fixed.zip` con las correcciones aplicadas.

### Problema 3: Cierre inmediato de ventana al ejecutar aplicación (Crítico)
**Descripción**: Durante las pruebas adicionales, se detectó que al ejecutar la aplicación desde los accesos directos (escritorio o menú de inicio), la ventana DOS se abría, mostraba "Iniciando InstallerApp..." y se cerraba inmediatamente sin permitir leer la salida.

**Causa raíz**: El script `run-app.bat` solo ejecutaba `pause` en caso de error:
```bat
java -jar "InstallerApp-1.0.0.jar"

if %errorlevel% neq 0 (
    echo La aplicación terminó con un error.
    pause
)
REM Sin pausa si la aplicación termina exitosamente (código 0)
```

Cuando la aplicación Java se ejecutaba exitosamente (código de salida 0), el script terminaba inmediatamente y cerraba la ventana, impidiendo al usuario leer la salida.

**Solución implementada**: Se simplificó el script para hacer pausa siempre:
```bat
@echo off
cd /d "%~dp0"

java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Java no esta instalado
    pause
    exit /b 1
)

echo Iniciando InstallerApp...
java -jar "InstallerApp-1.0.0.jar"

echo.
echo Aplicacion terminada. Presiona cualquier tecla para cerrar...
pause >nul
```

**Resultado**: Se creó `InstallerApp-1.0.0-Windows-Installer-v2.zip` con todas las correcciones aplicadas.

---

## Creación del instalador de Windows

### Pregunta:
> crea un instalador de esta aplicación en windows

### Respuesta:
Se configuró un sistema completo para generar un instalador de Windows con las siguientes características:

### Configuración del proyecto Maven

Se actualizó el `pom.xml` para incluir:

- **Java 8** (compatible con la versión instalada) - *Originalmente planificado para Java 17+*
- **Maven Shade Plugin** para crear JAR ejecutable
- **Configuración de aplicación**:
  - Nombre: InstallerApp
  - Versión: 1.0.0
  - Clase principal: `org.example.Main`

**Nota importante**: La configuración inicial contemplaba usar `jpackage` (disponible desde Java 14+), pero se adaptó para Java 8+ por compatibilidad con el entorno de desarrollo disponible.

### Archivos creados para el instalador

1. **Scripts de automatización**:
   - `crear-instalador.ps1` - Script de PowerShell completo
   - `crear-instalador-simple.ps1` - Script simplificado
   - `crear-instalador.bat` - Script de batch alternativo

2. **Recursos del instalador**:
   - `installer-resources/run-app.bat` - Script para ejecutar la aplicación
   - `installer.nsi` - Script NSIS para instaladores avanzados

3. **Instalador final**:
   - `target/installer/instalar.bat` - Instalador principal
   - `target/installer/LEEME.txt` - Documentación del usuario
   - `target/InstallerApp-1.0.0-Windows-Installer.zip` - Paquete completo

### Características del instalador

- ✅ **Verificación automática de Java** (Java 8+)
- ✅ **Instalación en** `C:\Program Files\InstallerApp\TGCS`
- ✅ **Acceso directo en el escritorio**
- ✅ **Acceso directo en el menú de inicio** (TGCS > InstallerApp)
- ✅ **Desinstalador automático** incluido
- ✅ **Compatible con Windows 7+**

---

## Estructura del proyecto

```
installer_pull_updates/
├── docs/
│   └── README.md                    # Esta documentación
├── src/
│   └── main/
│       └── java/
│           ├── org/example/
│           │   └── Main.java        # Clase principal actualizada
│           └── com/tgcs/impl/
│               └── Calculator.java  # Nueva clase Calculator
├── installer-resources/
│   └── run-app.bat                  # Script de ejecución
├── target/
│   ├── installer/
│   │   ├── instalar.bat            # Instalador principal
│   │   ├── InstallerApp-1.0.0.jar  # Aplicación ejecutable
│   │   ├── run-app.bat             # Script de ejecución
│   │   └── LEEME.txt               # Instrucciones
│   └── InstallerApp-1.0.0-Windows-Installer.zip  # Paquete final
├── pom.xml                          # Configuración Maven actualizada
├── crear-instalador.ps1             # Script PowerShell completo
├── crear-instalador-simple.ps1      # Script PowerShell simplificado
├── crear-instalador.bat             # Script batch alternativo
├── installer.nsi                    # Script NSIS
└── README.md                        # Documentación del proyecto
```

---

## Archivos generados

### JAR ejecutable
- **Archivo**: `target/InstallerApp-1.0.0.jar` (3.9 KB)
- **Tipo**: JAR ejecutable con todas las dependencias incluidas
- **Ejecución**: `java -jar InstallerApp-1.0.0.jar`

### Paquete del instalador
- **Archivo original**: `target/InstallerApp-1.0.0-Windows-Installer.zip` (5.4 KB) - Con problemas de rutas
- **Archivo v1**: `target/InstallerApp-1.0.0-Windows-Installer-Fixed.zip` (5.6 KB) - Rutas corregidas
- **Archivo v2**: `target/InstallerApp-1.0.0-Windows-Installer-v2.zip` (5.6 KB) - Todas las correcciones
- **Contenido**: Instalador completo con scripts corregidos y verificaciones mejoradas

**Recomendación**: Usar siempre la versión v2 que incluye todas las correcciones.

### Funcionalidad de la aplicación
La aplicación demuestra el uso de la clase Calculator con ejemplos automáticos:

```
¡Bienvenido a la aplicación Java con Calculadora!

Demostrando la funcionalidad de la calculadora:
Suma de 1 + 2 = 3
Suma de 2 + 4 = 6
Suma de 3 + 6 = 9
Suma de 4 + 8 = 12
Suma de 5 + 10 = 15

¡Aplicación ejecutada exitosamente!
```

---

## Instrucciones de uso

### Para desarrolladores

#### Compilar y ejecutar
```bash
# Compilar el proyecto
mvn clean compile

# Crear JAR ejecutable
mvn package

# Ejecutar la aplicación
java -jar target/InstallerApp-1.0.0.jar
```

#### Crear instalador
```bash
# Opción 1: PowerShell (recomendado)
.\crear-instalador-simple.ps1

# Opción 2: Batch
crear-instalador.bat

# Opción 3: Maven directo
mvn clean package
```

**Nota**: Se recomienda usar `crear-instalador-simple.ps1` que es más estable y compatible.

### Para usuarios finales

#### Instalación
1. **Descargar** el archivo `InstallerApp-1.0.0-Windows-Installer-v2.zip` (versión más reciente)
2. **Extraer** el contenido en cualquier ubicación
3. **Ejecutar** `instalar.bat` como administrador
4. **Seguir** las instrucciones en pantalla

**Importante**: Usar la versión "v2" que contiene todas las correcciones aplicadas (rutas relativas + cierre de ventana).

#### Requisitos del sistema
- Windows 7 o superior
- Java 8 o superior instalado
- 50 MB de espacio libre en disco

#### Ejecución
- **Escritorio**: Doble clic en "InstallerApp" - Mantiene ventana abierta tras ejecución
- **Menú de inicio**: TGCS > InstallerApp - Funciona correctamente
- **Directo**: `C:\Program Files\InstallerApp\TGCS\run-app.bat` - Siempre funcional

**Nota**: La versión v2 corrige el problema de cierre inmediato de ventana.

#### Desinstalación
Ejecutar como administrador:
```
C:\Program Files\InstallerApp\TGCS\desinstalar.bat
```

---

## Proceso de construcción exitoso

### Resultados de la compilación
- ✅ Maven verificado y funcionando
- ✅ Java 8 compatible confirmado
- ✅ Compilación exitosa sin errores
- ✅ JAR ejecutable creado: `target\InstallerApp-1.0.0.jar`
- ✅ Aplicación probada y funcionando correctamente
- ✅ Instalador v1 empaquetado: `target\InstallerApp-1.0.0-Windows-Installer-Fixed.zip`
- ✅ Instalador v2 empaquetado: `target\InstallerApp-1.0.0-Windows-Installer-v2.zip` (recomendado)
- ✅ Problemas de rutas relativas solucionados
- ✅ Problema de cierre inmediato de ventana solucionado

### Prueba de ejecución
La aplicación se ejecutó exitosamente mostrando:
- Mensaje de bienvenida
- 5 ejemplos de suma usando la clase Calculator
- Mensaje de finalización exitosa

---

## Conclusión

Se ha creado exitosamente:

1. ✅ **Clase Calculator** con método sum() funcionando correctamente
2. ✅ **Aplicación Java** que demuestra el uso de la calculadora
3. ✅ **Instalador de Windows** completo y funcional
4. ✅ **Paquete distribuible** listo para compartir
5. ✅ **Documentación completa** del proyecto y proceso

El proyecto está listo para distribución y uso en sistemas Windows con Java 8+.

---

## Notas para desarrolladores

### Lecciones aprendidas durante el desarrollo

1. **Compatibilidad de versiones Java**:
   - Siempre verificar la versión de Java disponible en el entorno de destino
   - `jpackage` requiere Java 14+ pero no está disponible en entornos con Java 8
   - Los scripts `.bat` personalizados son más universalmente compatibles

2. **Problema crítico de rutas relativas**:
   - Los scripts que se ejecutan como administrador pueden cambiar su directorio de trabajo
   - **Siempre usar rutas absolutas** en scripts de instalación
   - La variable `%~dp0` en batch obtiene la ruta del directorio donde está el script
   - Verificar la existencia de archivos antes de intentar operaciones

3. **Problema crítico de cierre inmediato de ventana**:
   - Los scripts que ejecutan aplicaciones de consola deben manejar correctamente la finalización
   - **Siempre incluir pausa** al final para que el usuario pueda leer la salida
   - No depender solo de pausas condicionales en caso de error
   - El código de salida 0 (éxito) también requiere pausa para experiencia de usuario correcta
   ```bat
   REM Obtener ruta del script
   set "SCRIPT_DIR=%~dp0"
   
   REM Verificar archivos antes de usar
   if not exist "%SCRIPT_DIR%archivo.jar" (
       echo ERROR: Archivo no encontrado
       exit /b 1
   )
   
   REM Usar rutas absolutas
   copy "%SCRIPT_DIR%archivo.jar" "%DESTINO%\"
   ```

4. **Testing de instaladores**:
   - Probar siempre en un entorno limpio
   - Ejecutar como administrador para simular instalación real
   - Verificar que los accesos directos funcionen correctamente
   - Probar el proceso de desinstalación

5. **Versionado de instaladores**:
   - Incluir información de versión en nombres de archivos
   - Mantener versiones anteriores para rollback si es necesario
   - Documentar cambios entre versiones (ej: "-Fixed" para correcciones)

### Archivos críticos para el instalador

1. **`instalar.bat`**: Script principal de instalación
   - **Crítico**: Debe usar rutas absolutas con `%~dp0`
   - Debe verificar Java antes de continuar
   - Debe verificar existencia de archivos necesarios

2. **`run-app.bat`**: Script para ejecutar la aplicación
   - Debe cambiar al directorio correcto antes de ejecutar
   - Debe manejar errores de Java no encontrado

3. **JAR ejecutable**: Debe ser autocontenido (fat JAR)
   - Generado con Maven Shade Plugin
   - Incluye todas las dependencias necesarias

### Consideraciones para futuras versiones

1. **Migración a Java moderno**:
   - Cuando sea posible migrar a Java 17+, considerar usar `jpackage`
   - `jpackage` genera instaladores nativos (.msi, .exe, .pkg, .deb)
   - Mejor integración con el sistema operativo

2. **Instalador MSI nativo**:
   - Considerar WiX Toolset para instaladores .msi profesionales
   - Mejor experiencia de usuario
   - Integración con "Programas y características" de Windows

3. **Firma digital**:
   - Para distribución profesional, considerar firmar los instaladores
   - Evita advertencias de seguridad en Windows
   - Mejora la confianza del usuario

4. **Actualizaciones automáticas**:
   - Implementar mecanismo de verificación de actualizaciones
   - Descarga e instalación automática de nuevas versiones
