package com.zenithbank.banking.coporate.ibank.payment;


/**
 * @author Ubah john
 * @version 1.0
 */
public class Bank 
{
private String _bankcode;
private String _bankName;
  public Bank()
  {
  }
   /**
   * This constructor takes two variable to initialize the bankcode and the bankname
   * You mus pass the bankCode and the bankName
 */
  public Bank(String bankCode,String bankName)
  {
    _bankcode = bankCode;
    _bankName = bankName;
  }
   /**
    * pass the bankcode to this argument to initialize the bank code
 */
  public void setBankCode(String bankcode)
  {
    _bankcode = bankcode;
  }
  public String getBankCode()
  {
    return _bankcode;
  }
   /**
    * pass the bankName to this argument to initialize the bankname
 */
  public void setBankName(String bankName)
  {
    _bankName = bankName;
  }
   /**
    * get the Bank name
 */
  public String getBankName()
  {
    return _bankName;
  }
}