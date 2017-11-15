/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduler;

/**
 *
 * @author appdev2
 */
public class LamdaTest {

    public static void main(String[] args) {

        LamdaTest lam = new LamdaTest();

        final String greet = "hello";

        GreetingService greeting = message
                -> System.out.println(greet + " " + message);

        MathOperation addition = (a, b) -> {
            return (a + b);
        };

        MathOperation subtraction = (a, b) -> {
            return a - b;
        };

        MathOperation Multiply = (a, b) -> {
            return a * b;
        };

        greeting.sayMessage("Tayelolu");

        System.out.println(lam.operate(10, 5, subtraction));
        System.out.println(lam.operate(10, 5, addition));
        System.out.println(lam.operate(10, 5, Multiply));

    }

    interface MathOperation {

        int operation(int a, int b);
    }

    interface GreetingService {

        void sayMessage(String message);
    }

    private int operate(int a, int b, MathOperation mathOperation) {
        return mathOperation.operation(a, b);
    }

}
