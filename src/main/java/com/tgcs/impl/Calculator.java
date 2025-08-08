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
    
}
