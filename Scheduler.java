/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduler;

import java.util.Timer;

/**
 *
 * @author appdev2
 */
public class Scheduler {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {

        try {
            Timer time = new Timer();
            Sche sc = new Sche();
            time.schedule(sc, 0, 3000);
        } catch (Exception e) {
            System.err.println(e);
        }
    }

}
