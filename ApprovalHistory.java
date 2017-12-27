package com.zenithbank.banking.coporate.ibank.payment;
import java.util.Date;
public class ApprovalHistory 
{
private String status;
private String username;
private int level;
private Date taskdate;
  public ApprovalHistory()
  {
  }


  public void setStatus(String status)
  {
    this.status = status;
  }


  public String getStatus()
  {
    return status;
  }


  public void setUsername(String username)
  {
    this.username = username;
  }


  public String getUsername()
  {
    return username;
  }

  public void setLevel(int level)
  {
    this.level = level;
  }

  public int getLevel()
  {
    return level;
  }

  public void setTaskdate(Date taskdate)
  {
    this.taskdate = taskdate;
  }

  public Date getTaskdate()
  {
    return taskdate;
  }
}