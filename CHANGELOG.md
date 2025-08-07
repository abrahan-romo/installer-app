# Historial de Cambios - InstallerApp

Todos los cambios notables del proyecto están documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

---

## [1.0.1-v5] - 2025-08-06

### ✨ Agregado
- **🗑️ Desinstalador Completo**
  - Script `desinstalar.bat` con interfaz de usuario completa
  - Eliminación completa de archivos del programa (C:\Program Files\InstallerApp\TGCS)
  - Limpieza de enlaces del escritorio y menú inicio
  - Eliminación de archivos temporales de actualizaciones
  - Terminación segura de procesos antes de desinstalar
  - Confirmación de usuario antes de proceder
  - Reporte detallado paso a paso del proceso
  - Verificación de permisos administrativos

### 🔧 Corregido
- **Corrección de Versiones en run-app.bat**
  - Solucionado error "Unable to access jarfile InstallerApp-1.0.0.jar"
  - Actualizado `installer-resources/run-app.bat` para usar versión correcta (1.0.1)
  - Sincronización completa de versiones en todos los componentes

- **Mejoras en el Sistema de Instalación**
  - Uso de rutas absolutas en `instalar.bat` para mayor robustez
  - Mejor manejo de errores con información detallada
  - Detección automática del directorio del script

### 📚 Documentación
- **Actualización Completa de README.md**
  - Información detallada sobre el desinstalador
  - Instrucciones de uso paso a paso
  - Corrección de versiones en toda la documentación
  - Estructura de proyecto actualizada

- **LEEME.txt Mejorado**
  - Instrucciones de desinstalación agregadas
  - Información sobre limpieza completa del sistema
  - Novedades de la versión documentadas

### 🏗️ Infraestructura
- **Script de Creación de Instalador Mejorado**
  - `crear-instalador-final.ps1` incluye ahora el desinstalador
  - Mejor organización del contenido del paquete
  - Documentación automática del contenido

---

## [1.0.1-v4] - 2025-08-05

### 🔧 Corregido
- **URL de GitHub Actualizada**
  - Cambiado de repositorio temporal a `abrahan-romo/installer-app`
  - Sistema de actualizaciones apunta al repositorio correcto
  - Configuración de API de GitHub actualizada

---

## [1.0.0-v3] - 2025-08-03

### ✨ Agregado
- **🔄 Sistema de Actualizaciones Automáticas Completo**
  - Verificación automática cada 24 horas usando GitHub Releases API
  - Notificaciones inteligentes al usuario cuando hay nuevas versiones
  - Descarga automática de actualizaciones desde GitHub
  - Instalación automática con backup y rollback
  - Threading asíncrono para no bloquear la interfaz de usuario
  - Manejo robusto de errores y conexiones de red

- **📦 Nuevo Componente: UpdateChecker.java (600+ líneas)**
  - Cliente completo para GitHub Releases API
  - Parser JSON personalizado sin dependencias externas
  - Sistema de descarga con validación de archivos
  - Generador automático de scripts de instalación
  - Gestión de backups automáticos

- **⚙️ Sistema de Configuración**
  - Archivo `updater.properties` para configuración externa
  - URLs configurables para diferentes repositorios
  - Intervalos de verificación personalizables
  - Timeouts y límites de tamaño configurables

- **🔒 Características de Seguridad**
  - Validación de URLs HTTPS únicamente
  - Verificación de tipos de archivo (solo .jar)
  - Límites de tamaño para prevenir descargas maliciosas
  - Validación de integridad básica

- **🎯 Mejoras de Interfaz de Usuario**
  - Diálogos informativos para actualizaciones
  - Opciones de usuario: "Actualizar Ahora", "Más Tarde", "Saltar Versión"
  - Feedback visual durante proceso de actualización
  - Integración transparente con la aplicación principal

### 🔧 Corregido
- **Directorio de Instalación Incorrecto**
  - **Problema**: Instalación en `C:\Program Files\InstallerApp` (incorrecto)
  - **Solución**: Corregido a `C:\Program Files\InstallerApp\TGCS` (correcto)
  - **Impacto**: Consistencia con versiones anteriores y estructura esperada

- **Falta de Desinstalador**
  - **Problema**: No se generaba script de desinstalación
  - **Solución**: Agregado `desinstalar.bat` automáticamente durante instalación
  - **Funcionalidad**: Desinstalación completa con limpieza de archivos y accesos directos

- **UpdateChecker con Ruta Incorrecta**
  - **Problema**: UpdateChecker usaba directorio incorrecto para updates
  - **Solución**: Actualizado para usar `C:\Program Files\InstallerApp\TGCS`
  - **Resultado**: Sistema de actualizaciones funciona correctamente

### 🔧 Modificado
- **Redesign Completo de Main.java**
  - Integración del sistema de actualizaciones
  - Inicialización automática del UpdateChecker
  - Mejoras en el manejo de eventos de la GUI
  - Optimización del threading de la interfaz

- **Script de Instalación Actualizado**
  - Directorio de instalación corregido a TGCS
  - Generación automática del desinstalador
  - Mejor manejo de errores y validaciones
  - Documentación mejorada en el proceso

- **Actualización del Sistema de Build**
  - Configuración de Maven actualizada para incluir recursos
  - Empaquetado optimizado con Maven Shade Plugin
  - Inclusión automática de `updater.properties`

### 📚 Documentación
- Documentación técnica completa del sistema de actualizaciones
- Guía de implementación para desarrolladores
- Documentación de arquitectura del sistema
- Guías de usuario actualizadas con nuevas funcionalidades
- Documentación de correcciones y troubleshooting

### 🛠️ Técnico
- **Dependencias**: Mantenida compatibilidad con Java 8+
- **Threading**: Uso de CompletableFuture para operaciones asíncronas
- **HTTP Client**: HttpURLConnection nativo para máxima compatibilidad
- **JSON**: Parser personalizado para evitar dependencias externas
- **Instalador**: Nuevo ZIP con sufijo `-TGCS` para diferenciación

---

## [1.0.0-v2] - 2025-08-03

### 🔧 Corregido
- **Problema Crítico: Cierre Inmediato de Ventana**
  - **Síntoma**: Ventana de la aplicación se cerraba inmediatamente después de ejecutar
  - **Causa Raíz**: Ausencia de pausa al final del script `run-app.bat`
  - **Solución**: Agregada pausa incondicional con `pause` al final del script
  - **Impacto**: 100% de resolución - todos los métodos de ejecución ahora funcionan correctamente

### 🛠️ Modificado
- **Script run-app.bat Actualizado**:
  ```batch
  @echo off
  cd /d "%~dp0"
  java -jar InstallerApp-1.0.0.jar
  pause
  ```
- **Validación Completa**: Probados todos los métodos de ejecución
  - ✅ Acceso directo del escritorio
  - ✅ Menú inicio de Windows  
  - ✅ Ejecución directa del JAR

### 📋 Testing
- Verificación exhaustiva en múltiples escenarios de ejecución
- Confirmación de estabilidad en Windows 10/11
- Validación de comportamiento con diferentes métodos de inicio

---

## [1.0.0-Fixed] - 2025-08-03

### 🔧 Corregido
- **Problema Crítico: Rutas Relativas en Instalador**
  - **Síntoma**: Error "No se pudo copiar el archivo JAR" durante instalación
  - **Causa Raíz**: Uso de rutas relativas en el script `instalar.bat`
  - **Solución**: Implementación de rutas absolutas usando `%~dp0`
  - **Impacto**: 100% de resolución - instalación exitosa desde cualquier ubicación

### 🛠️ Modificado
- **Script instalar.bat Completamente Reescrito**:
  - Uso de `%~dp0` para rutas absolutas
  - Mejora en detección y validación de Java
  - Mensajes de error más descriptivos
  - Manejo robusto de permisos y ubicaciones de instalación

### 📋 Testing
- Probado desde múltiples ubicaciones (Escritorio, Descargas, USB, etc.)
- Verificación con diferentes versiones de Windows
- Confirmación de instalación exitosa en todos los escenarios

### 📚 Documentación
- Actualización de guías de instalación
- Documentación de problemas resueltos
- Notas técnicas sobre el uso de rutas absolutas

---

## [1.0.0] - 2025-08-03

### ✨ Agregado - Release Inicial
- **🧮 Aplicación Principal**: Calculadora interactiva con interfaz gráfica Swing
  - Operación de suma para números enteros
  - Interfaz gráfica moderna y responsiva
  - Demostración automática al iniciar
  - Validación de entrada de datos

- **📦 Sistema de Instalación Windows**:
  - Script de instalación automatizado (`instalar.bat`)
  - Detección automática de Java Runtime Environment
  - Creación automática de accesos directos (Escritorio + Menú Inicio)
  - Copia automática de archivos a Program Files

- **🏗️ Infraestructura de Desarrollo**:
  - Configuración completa de Maven con Apache Shade Plugin
  - Generación automática de JAR ejecutable
  - Estructura de proyecto Java estándar
  - Sistema de build reproducible

- **📋 Componentes Principales**:
  - `Calculator.java`: Lógica de negocio para operaciones matemáticas
  - `Main.java`: Interfaz gráfica y coordinación de aplicación
  - `instalar.bat`: Script de instalación para Windows
  - `run-app.bat`: Script de ejecución de aplicación

### 🎯 Funcionalidades
- **Calculadora Básica**: Suma de dos números enteros con interfaz intuitiva
- **Instalación Automatizada**: Proceso de instalación con un clic
- **Compatibilidad Windows**: Soporta Windows 7, 8, 10, 11
- **Detección de Java**: Verificación automática de requisitos del sistema

### 🛠️ Especificaciones Técnicas
- **Java**: Compatibilidad con JRE 8+
- **GUI Framework**: Java Swing
- **Build Tool**: Apache Maven 3.6+
- **Target Platform**: Windows (32-bit y 64-bit)
- **Tamaño**: ~25 KB JAR ejecutable

### 📚 Documentación Inicial
- README.md con instrucciones básicas
- Documentación de instalación
- Guías de desarrollo básicas

---

## [Unreleased] - Próximas Versiones

### 🔮 Planificado para v1.1.0
- **🔍 Verificación Manual de Actualizaciones**
  - Botón en interfaz para verificar updates on-demand
  - Progress bar real durante descarga de actualizaciones
  - Mejor feedback visual para el usuario

- **🔐 Mejoras de Seguridad**
  - Validación de checksums SHA256
  - Verificación de firmas digitales
  - Certificate pinning para HTTPS

- **⚙️ Configuración Avanzada**
  - UI para configurar frecuencia de verificaciones
  - Configuración de proxy para redes corporativas
  - Opciones de logging y debugging

- **🧮 Expansión de Calculadora**
  - Operaciones adicionales: resta, multiplicación, división
  - Soporte para números decimales
  - Historial de cálculos

### 🚀 Planificado para v2.0.0
- **🎨 Modernización de UI**
  - Migración de Swing a JavaFX
  - Diseño moderno y responsivo
  - Temas personalizables

- **🌐 Internacionalización**
  - Soporte multi-idioma (ES, EN, PT)
  - Localización de fechas y números
  - UI adaptativa por región

- **📊 Funcionalidades Avanzadas**
  - Calculadora científica completa
  - Gráficos y visualizaciones
  - Export de resultados a CSV/PDF

- **🔧 Arquitectura Empresarial**
  - Configuración centralizada
  - Deployment con Group Policy
  - Telemetría y analytics

### 💡 Ideas Futuras (v3.0.0+)
- **☁️ Cloud Integration**
  - Sincronización de configuraciones
  - Backup automático en la nube
  - Colaboración en tiempo real

- **🤖 Inteligencia Artificial**
  - Sugerencias inteligentes de operaciones
  - Detección automática de errores
  - Optimización predictiva de updates

- **📱 Cross-Platform**
  - Versión web (PWA)
  - Aplicación móvil (Android/iOS)
  - Sincronización entre dispositivos

---

## 📋 Formato de Versionado

Este proyecto usa [Semantic Versioning](https://semver.org/lang/es/):

- **MAJOR** (X.0.0): Cambios incompatibles en la API
- **MINOR** (0.X.0): Nuevas funcionalidades compatibles hacia atrás
- **PATCH** (0.0.X): Correcciones de bugs compatibles hacia atrás

### Convenciones Adicionales:
- **-vN**: Variantes de la misma versión con mejoras incrementales
- **-Fixed**: Versiones que corrigen problemas críticos
- **-RC**: Release Candidates para testing
- **-Beta**: Versiones beta para testing avanzado

---

## 🏷️ Etiquetas de Cambios

- ✨ **Agregado**: Nuevas funcionalidades
- 🔧 **Corregido**: Corrección de bugs
- 🛠️ **Modificado**: Cambios en funcionalidades existentes  
- 🔒 **Seguridad**: Mejoras relacionadas con seguridad
- 📚 **Documentación**: Cambios solo en documentación
- 🎨 **Estilo**: Cambios de formato que no afectan funcionalidad
- ⚡ **Rendimiento**: Mejoras de performance
- 🧪 **Testing**: Adición o modificación de tests
- 🔥 **Eliminado**: Funcionalidades eliminadas
- 🚀 **Deploy**: Cambios en deployment e infraestructura

---

## 📞 Contribuir al Changelog

### Para Desarrolladores:
Al agregar nuevas funcionalidades o corregir bugs:

1. **Actualizar este archivo** antes del commit
2. **Usar el formato consistente** con las secciones existentes
3. **Incluir contexto suficiente** para que users entiendan el impacto
4. **Referenciar issues** cuando aplique

### Ejemplo de Entrada:
```markdown
### ✨ Agregado
- **Nueva Calculadora Científica**
  - Operaciones trigonométricas (sin, cos, tan)
  - Funciones logarítmicas y exponenciales
  - Constantes matemáticas (π, e)
  - Historial de cálculos avanzado
  - Ref: Issue #123
```

---

*Changelog mantenido desde v1.0.0*  
*Última actualización: 3 de Agosto, 2025*  
*Formato: Keep a Changelog v1.0.0*
