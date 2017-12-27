package com.zenithbank.banking.coporate.ibank.payment;

public class UserValue 
{
  public UserValue()
  {
  }
  
  private String _GsmNo;
  private String _emailAddress;
  private String _firstName;
  private String _lastName;
  private String _fullName;


  public void setGsmNo(String GsmNo)
  {
    _GsmNo = GsmNo;
  }


  public String getGsmNo()
  {
    return _GsmNo;
  }


  public void setEmailAddress(String emailAddress)
  {
    _emailAddress = emailAddress;
  }


  public String getEmailAddress()
  {
    return _emailAddress;
  }


  public void setFirstName(String firstName)
  {
    _firstName = firstName;
  }


  public String getFirstName()
  {
    return _firstName;
  }


  public void setLastName(String lastName)
  {
    _lastName = lastName;
  }


  public String getLastName()
  {
    return _lastName;
  }


  public void setFullName(String fullName)
  {
    _fullName = fullName;
  }


  public String getFullName()
  {
    return _fullName;
  }
}