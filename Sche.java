/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduler;

import java.util.TimerTask;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author appdev2
 */
public class Sche extends TimerTask {

    volatile Date date;
    volatile String messg = "Remember to call your mum \n Dialing 08166833946...";

    @Override
    public void run() {
        for (int i = 0; i <= 10; i++) {
            System.out.println();

            System.out.println("OPERATIONS OF MAIN THREAD....." + i);
            date = new Date();

            System.out.println("it's " + date);
            System.out.println(messg);
            try {
                Thread.sleep(3000);
            } catch (InterruptedException ex) {
                Logger.getLogger(Sche.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (i == 10) {
                System.out.println();
                System.err.println("TERMINATING APPLICATION..... \n APPLICATION TERMINATED!");
                System.exit(0);
            }
        }

    }

}
