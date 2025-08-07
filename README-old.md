# Instalador de Aplicación Java

Esta aplicación Java incluye una calculadora básica y está configurada para generar un instalador de Windows (.msi).

## Requisitos Previos

Para generar el instalador, necesitas tener instalado:

1. **Java Development Kit (JDK) 8 o superior** *(Actualizado: Compatible con Java 8+)*
   - Descarga desde: https://adoptium.net/
   - Asegúrate de que `java` esté en tu PATH
   - **Nota**: Originalmente se planificó para Java 17+, pero se adaptó para Java 8+ por compatibilidad

2. **Apache Maven**
   - Descarga desde: https://maven.apache.org/download.cgi
   - Asegúrate de que `mvn` esté en tu PATH

3. **WiX Toolset** *(Opcional - para instaladores .msi avanzados)*
   - Descarga desde: https://wixtoolset.org/
   - **Nota**: No requerido para el instalador actual que usa scripts .bat

## Cómo crear el instalador

### Opción 1: Usar el script automatizado (Recomendado)

1. Abre PowerShell como administrador
2. Navega al directorio del proyecto
3. Ejecuta el script:
   ```powershell
   .\crear-instalador-simple.ps1
   ```
   **Nota**: Se recomienda usar `crear-instalador-simple.ps1` que es compatible con Java 8+

### Opción 2: Comandos manuales

1. Abre una terminal (cmd o PowerShell)
2. Navega al directorio del proyecto
3. Ejecuta los siguientes comandos:

```bash
# Limpiar construcciones anteriores
mvn clean

# Compilar y crear el JAR ejecutable
mvn package
```

**Importante**: Se removió el comando `mvn jpackage:jpackage` ya que requiere Java 17+

## Resultado

El instalador se generará como un archivo ZIP: `target/InstallerApp-1.0.0-Windows-Installer-Fixed.zip`.

**Importante**: El nombre incluye "Fixed" debido a correcciones de rutas relativas implementadas después de pruebas de instalación.

## Problemas Conocidos y Soluciones

### Problema de Rutas Relativas (Solucionado en v1.0.0-Fixed)
- **Síntoma**: Error "No se pudo copiar el archivo JAR" durante la instalación
- **Causa**: El script original usaba rutas relativas que fallaban cuando se ejecutaba como administrador
- **Solución**: Se corrigió para usar rutas absolutas basadas en la ubicación del script (`%~dp0`)

### Problema de Cierre Inmediato de Ventana (Solucionado en v1.0.0-v2)
- **Síntoma**: Al ejecutar la aplicación desde accesos directos, la ventana DOS se cierra inmediatamente después de mostrar "Iniciando InstallerApp..."
- **Causa**: El script `run-app.bat` solo hacía pausa en caso de error, pero cerraba inmediatamente cuando la aplicación terminaba exitosamente
- **Solución**: Se modificó el script para hacer pausa siempre al final, permitiendo leer la salida completa

### Versiones del Instalador
- **v1.0.0**: Versión inicial con problemas de rutas relativas
- **v1.0.0-Fixed**: Solucionados problemas de rutas relativas  
- **v1.0.0-v2**: Solucionado problema de cierre inmediato + rutas relativas (Versión recomendada)

## Estructura del Proyecto

```
src/
├── main/
│   ├── java/
│   │   ├── org/example/
│   │   │   └── Main.java          # Clase principal
│   │   └── com/tgcs/impl/
│   │       └── Calculator.java    # Clase calculadora
│   └── resources/
├── test/
└── target/
    ├── InstallerApp-1.0.0.jar                    # JAR ejecutable
    ├── InstallerApp-1.0.0-Windows-Installer-v2.zip # Paquete instalador (más reciente)
    └── installer/
        ├── instalar.bat                          # Script de instalación  
        ├── run-app.bat                           # Script de ejecución corregido
        ├── InstallerApp-1.0.0.jar                # JAR de la aplicación
        └── LEEME.txt                             # Instrucciones para usuarios
```

## Características del Instalador

- **Tipo**: Script de instalación .bat (compatible con todas las versiones de Windows)
- **Ubicación de instalación**: `C:\Program Files\TGCS\InstallerApp`
- **Accesos directos**: Se crean en el menú de inicio y escritorio automáticamente
- **Desinstalación**: Disponible ejecutando `desinstalar.bat` en la carpeta de instalación
- **Verificaciones**: Comprueba automáticamente la presencia de Java y los archivos necesarios

## Ejecutar la aplicación

Después de la instalación, puedes ejecutar la aplicación desde:
- Menú de inicio > InstallerApp
- Acceso directo en el escritorio
- Línea de comandos: `InstallerApp`

## Funcionalidades

La aplicación incluye:
- Una clase principal que demuestra el uso de la calculadora
- Una clase `Calculator` con método `sum()` para sumar dos números enteros
- Salida por consola mostrando ejemplos de cálculos
