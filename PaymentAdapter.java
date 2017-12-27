package com.zenithbank.banking.coporate.ibank.payment;

import com.zenithbank.banking.coporate.ibank.PaymentUserProfile;
import com.zenithbank.banking.ibank.common.BaseAdapter;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date; 
import java.util.*;
import java.sql.*;
import java.util.ArrayList;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.util.List;
import java.text.*;


public class PaymentAdapter extends BaseAdapter
{
 /*
  private Connection conn = null;
  private CallableStatement  cstmt;
  private ResultSet rs = null;
  private Statement s;
  private PreparedStatement ps;
  private Connection liveCon;
  */
  private SimpleDateFormat sd ;
  //= new java.text.SimpleDateFormat("MM/dd/yyyy");
  private String strToday = null;

  public PaymentAdapter()
  {
  }
  
  public double insertToFileUpload(String FromAccount , String PaymentType , String BeneficiaryLookup , 
                                String VendorAddress, String VendorName, String VendorBank, 
                                String VendorBankBranch, String sCurrency, String PaymentDate, 
                                String PaymentRef, String ClientID, String Username, String ServerFilename) throws SQLException, Exception
  {
    
      Connection conn = null;
      ResultSet rs = null;
      PreparedStatement ps = null;
    try
    {
         
    
      conn = getConnection();
      double newBatchID = 0;
      ps = conn.prepareStatement("SELECT ISNULL(MAX(batchid),1)+1 from ZENBASENET..zib_cib_pmt_fileupload");
      rs = ps.executeQuery();
      if (rs.next())
        newBatchID = rs.getDouble(1);

    
      String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_fileupload (batchid, original_filename," ;	
			SQLQuery += " server_filename,	company_code," ;
			SQLQuery += "	upload_date, upload_operator, batch_status,GROUP_ROLEID) VALUES ";
      SQLQuery += "	(" + newBatchID + ", 'Transaction upload', " ;				
			SQLQuery += "	'" + ServerFilename + "', '" +  ClientID + "', getdate()," ;
			SQLQuery += "	'" + Username + "','',"+Integer.parseInt(VendorName)+" )" ;
      ps = conn.prepareStatement(SQLQuery);
      ps.executeUpdate();
      return newBatchID;
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
      throw sqlExp;
    }
    catch(Exception exp)
    {
      System.out.println("Exception ***** >> "+ exp.getMessage());
      throw exp;
    }
    finally
    {
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(ps != null)
           try  { ps.close();} catch(Exception e) {}
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  
  public double getBatchID(String strServerFilename, String ClientID) throws SQLException, Exception
  {
      Connection conn = null;
      ResultSet rs = null;
      Statement s = null;
      //PreparedStatement ps;
    try
    {
      conn = getConnection();
      String SQLQuery = "SELECT batchid FROM ZENBASENET..zib_cib_pmt_fileupload " ;	
      SQLQuery += " WHERE company_code =  '"+ ClientID+"'" ;	
      SQLQuery += " AND server_filename = '" + strServerFilename + "'" ;	
      
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      
      double batchID = 0.0;
      if (rs.next())
      {
        batchID = rs.getDouble("batchid");
      }
      return batchID;
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
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(s != null)
           try  { s.close();} catch(Exception e) {}
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
   public UserValue[] getUserContactDetails4recallRolegroup(String ClientID, int level,String rolegroupid,String userLoggedIn) throws SQLException, Exception
  {
      Connection conn = null;
      ResultSet rs = null;
      Statement s = null;
      //PreparedStatement ps;
    try
    {
      UserValue[] array = new  UserValue[0];
      UserValue uv = new UserValue();
      ArrayList aList = new ArrayList();
      conn = getConnection();
      String SQLQuery = "SELECT fullname,email,mobile_no FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel <= " + level + " and group_roleid = " +rolegroupid;
      if(!userLoggedIn.trim().equalsIgnoreCase(""))
        SQLQuery += " and loginid <> '"+userLoggedIn.trim()+"'";
      //System.out.println(SQLQuery);
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      
      while (rs.next())
      {
        uv = new UserValue();
        uv.setFullName(rs.getString("fullname"));
        uv.setEmailAddress(rs.getString("email"));
        uv.setGsmNo(rs.getString("mobile_no"));
        
        aList.add(uv);
      }
      array = new UserValue[aList.size()];
      
      return (UserValue[])aList.toArray(array);
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
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(s != null)
           try  { s.close();} catch(Exception e) {}
      
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
   public UserValue[] getUserContactDetails4recall(String ClientID, int level) throws SQLException, Exception
  {
      Connection conn = null;
      ResultSet rs = null;
      Statement s = null;
    try
    {
      UserValue[] array = new  UserValue[0];
      UserValue uv = new UserValue();
      ArrayList aList = new ArrayList();
      conn = getConnection();
      //Exempt people on level zero from getting email for payments rejections
      String SQLQuery = "SELECT fullname,email,mobile_no FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel <= " + level + "  AND Authlevel <> 0 " ;
     // System.out.println(SQLQuery);
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      
      while (rs.next())
      {
        uv = new UserValue();
        uv.setFullName(rs.getString("fullname"));
        uv.setEmailAddress(rs.getString("email"));
        uv.setGsmNo(rs.getString("mobile_no"));
        
        aList.add(uv);
      }
      array = new UserValue[aList.size()];
      
      return (UserValue[])aList.toArray(array);
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
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(s != null)
           try  { s.close();} catch(Exception e) {}
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  
  public UserValue[] getUserContactDetailsRolegroup(String ClientID, int level,String rolegroupid,String userLoggedIn) throws SQLException, Exception
  {
      Connection conn = null;
      ResultSet rs = null;
      Statement s = null;
    try
    {
      UserValue[] array = new  UserValue[0];
      UserValue uv = new UserValue();
      ArrayList aList = new ArrayList();
      conn = getConnection();
      //String SQLQuery = "SELECT * FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level + " and group_roleid = " +rolegroupid;
  String SQLQuery = "SELECT fullname,email,mobile_no FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level + " and (group_roleid = " +rolegroupid + " or group_roleid = -1 )"; //07042010 - To ensure the last authorizer gets email
       if(!userLoggedIn.trim().equalsIgnoreCase(""))
        SQLQuery += " and loginid <> '"+userLoggedIn.trim()+"'";
     // System.out.println(SQLQuery);//07042010
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery); 
      
      while (rs.next())
      {
        uv = new UserValue();
        uv.setFullName(rs.getString("fullname"));
        uv.setEmailAddress(rs.getString("email"));
        uv.setGsmNo(rs.getString("mobile_no"));
        
        aList.add(uv);
      }
      array = new UserValue[aList.size()];
      
      return (UserValue[])aList.toArray(array);
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
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(s != null)
           try  { s.close();} catch(Exception e) {}
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  public UserValue[] getSoleUserContactDetails(int sequenceId) throws SQLException, Exception {      
      Connection conn = null;
      ResultSet rs = null;
      Statement s = null;
      try
      {
          UserValue[] array = new  UserValue[0];
          UserValue uv = new UserValue();
          ArrayList aList = new ArrayList();
          conn = getConnection();
          String SQLQuery = "SELECT fullname,email,mobile_no FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE seq = " + sequenceId +"";            
          s = conn.createStatement();
          rs = s.executeQuery(SQLQuery); 
            
          while (rs.next())
          {
              uv = new UserValue();
              uv.setFullName(rs.getString("fullname"));
              uv.setEmailAddress(rs.getString("email"));
              uv.setGsmNo(rs.getString("mobile_no"));
              aList.add(uv);
          }
          array = new UserValue[aList.size()];
          
          return (UserValue[])aList.toArray(array);
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
          if(rs != null)
             try  { rs.close();} catch(Exception e) {}
          if(s != null)
             try  { s.close();} catch(Exception e) {}
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
  }
  
    public UserValue[] getUserEscalationContactDetailsRolegroup(String ClientID, int level,String rolegroupid,String userLoggedIn,int escalation_level) throws SQLException, Exception
    {
        Connection conn = null;
        ResultSet rs = null;
        Statement s = null;
      try
      {
        UserValue[] array = new  UserValue[0];
        UserValue uv = new UserValue();
        ArrayList aList = new ArrayList();
        conn = getConnection();
        //String SQLQuery = "SELECT * FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level + " and group_roleid = " +rolegroupid;
    String SQLQuery = "SELECT fullname,email,mobile_no FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level + " AND escalation_level = " + escalation_level + " and (group_roleid = " +rolegroupid + " or group_roleid = -1 )"; //07042010 - To ensure the last authorizer gets email
         if(!userLoggedIn.trim().equalsIgnoreCase(""))
          SQLQuery += " and loginid <> '"+userLoggedIn.trim()+"'";
       // System.out.println(SQLQuery);//07042010
        s = conn.createStatement();
        rs = s.executeQuery(SQLQuery); 
        
        while (rs.next())
        {
          uv = new UserValue();
          uv.setFullName(rs.getString("fullname"));
          uv.setEmailAddress(rs.getString("email"));
          uv.setGsmNo(rs.getString("mobile_no"));
          
          aList.add(uv);
        }
        array = new UserValue[aList.size()];
        
        return (UserValue[])aList.toArray(array);
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
          if(rs != null)
             try  { rs.close();} catch(Exception e) {}
          if(s != null)
             try  { s.close();} catch(Exception e) {}
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
    }
  public UserValue[] getUserContactDetails(String ClientID, int level) throws SQLException, Exception
  {
      Connection conn = null;
      ResultSet rs = null;
      Statement s = null;
    try
    {
      UserValue[] array = new  UserValue[0];
      UserValue uv = new UserValue();
      ArrayList aList = new ArrayList();
      conn = getConnection();
      String SQLQuery = "SELECT fullname,email,mobile_no FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level;
     // System.out.println(SQLQuery);
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      
      while (rs.next())
      {
        uv = new UserValue();
        uv.setFullName(rs.getString("fullname"));
        uv.setEmailAddress(rs.getString("email"));
        uv.setGsmNo(rs.getString("mobile_no"));
        
        aList.add(uv);
      }
      array = new UserValue[aList.size()];
      
      return (UserValue[])aList.toArray(array);
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
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(s != null)
           try  { s.close();} catch(Exception e) {}
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  
    public UserValue[] getUserEscalationContactDetails(String ClientID, int level,int escalation_level) throws SQLException, Exception
    {
        Connection conn = null;
        ResultSet rs = null;
        Statement s = null;
      try
      {
        UserValue[] array = new  UserValue[0];
        UserValue uv = new UserValue();
        ArrayList aList = new ArrayList();
        conn = getConnection();
        String SQLQuery = "SELECT fullname,email,mobile_no FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level + " AND escalation_level = " + escalation_level ;
       // System.out.println(SQLQuery);
        s = conn.createStatement();
        rs = s.executeQuery(SQLQuery);
        
        while (rs.next())
        {
          uv = new UserValue();
          uv.setFullName(rs.getString("fullname"));
          uv.setEmailAddress(rs.getString("email"));
          uv.setGsmNo(rs.getString("mobile_no"));
          
          aList.add(uv);
        }
        array = new UserValue[aList.size()];
        
        return (UserValue[])aList.toArray(array);
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
          if(rs != null)
             try  { rs.close();} catch(Exception e) {}
          if(s != null)
             try  { s.close();} catch(Exception e) {}
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
    }
    
    public UserValue getUploaderContactDetail(int batchId) {
        Connection conn = null;
        ResultSet rs = null;
        Statement s = null;
        try {
            String query = "select a.upload_operator,b.email,b.mobile_no,b.authlevel "
                    + "from zib_cib_pmt_fileupload a ,zib_cib_gb_login b "
                    + "where a.batchid =" + batchId + "and a.upload_operator = b.loginid";
            conn = getConnection();
            s = conn.createStatement();
            rs = s.executeQuery(query);

            UserValue uv = null;
            while (rs.next()) {
                uv = new UserValue();
                uv.setEmailAddress(rs.getString("email"));
                uv.setGsmNo(rs.getString("mobile_no"));
            }
            return uv;
        } catch (SQLException sqlExp) {
            System.out.println("SQL Exception >> " + sqlExp.getMessage());
        } finally {
            if (rs != null) try {rs.close();} catch (SQLException e) {}
            if (s != null) try {s.close();} catch (SQLException e) {}
            if (conn != null) try {conn.close();} catch (SQLException e) {}
        }
        return null;
    }
  
  
  public boolean checkTransRefExistence(String company_code,String TransRef) throws SQLException, Exception
  {
      Connection conn = null;
      ResultSet rs = null;
      Statement s = null;
    try
    {
        TransRef = TransRef.replaceAll("'","''");//25032014
      conn = getConnection();
      //String SQLQuery = "SELECT trans_ref from ZENBASENET..zib_cib_pmt_payments WHERE trans_ref = '" + TransRef + "'";
       String SQLQuery = "SELECT trans_ref from ZENBASENET..zib_cib_pmt_payments WHERE company_code = '" + company_code + "'  and trans_ref = '" + TransRef + "'";//08072014
      
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      boolean statusFlag = false;
      if (rs.next()) 
        statusFlag = true;
      else
        statusFlag = false;
      
      return statusFlag;
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
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(s != null)
           try  { s.close();} catch(Exception e) {}
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
   
    public boolean checkTransRefExistence(String TransRef) throws SQLException, Exception
    {
        Connection conn = null;
        ResultSet rs = null;
        Statement s = null;
      try
      {
          TransRef = TransRef.replaceAll("'","''");//25032014
        conn = getConnection();
        String SQLQuery = "SELECT trans_ref from ZENBASENET..zib_cib_pmt_payments WHERE trans_ref = '" + TransRef + "'";
         
        
        s = conn.createStatement();
        rs = s.executeQuery(SQLQuery);
        boolean statusFlag = false;
        if (rs.next()) 
          statusFlag = true;
        else
          statusFlag = false;
        
        return statusFlag;
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
          if(rs != null)
             try  { rs.close();} catch(Exception e) {}
          if(s != null)
             try  { s.close();} catch(Exception e) {}
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
    }
   
   private int getPaymentID()
    {
        Connection conn = null;
        Statement s = null;
        PreparedStatement ps = null;
        
     String qryupdate = "UPDATE ZENBASENET..ZIB_PTID set PTID= PTID + 1 WHERE TABLE_NAME = 'zib_cib_pmt_payments'";
     String qryselect = "SELECT PTID FROM ZENBASENET..ZIB_PTID WHERE TABLE_NAME = 'zib_cib_pmt_payments'";
      ResultSet rst = null;
      int vendor_id=0;
      try
                {
                    conn = getConnection();
                    ps = conn.prepareStatement(qryupdate);
                    ps.executeUpdate();
                }
                catch(Exception e)
                {
                    System.out.println(e);
                    e.printStackTrace();
                    System.out.println("Error getting PTID for batch seq: " + e.getMessage());
                  //  System.exit(-1);
                }
                finally
                {
                    if (ps != null)
                  try 
                  {  ps.close(); }catch(Exception e){}
                   if (conn != null)
                    try 
                    { conn.close(); } catch(Exception e){}
                }
                
                
               try
                {
                    conn = getConnection();
                    s = conn.createStatement();
                    rst = s.executeQuery(qryselect);
                    if(rst.next())
                        vendor_id = rst.getInt(1);
                }
                catch(Exception e)
                {
                    System.out.println(e);
                    e.printStackTrace();
                    System.out.println("Error getting getVendorID: " + e.getMessage());
               //     System.exit(-1);
                }
                finally
                {
                  try 
                  {
                      if (rst != null) rst.close();
                    if (s != null) s.close();
                    if (conn != null) conn.close();
                    
                  }
                   catch(Exception e){}
                }
     return    vendor_id ;        
    }     
  
  private int getPaymentIDProcedure()
    {
    int ptid = -99;
    CallableStatement sqlcommand = null;
    Connection conn = null;
        
     try
                {
    
        conn = getConnection();
        sqlcommand = conn.prepareCall("{?=call ZENBASENET..zsp_cib_get_ptid(?,?,?,?)}");
        sqlcommand.registerOutParameter(1,Types.INTEGER);
        sqlcommand.setString(2,"zib_cib_pmt_payments");
        sqlcommand.setInt(3,1);
        sqlcommand.registerOutParameter(4,Types.INTEGER);
        sqlcommand.registerOutParameter(5,Types.INTEGER);
        sqlcommand.execute();
        int returncode = sqlcommand.getInt(1);
        ptid =  sqlcommand.getInt(4);
        //System.out.println("ptid"+ptid);
    }
    catch(Exception e)
                {
                    System.out.println(e);
                    e.printStackTrace();
                    System.out.println("Error getting getPaymentIDProcedure: " + e.getMessage());
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
    
  public String GetPaymentStatus(PaymentUserProfile profile,PaymentValue pv) {
      String ptystatus = "awaiting approval";
      
      if(   profile.getUserLevel() == profile.getCompanyProcessLevel() && 
            profile.getUserLevel() == 2 && 
            profile.getBeneficiaryValidation().equalsIgnoreCase("N")) 
      {
          ptystatus = "pending";
      }
      
      /*else if(  profile.getUserLevel() == 2 && 
                profile.getBeneficiaryValidation().equalsIgnoreCase("N") && 
                profile.getMultipleUser().equalsIgnoreCase("Y"))
      {
          ptystatus = "pending";
      }      
      //else if(  profile.getUserLevel() != 2 && //corrected 14112012
      else if(  profile.getUserLevel() == 2 && 
                profile.getBeneficiaryValidation().equalsIgnoreCase("Y") && 
                profile.getMultipleUser().equalsIgnoreCase("Y"))
      {
            System.out.println(pv.isIsNewBen());
            if(!pv.isIsNewBen()) {
                String benID = pv.getBenID();
                if(benID != null || !benID.trim().equalsIgnoreCase("")){
                    if(IsApproved(benID).toUpperCase().equalsIgnoreCase("ACTIVE")){
                        ptystatus = "pending";
                    }
                }
            }   
      }*/
      else if(  profile.getUserLevel() == 2 && 
                profile.getStatedLimit() > 0 &&
                pv.getAmount() <= profile.getStatedLimit() &&
                profile.getCompanyProcessLevel() >=2)
      {
          ptystatus = "pending";
      }
      
      
      // Begin- Intra Transfer Payment Status to return pending for Single Payment Menu if Intra Transfer Level is configured
      else if(  pv.getRoutingMethod().equalsIgnoreCase("ZENITH/INTRATRANSFER")  &&
                //profile.getStatedLimit() > 0 && 
                profile.getIntratransfer_authlevel() > 0 &&
               // pv.getAmount() <= profile.getStatedLimit() &&//confirm if necessary to check user limit
                profile.getUserLevel() == profile.getIntratransfer_authlevel() )
      {
          ptystatus = "pending";
      }
      //End - Intra Transfer Payment Status     
      return ptystatus;
  }
  
  
  //27052015
    public String GetIntraTransferPaymentStatus(PaymentUserProfile profile,PaymentValue pv) {
        String ptystatus = "awaiting approval";
        /*
        System.out.println("pv.getRoutingMethod() " + pv.getRoutingMethod());
        System.out.println("profile.getStatedLimit() " + profile.getStatedLimit());
        System.out.println("profile.getIntratransfer_authlevel() " + profile.getIntratransfer_authlevel());
        System.out.println("pv.getAmount() " + pv.getAmount());
        System.out.println("profile.getStatedLimit() " + profile.getStatedLimit());
        System.out.println("profile.getUserLevel() " + profile.getUserLevel());
        */
        
        if(   profile.getUserLevel() == profile.getCompanyProcessLevel() && 
              profile.getUserLevel() == 2 && 
              profile.getBeneficiaryValidation().equalsIgnoreCase("N")) 
        {
            ptystatus = "pending";
        }
        
        /*else if(  profile.getUserLevel() == 2 && 
                  profile.getBeneficiaryValidation().equalsIgnoreCase("N") && 
                  profile.getMultipleUser().equalsIgnoreCase("Y"))
        {
            ptystatus = "pending";
        }      
        //else if(  profile.getUserLevel() != 2 && //corrected 14112012
        else if(  profile.getUserLevel() == 2 && 
                  profile.getBeneficiaryValidation().equalsIgnoreCase("Y") && 
                  profile.getMultipleUser().equalsIgnoreCase("Y"))
        {
              System.out.println(pv.isIsNewBen());
              if(!pv.isIsNewBen()) {
                  String benID = pv.getBenID();
                  if(benID != null || !benID.trim().equalsIgnoreCase("")){
                      if(IsApproved(benID).toUpperCase().equalsIgnoreCase("ACTIVE")){
                          ptystatus = "pending";
                      }
                  }
              }   
        }*/
        
        
        else if(  profile.getUserLevel() == 2 && 
                  profile.getStatedLimit() > 0 &&
                  pv.getAmount() <= profile.getStatedLimit() &&
                  profile.getCompanyProcessLevel() >=2)
        {
            ptystatus = "pending";
        }
        
        /*
        System.out.println("pv.getRoutingMethod() " + pv.getRoutingMethod());
        System.out.println("profile.getStatedLimit() " + profile.getStatedLimit());
        System.out.println("profile.getIntratransfer_authlevel() " + profile.getIntratransfer_authlevel());
        System.out.println("pv.getAmount() " + pv.getAmount());
        System.out.println("profile.getStatedLimit() " + profile.getStatedLimit());
        System.out.println("profile.getUserLevel() " + profile.getUserLevel());
          */                
                          
        //Intra Transfer Payment Status _ Begin
        else if(  pv.getRoutingMethod().equalsIgnoreCase("ZENITH/INTRATRANSFER")  &&
                  //profile.getStatedLimit() > 0 && 
                  profile.getIntratransfer_authlevel() > 0 &&
                 // pv.getAmount() <= profile.getStatedLimit() &&//confirm if necessary to check user limit
                  profile.getUserLevel() == profile.getIntratransfer_authlevel() )
        {
            ptystatus = "pending";
        }
        
        /*
        else if(  pv.getRoutingMethod().equalsIgnoreCase("ZENITH/INTRATRANSFER")  &&
                  profile.getStatedLimit() > 0 && 
                  profile.getIntratransfer_authlevel() > 0 &&
                  pv.getAmount() <= profile.getStatedLimit() &&//confirm if necessary to check user limit
                  profile.getUserLevel() == profile.getCompanyProcessLevel() )
        {
            ptystatus = "pending";
        }
        */
        //Intra Transfer Payment Status _ End    
        return ptystatus;
    }
  
  
  
  
  public String IsApproved(String id){
      String status = "";
      String qryselect = "Select status from zenbasenet..zib_cib_gb_beneficiary where vendor_id="+ id +"";
      //System.out.println(qryselect);
      ResultSet rs = null;
      Connection conn = null;
      Statement s = null;
      
      try{
          conn = getConnection();
          s = conn.createStatement();                   
          rs = s.executeQuery(qryselect);
          if(rs.next())
              status = rs.getString(1);
              
      }catch(Exception e){
          System.out.println(e);
          e.printStackTrace();
          System.out.println("Error getting getVendorID: " + e.getMessage());
      }                
      finally
      {
          try 
          {
              if (rs != null) rs.close();
            if (s != null) s.close();
            if (conn != null) conn.close();
            
          }
       catch(Exception e){}
     }
    return status;
  }
  
  
  /*
  public void insertPayment(PaymentValue pv) throws SQLException, Exception
  {
   
      CallableStatement command = null ;//25042014
      CallableStatement commandAmt = null ;//25042014
      CallableStatement commandProc = null;//25032014
      
      
    try
    {
      PaymentUserProfile profile = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter().GetPaymentProfile(pv.getCompanyId(),pv.getUser_id());
      String ptystatus = GetPaymentStatus(profile,pv);
      
      conn = getConnection();
      
      //String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (payment_id, " ; //commented to use IDENTITY - 14012010
      
      
      //CallableStatement command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?)}");
      command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?)}");//25032014
      command.registerOutParameter(1,Types.INTEGER);
      command.setString(2,pv.getPaymentCurrency());
      command.setString(3,pv.getDebitAccountNo());
      command.setString(4,pv.getAccountCurrency());
      command.setString(5,String.valueOf(pv.getAmount()));         
    
      //command.setString(6,pv.getPmtDueDate());    
      String[] newdate = pv.getPmtDueDate().split("/");
      command.setString(6,new StringBuffer().append(newdate[1]).append("/").append(newdate[0]).append("/").append(newdate[2]).toString());
      
      command.setString(7, pv.getZenithClientID());
      command.execute();
      
      
       if(command.getInt(1) != 0)
       {
           double global_limt = 0;
           try
           {
               // CallableStatement commandAmt = conn.prepareCall("{?=call ZENBASENET..zsp_get_global_limt(?,?)}");//25032014
                commandAmt = conn.prepareCall("{?=call ZENBASENET..zsp_get_global_limt(?,?)}");//25032014
                commandAmt.registerOutParameter(1,Types.DOUBLE);
                commandAmt.setString(2,pv.getZenithClientID());
                commandAmt.setString(3,pv.getPaymentCurrency());
                commandAmt.execute();
                global_limt = commandAmt.getDouble(1);
           }
           catch(Exception ex) 
           {
               
           }
            
            throw new Exception(new StringBuffer().append("Your global limit of ").append(String.valueOf(global_limt)).append(" for ").append(pv.getPmtDueDate()).append(" has exceeded").toString());
       }
            
            String paymentQuery = "{? = call zenbasenet..zsp_cib_ins_payments(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
            
            ////Connection connection  = getConnection();//25032014-unclosed connection,modified to use existing open connection
            //CallableStatement commandProc = connection.prepareCall(paymentQuery);//25032014
            //commandProc = connection.prepareCall(paymentQuery);//25032014
            commandProc = conn.prepareCall(paymentQuery);//25032014
            commandProc.registerOutParameter(1,Types.INTEGER);
            commandProc.setString(2,pv.getZenithClientID());
            commandProc.setDouble(3,pv.getBatchID());
            
            commandProc.setString(4,pv.getVendorName());
            commandProc.setString(5,pv.getVendorAddress());
            commandProc.setString(6,pv.getVendorCity());
            commandProc.setString(7,pv.getVendorState());
            commandProc.setString(8,pv.getVendorPhone());
            commandProc.setString(9,pv.getVendorEmail());
            commandProc.setString(10,pv.getVendorCategory());
            commandProc.setString(11,pv.getVendorCode());
            
            commandProc.setDouble(12,pv.getAmount());
            
            commandProc.setString(13,pv.getPmtDueDate());
            commandProc.setString(14,pv.getPaymentCurrency());
            commandProc.setString(15,pv.getPaymentType());
            commandProc.setString(16,pv.getPaymentMethod());
            
            commandProc.setString(17,pv.getVendorAccountNumber().trim());
            commandProc.setString(18,pv.getVendorBankName());
            commandProc.setString(19,pv.getVendorBankBranchName());
            
            commandProc.setString(20,pv.getContractNo());
            
            commandProc.setString(21,pv.getRoutingMethod());
            commandProc.setString(22,pv.getRoutingBankCode());
            
            commandProc.setString(23,pv.getDebitAccountNo().trim());
            commandProc.setString(24,pv.getAccountCurrency());
            commandProc.setString(25,pv.getAccountName());
            
            commandProc.setString(26,pv.getTransRef());
            commandProc.setString(27,pv.getSortCode());            
            commandProc.setString(28,pv.getIntermediary_bank_name());
            commandProc.setString(29,pv.getIntermediary_bank_acctno());
            commandProc.setString(30,pv.getIntermediary_bank_bic());
            
            commandProc.setInt(31,profile.getUserLevel());   
            commandProc.setDouble(32,pv.getAuthorizerID()); // authorizer id
            commandProc.setString(33, ptystatus);
            commandProc.setString(34, pv.getChargeOption());//09012013
            
            commandProc.registerOutParameter(35,Types.VARCHAR);
            
            commandProc.execute();
            //commandProc.executeQuery();
      
    }
    catch(SQLException sqlExp)
    {
      System.out.println(" SQL Exception >>insertPayment "+ sqlExp.getMessage());
      throw sqlExp;
    }
    catch(Exception exp)
    {
      System.out.println(" Exception >>insertPayment "+ exp.getMessage());
      throw exp;
    }
    finally
    {
     
     //25032014 
      if(command != null)
           try  { command.close();} catch(Exception e) {}
      if(commandAmt != null)
           try  { commandAmt.close();} catch(Exception e) {}   
      if(commandProc != null)
           try  { commandProc.close();} catch(Exception e) {}
     //25032014
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
         
     
    }
  }
   
  */ 
   
   // added from NIBSS e-BillsPay modification
    public void insertPayment(PaymentValue pv)
           throws SQLException, Exception
         {
             
             Connection conn = null;
             Connection connection = null;
             
             CallableStatement command = null ;//25042014
             CallableStatement commandAmt = null ;//25042014
             CallableStatement commandProc = null;//25032014
           try
           {
              //PaymentUserProfile profile = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter().GetPaymentProfile(pv.getCompanyId(),pv.getUser_id());
             PaymentUserProfile profile = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter().GetPaymentProfile(pv.getCompanyId(), pv.getUser_id());
             String ptystatus = GetPaymentStatus(profile, pv);

             conn = getConnection();

             System.out.println(pv.getDebitAccountNo() +  "HI_9_Debug --- zsp_cib_exceed_global_limit begin  ");
             //System.out.println(pv.getPaymentCurrency() + "  " + pv.getDebitAccountNo() + "  " + pv.getAccountCurrency() + "  " + pv.getAmount() + "  " + pv.getPmtDueDate() + "  " + pv.getZenithClientID());
             command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?,?)}");
             command.registerOutParameter(1, 4);
             command.setString(2, pv.getPaymentCurrency());
             command.setString(3, pv.getDebitAccountNo());
             command.setString(4, pv.getAccountCurrency());
             command.setString(5, String.valueOf(pv.getAmount()));

             String[] newdate = pv.getPmtDueDate().split("/");
             command.setString(6, newdate[1] + "/" + newdate[0] + "/" + newdate[2]);
             
            // command.setString(6, pv.getPmtDueDate());    
             command.setString(7, pv.getZenithClientID());
             
             command.setString(8, pv.getPaymentType());//added payment type for ISW limit
             command.execute();

             System.out.println(command.getInt(1));

             if (command.getInt(1) != 0)
             {
                 /*//24102014
               System.out.println("Debug --- zsp_cib_exceed_global_limit successful  ");
              
               double global_limt = 0.0D;
               try
               {
                 System.out.println("Debug --- zsp_get_global_limt begin  ");
                 commandAmt = conn.prepareCall("{?=call ZENBASENET..zsp_get_global_limt(?,?)}");
                 commandAmt.registerOutParameter(1, 8);
                 commandAmt.setString(2, pv.getZenithClientID());
                 commandAmt.setString(3, pv.getPaymentCurrency());
                 commandAmt.execute();
                 global_limt = commandAmt.getDouble(1);
                 System.out.println("Debug --- zsp_get_global_limt end  ");
               }
               catch (Exception ex)
               {
               }

               throw new Exception("Your global limit of " + String.valueOf(global_limt) + " for " + pv.getPmtDueDate() + " has exceeded");
               *///24102014
               
               System.out.println(pv.getDebitAccountNo() + " Your daily transfer limit for " + pv.getPmtDueDate() + " has been exceeded");
                throw new Exception(pv.getDebitAccountNo() + " Your daily transfer limit for " + pv.getPmtDueDate() + " has been exceeded");//24102014
             }

             //System.out.println("Debug --- zsp_cib_ins_payments begin  ");
             String paymentQuery = "{? = call zenbasenet..zsp_cib_ins_payments(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";

             //Connection connection = getConnection();
             connection = getConnection();
             commandProc = connection.prepareCall(paymentQuery);
             commandProc.registerOutParameter(1, 4);
             commandProc.setString(2, pv.getZenithClientID());
             //System.out.println(pv.getZenithClientID());
             commandProc.setDouble(3, pv.getBatchID());
             //System.out.println(pv.getBatchID());

             commandProc.setString(4, pv.getVendorName());
             //System.out.println(pv.getVendorName());
             commandProc.setString(5, pv.getVendorAddress());
             //System.out.println(pv.getVendorAddress());
             commandProc.setString(6, pv.getVendorCity());
             //System.out.println(pv.getVendorCity());
             commandProc.setString(7, pv.getVendorState());
             //System.out.println(pv.getVendorState());
             commandProc.setString(8, pv.getVendorPhone());
             //System.out.println(pv.getVendorPhone());
             commandProc.setString(9, pv.getVendorEmail());
             //System.out.println(pv.getVendorEmail());
             commandProc.setString(10, pv.getVendorCategory());
             //System.out.println(pv.getVendorCategory());
             commandProc.setString(11, pv.getVendorCode());
             //System.out.println(pv.getVendorCode());

             commandProc.setDouble(12, pv.getAmount());
             //System.out.println(pv.getAmount());

             commandProc.setString(13, pv.getPmtDueDate());
             //System.out.println(pv.getPmtDueDate());
             commandProc.setString(14, pv.getPaymentCurrency());
             //System.out.println(pv.getPaymentCurrency());
             commandProc.setString(15, pv.getPaymentType());
             //System.out.println(pv.getPaymentType());
             commandProc.setString(16, pv.getPaymentMethod());
             //System.out.println(pv.getPaymentMethod());

             commandProc.setString(17, pv.getVendorAccountNumber().trim());
             //System.out.println(pv.getVendorAccountNumber().trim());
             commandProc.setString(18, pv.getVendorBankName());
             //System.out.println(pv.getVendorBankName());
             commandProc.setString(19, pv.getVendorBankBranchName());
             //System.out.println(pv.getVendorBankBranchName());

             commandProc.setString(20, pv.getContractNo());
             //System.out.println(pv.getContractNo());

             commandProc.setString(21, pv.getInvoice_number());
             //System.out.println(pv.getInvoice_number());

             commandProc.setString(22, pv.getRoutingMethod());
             //System.out.println(pv.getRoutingMethod());
             commandProc.setString(23, pv.getRoutingBankCode());
             //System.out.println(pv.getRoutingBankCode());

             commandProc.setString(24, pv.getDebitAccountNo().trim());
             //System.out.println(pv.getDebitAccountNo().trim());
             commandProc.setString(25, pv.getAccountCurrency());
             //System.out.println(pv.getAccountCurrency());
             commandProc.setString(26, pv.getAccountName());
             //System.out.println(pv.getAccountName());

             commandProc.setString(27, pv.getTransRef());
             //System.out.println(pv.getTransRef());
             commandProc.setString(28, pv.getSortCode());
             //System.out.println(pv.getSortCode());
             commandProc.setString(29, pv.getIntermediary_bank_name());
             //System.out.println(pv.getIntermediary_bank_name());
             commandProc.setString(30, pv.getIntermediary_bank_acctno());
             //System.out.println(pv.getIntermediary_bank_acctno());
             commandProc.setString(31, pv.getIntermediary_bank_bic());
             //System.out.println(pv.getIntermediary_bank_bic());

             commandProc.setInt(32, profile.getUserLevel());
             //System.out.println(profile.getUserLevel());
             commandProc.setDouble(33, pv.getAuthorizerID());
             //System.out.println(pv.getAuthorizerID());
             commandProc.setString(34, ptystatus);
             //System.out.println(ptystatus);
             commandProc.setString(35, pv.getChargeOption());
             //System.out.println(pv.getChargeOption());
             commandProc.setDouble(36, pv.getCharge_amt());
             //System.out.println(pv.getCharge_amt());

             commandProc.registerOutParameter(37, 12);

             commandProc.execute();
             
             int returnCode = commandProc.getInt(1);
             
             System.out.println("HI_10 returnCode " + returnCode);

             //System.out.println("Debug --- zsp_cib_ins_payments end  ");
           }
           catch (SQLException sqlExp)
           {
             System.out.println( pv.getDebitAccountNo() + " SQL Exception >>insertPayment " + sqlExp.getMessage());
             throw sqlExp;
           }
           catch (Exception exp)
           {
             System.out.println(pv.getDebitAccountNo() + " Exception >>insertPayment " + exp.getMessage());
             throw exp;
           }
           finally
           {
             /*
             if (this.conn != null) 
             try {
                 this.conn.close();
               }
               catch (Exception localException1)
               {
               }
             */  
               
               //25032014 
                if(command != null)
                     try  { command.close();} catch(Exception e) {}
                if(commandAmt != null)
                     try  { commandAmt.close();} catch(Exception e) {}   
                if(commandProc != null)
                     try  { commandProc.close();} catch(Exception e) {}
               //25032014
                if(conn != null)
                   try  { conn.close();} catch(Exception e) {}
               if(connection != null)
                  try  { connection.close();} catch(Exception e) {}
               
           }
         }
      
   
   
    public void insertIntraTransferPayment(PaymentValue pv)
           throws SQLException, Exception
         {
             
             Connection conn = null;
             Connection connection = null;
             
             CallableStatement command = null ;//25042014
             CallableStatement commandAmt = null ;//25042014
             CallableStatement commandProc = null;//25032014
           try
           {
              //PaymentUserProfile profile = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter().GetPaymentProfile(pv.getCompanyId(),pv.getUser_id());
             PaymentUserProfile profile = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter().GetPaymentProfile(pv.getCompanyId(), pv.getUser_id());
             String ptystatus = GetIntraTransferPaymentStatus(profile, pv);

             conn = getConnection();

             System.out.println(pv.getDebitAccountNo() +  "HI_9_Debug --- zsp_cib_exceed_global_limit begin  ");
             
             
             
             //System.out.println(pv.getPaymentCurrency() + "  " + pv.getDebitAccountNo() + "  " + pv.getAccountCurrency() + "  " + pv.getAmount() + "  " + pv.getPmtDueDate() + "  " + pv.getZenithClientID());
             command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?,?)}");
             command.registerOutParameter(1, 4);
             command.setString(2, pv.getPaymentCurrency());
             command.setString(3, pv.getDebitAccountNo());
             command.setString(4, pv.getAccountCurrency());
             command.setString(5, String.valueOf(pv.getAmount()));

             String[] newdate = pv.getPmtDueDate().split("/");
             command.setString(6, newdate[1] + "/" + newdate[0] + "/" + newdate[2]);
             
            // command.setString(6, pv.getPmtDueDate());    
             command.setString(7, pv.getZenithClientID());
             
             command.setString(8, pv.getPaymentType());//added payment type for ISW limit
             command.execute();

             System.out.println(command.getInt(1));

             if (command.getInt(1) != 0)
             {
                 /*//24102014
               System.out.println("Debug --- zsp_cib_exceed_global_limit successful  ");
              
               double global_limt = 0.0D;
               try
               {
                 System.out.println("Debug --- zsp_get_global_limt begin  ");
                 commandAmt = conn.prepareCall("{?=call ZENBASENET..zsp_get_global_limt(?,?)}");
                 commandAmt.registerOutParameter(1, 8);
                 commandAmt.setString(2, pv.getZenithClientID());
                 commandAmt.setString(3, pv.getPaymentCurrency());
                 commandAmt.execute();
                 global_limt = commandAmt.getDouble(1);
                 System.out.println("Debug --- zsp_get_global_limt end  ");
               }
               catch (Exception ex)
               {
               }

               throw new Exception("Your global limit of " + String.valueOf(global_limt) + " for " + pv.getPmtDueDate() + " has exceeded");
               *///24102014
               
               System.out.println(pv.getDebitAccountNo() + " Your daily transfer limit for " + pv.getPmtDueDate() + " has been exceeded");
                throw new Exception(pv.getDebitAccountNo() + " Your daily transfer limit for " + pv.getPmtDueDate() + " has been exceeded");//24102014
             }

             //System.out.println("Debug --- zsp_cib_ins_payments begin  ");
             String paymentQuery = "{? = call zenbasenet..zsp_cib_ins_payments(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";

             //Connection connection = getConnection();
             connection = getConnection();
             commandProc = connection.prepareCall(paymentQuery);
             commandProc.registerOutParameter(1, 4);
             commandProc.setString(2, pv.getZenithClientID());
             //System.out.println(pv.getZenithClientID());
             commandProc.setDouble(3, pv.getBatchID());
             //System.out.println(pv.getBatchID());

             commandProc.setString(4, pv.getVendorName());
             //System.out.println(pv.getVendorName());
             commandProc.setString(5, pv.getVendorAddress());
             //System.out.println(pv.getVendorAddress());
             commandProc.setString(6, pv.getVendorCity());
             //System.out.println(pv.getVendorCity());
             commandProc.setString(7, pv.getVendorState());
             //System.out.println(pv.getVendorState());
             commandProc.setString(8, pv.getVendorPhone());
             //System.out.println(pv.getVendorPhone());
             commandProc.setString(9, pv.getVendorEmail());
             //System.out.println(pv.getVendorEmail());
             commandProc.setString(10, pv.getVendorCategory());
             //System.out.println(pv.getVendorCategory());
             commandProc.setString(11, pv.getVendorCode());
             //System.out.println(pv.getVendorCode());

             commandProc.setDouble(12, pv.getAmount());
             //System.out.println(pv.getAmount());

             commandProc.setString(13, pv.getPmtDueDate());
             //System.out.println(pv.getPmtDueDate());
             commandProc.setString(14, pv.getPaymentCurrency());
             //System.out.println(pv.getPaymentCurrency());
             commandProc.setString(15, pv.getPaymentType());
             //System.out.println(pv.getPaymentType());
             commandProc.setString(16, pv.getPaymentMethod());
             //System.out.println(pv.getPaymentMethod());

             commandProc.setString(17, pv.getVendorAccountNumber().trim());
             //System.out.println(pv.getVendorAccountNumber().trim());
             commandProc.setString(18, pv.getVendorBankName());
             //System.out.println(pv.getVendorBankName());
             commandProc.setString(19, pv.getVendorBankBranchName());
             //System.out.println(pv.getVendorBankBranchName());

             commandProc.setString(20, pv.getContractNo());
             //System.out.println(pv.getContractNo());

             commandProc.setString(21, pv.getInvoice_number());
             //System.out.println(pv.getInvoice_number());

             commandProc.setString(22, pv.getRoutingMethod());
             //System.out.println(pv.getRoutingMethod());
             commandProc.setString(23, pv.getRoutingBankCode());
             //System.out.println(pv.getRoutingBankCode());

             commandProc.setString(24, pv.getDebitAccountNo().trim());
             //System.out.println(pv.getDebitAccountNo().trim());
             commandProc.setString(25, pv.getAccountCurrency());
             //System.out.println(pv.getAccountCurrency());
             commandProc.setString(26, pv.getAccountName());
             //System.out.println(pv.getAccountName());

             commandProc.setString(27, pv.getTransRef());
             //System.out.println(pv.getTransRef());
             commandProc.setString(28, pv.getSortCode());
             //System.out.println(pv.getSortCode());
             commandProc.setString(29, pv.getIntermediary_bank_name());
             //System.out.println(pv.getIntermediary_bank_name());
             commandProc.setString(30, pv.getIntermediary_bank_acctno());
             //System.out.println(pv.getIntermediary_bank_acctno());
             commandProc.setString(31, pv.getIntermediary_bank_bic());
             //System.out.println(pv.getIntermediary_bank_bic());

             commandProc.setInt(32, profile.getUserLevel());
             //System.out.println(profile.getUserLevel());
             commandProc.setDouble(33, pv.getAuthorizerID());
             //System.out.println(pv.getAuthorizerID());
             commandProc.setString(34, ptystatus);
             //System.out.println(ptystatus);
             commandProc.setString(35, pv.getChargeOption());
             //System.out.println(pv.getChargeOption());
             commandProc.setDouble(36, pv.getCharge_amt());
             //System.out.println(pv.getCharge_amt());

             commandProc.registerOutParameter(37, 12);

             commandProc.execute();
             
             int returnCode = commandProc.getInt(1);
             
             System.out.println("HI_10 returnCode " + returnCode);

             //System.out.println("Debug --- zsp_cib_ins_payments end  ");
           }
           catch (SQLException sqlExp)
           {
             System.out.println( pv.getDebitAccountNo() + " SQL Exception >>insertPayment " + sqlExp.getMessage());
             throw sqlExp;
           }
           catch (Exception exp)
           {
             System.out.println(pv.getDebitAccountNo() + " Exception >>insertPayment " + exp.getMessage());
             throw exp;
           }
           finally
           {
             /*
             if (this.conn != null) 
             try {
                 this.conn.close();
               }
               catch (Exception localException1)
               {
               }
             */  
               
               //25032014 
                if(command != null)
                     try  { command.close();} catch(Exception e) {}
                if(commandAmt != null)
                     try  { commandAmt.close();} catch(Exception e) {}   
                if(commandProc != null)
                     try  { commandProc.close();} catch(Exception e) {}
               //25032014
                if(conn != null)
                   try  { conn.close();} catch(Exception e) {}
               if(connection != null)
                  try  { connection.close();} catch(Exception e) {}
               
           }
         }
    
  
    
   

        public void insertMakePayment(PaymentValue pv)
            throws SQLException, Exception
        {
         CallableStatement command = null; //25032014
         CallableStatement commandAmt = null; //25032014
         
         Connection conn = null;
         
         PreparedStatement ps = null;
         
            try
            {
                conn = getConnection();
                //CallableStatement command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?)}");//25032014
                command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?,?)}");//25032014
                command.registerOutParameter(1, 4);
                command.setString(2, pv.getPaymentCurrency());
                command.setString(3, pv.getDebitAccountNo());
                command.setString(4, pv.getAccountCurrency());
                command.setString(5, String.valueOf(pv.getAmount()));
                String newdate[] = pv.getPmtDueDate().split("/");
                command.setString(6, newdate[1] + "/" + newdate[0] + "/" + newdate[2]);
                command.setString(7, pv.getZenithClientID());
                
                command.setString(8, pv.getPaymentType());//added payment type for ISW limit
                command.execute();
                if(command.getInt(1) != 0)
                {
                    double global_limt = 0.0D;
                    /*
                    try
                    {
                        commandAmt = conn.prepareCall("{?=call ZENBASENET..zsp_get_global_limt(?,?)}");
                        commandAmt.registerOutParameter(1, 8);
                        commandAmt.setString(2, pv.getZenithClientID());
                        commandAmt.setString(3, pv.getPaymentCurrency());
                        commandAmt.execute();
                        global_limt = commandAmt.getDouble(1);
                    }
                    catch(Exception ex) { }
                    throw new Exception("Your global limit of " + String.valueOf(global_limt) + " for " + pv.getPmtDueDate() + " has exceeded");
                    */
                    throw new Exception("Your daily transfer limit for " + pv.getPmtDueDate() + " has been exceeded");//24102014
                }
                
                /*begin for Intra transfer Limit Check-09012015*/
               
               
                 if ( (command.getInt(1) == 0) && ( pv.getPaymentType().equalsIgnoreCase("ZENITH/BENEFICIARY") ) )
                 
                 {
                     command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_get_trancode(?,?,?,?,?)}");//05102015
                     command.registerOutParameter(1, 4);
                     command.setString(2, pv.getDebitAccountNo());
                     command.setString(3, pv.getVendorAccountNumber());
                     command.registerOutParameter(4, Types.INTEGER);
                     command.registerOutParameter(5, Types.INTEGER);
                     command.registerOutParameter(6, Types.VARCHAR);
                     
                     command.execute();
                     
                     // if the account are on same rim , it will return 163
                     if ((command.getInt(1) == 0) && (command.getInt(4) == 163))
                         {
                         pv.setRoutingMethod("ZENITH/INTRATRANSFER");
                     
                         }
                     
                     
                 }
          
                
                String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (";
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("company_code,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("batchid,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_name,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_address,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_city,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_state,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_phone,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_email,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_category,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_code,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("amount,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("payment_due_date,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("payment_currency,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("payment_type,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("payment_method,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_acct_no,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_bank,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("vendor_bank_branch,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("contract_no,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("contract_date,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("routing_method,routing_bank_code,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("debit_acct_no,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("account_currency,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("account_name,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("trans_ref,").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("sort_code,int_bank_name,vendor_bank_acctno,int_bank_bic,corresp_bank_bic)").toString();//added 30092013 for debit bank BIC for SWIFT/DIRECTDEBIT                        
                SQLQuery = (new StringBuilder()).append(SQLQuery).append(" VALUES ").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("('").append(pv.getZenithClientID()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append(pv.getBatchID()).append(",").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorName()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorAddress()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorCity()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorState()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorPhone()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorEmail()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorCategory()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorCode()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append(pv.getAmount()).append(",").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getPmtDueDate()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getPaymentCurrency()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getPaymentType()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getPaymentMethod()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorAccountNumber().trim()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorBankName()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getVendorBankBranchName()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getContractNo()).append("',").toString();
               // SQLQuery = (new StringBuilder()).append(SQLQuery).append("getdate(),").toString();//13022013
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getChargeOption()).append("',").toString();//13022013
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getRoutingMethod()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getRoutingBankCode()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getDebitAccountNo().trim()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getAccountCurrency()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getAccountName()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getTransRef()).append("',").toString();
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getSortCode()).append("',").toString();
                //added 30092013 for debit bank BIC for SWIFT/DIRECTDEBIT                        
                SQLQuery = (new StringBuilder()).append(SQLQuery).append("'").append(pv.getIntermediary_bank_name()).append("','").append(pv.getIntermediary_bank_acctno()).append("','").append(pv.getIntermediary_bank_bic()).append("','").append(pv.getCorresp_bank_bic()).append("')").toString();
                
                //System.out.println(" SQLQuery insertMakePayment " + SQLQuery);
                ps = conn.prepareStatement(SQLQuery);
                ps.executeUpdate();
                
            }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> insertMakePayment "+ sqlExp.getMessage());
      throw sqlExp;
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
      throw exp;
    }
    finally
    {
        
        if(command != null)
           try  { command.close();} catch(Exception e) {}//25032014
        
        if(commandAmt != null)
               try  { commandAmt.close();} catch(Exception e) {}//25032014   
           
        if(ps != null)
           try  { ps.close();} catch(Exception e) {}//25032014
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
    }
  //08112010- import duty payment
   public void insertDutyPayment(PaymentValue pv) throws SQLException, Exception
   {
      CallableStatement command = null;//25032014
      CallableStatement commandAmt = null ;//25032014
       Connection conn = null;
       PreparedStatement ps = null;
        
     try
     {       
       //double newPaymentID = 0;//commented to use IDENTITY - 14012010
       // newPaymentID = getPaymentIDProcedure();//commented to use IDENTITY - 14012010
       conn = getConnection();
       //String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (payment_id, " ; //commented to use IDENTITY - 14012010
       
       
       command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?)}");
       command.registerOutParameter(1,Types.INTEGER);
       command.setString(2,pv.getPaymentCurrency());
       command.setString(3,pv.getDebitAccountNo());
       command.setString(4,pv.getAccountCurrency());
       command.setString(5,String.valueOf(pv.getAmount()));    
     
      // String[] payment_due_dates =pv.getPmtDueDate().split("/");
       
     
       //command.setString(6,pv.getPmtDueDate());    
       String[] newdate = pv.getPmtDueDate().split("/");
       command.setString(6,new StringBuffer().append(newdate[1]).append("/").append(newdate[0]).append("/").append(newdate[2]).toString());
       
       command.setString(7, pv.getZenithClientID());
       command.execute();
       
       
        if(command.getInt(1) != 0)
        {
            double global_limt = 0;
            try
            {
                 commandAmt = conn.prepareCall("{?=call ZENBASENET..zsp_get_global_limt(?,?)}");
                 commandAmt.registerOutParameter(1,Types.DOUBLE);
                 commandAmt.setString(2,pv.getZenithClientID());
                 commandAmt.setString(3,pv.getPaymentCurrency());
                 commandAmt.execute();
                 global_limt = commandAmt.getDouble(1);
            }
            catch(Exception ex) 
            {
                
            }
             
             throw new Exception(new StringBuffer().append("Your global limit of ").append(String.valueOf(global_limt)).append(" for ").append(pv.getPmtDueDate()).append(" has exceeded").toString());
        }
      
       String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (" ; //removed payment id to use IDENTITY - 14012010
              SQLQuery +=               "company_code,";
              SQLQuery +=               "batchid," ;
              SQLQuery +=               "vendor_name," ;
              SQLQuery +=               "vendor_address," ;
              SQLQuery +=               "vendor_city," ;
              SQLQuery +=               "vendor_state," ;
              SQLQuery +=               "vendor_phone," ;
              SQLQuery +=               "vendor_email," ;
              SQLQuery +=               "vendor_category," ;
              SQLQuery +=               "vendor_code," ;
              SQLQuery +=               "amount,";                                                       
              SQLQuery +=               "payment_due_date," ;
              SQLQuery +=               "payment_currency," ;
              SQLQuery +=               "payment_type," ;
              SQLQuery +=               "payment_method," ;
              SQLQuery +=               "vendor_acct_no," ;
              SQLQuery +=               "vendor_bank," ;
              SQLQuery +=               "vendor_bank_branch," ;
              SQLQuery +=               "contract_no," ;
              SQLQuery +=               "contract_date," ;
              SQLQuery +=               "routing_method,routing_bank_code," ;//02032010
              SQLQuery +=               "debit_acct_no," ;
              SQLQuery +=               "account_currency," ;
              SQLQuery +=               "account_name," ;
              SQLQuery +=               "trans_ref,";
              SQLQuery +=               "sort_code,int_bank_name,vendor_bank_acctno,int_bank_bic,invoice_number,telex_ref)";
              SQLQuery +=               " VALUES ";
              //SQLQuery +=  "(" + newPaymentID + ", " ;//commented to use IDENTITY 14012010
              SQLQuery +=  "('" + pv.getZenithClientID() + "',";
              SQLQuery +=  pv.getBatchID() + ",";
              SQLQuery +=  "'" + pv.getVendorName() + "',";
              SQLQuery +=  "'" + pv.getVendorAddress() + "',";
              SQLQuery +=  "'" + pv.getVendorCity() + "',";
              SQLQuery +=  "'" + pv.getVendorState() + "',";
              SQLQuery +=  "'" + pv.getVendorPhone() + "',";
              SQLQuery +=  "'" + pv.getVendorEmail() + "',";
              SQLQuery +=  "'" + pv.getVendorCategory() + "',";
              SQLQuery +=  "'" + pv.getVendorCode() + "',";
              SQLQuery +=  pv.getAmount() + ",";
              //SQLQuery +=  "'" + pv.getPmtDueDate() + "',";
              SQLQuery +=  "getdate(),";
              SQLQuery +=  "'" + pv.getPaymentCurrency() + "',";
              SQLQuery +=  "'" + pv.getPaymentType() + "',";
              SQLQuery +=  "'" + pv.getPaymentMethod() + "',";
              SQLQuery +=  "'" + pv.getVendorAccountNumber().trim() + "',";
              SQLQuery +=  "'" + pv.getVendorBankName() + "',";
              SQLQuery +=  "'" + pv.getVendorBankBranchName() + "',";
              SQLQuery +=  "'" + pv.getContractNo() + "',";
              SQLQuery +=  "getdate(),";
              SQLQuery +=  "'" + pv.getRoutingMethod() + "',";//02032010 
              SQLQuery +=  "'" + pv.getRoutingBankCode() + "',";
              SQLQuery +=  "'" + pv.getDebitAccountNo().trim() + "',";
              SQLQuery +=  "'" + pv.getAccountCurrency() + "',";
              SQLQuery +=  "'" + pv.getAccountName() + "',";
              SQLQuery +=  "'" + pv.getTransRef() + "',";
              SQLQuery +=  "'" + pv.getSortCode() + "','" + pv.getIntermediary_bank_name() + "','" + pv.getIntermediary_bank_acctno() + "','" + pv.getIntermediary_bank_bic() + "','" + pv.getInvoice_number() + "','" + pv.getTelex_ref() + "')";
          // System.out.println("SQL SQLQuery >> " + SQLQuery); 
              ps = conn.prepareStatement(SQLQuery);
              ps.executeUpdate();
       
     }
     catch(SQLException sqlExp)
     {
       System.out.println("SQL Exception >>insertDutyPayment "+ sqlExp.getMessage());
       throw sqlExp;
     }
     catch(Exception exp)
     {
       System.out.println("Exception >>insertDutyPayment "+ exp.getMessage());
       throw exp;
     }
     finally
     {
     if(command != null)
          try  { command.close();} catch(Exception e) {}
     if(commandAmt != null)
           try  { commandAmt.close();} catch(Exception e) {}
     if(ps != null)
           try  { ps.close();} catch(Exception e) {}
      if(conn != null)
          try  { conn.close();} catch(Exception e) {}
     }
   }
   
  //0811201-import duty payment
  
  
  
   //04042011- Cheque Confirmation
    public void insertChequeConfirmation(PaymentValue pv) throws SQLException, Exception
    {
        Connection conn = null;
        PreparedStatement ps = null;
         
      try
      {
        //double newPaymentID = 0;//commented to use IDENTITY - 14012010
        // newPaymentID = getPaymentIDProcedure();//commented to use IDENTITY - 14012010
        conn = getConnection();
        //String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (payment_id, " ; //commented to use IDENTITY - 14012010
        
        /* commented to removed global limit check for Cheque Confirmation
        CallableStatement command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?)}");
        command.registerOutParameter(1,Types.INTEGER);
        command.setString(2,pv.getPaymentCurrency());
        command.setString(3,pv.getDebitAccountNo());
        command.setString(4,pv.getAccountCurrency());
        command.setString(5,String.valueOf(pv.getAmount()));    
      
       // String[] payment_due_dates =pv.getPmtDueDate().split("/");
        
      
        //command.setString(6,pv.getPmtDueDate());    
        String[] newdate = pv.getPmtDueDate().split("/");
        command.setString(6,new StringBuffer().append(newdate[1]).append("/").append(newdate[0]).append("/").append(newdate[2]).toString());
        
        command.setString(7, pv.getZenithClientID());
        command.execute();
        
        
         if(command.getInt(1) != 0)
         {
             double global_limt = 0;
             try
             {
                  CallableStatement commandAmt = conn.prepareCall("{?=call ZENBASENET..zsp_get_global_limt(?,?)}");
                  commandAmt.registerOutParameter(1,Types.DOUBLE);
                  commandAmt.setString(2,pv.getZenithClientID());
                  commandAmt.setString(3,pv.getPaymentCurrency());
                  commandAmt.execute();
                  global_limt = commandAmt.getDouble(1);
             }
             catch(Exception ex) 
             {
                 
             }
              
              throw new Exception(new StringBuffer().append("Your global limit of ").append(String.valueOf(global_limt)).append(" for ").append(pv.getPmtDueDate()).append(" has exceeded").toString());
         }
       */
        String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (" ; //removed payment id to use IDENTITY - 14012010
               SQLQuery +=               "company_code,";
               SQLQuery +=               "batchid," ;
               SQLQuery +=               "vendor_name," ;
               SQLQuery +=               "vendor_address," ;
               SQLQuery +=               "vendor_city," ;
               SQLQuery +=               "vendor_state," ;
               SQLQuery +=               "vendor_phone," ;
               SQLQuery +=               "vendor_email," ;
               SQLQuery +=               "vendor_category," ;
               SQLQuery +=               "vendor_code," ;
               SQLQuery +=               "amount,";                                                       
               SQLQuery +=               "payment_due_date," ;
               SQLQuery +=               "payment_currency," ;
               SQLQuery +=               "payment_type," ;
               SQLQuery +=               "payment_method," ;
               SQLQuery +=               "vendor_acct_no," ;
               SQLQuery +=               "vendor_bank," ;
               SQLQuery +=               "vendor_bank_branch," ;
               SQLQuery +=               "contract_no," ;
               SQLQuery +=               "contract_date," ;
               SQLQuery +=               "routing_method,routing_bank_code," ;//02032010
               SQLQuery +=               "debit_acct_no," ;
               SQLQuery +=               "account_currency," ;
               SQLQuery +=               "account_name," ;
               SQLQuery +=               "trans_ref,";
               SQLQuery +=               "sort_code,int_bank_name,vendor_bank_acctno,int_bank_bic,invoice_number,telex_ref,transfer_id,userid,vendor_acct_type)";
               SQLQuery +=               " VALUES ";
               //SQLQuery +=  "(" + newPaymentID + ", " ;//commented to use IDENTITY 14012010
               SQLQuery +=  "('" + pv.getZenithClientID() + "',";
               SQLQuery +=  pv.getBatchID() + ",";
               SQLQuery +=  "'" + pv.getVendorName() + "',";
               SQLQuery +=  "'" + pv.getVendorAddress() + "',";
               SQLQuery +=  "'" + pv.getVendorCity() + "',";
               SQLQuery +=  "'" + pv.getVendorState() + "',";
               SQLQuery +=  "'" + pv.getVendorPhone() + "',";
               SQLQuery +=  "'" + pv.getVendorEmail() + "',";
               SQLQuery +=  "'" + pv.getVendorCategory() + "',";
               SQLQuery +=  "'" + pv.getVendorCode() + "',";
               SQLQuery +=  pv.getAmount() + ",";
               SQLQuery +=  "'" + pv.getPmtDueDate() + "',";
               //SQLQuery +=  "getdate(),";
               SQLQuery +=  "'" + pv.getPaymentCurrency() + "',";
               SQLQuery +=  "'" + pv.getPaymentType() + "',";
               SQLQuery +=  "'" + pv.getPaymentMethod() + "',";
               SQLQuery +=  "'" + pv.getVendorAccountNumber().trim() + "',";
               SQLQuery +=  "'" + pv.getVendorBankName() + "',";
               SQLQuery +=  "'" + pv.getVendorBankBranchName() + "',";
               SQLQuery +=  "'" + pv.getContractNo() + "',";
               SQLQuery +=  "getdate(),";
               SQLQuery +=  "'" + pv.getRoutingMethod() + "',";//02032010 
               SQLQuery +=  "'" + pv.getRoutingBankCode() + "',";
               SQLQuery +=  "'" + pv.getDebitAccountNo().trim() + "',";
               SQLQuery +=  "'" + pv.getAccountCurrency() + "',";
               SQLQuery +=  "'" + pv.getAccountName() + "',";
               SQLQuery +=  "'" + pv.getTransRef() + "',";
               SQLQuery +=  "'" + pv.getSortCode() + "','" + pv.getIntermediary_bank_name() + "','" + pv.getIntermediary_bank_acctno() + "','" + pv.getIntermediary_bank_bic() + "','" + pv.getInvoice_number() + "','" + pv.getTelex_ref() + "','" + pv.getTransfer_id() + "','" + pv.getUser_id() + "','" + pv.getVendor_acct_type() + "')";
           // System.out.println("SQL SQLQuery >> " + SQLQuery); 
               ps = conn.prepareStatement(SQLQuery);
               ps.executeUpdate();
        
      }
      catch(SQLException sqlExp)
      {
        System.out.println("SQL Exception >>insertChequeConfirmation "+ sqlExp.getMessage());
        throw sqlExp;
      }
      catch(Exception exp)
      {
        System.out.println("Exception >>insertChequeConfirmation "+ exp.getMessage());
        throw exp;
      }
      finally
      {
        
        
        if(ps != null)
             try  { ps.close();} catch(Exception e) {}
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
    }
    
    
    //04032013-invoice discount
      
    public void insertInvoiceDiscount(PaymentValue pv) throws SQLException, Exception
    {
        CallableStatement command = null;//25032014
        CallableStatement commandAmt = null ;//25032014
        Connection conn = null;
        PreparedStatement ps = null;
         
      try
      {       
        //double newPaymentID = 0;//commented to use IDENTITY - 14012010
        // newPaymentID = getPaymentIDProcedure();//commented to use IDENTITY - 14012010
        conn = getConnection();
        //String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (payment_id, " ; //commented to use IDENTITY - 14012010
        
        
        command = conn.prepareCall("{?=call ZENBASENET..zsp_cib_exceed_global_limit(?,?,?,?,?,?)}");//25032014
        command.registerOutParameter(1,Types.INTEGER);
        command.setString(2,pv.getPaymentCurrency());
        command.setString(3,pv.getDebitAccountNo());
        command.setString(4,pv.getAccountCurrency());
        command.setString(5,String.valueOf(pv.getAmount()));    
      
       // String[] payment_due_dates =pv.getPmtDueDate().split("/");
        
      
        //command.setString(6,pv.getPmtDueDate());    
        String[] newdate = pv.getPmtDueDate().split("/");
        command.setString(6,new StringBuffer().append(newdate[1]).append("/").append(newdate[0]).append("/").append(newdate[2]).toString());
        
        command.setString(7, pv.getZenithClientID());
        command.execute();
        
        
         if(command.getInt(1) != 0)
         {
             double global_limt = 0;
             try
             {
                  commandAmt = conn.prepareCall("{?=call ZENBASENET..zsp_get_global_limt(?,?)}");//25032014
                  commandAmt.registerOutParameter(1,Types.DOUBLE);
                  commandAmt.setString(2,pv.getZenithClientID());
                  commandAmt.setString(3,pv.getPaymentCurrency());
                  commandAmt.execute();
                  global_limt = commandAmt.getDouble(1);
             }
             catch(Exception ex) 
             {
                 
             }
              
              throw new Exception(new StringBuffer().append("Your global limit of ").append(String.valueOf(global_limt)).append(" for ").append(pv.getPmtDueDate()).append(" has exceeded").toString());
         }
       
        String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (" ; //removed payment id to use IDENTITY - 14012010
               SQLQuery +=               "company_code,";
               SQLQuery +=               "batchid," ;
               SQLQuery +=               "vendor_name," ;
               SQLQuery +=               "vendor_address," ;
               SQLQuery +=               "vendor_city," ;
               SQLQuery +=               "vendor_state," ;
               SQLQuery +=               "vendor_phone," ;
               SQLQuery +=               "vendor_email," ;
               SQLQuery +=               "vendor_category," ;
               SQLQuery +=               "vendor_code," ;
               SQLQuery +=               "amount,";                                                       
               SQLQuery +=               "payment_due_date," ;
               SQLQuery +=               "payment_currency," ;
               SQLQuery +=               "payment_type," ;
               SQLQuery +=               "payment_method," ;
               SQLQuery +=               "vendor_acct_no," ;
               SQLQuery +=               "vendor_bank," ;
               SQLQuery +=               "vendor_bank_branch," ;
               SQLQuery +=               "contract_no," ;
               SQLQuery +=               "contract_date," ;
               SQLQuery +=               "routing_method,routing_bank_code," ;//02032010
               SQLQuery +=               "debit_acct_no," ;
               SQLQuery +=               "account_currency," ;
               SQLQuery +=               "account_name," ;
               SQLQuery +=               "trans_ref,";
               SQLQuery +=               "sort_code,int_bank_name,vendor_bank_acctno,int_bank_bic,invoice_number,telex_ref,invoice_date,tenor,invoice_duedate,discounted_amount,discounted_days)";
               SQLQuery +=               " VALUES ";
               //SQLQuery +=  "(" + newPaymentID + ", " ;//commented to use IDENTITY 14012010
               SQLQuery +=  "('" + pv.getZenithClientID() + "',";
               SQLQuery +=  pv.getBatchID() + ",";
               SQLQuery +=  "'" + pv.getVendorName() + "',";
               SQLQuery +=  "'" + pv.getVendorAddress() + "',";
               SQLQuery +=  "'" + pv.getVendorCity() + "',";
               SQLQuery +=  "'" + pv.getVendorState() + "',";
               SQLQuery +=  "'" + pv.getVendorPhone() + "',";
               SQLQuery +=  "'" + pv.getVendorEmail() + "',";
               SQLQuery +=  "'" + pv.getVendorCategory() + "',";
               SQLQuery +=  "'" + pv.getVendorCode() + "',";
               SQLQuery +=  pv.getAmount() + ",";
               SQLQuery +=  "'" + pv.getPmtDueDate() + "',";
               // SQLQuery +=  "getdate(),";
               SQLQuery +=  "'" + pv.getPaymentCurrency() + "',";
               SQLQuery +=  "'" + pv.getPaymentType() + "',";
               SQLQuery +=  "'" + pv.getPaymentMethod() + "',";
               SQLQuery +=  "'" + pv.getVendorAccountNumber().trim() + "',";
               SQLQuery +=  "'" + pv.getVendorBankName() + "',";
               SQLQuery +=  "'" + pv.getVendorBankBranchName() + "',";
               SQLQuery +=  "'" + pv.getContractNo() + "',";
               SQLQuery +=  "getdate(),";
               SQLQuery +=  "'" + pv.getRoutingMethod() + "',";//02032010 
               SQLQuery +=  "'" + pv.getRoutingBankCode() + "',";
               SQLQuery +=  "'" + pv.getDebitAccountNo().trim() + "',";
               SQLQuery +=  "'" + pv.getAccountCurrency() + "',";
               SQLQuery +=  "'" + pv.getAccountName() + "',";
               SQLQuery +=  "'" + pv.getTransRef() + "',";
               SQLQuery +=  "'" + pv.getSortCode() + "','" + pv.getIntermediary_bank_name() + "','" + pv.getIntermediary_bank_acctno() + "','" + pv.getIntermediary_bank_bic() + "','" + pv.getInvoice_number() + "','" + pv.getTelex_ref() + "',";
               SQLQuery +=  "'" + pv.getInvoice_date() + "'," + pv.getTenor() + ",'" + pv.getInvoice_duedate() + "'," + pv.getDiscounted_amount() + "," + pv.getDiscounted_days() + ")";
           // System.out.println("SQL SQLQuery >> " + SQLQuery); 
               ps = conn.prepareStatement(SQLQuery);
               ps.executeUpdate();
        
      }
      catch(SQLException sqlExp)
      {
        System.out.println("SQL Exception >>insertInvoiceDiscount "+ sqlExp.getMessage());
        throw sqlExp;
      }
      catch(Exception exp)
      {
        System.out.println("Exception >>insertInvoiceDiscount "+ exp.getMessage());
        throw exp;
      }
      finally
      {
          if(command != null)
               try  { command.close();} catch(Exception e) {}
          if(commandAmt != null)
                try  { commandAmt.close();} catch(Exception e) {}
          if(ps != null)
             try  { ps.close();} catch(Exception e) {}
          if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
    }
    
    //04032013-invoice discount
    
    
   
    public void insertBillsPayment(BillsPaymentValue pv) throws SQLException, Exception
      {
          Connection conn = null;
          PreparedStatement ps = null;
           
        try
        {
          
          
          double newPaymentID = 0;
          
            ////newPaymentID = getPaymentIDProcedure();
          conn = getConnection();
          String SQLQuery = "INSERT INTO zenbasenet..zib_cib_pmt_payments ( " ;
                 SQLQuery +=               "company_code,";
                 SQLQuery +=               "batchid," ;
                 SQLQuery +=               "vendor_name," ;
                 SQLQuery +=               "vendor_address," ;
                 SQLQuery +=               "vendor_city," ;
                 SQLQuery +=               "vendor_state," ;
                 SQLQuery +=               "vendor_phone," ;
                 SQLQuery +=               "vendor_email," ;
                 SQLQuery +=               "vendor_category," ;
                 SQLQuery +=               "vendor_code," ;
                 SQLQuery +=               "amount,";                                                       
                 SQLQuery +=               "payment_due_date," ;
                 SQLQuery +=               "payment_currency," ;
                 SQLQuery +=               "payment_type," ;
                 SQLQuery +=               "payment_method," ;
                 SQLQuery +=               "vendor_acct_no," ;
                 SQLQuery +=               "vendor_bank," ;
                 SQLQuery +=               "vendor_bank_branch," ;
                 SQLQuery +=               "contract_no," ;
                 SQLQuery +=               "contract_date," ;
                 SQLQuery +=               "routing_bank_code," ;
                 SQLQuery +=               "debit_acct_no," ;
                 SQLQuery +=               "account_currency," ;
                 SQLQuery +=               "account_name," ;
                 SQLQuery +=               "trans_ref,";
                 SQLQuery +=               "sort_code)";
                 SQLQuery +=               " VALUES ";
                 SQLQuery +=  "("   ;
                 SQLQuery +=  "'" + pv.getZenithClientID() + "',";
                 SQLQuery +=  pv.getBatchID() + ",";
                 SQLQuery +=  "'" + pv.getVendorName() + "',";
                 SQLQuery +=  "'" + pv.getVendorAddress() + "',";
                 SQLQuery +=  "'" + pv.getVendorCity() + "',";
                 SQLQuery +=  "'" + pv.getVendorState() + "',";
                 SQLQuery +=  "'" + pv.getVendorPhone() + "',";
                 SQLQuery +=  "'" + pv.getVendorEmail() + "',";
                 SQLQuery +=  "'" + pv.getVendorCategory() + "',";
                 SQLQuery +=  "'" + pv.getVendorCode() + "',";
                 SQLQuery +=  pv.getAmount() + ",";
                 SQLQuery +=  "'" + pv.getPmtDueDate() + "',";
                 SQLQuery +=  "'" + pv.getPaymentCurrency() + "',";
                 SQLQuery +=  "'" + pv.getPaymentType() + "',";
                 SQLQuery +=  "'" + pv.getPaymentMethod() + "',";
                 SQLQuery +=  "'" + pv.getVendorAccountNumber().trim() + "',";
                 SQLQuery +=  "'" + pv.getVendorBankName() + "',";
                 SQLQuery +=  "'" + pv.getVendorBankBranchName() + "',";
                 SQLQuery +=  "'" + pv.getContractNo() + "',";
                 SQLQuery +=  "getdate(),";
                 SQLQuery +=  "'" + pv.getRoutingBankCode() + "',";
                 SQLQuery +=  "'" + pv.getDebitAccountNo().trim() + "',";
                 SQLQuery +=  "'" + pv.getAccountCurrency() + "',";
                 SQLQuery +=  "'" + pv.getAccountName() + "',";
                 SQLQuery +=  "'" + pv.getTransRef() + "',";
                 SQLQuery +=  "'" + pv.getSortCode() + "')";
                 ps = conn.prepareStatement(SQLQuery);
                 ps.executeUpdate();
          
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

      
   
  
  
  public Payment[] getPaymentExceptions(double batchID, String CompanyCode) throws SQLException, Exception
  {
    ArrayList aList = new ArrayList();
    Payment[] pArray = new Payment[0];
    Payment pmt = new Payment();
    
      ResultSet rs = null;
      Connection conn = null;
      Statement s = null;
       
    try
    {
      conn = getConnection();
      
      String SQLQuery = "SELECT * from ZENBASENET..zib_cib_payments_exceptions ";
      SQLQuery += " WHERE batchid = " + batchID;
      SQLQuery += " AND zenith_client_id = '" + CompanyCode + "'";
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        pmt = new Payment();
        pmt.setTrans_ref(rs.getString("Trans_Ref"));
        pmt.setVendor_name(rs.getString("Vendor_Name"));
        pmt.setVendor_address("Vendor_Address");
        pmt.setVendor_city("Vendor_City");
        pmt.setVendor_state(rs.getString("Vendor_State"));
        pmt.setVendor_postcode(rs.getString("Vendor_Postcode"));
        pmt.setVendor_phone(rs.getString("Vendor_Phone"));
        pmt.setVendor_category(rs.getString("Vendor_Category"));
        pmt.setVendor_code(rs.getString("Vendor_Code"));
        pmt.setInvoicenumber(rs.getString("Invoice_Number"));
        pmt.setPayment_currency(rs.getString("Payment_Currency"));
        pmt.setPayment_method(rs.getString("Payment_Method"));
        pmt.setPayment_type(rs.getString("Payment_Type"));
        pmt.setVendor_acct_no(rs.getString("Account_Id"));
        pmt.setVendor_bank(rs.getString("Vendor_Bank"));
        pmt.setVendor_bank_branch(rs.getString("Vendor_Bank_Branch"));
        pmt.setContract_no(rs.getString("Contract_No"));
        pmt.setContract_date(rs.getString("Contract_Date"));
        pmt.setRouting_bank_code(rs.getString("Routing_Method"));
        pmt.setRouting_bank_code(rs.getString("Routing_Bank_Code"));
        pmt.setDebit_acct_no(rs.getString("Debit_Account_Id"));
        pmt.setAccount_currency(rs.getString("account_Currency"));
        pmt.setAccount_name(rs.getString("Account_Name"));
        pmt.setAmount(rs.getDouble("Amount"));
        pmt.setPaymentDueDate(rs.getString("Payment_Due_Date"));
        pmt.setBatchid(rs.getInt("batchid"));
        pmt.setReject_reason(rs.getString("reject_reason"));
        pmt.setPaymentstatus(rs.getString("ptystatus"));
        pmt.setUploadDate(rs.getTimestamp("time_stamp"));
        pmt.setcompany_code(rs.getString("zenith_client_id"));
        pmt.setPayment_id(rs.getInt("ptid"));
        aList.add(pmt);
      } 
      pArray = new Payment[aList.size()];
      
      return (Payment[])aList.toArray(pArray);
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
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(s != null)
           try  { s.close();} catch(Exception e) {}
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
 /* public static void main(String args[])
    {
        PaymentAdapter Service = new PaymentAdapter();
     //   Service.Get_File_To_Read(1,"super", "000");
       // Service.Get_File_To_Read();
       int output = Service.getPaymentIDProcedure();
       System.out.println(output);
    } */
    
    
    public int CountPaymentAwaitingApproval(String companycode,String userid,int authlevel) throws SQLException
  {
    authlevel -= 1;
    int count = 0;
    PreparedStatement command = null;//25032014
     ResultSet rs = null;
     Connection conn = null;
      
    try
    {
      if(conn == null)
        conn = getConnection();
      else{
        if(conn.isClosed())
          conn = getConnection();
      }
      String sqltext = "select count(payment_id) as no_awaitingpmt from ZENBASENET..zib_cib_pmt_payments " +
      "where ptystatus = 'awaiting approval' and approval_level = ? and company_code =?";
      command = conn.prepareStatement(sqltext);//25032014
      command.setInt(1,authlevel);
      command.setString(2,companycode);
      rs = command.executeQuery();
     rs.next();
     count = rs.getInt("no_awaitingpmt");
     rs.close();
      
    }
    catch(SQLException exp)
    {
      throw exp;
    }
    finally
    {
        command.close();
      //closeconnection();
       if(conn != null)
        try
        {
           conn.close();
        }
        catch(SQLException exp)
        {
          
        }
    }
   return count; 
  }
  /*
  private void closeconnection()
  {
    try
    {
      if(conn != null)
        conn.close();
    }
    catch(SQLException exp)
    {
      
    }
    
  }
   */
  
  public Payment[] getBeneficiaryExceptions(double batchID, String CompanyCode) throws SQLException, Exception
  {
    ArrayList aList = new ArrayList(); 
    Payment[] pArray = new Payment[0];
    Payment pmt = new Payment();
      ResultSet rs = null;
      Connection conn = null;
      Statement s = null;
    
    try
    {
      conn = getConnection();
      
      String SQLQuery = "SELECT * from ZENBASENET..zib_cib_beneficiary_exceptions ";
      SQLQuery += " WHERE batchid = " + batchID;
      SQLQuery += " AND zenith_client_id = '" + CompanyCode + "'";
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        pmt = new Payment();
        
        pmt.setVendor_code(rs.getString("Beneficiary_code"));
        pmt.setVendor_name(rs.getString("Beneficiary_Name"));
        pmt.setVendor_address(rs.getString("Beneficiary_Address"));
        pmt.setVendor_city(rs.getString("Beneficiary_City"));
        pmt.setVendor_state(rs.getString("Beneficiary_State"));
        pmt.setVendor_phone(rs.getString("Beneficiary_Phone"));
        pmt.setBene_gsmnumber(rs.getString("Beneficiary_email"));
        pmt.setBene_email(rs.getString("Bene_email"));
        pmt.setContact_per(rs.getString("Contact_person"));
        pmt.setBank_code(rs.getString("Bank_code"));
        pmt.setBank_Branch_code(rs.getString("Bank_Branch_code"));
        pmt.setVendor_bank_acctno(rs.getString("Bene_acct_Number"));
        pmt.setVendor_category(rs.getString("Category"));
        pmt.setPayment_type(rs.getString("Beneficiary_Type"));
        pmt.setVendor_bank(rs.getString("Bank_Name"));
        pmt.setVendor_bank_branch(rs.getString("Bank_Branch_Name"));
        pmt.setBatchid(rs.getInt("batchid"));
        pmt.setReject_reason(rs.getString("reject_reason"));
        pmt.setPaymentstatus(rs.getString("ptystatus"));
        pmt.setUploadDate(rs.getTimestamp("time_stamp")); 
        pmt.setcompany_code(rs.getString("zenith_client_id"));
        pmt.setPayment_id(rs.getInt("ptid"));
        aList.add(pmt);
      } 
      pArray = new Payment[aList.size()];
      
      return (Payment[])aList.toArray(pArray);
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
        if(rs != null)
           try  { rs.close();} catch(Exception e) {}
        if(s != null)
           try  { s.close();} catch(Exception e) {}
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  
    public Payment[] getNubanBeneficiaryExceptions(double batchID, String CompanyCode) throws SQLException, Exception
    {
      ArrayList aList = new ArrayList(); 
      Payment[] pArray = new Payment[0];
      Payment pmt = new Payment();
      
        ResultSet rs = null;
        Connection conn = null;
        Statement s = null;
      
      try
      {
        conn = getConnection();
        String SQLQuery = "SELECT * from ZENBASENET..zib_cib_nuban_bene_exceptions ";
        SQLQuery += " WHERE batchid = " + batchID;
        SQLQuery += " AND zenith_client_id = '" + CompanyCode + "'";
        s = conn.createStatement();
        rs = s.executeQuery(SQLQuery);
        while (rs.next())
        {
          pmt = new Payment();
          
          pmt.setVendor_code(rs.getString("Beneficiary_code"));
          pmt.setVendor_name(rs.getString("Beneficiary_Name"));
          pmt.setVendor_address(rs.getString("Beneficiary_Address"));
          pmt.setVendor_city(rs.getString("Beneficiary_City"));
          pmt.setVendor_state(rs.getString("Beneficiary_State"));
          pmt.setVendor_phone(rs.getString("Beneficiary_Phone"));
          pmt.setBene_gsmnumber(rs.getString("Beneficiary_email"));
          pmt.setBene_email(rs.getString("Bene_email"));
          pmt.setContact_per(rs.getString("Contact_person"));
          pmt.setBank_code(rs.getString("Bank_code"));
          pmt.setBank_Branch_code(rs.getString("Bank_Branch_code"));
          pmt.setVendor_bank_acctno(rs.getString("Bene_acct_Number"));
          pmt.setVendor_category(rs.getString("Category"));
          pmt.setPayment_type(rs.getString("Beneficiary_Type"));
          pmt.setVendor_bank(rs.getString("Bank_Name"));
          pmt.setVendor_bank_branch(rs.getString("Bank_Branch_Name"));
          pmt.setBatchid(rs.getInt("batchid"));
          pmt.setReject_reason(rs.getString("reject_reason"));
          pmt.setPaymentstatus(rs.getString("ptystatus"));
          pmt.setUploadDate(rs.getTimestamp("time_stamp")); 
          pmt.setcompany_code(rs.getString("zenith_client_id"));
          pmt.setPayment_id(rs.getInt("ptid"));
          aList.add(pmt);
        } 
        pArray = new Payment[aList.size()];
        
        return (Payment[])aList.toArray(pArray);
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
       
        if(rs != null)
             try  { rs.close();} catch(Exception e) {}
        if(s != null)
             try  { s.close();} catch(Exception e) {}
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
    }
    
    public String BeneficiaryPrivilege(String companyID) {
        String flag = "false";
        PreparedStatement command = null;
        ResultSet rs = null;
        Connection conn = null;
        
        try{
            conn = getConnection();
            
            String query = "select count(*) as noofusers from zib_cib_gb_login where hostcompany = ?";
            command = conn.prepareStatement(query) ;
            
            command.setString(1,companyID.trim());
            rs = command.executeQuery();
            
            while(rs.next()) 
            {
                if(rs.getInt("noofusers") == 1) {
                    break;
                }
                if(rs.getInt("noofusers") > 1) {
                    flag = IsValidation(companyID);
                }
                break;
            }
   
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if( command != null)
            try
            {
                command.close();
                //closeconnection();
            }
            catch(Exception ex) {
                ex.printStackTrace();
            }
            
            if( rs != null)
            try
            {
                rs.close();
                //closeconnection();
            }
            catch(Exception ex) {
                ex.printStackTrace();
            }
            
            if( conn != null)
            try
            {
                conn.close();
                //closeconnection();
            }
            catch(Exception ex) {
                ex.printStackTrace();
            }
        }
        return flag;
    }
    
    public String IsValidation(String companyID) {
        String flag = "false";
        PreparedStatement command = null;
        ResultSet rs = null;
        
        Connection conn = null;
        
        
        try{
            conn = getConnection();
            
            String query = "select * from zib_cib_gb_company where company_code = ?";
            command = conn.prepareStatement(query);
            
            command.setString(1,companyID.trim());
            rs = command.executeQuery();
            
            while(rs.next()) 
            {
                if(rs.getString("beneficiary_validation").toUpperCase().equalsIgnoreCase("Y")){
                    flag = "true";
                }
                break;
            }
            
            }catch(Exception e){
                e.printStackTrace();
            }finally{
                
                try
                {
                    if( command != null)command.close();
                    //closeconnection();
                }
                catch(Exception ex) {
                    ex.printStackTrace();
                }
                try
                {
                    if(rs != null)rs.close();
                    
                    
                }
                catch(Exception ex) {
                    ex.printStackTrace();
                }
                try
                {                                   
                    if(conn != null)conn.close();
                    
                }
                catch(Exception ex) {
                    ex.printStackTrace();
                }
            }
        return flag;
    }
    
  
}