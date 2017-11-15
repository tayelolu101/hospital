/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package merchantclient;

/**
 *
 * @author appdev2
 */
public class PropLoader {

    public static void main(String[] args) {

        MerchantClient merch = new MerchantClient();
        Thread t1 = new Thread(merch);
        t1.start();

    }
}
