package com.zenithbank.banking.coporate.ibank.payment;

import com.zenithbank.banking.coporate.ibank.payment.EmailParametersValue;
import com.zenithbank.banking.ibank.common.BaseAdapter;
import com.zenithbank.banking.ibank.mail.*;
//import com.zenithbank.mailapp.transport;
import java.sql.*;
import java.text.*;
//import com.zenithbank.banking.ibank.account.MessageValue;

public class UtilityProcessor  extends BaseAdapter
{
  public UtilityProcessor()
  {
  }
  
  private Connection conn = null;
  private CallableStatement  cstmt;
  private ResultSet rs = null;
  private Statement s;
  private PreparedStatement ps;
  private Connection liveCon;
  private SimpleDateFormat sd ;

  
  public void sendMail(String MsgBody, EmailParametersValue epv) throws Exception
  {
    try
    {
        
        String MsgToSend =  MsgBody;
        MessageValue msgValue = new MessageValue();
        msgValue.setMailMessage(MsgToSend);
        //msgValue.setMailTo(epv.getToAddress());
        msgValue.setMailTo("okuwa.nwanze@zenithbank.com");
        //msgValue.setMailCC("");
        msgValue.setMailFrom(epv.getFromAddress());
        //msgValue.setMailBC("notify@zenithbank.com");
        msgValue.setMailSubject(epv.getSubject());
        // transport.doSend(msgValue);
        System.out.println("MSg sent");
        //use code below to send attachments
        System.out.println("< MsgToSend > "+msgValue.getMailMessage());
        System.out.println("< epv.getToAddress() > "+msgValue.getMailTo());
        System.out.println("< epv.getFromAddress() > "+msgValue.getMailFrom());
        System.out.println("< epv.getSubject() > "+msgValue.getMailSubject());
        System.out.println("< MsgToSend > "+msgValue.getMailMessage());
        transport.doSend(msgValue);

    }
    catch(Exception exp)
    {
      System.out.println("EXception Occured sending mail >> "+exp.getMessage());
      throw exp;
    }
  }
  
  
    
//Method to get the Ptid for SMS Messages table on Ibank 
    private int getSMSPTID()
      {
      int ptid = -99;
      java.sql.CallableStatement sqlcommand = null;
    
       try
        {
      
          conn = getConnection();
          sqlcommand = conn.prepareCall("{?=call ZENBASENET..zsp_cib_get_ptid(?,?,?,?)}");
          sqlcommand.registerOutParameter(1,Types.INTEGER);
          sqlcommand.setString(2,"zib_sms_messages");
          sqlcommand.setInt(3,1);
          sqlcommand.registerOutParameter(4,Types.INTEGER);
          sqlcommand.registerOutParameter(5,Types.INTEGER);
          sqlcommand.execute();
          int returncode = sqlcommand.getInt(1);
          ptid =  sqlcommand.getInt(4);
          //System.out.println("SMS ptid"+ptid);
      }
      catch(Exception e)
                  {
                      System.out.println(e);
                      e.printStackTrace();
                      System.out.println("Error getSMSPTID: " + e.getMessage());
                    //  System.exit(-1);
                  }
                  finally
                  {
                    try 
                    {
                      if (sqlcommand != null) sqlcommand.close();
                      if (conn != null) conn.close();
                    }
                     catch(Exception e){}
                  }
       return ptid;           
      }
  
    public void sendSMS(String SMSMessage, String MobileNo) throws SQLException, Exception
    {
      try
      {
        int nextPTID = 0;
        nextPTID = getSMSPTID();
        //System.out.println("nextPTID "+nextPTID);
        conn = getConnection();
        String SQLQuery = "INSERT INTO ZENBASENET..zib_sms_messages (ptid, recipient_addr, message, status, create_dt) ";
        SQLQuery += "  VALUES (" + nextPTID + ", '" + MobileNo + "', '" + SMSMessage + "', 'Send', getdate())";
        //System.out.println("<SQLQuery> 1 "+SQLQuery);
        ps = conn.prepareStatement(SQLQuery);
        ps.executeUpdate();
        //System.out.println("<SQLQuery> 2 "+SQLQuery);
      }
      catch(SQLException sqlExp)
      {
        System.out.println("SQL Exception in sendSMS >> "+ sqlExp.getMessage());
        throw sqlExp;
      }
      catch(Exception exp)
      {
        System.out.println("Exception in  sendSMS >> "+ exp.getMessage());
        throw exp;
      }
      finally
      {
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
    }
  
  /* commented to use above method during PHOENIXME conversion - 12072010
  public void sendSMS(String SMSMessage, String MobileNo) throws SQLException, Exception
  {
    try
    {
      conn = getConnection();
      // get next PTID
      String SQLQuery = " exec atm..psp_class_get_ptid 'zib_sms_messages', 1 ";
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      
      int nextPTID = 0;
      if (rs.next())
        nextPTID = rs.getInt(1);
      
      SQLQuery = "INSERT INTO ZENBASENET..zib_sms_messages (ptid, recipient_addr, message, status, create_dt) ";
      SQLQuery += "  VALUES (" + nextPTID + ", '" + MobileNo + "', '" + SMSMessage + "', 'Send', getdate())";
      
      ps = conn.prepareStatement(SQLQuery);
      ps.executeUpdate();
     // System.out.println("<SQLQuery> "+SQLQuery);
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
      throw sqlExp;
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
      throw exp;
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  */
}