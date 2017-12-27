package com.zenithbank.banking.coporate.ibank.payment;

import com.zenithbank.banking.ibank.common.BaseAdapter;
import com.dwise.util.*;
import java.util.ArrayList;
import java.sql.*;

public class MakePaymentTokenValidation extends BaseAdapter {
    String nextPage = "";
    String checkDigipass = "";
    int alist = -9;
    String DigipassPin = "";
    
    public MakePaymentTokenValidation() {        
    }
    
    com.zenithbank.banking.coporate.ibank.DigipassHostAdapter digipassValidate = new com.zenithbank.banking.coporate.ibank.DigipassHostAdapter();
    com.dwise.util.CryptoManager crypto = new com.dwise.util.CryptoManager();
    
    public String validatePin(String loginId, String accesscode, String tokencode){ 
        String result = "";
        int checkTokenValidate = digipassValidate.Token_authentication(loginId,accesscode);
        System.out.println("processLogin::requesting user authentification :"+System.currentTimeMillis());
        System.out.println( " checkTokenValidate = "+ checkTokenValidate); //30082010     
        
        if( checkTokenValidate > 0 )
        {   
              
              String serialno = digipassValidate.getSerialNo(loginId,accesscode);
              String firstTimeLogon = digipassValidate.getFirstTimeLogin(loginId,accesscode);
              System.out.println("First time login: " + firstTimeLogon);             
              if (firstTimeLogon.trim().equalsIgnoreCase("1"))
              {
                    System.out.println(tokencode.trim());
                    int len = tokencode.trim().length();
                    String DigipassCode = tokencode.trim().substring(len-6);
                    String PinCode = tokencode.trim().substring(0,len-6); 
                    
                    String decryptPin = digipassValidate.encrypt_btn_actionPerformed(PinCode.trim());
                    DigipassPin = digipassValidate.getValidate_PIN(loginId,accesscode);
                        
                    //System.out.println("Digipass: " + DigipassPin);   
                    //System.out.println("Decrypt pin: " + decryptPin);   
                    // check if pin is valid first  
                    if ( decryptPin.trim().equalsIgnoreCase(DigipassPin.trim()) )
                    {                        
                        try{
                            alist = digipassValidate.ValidateToken(loginId,accesscode,serialno,DigipassCode);
                          }catch(Exception e){
                            System.out.println(e.getMessage());
                        }                        
                          System.out.println( "alist: " + alist); //30082010 
                          if (alist == 0 )
                          {
                             result = "success";
                          }
                          else if( alist == 202 )
                          { 
                             result = "disabled";
                          } 
                          else
                          {
                              result = "invalidLogin";
                              System.out.println(" Invalid DigiPass Code for Transfer Authentication. ");
                          } 
                    }
                    else
                    {
                          alist = digipassValidate.ValidateToken(loginId,accesscode,serialno,tokencode);  
                          
                          System.out.println("alist: " + alist); 
                          if (alist == 0 )
                          {
                             result = "success";
                             System.out.println(" Successful Login ");
                          }
                          else if( alist == 202 )
                          {                
                              result = "disabled";
                              System.out.println("  Your Account has been Disabled for failed logons. Please contact E-business Zenith Bank or call 234-1-2784000 for more Infomation. ");            
                          } else {
                              result = "invalidLogin";
                              System.out.println(" Invalid Pin for Authentication Logon. ");
                          } 
                    }
              }
        }
        //if user does not exist in ZIB_CIB_GB_VASCO_TBL,then try new token versions
        else 
        {
                 String tokenStatus = digipassValidate.getTokenStatus(loginId,accesscode);
             //first time login
                String accesscode_loginId = accesscode + "_" + loginId ;
                if ((tokenStatus != null) && (tokenStatus != ""))
                {
                        // first time new version token users or existing users that needs to create pin 
                        if   ((tokencode.length() ==  6 ) && (tokenStatus.trim().equalsIgnoreCase("1") || tokenStatus.trim().equalsIgnoreCase("2")) )
                        {
                        }
                        // new version token existing users trying to logon
                        else if ((tokencode.length() >  6 ) && (tokenStatus.trim().equalsIgnoreCase("2")))
                        {
                        
                            String tokenResult =  digipassValidate.authenticate(accesscode_loginId,tokencode,"");
                            System.out.println("tokenResult ***" + tokenResult);
                            String tokenResultCode = tokenResult.substring(0,2); 
                            if(tokenResultCode.trim().equalsIgnoreCase("00"))
                            {
                                result = "success";
                            }
                            else if  (tokenResultCode.trim().equalsIgnoreCase("01"))    
                            {
                                  if (tokenResult.contains("1009:Digipass User account is disabled"))
                                  {
                                      result = "disabled";
                                      System.out.println("  Your Account has been Disabled for failed logons. Please contact E-product Support Zenith Bank or call 234-1-2784000 for more Infomation. ");            
                                  }
                                  else if (tokenResult.contains("Failed(Weak PIN Not Allowed)"))//25042012
                                  {
                                      result = "weakPin";
                                      System.out.println("  Failed (Weak PIN Not Allowed . ");            
                                  }
                                  else
                                  {
                                      result = "invalidLogin";
                                      System.out.println(" Invalid DigiPass Code for Authentication. ");
                                  }
                             }
                             else
                              {
                                  result = "invalidLogin";
                                  System.out.println(" Invalid DigiPass Code for Authentication. ");
                              }
                        
                   }
                    else if ((tokencode.length() >  6 ) && (tokenStatus.trim().equalsIgnoreCase("1")))
                    {
                        result = "noPin";
                    }
                    else if (tokenStatus.trim().equalsIgnoreCase("3"))
                    {
                        result = "recordNotApproved";
                    }
                    else
                    {
                        result = "invalidLogin";
                        System.out.println(" Invalid DigiPass Code for Authentication. ");
                    } 
                }
            else
            {
                result = "tokenNotAssigned";
            }
            
        }
        return result;
    }
    
}
