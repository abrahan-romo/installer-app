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
        System.out.println("¡Bienvenido a InstallerApp v1.0.7-v11!");
        System.out.println("==================================================");
        
        // Crear la ventana principal de la aplicación
        SwingUtilities.invokeLater(() -> createAndShowGUI());
    }
    
    /**
     * Crear y mostrar la interfaz gráfica principal
     */
    private static void createAndShowGUI() {
        JFrame frame = new JFrame("InstallerApp v1.0.7-v11 - Calculadora");
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
        
        // Mostrar popup DEMO con métodos disponibles
        showDemoPopup(frame);
        
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
            "InstallerApp v1.0.7-v11 con Sistema de Actualizaciones Automáticas<br/>" +
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
     * Mostrar popup DEMO con información de métodos disponibles
     */
    private static void showDemoPopup(JFrame parentFrame) {
        String demoMessage = 
            "=== DEMO - InstallerApp v1.0.7-v11 ===\n\n" +
            "✅ MÉTODOS DISPONIBLES EN CALCULATOR.JAVA:\n\n" +
            "🔢 OPERACIONES BÁSICAS:\n" +
            "• sum(int a, int b) - Suma de dos números\n" +
            "• resta(int a, int b) - Resta de dos números\n" +
            "• multiplicacion(int a, int b) - Multiplicación\n" +
            "• division(int a, int b) - División\n\n" +
            "🔢 OPERACIONES AVANZADAS:\n" +
            "• raizCuadrada(int a) - Raíz cuadrada entera\n\n" +
            "🔢 MULTIPLICACIONES ESPECIALES:\n" +
            "• multiplicarPorDos(int a) - Multiplica por 2\n" +
            "• multiplicarPorTres(int a) - Multiplica por 3\n\n" +
            "📊 TOTAL: 7 métodos implementados\n\n" +
            "Esta versión incluye mejoras en el sistema de actualizaciones\n" +
            "y correcciones de PowerShell para Windows.";

        JTextArea textArea = new JTextArea(demoMessage);
        textArea.setEditable(false);
        textArea.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 12));
        textArea.setBackground(parentFrame.getBackground());
        
        JScrollPane scrollPane = new JScrollPane(textArea);
        scrollPane.setPreferredSize(new Dimension(500, 400));
        
        JOptionPane.showMessageDialog(
            parentFrame,
            scrollPane,
            "DEMO - Métodos Calculator v1.0.7-v11",
            JOptionPane.INFORMATION_MESSAGE
        );
    }
    
    /**
     * Ejecutar demostración automática de la calculadora
     */
    private static void runCalculatorDemo(JTextArea demoArea) {
        Calculator calculator = new Calculator();
        
        demoArea.append("=== Demostración de InstallerApp v1.0.7-v11 ===\n");
        demoArea.append("TODOS LOS MÉTODOS IMPLEMENTADOS:\n\n");
        
        // Demostración de suma
        demoArea.append("🔢 SUMA:\n");
        for (int i = 1; i <= 2; i++) {
            int result = calculator.sum(i, i * 2);
            demoArea.append("  sum(" + i + ", " + (i * 2) + ") = " + result + "\n");
        }
        demoArea.append("\n");
        
        // Demostración de resta
        demoArea.append("🔢 RESTA:\n");
        demoArea.append("  resta(10, 3) = " + calculator.resta(10, 3) + "\n");
        demoArea.append("  resta(15, 7) = " + calculator.resta(15, 7) + "\n\n");
        
        // Demostración de multiplicación
        demoArea.append("🔢 MULTIPLICACIÓN:\n");
        demoArea.append("  multiplicacion(4, 5) = " + calculator.multiplicacion(4, 5) + "\n");
        demoArea.append("  multiplicacion(3, 7) = " + calculator.multiplicacion(3, 7) + "\n\n");
        
        // Demostración de división
        demoArea.append("🔢 DIVISIÓN:\n");
        demoArea.append("  division(20, 4) = " + calculator.division(20, 4) + "\n");
        demoArea.append("  division(15, 3) = " + calculator.division(15, 3) + "\n\n");
        
        // Demostración de raíz cuadrada
        demoArea.append("🔢 RAÍZ CUADRADA:\n");
        demoArea.append("  raizCuadrada(16) = " + calculator.raizCuadrada(16) + "\n");
        demoArea.append("  raizCuadrada(25) = " + calculator.raizCuadrada(25) + "\n\n");
        
        // Demostración de multiplicaciones especiales
        demoArea.append("🔢 MULTIPLICACIONES ESPECIALES:\n");
        demoArea.append("  multiplicarPorDos(7) = " + calculator.multiplicarPorDos(7) + "\n");
        demoArea.append("  multiplicarPorTres(5) = " + calculator.multiplicarPorTres(5) + "\n\n");
        
        demoArea.append("=== Demostración completada ===\n");
        demoArea.append("Pruebe la calculadora usando los campos de arriba.\n");
        demoArea.append("Esta versión incluye 7 métodos implementados.\n\n");
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
