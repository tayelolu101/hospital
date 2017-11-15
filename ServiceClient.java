/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package MerchantInformation;

/**
 *
 * @author appdev2
 */
public class ServiceClient {

    

    public static String encrypteData(String in0) {
        MerchantInformation.NibbsFasterPay service = new MerchantInformation.NibbsFasterPay();
        MerchantInformation.INibbsFasterPay port = service.getBasicHttpBindingINibbsFasterPay();
        return port.encrypteData(in0);
    }
    


    public static String decrypteData(String in0) {
        MerchantInformation.NibbsFasterPay service = new MerchantInformation.NibbsFasterPay();
        MerchantInformation.INibbsFasterPay port = service.getBasicHttpBindingINibbsFasterPay();
        return port.decrypteData(in0);
    }
   

}
