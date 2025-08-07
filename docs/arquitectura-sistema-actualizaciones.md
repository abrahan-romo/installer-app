# Arquitectura del Sistema de Actualizaciones Automáticas

## 📋 Documento Técnico: InstallerApp v1.0.0-v3

**Fecha**: 3 de Agosto, 2025  
**Versión**: 1.0.0-v3  
**Audiencia**: Desarrolladores y Arquitectos de Software  

---

## 🏗️ Arquitectura General

### **Componentes Principales**

```
┌─────────────────────────────────────────────────────────────┐
│                    APLICACIÓN PRINCIPAL                    │
├─────────────────────────────────────────────────────────────┤
│  Main.java (GUI + Coordinador)                             │
│  ├── SwingWorker                                           │
│  ├── Event Handling                                        │
│  └── UpdateChecker Integration                             │
└─────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│              SISTEMA DE ACTUALIZACIONES                    │
├─────────────────────────────────────────────────────────────┤
│  UpdateChecker.java (600+ líneas)                          │
│  ├── GitHub API Client                                     │
│  ├── JSON Parser (Custom)                                  │
│  ├── Download Manager                                      │
│  ├── Installation Manager                                  │
│  ├── Backup System                                         │
│  └── Threading Management                                  │
└─────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 SERVICIOS EXTERNOS                         │
├─────────────────────────────────────────────────────────────┤
│  GitHub Releases API                                       │
│  ├── GET /repos/{owner}/{repo}/releases/latest             │
│  ├── Download Assets                                       │
│  └── Version Comparison                                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Implementación Técnica

### **1. UpdateChecker.java - Componente Central**

#### **Arquitectura Interna**:
```java
public class UpdateChecker {
    // CONFIGURACIÓN
    private static final String GITHUB_API_URL = "...";
    private static final int CONNECTION_TIMEOUT = 10000;
    private static final String CURRENT_VERSION = "1.0.0";
    
    // ESTADO INTERNO
    private boolean updateInProgress = false;
    private String lastCheckedVersion = null;
    private JFrame parentFrame;
    
    // COMPONENTES PRINCIPALES
    private CompletableFuture<Void> updateTask;
    private ThreadPoolExecutor executor;
}
```

#### **Métodos Principales**:

1. **initializeUpdateSystem()**
   - Inicializa el executor thread pool
   - Carga configuración desde updater.properties
   - Programa la primera verificación

2. **checkForUpdatesAsync()**
   - Ejecuta verificación en thread separado
   - No bloquea la UI principal
   - Maneja errores gracefully

3. **performUpdateCheck()**
   - Realiza HTTP GET a GitHub API
   - Parsea respuesta JSON manualmente
   - Compara versiones semánticamente

4. **downloadAndInstallUpdate()**
   - Descarga archivo JAR desde GitHub
   - Valida integridad del archivo
   - Genera script de instalación
   - Ejecuta proceso de actualización

### **2. Integración con Main.java**

#### **Inicialización**:
```java
public class Main {
    private static UpdateChecker updateChecker;
    
    private static void initializeUpdateSystem() {
        updateChecker = new UpdateChecker(frame);
        updateChecker.initializeUpdateSystem();
    }
}
```

#### **Threading Model**:
- **UI Thread**: Maneja la interfaz Swing
- **Update Thread**: Verificaciones y descargas en background
- **Installation Thread**: Proceso de instalación separado

---

## 🌐 Protocolo de Comunicación

### **GitHub Releases API**

#### **Endpoint Principal**:
```
GET https://api.github.com/repos/{owner}/{repo}/releases/latest
```

#### **Respuesta JSON Típica**:
```json
{
  "tag_name": "v1.0.1",
  "name": "InstallerApp v1.0.1",
  "published_at": "2025-08-03T10:00:00Z",
  "assets": [
    {
      "name": "InstallerApp-1.0.1.jar",
      "browser_download_url": "https://github.com/.../InstallerApp-1.0.1.jar",
      "size": 1234567
    }
  ]
}
```

#### **Manejo de Errores HTTP**:
- **200 OK**: Procesamiento normal
- **404 Not Found**: Repositorio no encontrado
- **403 Forbidden**: Rate limit excedido
- **Timeout**: Reintento con backoff exponencial

---

## 🔄 Flujo de Actualización

### **Diagrama de Secuencia**:

```
Usuario    │  Main.java  │  UpdateChecker  │  GitHub API  │  Sistema OS
───────────┼─────────────┼─────────────────┼──────────────┼─────────────
    │      │             │                 │              │
    │ ─────▶ Inicia App  │                 │              │
    │      │             │                 │              │
    │      │ ─────────────▶ checkForUpdates │              │
    │      │             │                 │              │
    │      │             │ ─────────────────▶ GET latest  │
    │      │             │                 │              │
    │      │             │ ◀─────────────── JSON response │
    │      │             │                 │              │
    │      │ ◀─────────── notifyUpdate     │              │
    │      │             │                 │              │
    │ ◀──── Dialog       │                 │              │
    │      │             │                 │              │
    │ ─────▶ "Actualizar"│                 │              │
    │      │             │                 │              │
    │      │ ─────────────▶ downloadUpdate │              │
    │      │             │                 │              │
    │      │             │ ─────────────────▶ Download JAR│
    │      │             │                 │              │
    │      │             │ ◀─────────────── Binary file   │
    │      │             │                 │              │
    │      │             │ ─────────────────────────────────▶ backup.bat
    │      │             │                 │              │
    │      │             │ ─────────────────────────────────▶ update.bat
    │      │             │                 │              │
    │      │ ◀─────────── "Reiniciando..." │              │
    │      │             │                 │              │
    │      │             │ ─────────────────────────────────▶ System.exit(0)
```

### **Estados del Sistema**:

1. **IDLE**: Sistema en espera, verificación programada
2. **CHECKING**: Verificando nuevas versiones en GitHub
3. **UPDATE_AVAILABLE**: Nueva versión detectada, esperando decisión
4. **DOWNLOADING**: Descargando nueva versión
5. **INSTALLING**: Ejecutando proceso de instalación
6. **RESTARTING**: Reiniciando con nueva versión

---

## 📁 Gestión de Archivos

### **Estructura de Directorios**:
```
C:\Program Files\InstallerApp\TGCS\
├── InstallerApp-1.0.0.jar          # JAR principal actual
├── InstallerApp-1.0.0.jar.backup   # Backup automático
├── desinstalar.bat                 # Script de desinstalación
├── temp/
│   ├── InstallerApp-1.0.1.jar      # Nueva versión descargada
│   ├── update.bat                  # Script de instalación
│   └── download.tmp                # Archivo temporal durante descarga
└── logs/
    └── updater.log                 # Logs del sistema (futuro)
```

### **Scripts Generados Dinámicamente**:

#### **update.bat** (Generado automáticamente):
```batch
@echo off
title Actualizando InstallerApp...

echo Actualizando InstallerApp a version %NEW_VERSION%...

REM Esperar a que la aplicacion se cierre
timeout /t 3 /nobreak > nul

REM Crear backup de la version actual
copy "%JAR_PATH%" "%JAR_PATH%.backup"

REM Copiar nueva version
copy "%TEMP_JAR%" "%JAR_PATH%"

REM Limpiar archivos temporales
del "%TEMP_JAR%"

REM Reiniciar aplicacion
start "" java -jar "%JAR_PATH%"

echo Actualizacion completada.
pause
```

---

## 🔐 Seguridad y Validación

### **Validaciones Implementadas**:

1. **Validación de URL**:
   ```java
   if (!url.startsWith("https://")) {
       throw new SecurityException("URL no segura");
   }
   ```

2. **Validación de Archivo**:
   ```java
   if (!downloadedFile.getName().endsWith(".jar")) {
       throw new SecurityException("Tipo de archivo inválido");
   }
   ```

3. **Validación de Tamaño**:
   ```java
   long maxSize = 100 * 1024 * 1024; // 100 MB
   if (file.length() > maxSize) {
       throw new SecurityException("Archivo demasiado grande");
   }
   ```

### **Mejoras de Seguridad Futuras**:
- **Checksum SHA256**: Validación de integridad
- **Firma Digital**: Verificación de autenticidad
- **HTTPS Certificate Pinning**: Mayor seguridad en conexiones
- **Sandbox Execution**: Ejecución aislada de updates

---

## ⚡ Optimizaciones de Rendimiento

### **Threading Strategy**:
```java
// Thread Pool Optimizado
private static final int CORE_THREADS = 2;
private static final int MAX_THREADS = 4;
private static final int KEEP_ALIVE = 60; // segundos

ThreadPoolExecutor executor = new ThreadPoolExecutor(
    CORE_THREADS, MAX_THREADS, KEEP_ALIVE, TimeUnit.SECONDS,
    new LinkedBlockingQueue<>()
);
```

### **Caching y Rate Limiting**:
- **Cache de Versiones**: Evita verificaciones duplicadas
- **Cooldown Period**: Mínimo 1 hora entre verificaciones manuales
- **Connection Pooling**: Reutilización de conexiones HTTP

### **Memory Management**:
- **Stream Processing**: Descarga directa a archivo sin cargar en memoria
- **Weak References**: Para callbacks de UI
- **Explicit Cleanup**: Liberación de recursos en shutdown hooks

---

## 🧪 Testing y Calidad

### **Testing Strategy**:

#### **Unit Tests** (Futuros):
```java
@Test
public void testVersionComparison() {
    assertTrue(UpdateChecker.isNewerVersion("1.0.1", "1.0.0"));
    assertFalse(UpdateChecker.isNewerVersion("1.0.0", "1.0.1"));
}

@Test
public void testGitHubApiParsing() {
    String json = "{\"tag_name\":\"v1.0.1\"}";
    String version = UpdateChecker.parseVersionFromJson(json);
    assertEquals("1.0.1", version);
}
```

#### **Integration Tests**:
- **Mock GitHub API**: Respuestas simuladas
- **File System Tests**: Validación de operaciones de archivo
- **Network Tests**: Manejo de errores de conexión

### **Error Handling**:
```java
try {
    performUpdateCheck();
} catch (IOException e) {
    logger.error("Error de conexión: " + e.getMessage());
    showUserNotification("No se pudo verificar actualizaciones");
} catch (SecurityException e) {
    logger.error("Error de seguridad: " + e.getMessage());
    showUserNotification("Actualización bloqueada por seguridad");
} catch (Exception e) {
    logger.error("Error inesperado: " + e.getMessage());
    showUserNotification("Error inesperado en actualizaciones");
}
```

---

## 📊 Métricas y Monitoreo

### **Métricas Implementadas**:
- **Tiempo de verificación**: Duración de checks de GitHub API
- **Tiempo de descarga**: Velocidad de download por MB
- **Tasa de éxito**: Porcentaje de actualizaciones exitosas
- **Errores**: Tracking de tipos de error más comunes

### **Logging Strategy** (Futuro):
```java
// Framework de logging propuesto
private static final Logger logger = LoggerFactory.getLogger(UpdateChecker.class);

logger.info("Iniciando verificación de actualizaciones...");
logger.debug("Conectando a: {}", GITHUB_API_URL);
logger.warn("Rate limit aproximándose: {} requests restantes", remaining);
logger.error("Error descargando archivo: {}", e.getMessage());
```

---

## 🔮 Roadmap Técnico

### **v1.1.0 - Mejoras de Estabilidad**:
- ✅ **Progress Tracking**: Barra de progreso real
- ✅ **Retry Logic**: Reintentos automáticos con backoff
- ✅ **Better Error Messages**: Mensajes más descriptivos para usuarios
- ✅ **Configuration File**: Externalización de configuración

### **v1.2.0 - Seguridad y Validación**:
- 🔐 **SHA256 Checksums**: Validación de integridad de archivos
- 🔏 **Digital Signatures**: Verificación de autenticidad
- 🛡️ **Certificate Pinning**: Mayor seguridad en HTTPS
- 📋 **Audit Logging**: Logs detallados para auditoría

### **v2.0.0 - Arquitectura Moderna**:
- 🚀 **Reactive Programming**: Migración a RxJava/CompletableFuture
- 🌐 **HTTP/2 Support**: Uso de cliente HTTP moderno
- 🎯 **Microservices**: Separación de update service
- 📱 **Cross-Platform**: Soporte para macOS y Linux

---

## 📚 Referencias y Recursos

### **APIs y Documentación**:
- **GitHub API**: https://docs.github.com/en/rest/releases/releases
- **Java CompletableFuture**: Oracle Java Documentation
- **Swing EDT**: Event Dispatch Thread Best Practices

### **Patrones de Diseño Utilizados**:
- **Observer Pattern**: Para notificaciones de UI
- **Strategy Pattern**: Para diferentes tipos de instalación
- **Command Pattern**: Para operaciones de actualización
- **Singleton Pattern**: Para el UpdateChecker instance

### **Librerías y Frameworks**:
- **Java Standard Library**: HTTP, JSON, Threading
- **Swing**: GUI Framework
- **Maven**: Build automation
- **JUnit**: Testing framework (futuro)

---

## 🎯 Conclusiones Técnicas

### **Fortalezas del Diseño**:
✅ **Modularidad**: Componentes bien separados y cohesivos  
✅ **Extensibilidad**: Fácil agregar nuevas fuentes de actualización  
✅ **Robustez**: Manejo comprehensivo de errores  
✅ **Performance**: Operaciones asíncronas no bloquean UI  
✅ **Usabilidad**: Interfaz intuitiva para el usuario final  

### **Áreas de Mejora Identificadas**:
🔄 **Testing**: Mayor cobertura de tests automatizados  
🔄 **Logging**: Sistema de logging más robusto  
🔄 **Configuration**: Más opciones configurables externamente  
🔄 **Security**: Validaciones de seguridad más estrictas  
🔄 **Monitoring**: Métricas y telemetría en producción  

### **Lecciones Aprendidas**:
1. **Threading**: CompletableFuture es excelente para operaciones async
2. **GitHub API**: Es confiable y bien documentada para releases
3. **User Experience**: Notificaciones no intrusivas mejoran adopción
4. **Error Handling**: Rollback automático es crítico para confianza
5. **Documentation**: Documentación clara acelera adopción y mantenimiento

---

*Documento técnico v1.0 - InstallerApp v1.0.0-v3*  
*Última actualización: 3 de Agosto, 2025*
