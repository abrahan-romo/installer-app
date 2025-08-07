# InstallerApp v1.0.1-v5 con Sistema de Actualizaciones Automáticas

## 📋 Descripción del Proyecto

InstallerApp es una aplicación Java que demuestra las mejores prácticas para crear instaladores de aplicaciones de escritorio en Windows con **sistema de actualizaciones automáticas integrado**. El proyecto incluye una calculadora interactiva como funcionalidad principal, un sistema robusto de instalación, **desinstalador completo** y un **sistema completo de actualizaciones automáticas** usando GitHub Releases.

## ✨ Características Principales

- ✅ **Aplicación Java funcional** con interfaz gráfica (Swing) y calculadora interactiva
- ✅ **🔄 Sistema de Actualizaciones Automáticas** integrado con GitHub Releases API
- ✅ **Instalador Windows completo** con scripts batch optimizados
- ✅ **🗑️ Desinstalador completo** con limpieza total del sistema
- ✅ **Accesos directos automáticos** (Escritorio + Menú Inicio)
- ✅ **Detección de Java** y validación de requisitos
- ✅ **Manejo robusto de errores** y rollback automático
- ✅ **Documentación completa** para usuarios y desarrolladores

## 🔄 **NUEVO: Sistema de Actualizaciones Automáticas**

### **Funcionalidades de Actualización**:
- 🎯 **Verificación automática** de nuevas versiones (al inicio + cada 24 horas)
- 📱 **Notificaciones inteligentes** al usuario cuando hay actualizaciones
- 📥 **Descarga automática** desde GitHub Releases
- 🛠️ **Instalación automática** con backup y rollback
- 🔒 **Validación de archivos** y manejo de errores robusto
- 👤 **Control del usuario** - decides cuándo y cómo actualizar

### **Arquitectura de Actualizaciones**:
- **Cliente Integrado**: Sistema embedido en la aplicación principal
- **GitHub Releases**: Servidor de actualizaciones usando GitHub API
- **JSON Parser**: Parser personalizado sin dependencias externas
- **Threading Asíncrono**: No bloquea la interfaz de usuario
- **Scripts de Instalación**: Generación automática de update.bat

## 🎯 Funcionalidad Principal

### **Calculadora Interactiva**:
- **GUI Moderna**: Interfaz gráfica con Swing
- **Operaciones**: Suma de números enteros con validación
- **Demostración**: Ejemplos automáticos al iniciar
- **Interacción**: Campos de entrada personalizables

### **Sistema de Instalación y Desinstalación**:
- **Instalador ZIP**: Extracción simple sin dependencias
- **Script de Instalación**: `instalar.bat` con detección automática
- **🗑️ Desinstalador Completo**: `desinstalar.bat` con limpieza total
- **Accesos Directos**: Creación automática en escritorio y menú inicio
- **Validación**: Verificación de Java y permisos

## 🚀 Inicio Rápido

### **Para Usuarios Finales**:

1. **Descargar** el instalador:
   ```
   InstallerApp-1.0.1-v5-Windows-Installer-TGCS.zip
   ```

2. **Extraer** los archivos en una carpeta temporal

3. **Ejecutar** el instalador como administrador:
   ```cmd
   instalar.bat
   ```

4. **Usar** la aplicación desde los accesos directos creados

5. **Desinstalar** (si es necesario):
   ```cmd
   desinstalar.bat
   ```

### **Para Desarrolladores**:

1. **Clonar** el repositorio:
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd installer_pull_updates
   ```

2. **Compilar** la aplicación:
   ```bash
   mvn clean package
   ```

3. **Ejecutar** desde el JAR:
   ```bash
   java -jar target/InstallerApp-1.0.1.jar
   ```

4. **Crear** nuevo instalador:
   ```bash
   powershell -File crear-instalador-final.ps1
   ```

## 🛠️ Requisitos del Sistema

### **Para Usuarios**:
- **Sistema Operativo**: Windows 7, 8, 10, 11
- **Java Runtime**: JRE 8 o superior
- **Memoria**: Mínimo 256 MB RAM
- **Espacio**: 50 MB libres en disco
- **Internet**: Para verificar actualizaciones (opcional)

### **Para Desarrollo**:
- **JDK**: Java Development Kit 8 o superior
- **Maven**: Apache Maven 3.6+
- **Git**: Para control de versiones
- **Editor**: VS Code, IntelliJ IDEA, o similar

## 📁 Estructura del Proyecto

```
installer_pull_updates/
├── 📁 src/main/java/
│   ├── 📁 org/example/
│   │   ├── 📄 Main.java                    # Aplicación principal con GUI
│   │   └── 📁 updater/
│   │       └── 📄 UpdateChecker.java       # Sistema de actualizaciones
│   └── 📁 com/tgcs/impl/
│       └── 📄 Calculator.java              # Lógica de calculadora
├── 📁 src/main/resources/
│   └── 📄 updater.properties              # Configuración de updates
├── 📁 installer-resources/
│   ├── 📄 run-app.bat                     # Script de ejecución
│   └── 📄 desinstalar.bat                # Script de desinstalación
├── 📁 target/
│   ├── 📄 InstallerApp-1.0.1.jar         # JAR ejecutable
│   └── 📄 InstallerApp-1.0.1-v5-Windows-Installer-TGCS.zip # Instalador completo
├── 📁 docs/
│   ├── 📄 propuesta-actualizaciones-automaticas.md
│   ├── 📄 implementacion-actualizaciones.md
│   ├── 📄 implementacion-completada.md
│   └── 📄 conversacion.md
├── 📄 pom.xml                             # Configuración de Maven
├── 📄 crear-instalador-final.ps1         # Script de creación de instalador
└── 📄 README.md                          # Este archivo
```

## 🔧 Configuración del Sistema de Actualizaciones

### **Para Activar en Producción**:

1. **Crear repositorio GitHub**:
   ```bash
   # Crear repositorio público llamado 'installerapp'
   # URL ejemplo: https://github.com/tuusuario/installerapp
   ```

2. **Actualizar configuración**:
   ```java
   // En UpdateChecker.java línea 26:
   private static final String GITHUB_API_URL = 
       "https://api.github.com/repos/abrahan-romo/installer-app/releases/latest";
   ```

3. **Crear primera release**:
   ```bash
   # Crear tag v1.0.2
   git tag v1.0.2
   git push origin v1.0.2
   
   # En GitHub: Create Release + subir JAR como asset
   ```

### **Configuración Avanzada**:
```properties
# En src/main/resources/updater.properties
github.api.url=https://api.github.com/repos/abrahan-romo/installer-app/releases/latest
check.interval.hours=24
auto.check.enabled=true
connection.timeout=10000
```

## 🎮 Uso de la Aplicación

### **Interfaz Principal**:
1. **Calculadora**: Introduce dos números y presiona "Calcular Suma"
2. **Demostración**: Ver ejemplos automáticos en el área de texto
3. **Actualizaciones**: El sistema verifica automáticamente nuevas versiones

### **Actualizaciones**:
1. **Automática**: Se verifican cada 24 horas en background
2. **Notificación**: Aparece un dialog cuando hay actualizaciones
3. **Opciones**: "Actualizar Ahora", "Más Tarde", "Saltar Versión"
4. **Proceso**: Descarga → Validación → Backup → Instalación → Reinicio

### **Métodos de Ejecución**:
- 🖥️ **Acceso directo del escritorio**: `InstallerApp v1.0.1-v5`
- 📁 **Menú inicio**: `Programas > InstallerApp v1.0.1-v5`
- 💻 **Comando directo**: `java -jar InstallerApp-1.0.1.jar`

### **🗑️ Desinstalación Completa**:
- 🔧 **Ejecutar como administrador**: `desinstalar.bat`
- 🧹 **Eliminación completa**: Archivos del programa + enlaces + temporales
- ✅ **Confirmación de usuario**: Solicita confirmación antes de proceder
- 📊 **Reporte detallado**: Muestra progreso paso a paso

## 🐛 Solución de Problemas

### **Problemas Comunes**:

#### **❌ Java no encontrado**:
```
Solución: 
1. Descargar Java desde https://java.com/
2. Reinstalar con permisos de administrador
3. Verificar PATH: java -version
```

#### **❌ Error de permisos al instalar**:
```
Solución:
1. Ejecutar instalar.bat como administrador
2. Verificar permisos en C:\Program Files\
3. Usar directorio alternativo si es necesario
```

#### **❌ Actualizaciones no funcionan**:
```
Solución:
1. Verificar conexión a internet
2. Comprobar configuración de proxy/firewall
3. Reiniciar aplicación para forzar verificación
```

#### **❌ Ventana se cierra inmediatamente**:
```
Solución:
✅ SOLUCIONADO en v1.0.1-v5
Este problema ha sido corregido completamente.
```

#### **❌ Directorio de instalación incorrecto**:
```
Problema (versiones anteriores):
- Instalaba en: C:\Program Files\InstallerApp (INCORRECTO)

Solución (v1.0.1-v5 actual):
✅ CORREGIDO: Ahora instala en C:\Program Files\InstallerApp\TGCS
✅ AGREGADO: Desinstalador incluido (desinstalar.bat)
✅ ACTUALIZADO: UpdateChecker usa la ruta correcta
✅ MEJORADO: Manejo de errores y rutas absolutas
```

### **Logs y Debugging**:
```bash
# Ver logs en consola al ejecutar:
java -jar InstallerApp-1.0.1.jar

# Logs del sistema de actualizaciones:
[UpdateChecker] Inicializando sistema...
[UpdateChecker] Verificando actualizaciones...
[UpdateChecker] Nueva versión disponible: v1.0.2
```

## 📈 Historial de Versiones

| Versión | Fecha | Características Principales |
|---------|-------|---------------------------|
| **v1.0.1-v5** | 2025-08-06 | 🗑️ **Desinstalador Completo** + 🔧 **Corrección de Versiones** + ✅ **Sistema Estable** |
| v1.0.1-v4 | 2025-08-05 | 🔗 **URL GitHub Corregida** + 🚀 **Actualizaciones Funcionales** |
| v1.0.0-v3 | 2025-08-03 | ✨ **Sistema de Actualizaciones Automáticas** + ✅ **Directorio TGCS Corregido** |
| v1.0.0-v2 | 2025-08-03 | 🔧 Corrección de cierre inmediato de ventana |
| v1.0.0-Fixed | 2025-08-03 | 🔧 Corrección de rutas relativas en instalador |
| v1.0.0 | 2025-08-03 | 🎉 Primera versión con calculadora básica |

## 🔮 Roadmap y Futuras Mejoras

### **v1.0.2 (Próxima)**:
- 🔍 Verificación manual de actualizaciones (botón en UI)
- 📊 Progress bar real durante descarga
- 🔐 Validación de checksums SHA256
- ⚙️ Configuración externa desde updater.properties
- ➖ Operaciones de resta en calculadora

### **v2.0.0 (Futuro)**:
- 🎨 Migración a JavaFX para UI moderna
- 🧮 Calculadora científica avanzada
- 🌐 Soporte multi-idioma
- 📱 Notificaciones del sistema operativo

## 🤝 Contribución

### **Para Contribuir**:
1. **Fork** el repositorio
2. **Crear** rama feature: `git checkout -b feature/nueva-funcionalidad`
3. **Commit** cambios: `git commit -m 'Agregar nueva funcionalidad'`
4. **Push** a la rama: `git push origin feature/nueva-funcionalidad`
5. **Crear** Pull Request

### **Guidelines**:
- ✅ Mantener compatibilidad con Java 8+
- ✅ Incluir tests para nuevas funcionalidades
- ✅ Actualizar documentación correspondiente
- ✅ Seguir convenciones de código existentes

## 📚 Documentación Adicional

### **Para Usuarios**:
- 📄 `target/installer-v1.0.1-v5-TGCS/LEEME.txt` - Guía de instalación completa
- 📄 `docs/conversacion.md` - Historial de desarrollo

### **Para Desarrolladores**:
- 📄 `docs/propuesta-actualizaciones-automaticas.md` - Análisis técnico
- 📄 `docs/implementacion-actualizaciones.md` - Detalles de implementación
- 📄 `docs/implementacion-completada.md` - Estado final del proyecto

### **Para Gestión de Proyectos**:
- 📄 `docs/notas-tecnicas.md` - Problemas resueltos y lecciones aprendidas
- 📄 `docs/CHANGELOG.md` - Historial detallado de cambios

## 📞 Soporte y Contacto

### **Issues y Bugs**:
- 🐛 Reportar en GitHub Issues (cuando esté disponible)
- 📧 Incluir logs y pasos para reproducir
- 🖥️ Especificar SO y versión de Java

### **Preguntas y Ayuda**:
- 📚 Consultar documentación en `docs/`
- 💬 Discusiones en GitHub Discussions
- 📖 FAQ en LEEME.txt del instalador

## ⚖️ Licencia

Este proyecto está bajo la **Licencia MIT**. Ver archivo `LICENSE` para más detalles.

---

## 🎉 **¡Gracias por usar InstallerApp v1.0.1-v5!**

Esta versión representa un sistema completo y robusto con actualizaciones automáticas, desinstalador integrado y correcciones de estabilidad. Tu aplicación ahora se mantendrá siempre actualizada de forma transparente y se puede desinstalar completamente cuando sea necesario.

**🚀 ¡Disfruta la experiencia completa de instalación, actualización y desinstalación!**

---

*Última actualización: 6 de Agosto, 2025*  
*InstallerApp v1.0.1-v5 con Sistema Completo de Gestión*
