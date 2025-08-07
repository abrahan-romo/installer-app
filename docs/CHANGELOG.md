# Changelog - InstallerApp

Todas las modificaciones notables de este proyecto se documentan en este archivo.

## [1.0.0-v2] - 2025-08-03

### 🔧 Correcciones Críticas
- **CRÍTICO**: Solucionado problema de cierre inmediato de ventana en `run-app.bat`
  - Script ahora hace pausa siempre al final, no solo en caso de error
  - Eliminada lógica condicional compleja que causaba cierre inmediato
  - Mejorada experiencia de usuario para todas las formas de ejecución
- **Incluye**: Todas las correcciones de la versión Fixed (rutas relativas)

### ✨ Mejoras
- Simplificado script `run-app.bat` para mayor estabilidad
- Mejorados mensajes informativos al usuario
- Comportamiento consistente independientemente del método de ejecución

### 🎯 Funcionalidad Verificada
- ✅ Acceso directo del escritorio mantiene ventana abierta
- ✅ Menú de inicio funciona correctamente
- ✅ Ejecución directa siempre funcional
- ✅ Usuario puede leer toda la salida antes de cerrar

### 📚 Documentación
- Actualizada toda la documentación con el nuevo problema y solución
- Agregadas mejores prácticas para scripts de ejecución
- Expandidas las notas técnicas para desarrolladores

---

## [1.0.0-Fixed] - 2025-08-03

### 🔧 Correcciones Críticas
- **CRÍTICO**: Solucionado problema de rutas relativas en `instalar.bat`
  - Script ahora usa rutas absolutas con `%~dp0`
  - Agregada verificación previa de archivos necesarios
  - Mejorados mensajes de error y debugging

### ✨ Mejoras
- Agregados mensajes informativos durante la instalación
- Implementada verificación robusta de archivos antes de la copia
- Mejorado manejo de errores con códigos de salida específicos

### 📚 Documentación
- Actualizada toda la documentación para reflejar las correcciones
- Agregada sección "Problemas Conocidos y Soluciones" en README.md
- Creado archivo de notas técnicas para desarrolladores
- Documentado el proceso completo de debugging y solución

### 📦 Archivos Afectados
- `target/installer/instalar.bat` - Script corregido
- `target/InstallerApp-1.0.0-Windows-Installer-Fixed.zip` - Paquete corregido
- `README.md` - Actualizado con nuevas instrucciones
- `docs/README.md` - Documentación técnica expandida
- `docs/conversacion.md` - Registro completo del proceso
- `docs/notas-tecnicas.md` - Nuevo archivo con detalles técnicos

### ⚠️ Problemas Conocidos
- Script `run-app.bat` cierra ventana inmediatamente después de ejecución exitosa (solucionado en v1.0.0-v2)

---

## [1.0.0] - 2025-08-02

### ✨ Características Iniciales
- Creada clase `Calculator` con método `sum()`
- Implementada aplicación Java de demostración
- Configurado proyecto Maven con Shade Plugin
- Creado instalador de Windows con scripts .bat

### 🏗️ Configuración del Proyecto
- Configurado `pom.xml` para Java 8 (adaptado desde Java 17 planificado)
- Implementado Maven Shade Plugin para JAR ejecutable
- Creada estructura de directorios estándar

### 📦 Instalador
- Script `instalar.bat` para instalación automática
- Script `run-app.bat` para ejecución de la aplicación
- Creación automática de accesos directos (escritorio y menú inicio)
- Script `desinstalar.bat` para eliminación completa

### 🎯 Funcionalidades
- Aplicación demuestra uso de Calculator con 5 ejemplos
- Verificación automática de Java en el sistema
- Instalación en `C:\Program Files\TGCS\InstallerApp`
- Desinstalación completa disponible

### 📚 Documentación Inicial
- `README.md` con instrucciones básicas
- Scripts de PowerShell para automatización
- Archivo LEEME.txt para usuarios finales

### ⚠️ Problemas Conocidos
- Script de instalación usa rutas relativas (solucionado en v1.0.0-Fixed)
- Puede fallar cuando se ejecuta como administrador (solucionado en v1.0.0-Fixed)
- Script `run-app.bat` cierra ventana inmediatamente (solucionado en v1.0.0-v2)

---

## Historial de Desarrollo

### Decisiones de Diseño

#### Java 8 vs Java 17+
**Decisión**: Usar Java 8 en lugar de Java 17+ planificado inicialmente
**Razón**: Compatibilidad con el entorno de desarrollo existente
**Impacto**: Cambio de estrategia de `jpackage` a scripts personalizados

#### Scripts .bat vs MSI
**Decisión**: Usar scripts .bat en lugar de instaladores MSI nativos
**Razón**: Mayor compatibilidad y simplicidad sin herramientas adicionales
**Impacto**: Instalador funcional pero menos profesional que MSI

#### Maven Shade vs Assembly Plugin
**Decisión**: Usar Maven Shade Plugin para JAR ejecutable
**Razón**: Mejor manejo de dependencias y metadatos
**Impacto**: JAR autocontenido funcional

### Lecciones Aprendidas

1. **Verificar entorno antes de planificar**: La versión de Java disponible determinó la estrategia completa
2. **Probar en condiciones reales**: Los problemas de rutas relativas y cierre de ventana solo se manifestaron en pruebas reales
3. **Documentar todo**: Cada decisión y problema debe documentarse para futuros desarrolladores
4. **Versionar correctamente**: Sufijos descriptivos (-Fixed, -v2) ayudan a identificar versiones
5. **Probar todos los métodos de ejecución**: Accesos directos pueden comportarse diferente que ejecución directa
6. **Considerar experiencia del usuario**: Scripts deben pausar para que usuarios puedan leer salida

### Próximas Versiones Planificadas

#### [1.1.0] - Futuro
- [ ] Migración a PowerShell para mejor manejo de errores
- [ ] Implementación de GUI simple para la aplicación
- [ ] Agregado de más funciones a la clase Calculator

#### [2.0.0] - Futuro
- [ ] Migración a Java 17+ cuando sea posible
- [ ] Implementación de `jpackage` para instaladores nativos
- [ ] Firma digital del instalador para mayor seguridad

#### [2.1.0] - Futuro
- [ ] Sistema de actualizaciones automáticas
- [ ] Instalador con GUI usando WiX Toolset
- [ ] Soporte para múltiples idiomas

---

## Convenciones de Versionado

Este proyecto sigue [Semantic Versioning](https://semver.org/):
- **MAJOR**: Cambios incompatibles en la API
- **MINOR**: Funcionalidad agregada de manera compatible
- **PATCH**: Correcciones de bugs compatibles
- **Sufijos**: -Fixed, -Beta, -RC para versiones especiales

## Contribuciones

Para contribuir a este proyecto:
1. Revisar la documentación en `docs/`
2. Leer las notas técnicas en `docs/notas-tecnicas.md`
3. Seguir las mejores prácticas documentadas
4. Actualizar este changelog con cualquier modificación
