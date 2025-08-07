package org.example;

import com.tgcs.impl.Calculator;
import org.example.updater.UpdateChecker;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class Main {
    private static UpdateChecker updateChecker;
    
    public static void main(String[] args) {
        System.out.println("¡Bienvenido a InstallerApp v1.0.0!");
        System.out.println("==================================================");
        
        // Crear la ventana principal de la aplicación
        SwingUtilities.invokeLater(() -> createAndShowGUI());
    }
    
    /**
     * Crear y mostrar la interfaz gráfica principal
     */
    private static void createAndShowGUI() {
        JFrame frame = new JFrame("InstallerApp v1.0.0 - Calculadora");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(500, 400);
        frame.setLocationRelativeTo(null);
        
        // Crear el panel principal
        JPanel mainPanel = createMainPanel();
        frame.add(mainPanel);
        
        // Configurar cierre de aplicación
        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                shutdownApplication();
            }
        });
        
        // Mostrar la ventana
        frame.setVisible(true);
        
        // Inicializar sistema de actualizaciones después de mostrar la GUI
        initializeUpdateSystem(frame);
        
        System.out.println("[Main] Interfaz gráfica inicializada correctamente.");
    }
    
    /**
     * Crear el panel principal con la funcionalidad de la calculadora
     */
    private static JPanel createMainPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        // Título
        JLabel titleLabel = new JLabel("InstallerApp - Calculadora", JLabel.CENTER);
        titleLabel.setFont(new Font(Font.SANS_SERIF, Font.BOLD, 18));
        panel.add(titleLabel, BorderLayout.NORTH);
        
        // Panel central con calculadora
        JPanel centerPanel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        
        // Campos de entrada
        gbc.gridx = 0; gbc.gridy = 0;
        centerPanel.add(new JLabel("Número 1:"), gbc);
        
        gbc.gridx = 1;
        JTextField num1Field = new JTextField(10);
        num1Field.setText("10");
        centerPanel.add(num1Field, gbc);
        
        gbc.gridx = 0; gbc.gridy = 1;
        centerPanel.add(new JLabel("Número 2:"), gbc);
        
        gbc.gridx = 1;
        JTextField num2Field = new JTextField(10);
        num2Field.setText("20");
        centerPanel.add(num2Field, gbc);
        
        // Botón de cálculo
        gbc.gridx = 0; gbc.gridy = 2;
        gbc.gridwidth = 2;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        JButton calculateButton = new JButton("Calcular Suma");
        centerPanel.add(calculateButton, gbc);
        
        // Resultado
        gbc.gridy = 3;
        JLabel resultLabel = new JLabel("Resultado: ", JLabel.CENTER);
        resultLabel.setFont(new Font(Font.SANS_SERIF, Font.BOLD, 14));
        centerPanel.add(resultLabel, gbc);
        
        panel.add(centerPanel, BorderLayout.CENTER);
        
        // Panel inferior con información
        JPanel bottomPanel = new JPanel(new GridLayout(2, 1, 5, 5));
        
        JTextArea demoArea = new JTextArea(8, 40);
        demoArea.setEditable(false);
        demoArea.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 12));
        demoArea.setBorder(BorderFactory.createTitledBorder("Demostración de la Calculadora"));
        
        // Ejecutar demostración automática
        runCalculatorDemo(demoArea);
        
        JScrollPane scrollPane = new JScrollPane(demoArea);
        bottomPanel.add(scrollPane);
        
        // Panel de información
        JLabel infoLabel = new JLabel(
            "<html><center>" +
            "InstallerApp v1.0.0 con Sistema de Actualizaciones Automáticas<br/>" +
            "La aplicación verificará automáticamente nuevas versiones cada 24 horas" +
            "</center></html>", 
            JLabel.CENTER
        );
        infoLabel.setFont(new Font(Font.SANS_SERIF, Font.ITALIC, 11));
        bottomPanel.add(infoLabel);
        
        panel.add(bottomPanel, BorderLayout.SOUTH);
        
        // Configurar acción del botón
        Calculator calculator = new Calculator();
        calculateButton.addActionListener(e -> {
            try {
                int num1 = Integer.parseInt(num1Field.getText().trim());
                int num2 = Integer.parseInt(num2Field.getText().trim());
                int result = calculator.sum(num1, num2);
                resultLabel.setText("Resultado: " + num1 + " + " + num2 + " = " + result);
                
                // Agregar al área de demostración
                demoArea.append("Usuario: " + num1 + " + " + num2 + " = " + result + "\n");
                demoArea.setCaretPosition(demoArea.getDocument().getLength());
                
            } catch (NumberFormatException ex) {
                resultLabel.setText("Error: Ingrese números válidos");
                JOptionPane.showMessageDialog(
                    centerPanel, 
                    "Por favor ingrese números enteros válidos", 
                    "Error de Entrada", 
                    JOptionPane.ERROR_MESSAGE
                );
            }
        });
        
        return panel;
    }
    
    /**
     * Ejecutar demostración automática de la calculadora
     */
    private static void runCalculatorDemo(JTextArea demoArea) {
        Calculator calculator = new Calculator();
        
        demoArea.append("=== Demostración de InstallerApp v1.0.0 ===\n");
        demoArea.append("Funcionalidad: Calculadora con Suma\n\n");
        
        for (int i = 1; i <= 5; i++) {
            int result = calculator.sum(i, i * 2);
            demoArea.append("Demo " + i + ": " + i + " + " + (i * 2) + " = " + result + "\n");
        }
        
        demoArea.append("\n=== Demostración completada ===\n");
        demoArea.append("Pruebe la calculadora usando los campos de arriba.\n\n");
    }
    
    /**
     * Inicializar el sistema de actualizaciones automáticas
     */
    private static void initializeUpdateSystem(JFrame parentFrame) {
        try {
            System.out.println("[Main] Inicializando sistema de actualizaciones...");
            
            updateChecker = new UpdateChecker(parentFrame);
            updateChecker.initializeUpdateSystem();
            
            System.out.println("[Main] Sistema de actualizaciones inicializado correctamente.");
            
        } catch (Exception e) {
            System.err.println("[Main] Error inicializando sistema de actualizaciones: " + e.getMessage());
            e.printStackTrace();
            
            // Mostrar advertencia al usuario pero continuar sin actualizaciones
            JOptionPane.showMessageDialog(
                parentFrame,
                "Advertencia: No se pudo inicializar el sistema de actualizaciones automáticas.\n" +
                "La aplicación funcionará normalmente, pero no verificará nuevas versiones.\n\n" +
                "Error: " + e.getMessage(),
                "Sistema de Actualizaciones",
                JOptionPane.WARNING_MESSAGE
            );
        }
    }
    
    /**
     * Cerrar la aplicación limpiamente
     */
    private static void shutdownApplication() {
        System.out.println("[Main] Cerrando aplicación...");
        
        // Cerrar sistema de actualizaciones
        if (updateChecker != null) {
            updateChecker.shutdown();
        }
        
        System.out.println("[Main] ¡Aplicación cerrada correctamente!");
        System.exit(0);
    }
}
