package com.zenithbank.banking.coporate.ibank.payment;

public class EmailParametersValue 
{
  public EmailParametersValue()
  {
  }
  
  private String _fromAddress;
  private String _toAddress;
  private String _subject;
  private String _copyAddress;


  public void setFromAddress(String fromAddress)
  {
    _fromAddress = fromAddress;
  }


  public String getFromAddress()
  {
    return _fromAddress;
  }


  public void setToAddress(String toAddress)
  {
    _toAddress = toAddress;
  }


  public String getToAddress()
  {
    return _toAddress;
  }


  public void setSubject(String subject)
  {
    _subject = subject;
  }


  public String getSubject()
  {
    return _subject;
  }


  public void setCopyAddress(String copyAddress)
  {
    _copyAddress = copyAddress;
  }


  public String getCopyAddress()
  {
    return _copyAddress;
  }
  
}