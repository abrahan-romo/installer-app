package org.example.updater;

import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Sistema de actualizaciones automáticas para InstallerApp
 * Integrado con GitHub Releases API
 * 
 * @author InstallerApp Team
 * @version 1.0.0
 * @since 2025-08-03
 */
public class UpdateChecker {
    
    // Configuración del sistema de updates
    private static final String GITHUB_API_URL = "https://api.github.com/repos/abrahan-romo/installer-app/releases/latest";
    private static final String USER_AGENT = "InstallerApp-Updater/1.0";
    private static final String CURRENT_VERSION = "1.0.2";
    private static final int CONNECTION_TIMEOUT_MS = 10000;
    private static final int READ_TIMEOUT_MS = 30000;
    private static final long CHECK_INTERVAL_HOURS = 24;
    
    // Directorios del sistema
    private static final String TEMP_UPDATE_DIR = System.getProperty("java.io.tmpdir") + File.separator + "installerapp-updates" + File.separator;
    private static final String APP_DIR = System.getProperty("user.dir");
    
    // Estado del sistema
    private ScheduledExecutorService scheduler;
    private boolean updateCheckEnabled = true;
    private JFrame parentFrame;
    
    /**
     * Constructor del UpdateChecker
     * @param parentFrame Frame principal de la aplicación para mostrar dialogs
     */
    public UpdateChecker(JFrame parentFrame) {
        this.parentFrame = parentFrame;
        this.scheduler = Executors.newScheduledThreadPool(1);
        
        // Crear directorio temporal si no existe
        createTempDirectory();
    }
    
    /**
     * Inicializar el sistema de actualizaciones
     * Verificar al inicio + programar verificaciones periódicas
     */
    public void initializeUpdateSystem() {
        System.out.println("[UpdateChecker] Inicializando sistema de actualizaciones...");
        
        // Verificación al inicio (asíncrona)
        checkForUpdatesAsync("Verificación al inicio de aplicación");
        
        // Programar verificaciones periódicas
        scheduler.scheduleAtFixedRate(
            () -> checkForUpdatesAsync("Verificación programada"), 
            CHECK_INTERVAL_HOURS, 
            CHECK_INTERVAL_HOURS, 
            TimeUnit.HOURS
        );
        
        System.out.println("[UpdateChecker] Sistema inicializado. Próxima verificación en " + CHECK_INTERVAL_HOURS + " horas.");
    }
    
    /**
     * Verificar actualizaciones de forma asíncrona
     */
    public void checkForUpdatesAsync(String reason) {
        if (!updateCheckEnabled) {
            System.out.println("[UpdateChecker] Verificación deshabilitada. Saltando check.");
            return;
        }
        
        CompletableFuture.runAsync(() -> {
            try {
                System.out.println("[UpdateChecker] Verificando actualizaciones... Motivo: " + reason);
                checkForUpdates();
            } catch (Exception e) {
                System.err.println("[UpdateChecker] Error durante verificación: " + e.getMessage());
                e.printStackTrace();
            }
        });
    }
    
    /**
     * Verificación principal de actualizaciones
     */
    private void checkForUpdates() throws Exception {
        // 1. Conectar a GitHub API
        UpdateInfo updateInfo = fetchLatestReleaseInfo();
        
        if (updateInfo == null) {
            System.out.println("[UpdateChecker] No se pudo obtener información de releases.");
            return;
        }
        
        // 2. Comparar versiones
        if (isNewerVersion(updateInfo.version, CURRENT_VERSION)) {
            System.out.println("[UpdateChecker] Nueva versión disponible: " + updateInfo.version);
            
            // 3. Mostrar notificación al usuario
            SwingUtilities.invokeLater(() -> showUpdateNotification(updateInfo));
        } else {
            System.out.println("[UpdateChecker] Aplicación actualizada. Versión actual: " + CURRENT_VERSION);
        }
    }
    
    /**
     * Obtener información del último release desde GitHub API
     */
    private UpdateInfo fetchLatestReleaseInfo() {
        try {
            System.out.println("[UpdateChecker] Conectando a: " + GITHUB_API_URL);
            URL url = new URL(GITHUB_API_URL);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            
            // Configurar connection
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Accept", "application/vnd.github.v3+json");
            connection.setRequestProperty("User-Agent", USER_AGENT);
            connection.setConnectTimeout(CONNECTION_TIMEOUT_MS);
            connection.setReadTimeout(READ_TIMEOUT_MS);
            
            System.out.println("[UpdateChecker] Headers enviados:");
            System.out.println("  User-Agent: " + USER_AGENT);
            System.out.println("  Accept: application/vnd.github.v3+json");
            
            int responseCode = connection.getResponseCode();
            System.out.println("[UpdateChecker] Response Code: " + responseCode);
            
            if (responseCode != 200) {
                System.err.println("[UpdateChecker] Error HTTP: " + responseCode);
                System.err.println("[UpdateChecker] Response Message: " + connection.getResponseMessage());
                
                // Leer el error response si existe
                try (InputStream errorStream = connection.getErrorStream()) {
                    if (errorStream != null) {
                        String errorResponse = readInputStream(errorStream);
                        System.err.println("[UpdateChecker] Error Response: " + errorResponse);
                    }
                } catch (Exception e) {
                    System.err.println("[UpdateChecker] No se pudo leer error response: " + e.getMessage());
                }
                return null;
            }
            
            // Leer response JSON
            String jsonResponse = readInputStream(connection.getInputStream());
            System.out.println("[UpdateChecker] Response recibido (primeros 500 chars): " + jsonResponse.substring(0, Math.min(500, jsonResponse.length())) + "...");
            
            // DEBUG: Mostrar información clave del JSON
            if (jsonResponse.contains("\"assets\"")) {
                System.out.println("[UpdateChecker] El release contiene sección 'assets'");
            } else {
                System.out.println("[UpdateChecker] ¡PROBLEMA! El release NO contiene sección 'assets'");
            }
            
            // Parsear JSON básico (implementación simple)
            return parseReleaseJson(jsonResponse);
            
        } catch (Exception e) {
            System.err.println("[UpdateChecker] Error obteniendo release info: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Parser simple de JSON para GitHub releases
     * Extrae tag_name y download URL del primer asset
     */
    private UpdateInfo parseReleaseJson(String json) {
        try {
            UpdateInfo info = new UpdateInfo();
            
            // Extraer tag_name (versión)
            String tagNamePattern = "\"tag_name\":\\s*\"([^\"]+)\"";
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(tagNamePattern);
            java.util.regex.Matcher matcher = pattern.matcher(json);
            if (matcher.find()) {
                info.version = matcher.group(1);
            }
            
            // Extraer release notes (body)
            String bodyPattern = "\"body\":\\s*\"([^\"]+)\"";
            pattern = java.util.regex.Pattern.compile(bodyPattern);
            matcher = pattern.matcher(json);
            if (matcher.find()) {
                info.releaseNotes = matcher.group(1).replace("\\n", "\n").replace("\\r", "");
            }
            
            // Extraer download URL del primer asset .jar
            String downloadPattern = "\"browser_download_url\":\\s*\"([^\"]+\\.jar)\"";
            pattern = java.util.regex.Pattern.compile(downloadPattern);
            matcher = pattern.matcher(json);
            if (matcher.find()) {
                info.downloadUrl = matcher.group(1);
            }
            
            // DEBUG: Mostrar todos los assets encontrados
            String allAssetsPattern = "\"browser_download_url\":\\s*\"([^\"]+)\"";
            pattern = java.util.regex.Pattern.compile(allAssetsPattern);
            matcher = pattern.matcher(json);
            System.out.println("[UpdateChecker] Assets encontrados en el release:");
            int assetCount = 0;
            while (matcher.find()) {
                assetCount++;
                String assetUrl = matcher.group(1);
                System.out.println("  Asset " + assetCount + ": " + assetUrl);
            }
            if (assetCount == 0) {
                System.out.println("  ¡No se encontraron assets en el release!");
            }
            
            // Extraer nombre del archivo
            if (info.downloadUrl != null) {
                info.fileName = info.downloadUrl.substring(info.downloadUrl.lastIndexOf("/") + 1);
            }
            
            System.out.println("[UpdateChecker] Parsed: version=" + info.version + ", downloadUrl=" + info.downloadUrl);
            return info;
            
        } catch (Exception e) {
            System.err.println("[UpdateChecker] Error parseando JSON: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Comparar si newVersion es mayor que currentVersion
     * Implementación simple que asume formato x.y.z
     */
    private boolean isNewerVersion(String newVersion, String currentVersion) {
        if (newVersion == null || currentVersion == null) return false;
        
        // Remover prefijo 'v' si existe
        newVersion = newVersion.startsWith("v") ? newVersion.substring(1) : newVersion;
        currentVersion = currentVersion.startsWith("v") ? currentVersion.substring(1) : currentVersion;
        
        String[] newParts = newVersion.split("\\.");
        String[] currentParts = currentVersion.split("\\.");
        
        int maxLength = Math.max(newParts.length, currentParts.length);
        
        for (int i = 0; i < maxLength; i++) {
            int newPart = i < newParts.length ? Integer.parseInt(newParts[i]) : 0;
            int currentPart = i < currentParts.length ? Integer.parseInt(currentParts[i]) : 0;
            
            if (newPart > currentPart) return true;
            if (newPart < currentPart) return false;
        }
        
        return false; // Versiones iguales
    }
    
    /**
     * Mostrar notificación de actualización disponible
     */
    private void showUpdateNotification(UpdateInfo updateInfo) {
        String message = String.format(
            "Nueva versión %s disponible.\n\n" +
            "Versión actual: %s\n" +
            "Nueva versión: %s\n\n" +
            "Mejoras:\n%s\n\n" +
            "¿Desea descargar e instalar la actualización?",
            updateInfo.version,
            CURRENT_VERSION,
            updateInfo.version,
            updateInfo.releaseNotes != null ? updateInfo.releaseNotes : "Ver notas de la versión en GitHub"
        );
        
        String[] options = {"Actualizar Ahora", "Recordar Más Tarde", "Saltar Esta Versión"};
        
        int choice = JOptionPane.showOptionDialog(
            parentFrame,
            message,
            "Actualización Disponible - InstallerApp",
            JOptionPane.YES_NO_CANCEL_OPTION,
            JOptionPane.INFORMATION_MESSAGE,
            null,
            options,
            options[0]
        );
        
        switch (choice) {
            case 0: // Actualizar Ahora
                downloadAndInstallUpdate(updateInfo);
                break;
            case 1: // Recordar Más Tarde
                System.out.println("[UpdateChecker] Usuario eligió 'Recordar Más Tarde'");
                break;
            case 2: // Saltar Esta Versión
                System.out.println("[UpdateChecker] Usuario eligió 'Saltar Esta Versión'");
                // TODO: Implementar lista de versiones saltadas
                break;
            default: // Cerrar dialog
                System.out.println("[UpdateChecker] Dialog cerrado sin selección");
                break;
        }
    }
    
    /**
     * Descargar e instalar actualización
     */
    private void downloadAndInstallUpdate(UpdateInfo updateInfo) {
        CompletableFuture.runAsync(() -> {
            try {
                System.out.println("[UpdateChecker] Iniciando descarga de actualización...");
                
                // 1. Mostrar progress dialog
                SwingUtilities.invokeLater(() -> showProgressDialog("Descargando actualización..."));
                
                // 2. Descargar archivo
                Path downloadedFile = downloadUpdate(updateInfo);
                if (downloadedFile == null) {
                    SwingUtilities.invokeLater(() -> {
                        hideProgressDialog();
                        showErrorDialog("Error durante la descarga. Intente más tarde.");
                    });
                    return;
                }
                
                // 3. Validar archivo (básico)
                if (!validateDownload(downloadedFile)) {
                    SwingUtilities.invokeLater(() -> {
                        hideProgressDialog();
                        showErrorDialog("El archivo descargado está corrupto. Intente más tarde.");
                    });
                    return;
                }
                
                // 4. Preparar instalación
                SwingUtilities.invokeLater(() -> updateProgressDialog("Preparando instalación..."));
                
                boolean installationPrepared = prepareInstallation(downloadedFile, updateInfo);
                
                SwingUtilities.invokeLater(() -> {
                    hideProgressDialog();
                    
                    if (installationPrepared) {
                        showInstallationReadyDialog(updateInfo);
                    } else {
                        showErrorDialog("Error preparando la instalación. Intente más tarde.");
                    }
                });
                
            } catch (Exception e) {
                System.err.println("[UpdateChecker] Error durante actualización: " + e.getMessage());
                e.printStackTrace();
                
                SwingUtilities.invokeLater(() -> {
                    hideProgressDialog();
                    showErrorDialog("Error inesperado durante la actualización: " + e.getMessage());
                });
            }
        });
    }
    
    /**
     * Descargar el archivo de actualización
     */
    private Path downloadUpdate(UpdateInfo updateInfo) {
        try {
            URL downloadUrl = new URL(updateInfo.downloadUrl);
            HttpURLConnection connection = (HttpURLConnection) downloadUrl.openConnection();
            
            connection.setRequestProperty("User-Agent", USER_AGENT);
            connection.setConnectTimeout(CONNECTION_TIMEOUT_MS);
            connection.setReadTimeout(READ_TIMEOUT_MS);
            
            if (connection.getResponseCode() != 200) {
                System.err.println("[UpdateChecker] Error descargando: HTTP " + connection.getResponseCode());
                return null;
            }
            
            // Crear archivo de destino
            Path downloadPath = Paths.get(TEMP_UPDATE_DIR, updateInfo.fileName);
            
            // Descargar con InputStream
            try (InputStream inputStream = connection.getInputStream()) {
                Files.copy(inputStream, downloadPath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            System.out.println("[UpdateChecker] Descarga completada: " + downloadPath);
            return downloadPath;
            
        } catch (Exception e) {
            System.err.println("[UpdateChecker] Error durante descarga: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Validar archivo descargado (verificación básica de tamaño)
     */
    private boolean validateDownload(Path filePath) {
        try {
            long fileSize = Files.size(filePath);
            System.out.println("[UpdateChecker] Validando archivo. Tamaño: " + fileSize + " bytes");
            
            // Verificación básica: archivo debe ser mayor a 1KB
            return fileSize > 1024;
            
        } catch (Exception e) {
            System.err.println("[UpdateChecker] Error validando archivo: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Preparar script de instalación
     */
    private boolean prepareInstallation(Path downloadedFile, UpdateInfo updateInfo) {
        try {
            // Crear script de instalación update.bat
            Path scriptPath = Paths.get(TEMP_UPDATE_DIR, "update.bat");
            
            String currentJarPath = getCurrentJarPath();
            String backupJarPath = currentJarPath + ".backup";
            
            StringBuilder script = new StringBuilder();
            script.append("@echo off\n");
            script.append("echo Instalando InstallerApp ").append(updateInfo.version).append("...\n");
            script.append("echo.\n");
            script.append("\n");
            script.append("REM Esperar 3 segundos para que se cierre la aplicación\n");
            script.append("timeout /t 3 /nobreak >nul\n");
            script.append("\n");
            script.append("REM Crear backup de la versión actual\n");
            script.append("copy \"").append(currentJarPath).append("\" \"").append(backupJarPath).append("\" >nul 2>&1\n");
            script.append("if errorlevel 1 (\n");
            script.append("    echo Error: No se pudo crear backup\n");
            script.append("    pause\n");
            script.append("    exit /b 1\n");
            script.append(")\n");
            script.append("\n");
            script.append("REM Instalar nueva versión\n");
            script.append("copy \"").append(downloadedFile.toString()).append("\" \"").append(currentJarPath).append("\" >nul 2>&1\n");
            script.append("if errorlevel 1 (\n");
            script.append("    echo Error: No se pudo instalar nueva versión\n");
            script.append("    echo Restaurando backup...\n");
            script.append("    copy \"").append(backupJarPath).append("\" \"").append(currentJarPath).append("\" >nul 2>&1\n");
            script.append("    pause\n");
            script.append("    exit /b 1\n");
            script.append(")\n");
            script.append("\n");
            script.append("echo Actualización completada exitosamente!\n");
            script.append("echo Nueva versión: ").append(updateInfo.version).append("\n");
            script.append("echo.\n");
            script.append("echo Reiniciando aplicación...\n");
            script.append("timeout /t 2 /nobreak >nul\n");
            script.append("\n");
            script.append("REM Reiniciar aplicación\n");
            script.append("start \"\" java -jar \"").append(currentJarPath).append("\"\n");
            script.append("\n");
            script.append("REM Limpiar archivos temporales\n");
            script.append("del \"").append(downloadedFile.toString()).append("\" >nul 2>&1\n");
            script.append("del \"").append(scriptPath.toString()).append("\" >nul 2>&1\n");
            script.append("\n");
            script.append("exit\n");
            
            Files.write(scriptPath, script.toString().getBytes());
            
            System.out.println("[UpdateChecker] Script de instalación creado: " + scriptPath);
            return true;
            
        } catch (Exception e) {
            System.err.println("[UpdateChecker] Error preparando instalación: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Obtener path del JAR actual
     */
    private String getCurrentJarPath() {
        try {
            // Intentar obtener el path del JAR actual
            String jarPath = UpdateChecker.class.getProtectionDomain().getCodeSource().getLocation().getPath();
            if (jarPath.endsWith(".jar")) {
                return jarPath;
            }
            
            // Fallback: asumir instalación estándar en TGCS
            return "C:\\Program Files\\InstallerApp\\TGCS\\InstallerApp-" + CURRENT_VERSION + ".jar";
            
        } catch (Exception e) {
            System.err.println("[UpdateChecker] Error obteniendo JAR path: " + e.getMessage());
            return "C:\\Program Files\\InstallerApp\\TGCS\\InstallerApp-" + CURRENT_VERSION + ".jar";
        }
    }
    
    /**
     * Mostrar dialog de instalación lista
     */
    private void showInstallationReadyDialog(UpdateInfo updateInfo) {
        String message = String.format(
            "Actualización descargada y lista para instalar.\n\n" +
            "Versión: %s\n\n" +
            "La aplicación se cerrará, se instalará la actualización\n" +
            "y se reiniciará automáticamente.\n\n" +
            "¿Proceder con la instalación?",
            updateInfo.version
        );
        
        String[] options = {"Instalar Ahora", "Instalar Al Cerrar", "Cancelar"};
        
        int choice = JOptionPane.showOptionDialog(
            parentFrame,
            message,
            "Instalación Lista - InstallerApp",
            JOptionPane.YES_NO_CANCEL_OPTION,
            JOptionPane.QUESTION_MESSAGE,
            null,
            options,
            options[0]
        );
        
        switch (choice) {
            case 0: // Instalar Ahora
                executeInstallation();
                break;
            case 1: // Instalar Al Cerrar
                System.out.println("[UpdateChecker] Instalación programada para el cierre de la aplicación");
                // TODO: Programar instalación para shutdown hook
                break;
            case 2: // Cancelar
                System.out.println("[UpdateChecker] Instalación cancelada por el usuario");
                break;
        }
    }
    
    /**
     * Ejecutar instalación inmediata
     */
    private void executeInstallation() {
        try {
            Path scriptPath = Paths.get(TEMP_UPDATE_DIR, "update.bat");
            
            if (!Files.exists(scriptPath)) {
                showErrorDialog("Script de instalación no encontrado.");
                return;
            }
            
            System.out.println("[UpdateChecker] Ejecutando instalación...");
            
            // Ejecutar script de instalación
            ProcessBuilder pb = new ProcessBuilder("cmd", "/c", scriptPath.toString());
            pb.start();
            
            // Cerrar aplicación
            System.out.println("[UpdateChecker] Cerrando aplicación para instalación...");
            System.exit(0);
            
        } catch (Exception e) {
            System.err.println("[UpdateChecker] Error ejecutando instalación: " + e.getMessage());
            showErrorDialog("Error iniciando instalación: " + e.getMessage());
        }
    }
    
    // === MÉTODOS DE UTILIDAD ===
    
    /**
     * Crear directorio temporal para updates
     */
    private void createTempDirectory() {
        try {
            Path tempDir = Paths.get(TEMP_UPDATE_DIR);
            if (!Files.exists(tempDir)) {
                Files.createDirectories(tempDir);
                System.out.println("[UpdateChecker] Directorio temporal creado: " + tempDir);
            }
        } catch (Exception e) {
            System.err.println("[UpdateChecker] Error creando directorio temporal: " + e.getMessage());
        }
    }
    
    /**
     * Leer InputStream completo como String
     */
    private String readInputStream(InputStream inputStream) throws IOException {
        StringBuilder result = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {
            String line;
            while ((line = reader.readLine()) != null) {
                result.append(line).append("\n");
            }
        }
        return result.toString();
    }
    
    // === MÉTODOS DE UI ===
    
    private JDialog progressDialog;
    private JLabel progressLabel;
    
    private void showProgressDialog(String message) {
        if (progressDialog != null) {
            progressDialog.dispose();
        }
        
        progressDialog = new JDialog(parentFrame, "Actualizando InstallerApp", true);
        progressDialog.setSize(400, 120);
        progressDialog.setLocationRelativeTo(parentFrame);
        progressDialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
        
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        progressLabel = new JLabel(message, JLabel.CENTER);
        panel.add(progressLabel, BorderLayout.CENTER);
        
        JProgressBar progressBar = new JProgressBar();
        progressBar.setIndeterminate(true);
        panel.add(progressBar, BorderLayout.SOUTH);
        
        progressDialog.add(panel);
        progressDialog.setVisible(true);
    }
    
    private void updateProgressDialog(String message) {
        if (progressLabel != null) {
            progressLabel.setText(message);
        }
    }
    
    private void hideProgressDialog() {
        if (progressDialog != null) {
            progressDialog.dispose();
            progressDialog = null;
        }
    }
    
    private void showErrorDialog(String message) {
        JOptionPane.showMessageDialog(
            parentFrame,
            message,
            "Error - InstallerApp Updater",
            JOptionPane.ERROR_MESSAGE
        );
    }
    
    /**
     * Cerrar el sistema de updates
     */
    public void shutdown() {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            System.out.println("[UpdateChecker] Sistema de actualizaciones cerrado.");
        }
    }
    
    /**
     * Habilitar/deshabilitar verificaciones automáticas
     */
    public void setUpdateCheckEnabled(boolean enabled) {
        this.updateCheckEnabled = enabled;
        System.out.println("[UpdateChecker] Verificaciones automáticas: " + (enabled ? "habilitadas" : "deshabilitadas"));
    }
    
    /**
     * Clase interna para información de actualización
     */
    private static class UpdateInfo {
        String version;
        String downloadUrl;
        String fileName;
        String releaseNotes;
        
        @Override
        public String toString() {
            return String.format("UpdateInfo{version='%s', downloadUrl='%s', fileName='%s'}", 
                version, downloadUrl, fileName);
        }
    }
}
