# Script de instalador NSIS para la aplicación Java
# Requiere NSIS instalado (https://nsis.sourceforge.io/)

!define APP_NAME "InstallerApp"
!define APP_VERSION "1.0.0"
!define APP_PUBLISHER "TGCS"
!define APP_DESCRIPTION "Aplicación Java con Calculadora"
!define APP_EXE_NAME "InstallerApp.exe"

# Configuración del instalador
Name "${APP_NAME}"
OutFile "target\installer\${APP_NAME}-${APP_VERSION}-Setup.exe"
InstallDir "$PROGRAMFILES\${APP_PUBLISHER}\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "InstallDir"
RequestExecutionLevel admin

# Páginas del instalador
Page directory
Page instfiles

# Páginas del desinstalador
UninstPage uninstConfirm
UninstPage instfiles

# Sección principal de instalación
Section "MainSection" SEC01
    SetOutPath "$INSTDIR"
    
    # Copiar archivos
    File "target\InstallerApp-1.0.0.jar"
    File "installer-resources\run-app.bat"
    File "installer-resources\app-icon.ico"
    
    # Crear acceso directo en el menú de inicio
    CreateDirectory "$SMPROGRAMS\${APP_PUBLISHER}"
    CreateShortCut "$SMPROGRAMS\${APP_PUBLISHER}\${APP_NAME}.lnk" "$INSTDIR\run-app.bat" "" "$INSTDIR\app-icon.ico"
    
    # Crear acceso directo en el escritorio
    CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\run-app.bat" "" "$INSTDIR\app-icon.ico"
    
    # Registrar el desinstalador
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\app-icon.ico"
    
    # Crear el desinstalador
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
    # Guardar la ruta de instalación
    WriteRegStr HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "InstallDir" "$INSTDIR"
SectionEnd

# Sección de desinstalación
Section "Uninstall"
    # Eliminar archivos
    Delete "$INSTDIR\InstallerApp-1.0.0.jar"
    Delete "$INSTDIR\run-app.bat"
    Delete "$INSTDIR\app-icon.ico"
    Delete "$INSTDIR\Uninstall.exe"
    
    # Eliminar accesos directos
    Delete "$SMPROGRAMS\${APP_PUBLISHER}\${APP_NAME}.lnk"
    Delete "$DESKTOP\${APP_NAME}.lnk"
    
    # Eliminar carpetas si están vacías
    RMDir "$SMPROGRAMS\${APP_PUBLISHER}"
    RMDir "$INSTDIR"
    
    # Eliminar entradas del registro
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
    DeleteRegKey HKLM "Software\${APP_PUBLISHER}\${APP_NAME}"
SectionEnd
