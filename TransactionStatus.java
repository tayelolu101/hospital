package com.zenithbank.banking.coporate.ibank.payment;

public class TransactionStatus 
{
 private double payment_id;
 private int authorizer_id;
 private String status;
 private int approval_level;
 private String rejectReason;
 private String recall;
  public TransactionStatus()
  {
  }

  public void setPayment_id(double payment_id)
  {
    this.payment_id = payment_id;
  }

  public double getPayment_id()
  {
    return payment_id;
  }

  public void setAuthorizer_id(int authorizer_id)
  {
    this.authorizer_id = authorizer_id;
  }


  public int getAuthorizer_id()
  {
    return authorizer_id;
  }


  public void setStatus(String status)
  {
    this.status = status;
  }


  public String getStatus()
  {
    return status;
  }


  public void setApproval_level(int approval_level)
  {
    this.approval_level = approval_level;
  }


  public int getApproval_level()
  {
    return approval_level;
  }


  public void setRejectReason(String rejectReason)
  {
    this.rejectReason = rejectReason;
  }


  public String getRejectReason()
  {
    return rejectReason;
  }


  public void setRecall(String recall)
  {
    this.recall = recall;
  }


  public String getRecall()
  {
    return recall;
  }
}