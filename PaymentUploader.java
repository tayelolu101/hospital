package com.zenithbank.banking.coporate.ibank.payment;
import java.util.*;
public class PaymentUploader 
{
private String fullname;
private String loginid;
private int authlevel;
private Date paymentUploadDate;
  public PaymentUploader()
  {
  }


  public void setFullname(String fullname)
  {
    this.fullname = fullname;
  }


  public String getFullname()
  {
    if(fullname == null)
      return "";
    return fullname;
  }


  public void setLoginid(String loginid)
  {
    this.loginid = loginid;
  }


  public String getLoginid()
  {
    return loginid;
  }


  public void setPaymentUploadDate(Date paymentUploadDate)
  {
    this.paymentUploadDate = paymentUploadDate;
  }


  public Date getPaymentUploadDate()
  {
    return paymentUploadDate;
  }


  public void setAuthlevel(int authlevel)
  {
    this.authlevel = authlevel;
  }


  public int getAuthlevel()
  {
    return authlevel;
  }
}