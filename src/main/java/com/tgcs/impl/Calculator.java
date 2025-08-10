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
    
    /**
     * Calculates the subtraction of two integers.
     * 
     * @param a the first integer
     * @param b the second integer
     * @return the subtraction of b from a
     */
    public int resta(int a, int b) {
        return a - b;
    }

    /**
     * Calculates the multiplication of two integers.
     *
     * @param a the first integer
     * @param b the second integer
     * @return the multiplication of a and b
     */
    public int multiplicacion(int a, int b) {
        return a * b;
    }
    
    /**
     * Calculates the division of two integers.
     *
     * @param a the dividend (first integer)
     * @param b the divisor (second integer)
     * @return the result of dividing a by b
     * @throws ArithmeticException if b is zero
     */
    public int division(int a, int b) {
        if (b == 0) {
            throw new ArithmeticException("Cannot divide by zero");
        }
        return a / b;
    }
    /**
     * Calcula la raíz cuadrada entera de un número.
     *
     * @param a el número del que se desea obtener la raíz cuadrada
     * @return la raíz cuadrada entera de a
     * @throws IllegalArgumentException si a es negativo
     */
    public int raizCuadrada(int a) {
        if (a < 0) {
            throw new IllegalArgumentException("No se puede calcular la raíz cuadrada de un número negativo");
        }
        return (int) Math.sqrt(a);
    }

    /**
     * Multiplica el parámetro por 2 y retorna el resultado.
     * @param a el número a multiplicar
     * @return el resultado de a * 2
     */
    public int multiplicarPorDos(int a) {
        return a * 2;
    }
    
}
