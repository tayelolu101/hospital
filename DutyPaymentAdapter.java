package com.zenithbank.banking.coporate.ibank.payment;

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

public class DutyPaymentAdapter extends BaseAdapter
{
  private Connection conn = null;
  private CallableStatement  cstmt;
  private ResultSet rs = null;
  private Statement s;
  private PreparedStatement ps;
  private Connection liveCon;
  private SimpleDateFormat sd ;
  //= new java.text.SimpleDateFormat("MM/dd/yyyy");
  private String strToday = null;

  public DutyPaymentAdapter()
  {
  }
  
  public double insertToFileUpload(String FromAccount , String PaymentType , String BeneficiaryLookup , 
                                String VendorAddress, String VendorName, String VendorBank, 
                                String VendorBankBranch, String sCurrency, String PaymentDate, 
                                String PaymentRef, String ClientID, String Username, String ServerFilename) throws SQLException, Exception
  {
    try
    {
      conn = getConnection();
      double newBatchID = 0;
      ps = conn.prepareStatement("SELECT ISNULL(MAX(batchid),1)+1 from ZENBASENET..zib_cib_duty_fileupload");
      rs = ps.executeQuery();
      if (rs.next())
        newBatchID = rs.getDouble(1);

    
      String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_duty_fileupload (batchid, original_filename," ;	
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
      System.out.println("Exception >> "+ exp.getMessage());
      throw exp;
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  
  public double getBatchID(String strServerFilename, String ClientID) throws SQLException, Exception
  {
    try
    {
      conn = getConnection();
      String SQLQuery = "SELECT batchid FROM ZENBASENET..zib_cib_duty_fileupload " ;	
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
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
   public UserValue[] getUserContactDetails4recallRolegroup(String ClientID, int level,String rolegroupid,String userLoggedIn) throws SQLException, Exception
  {
    try
    {
      UserValue[] array = new  UserValue[0];
      UserValue uv = new UserValue();
      ArrayList aList = new ArrayList();
      conn = getConnection();
      String SQLQuery = "SELECT * FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel <= " + level + " and group_roleid = " +rolegroupid;
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
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
   public UserValue[] getUserContactDetails4recall(String ClientID, int level) throws SQLException, Exception
  {
    try
    {
      UserValue[] array = new  UserValue[0];
      UserValue uv = new UserValue();
      ArrayList aList = new ArrayList();
      conn = getConnection();
      String SQLQuery = "SELECT * FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel <= " + level;
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
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  public UserValue[] getUserContactDetailsRolegroup(String ClientID, int level,String rolegroupid,String userLoggedIn) throws SQLException, Exception
  {
    try
    {
      UserValue[] array = new  UserValue[0];
      UserValue uv = new UserValue();
      ArrayList aList = new ArrayList();
      conn = getConnection();
      //String SQLQuery = "SELECT * FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level + " and group_roleid = " +rolegroupid;
  String SQLQuery = "SELECT * FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level + " and (group_roleid = " +rolegroupid + " or group_roleid = -1 )"; //07042010 - To ensure the last authorizer gets email
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
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  public UserValue[] getUserContactDetails(String ClientID, int level) throws SQLException, Exception
  {
    try
    {
      UserValue[] array = new  UserValue[0];
      UserValue uv = new UserValue();
      ArrayList aList = new ArrayList();
      conn = getConnection();
      String SQLQuery = "SELECT * FROM ZENBASENET..ZIB_CIB_GB_LOGIN  WHERE HostCompany='" + ClientID + "' AND STATUS = '1' AND AuthLevel = " + level;
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
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
  
  public boolean checkTransRefExistence(String TransRef) throws SQLException, Exception
  {
    try
    {
      conn = getConnection();
      String SQLQuery = "SELECT trans_ref from ZENBASENET..zib_cib_duty_payments WHERE trans_ref = '" + TransRef + "'";
      
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
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
   private int getPaymentID()
    {
     String qryupdate = "UPDATE ZENBASENET..ZIB_PTID set PTID= PTID + 1 WHERE TABLE_NAME = 'zib_cib_duty_payments'";
     String qryselect = "SELECT PTID FROM ZENBASENET..ZIB_PTID WHERE TABLE_NAME = 'zib_cib_duty_payments'";
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
                  try 
                  {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                  }
                   catch(Exception e){}
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
                    if (conn != null) conn.close();
                    if (s != null) s.close();
                  }
                   catch(Exception e){}
                }
     return    vendor_id ;        
    }     
  
  private int getPaymentIDProcedure()
    {
    int ptid = -99;
    CallableStatement sqlcommand = null;
  
     try
                {
    
        conn = getConnection();
        sqlcommand = conn.prepareCall("{?=call ZENBASENET..zsp_cib_get_ptid(?,?,?,?)}");
        sqlcommand.registerOutParameter(1,Types.INTEGER);
        sqlcommand.setString(2,"zib_cib_duty_payments");
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
  
  public void insertPayment(PaymentValue pv) throws SQLException, Exception
  {
    try
    {
      
      //double newPaymentID = 0;//commented to use IDENTITY - 14012010
      // newPaymentID = getPaymentIDProcedure();//commented to use IDENTITY - 14012010
      conn = getConnection();
      //String SQLQuery = "INSERT INTO ZENBASENET..zib_cib_pmt_payments (payment_id, " ; //commented to use IDENTITY - 14012010
      
      
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
             SQLQuery +=               "sort_code,int_bank_name,vendor_bank_acctno,int_bank_bic)";
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
             SQLQuery +=  "'" + pv.getSortCode() + "','" + pv.getIntermediary_bank_name() + "','" + pv.getIntermediary_bank_acctno() + "','" + pv.getIntermediary_bank_bic() + "')";
          System.out.println("SQL SQLQuery >> " + SQLQuery); 
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
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
 /* public static void main(String args[])
    {
        DutyPaymentAdapter Service = new DutyPaymentAdapter();
     //   Service.Get_File_To_Read(1,"super", "000");
       // Service.Get_File_To_Read();
       int output = Service.getPaymentIDProcedure();
       System.out.println(output);
    } */
    
    
    public int CountPaymentAwaitingApproval(String companycode,String userid,int authlevel) throws SQLException
  {
    authlevel -= 1;
    int count = 0;
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
      PreparedStatement command = conn.prepareStatement(sqltext);
      command.setInt(1,authlevel);
      command.setString(2,companycode);
     ResultSet rs = command.executeQuery();
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
      closeconnection();
    }
   return count; 
  }private void closeconnection()
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
  
  
  public Payment[] getBeneficiaryExceptions(double batchID, String CompanyCode) throws SQLException, Exception
  {
    ArrayList aList = new ArrayList(); 
    Payment[] pArray = new Payment[0];
    Payment pmt = new Payment();
    
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
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
  }
  
}