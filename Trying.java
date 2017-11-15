/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduler;

import java.util.logging.Logger;

/**
 *
 * @author appdev2
 */
public class Trying implements Runnable {

    int time = 5000;

    @Override
    @SuppressWarnings("SleepWhileInLoop")

    public void run() {
        Logger logger = Logger.getLogger(this.getClass().getName());
        for (;;) {

            logger.info(String.valueOf(System.currentTimeMillis()));
            int day = 60*60*24;
            System.out.println(day);
            try {
                Thread.sleep(time);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    
    

    public static void main(String[] args) {
        Trying ty = new Trying();
        Thread t1 = new Thread(ty);
        t1.start();

    }

}
