package com.zenithbank.banking.coporate.ibank.payment;
import com.zenithbank.banking.ibank.Data.*;
import com.zenithbank.banking.ibank.common.BaseAdapter;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.*;

public class PaymentReprocessAdapter extends BaseAdapter
{
  private Connection conn;
  private CallableStatement  cstmt;
  private ResultSet rs = null;
  private Statement s;
  public PaymentReprocessAdapter()
  {
  
  }
  
  
  
  private int getReprocessBatchID()
    {
    int ptid = -99;
    java.sql.CallableStatement sqlcommand = null;
  
     try
      {
    
        conn = getConnection();
        sqlcommand = conn.prepareCall("{?=call ZENBASENET..zsp_cib_get_ptid(?,?,?,?)}");
        sqlcommand.registerOutParameter(1,Types.INTEGER);
        sqlcommand.setString(2,"zib_cib_reprocess_pmt_batchid");
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
                    System.out.println("Error getting getReprocessBatchID: " + e.getMessage());
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
    
   //This method is called to initiate the reprocessing of Payments by the initiator
    public int ReprocessPayment(PaymentReprocessValue[] paymentReprocess) throws SQLException
    {

     String query =   "{? = call ZENBASENET..zsp_cib_ins_reprocess_payments(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
     CallableStatement cstmt = null;
     int batchid = 0;
     int returnCode = 0;

     try
       {
          batchid =  getReprocessBatchID();
          conn = getConnection();
          cstmt = conn.prepareCall(query) ;
          //if (batchid > 0)
        for(int i = 0; i < paymentReprocess.length; i++)
         {  
       /*
         System.out.println(" i ==== " + i);
         System.out.println(" batchid " + batchid);
         System.out.println(" paymentReprocess[i].getPayment_id()" + paymentReprocess[i].getPayment_id());
         System.out.println(" paymentReprocess[i].getPayment_due_date_new() " + paymentReprocess[i].getPayment_due_date_new());
         System.out.println(" paymentReprocess[i].getPayment_method_new() " + paymentReprocess[i].getPayment_method_new());
         System.out.println(" paymentReprocess[i].getPayment_type_new()" + paymentReprocess[i].getPayment_type_new());
         System.out.println(" paymentReprocess[i].getRouting_method_new()" + paymentReprocess[i].getRouting_method_new());
         System.out.println(" paymentReprocess[i].getVendor_acct_no_new()" + paymentReprocess[i].getVendor_acct_no_new());
         System.out.println(" paymentReprocess[i].getVendor_bank_new() " + paymentReprocess[i].getVendor_bank_new());
         System.out.println(" paymentReprocess[i].getVendor_bank_branch_new() " + paymentReprocess[i].getVendor_bank_branch_new());
         System.out.println(" paymentReprocess[i].getRouting_bank_code_new()" + paymentReprocess[i].getRouting_bank_code_new());
         System.out.println(" paymentReprocess[i].getSort_code_new()" + paymentReprocess[i].getSort_code_new());
         System.out.println(" paymentReprocess[i].getDebit_acct_no_new() " + paymentReprocess[i].getDebit_acct_no_new());
          System.out.println(" paymentReprocess[i].getDebit_acct_name_new() " + paymentReprocess[i].getDebit_acct_name_new());
         System.out.println(" paymentReprocess[i].getPtystatus_new() " + paymentReprocess[i].getPtystatus_new());
         System.out.println(" paymentReprocess[i].getApproval_level_new() " + paymentReprocess[i].getApproval_level_new());
         System.out.println(" paymentReprocess[i].getReturn_reason_new() " + paymentReprocess[i].getReturn_reason_new());
         System.out.println(" paymentReprocess[i].getIcount_new() " + paymentReprocess[i].getIcount_new());
         System.out.println(" paymentReprocess[i].getCreated_by() " + paymentReprocess[i].getCreated_by());
         System.out.println(" paymentReprocess[i].getBatch_reprocess_reason() " + paymentReprocess[i].getBatch_reprocess_reason());
         System.out.println(" paymentReprocess[i].getInitiator_action() " + paymentReprocess[i].getInitiator_action());
         System.out.println(" paymentReprocess[i].getStatus() " + paymentReprocess[i].getStatus());
        */  
          
          if(batchid <= 0) {
              cstmt.setNull(2, Types.INTEGER);
          }else{
             cstmt.setInt(2, batchid);
          }
          
          if( paymentReprocess[i].getPayment_id() <= 0) {
              cstmt.setNull(3, Types.DOUBLE);
          }else{
             cstmt.setDouble(3, paymentReprocess[i].getPayment_id());
          }
     
          if(paymentReprocess[i].getPayment_due_date_new() == null) {
              cstmt.setNull(4, Types.DATE);
          }else{            
             cstmt.setDate(4,new java.sql.Date(paymentReprocess[i].getPayment_due_date_new().getTime()));
          }
          if(paymentReprocess[i].getPayment_method_new() == null) {
              cstmt.setNull(5, Types.VARCHAR);
          }else{
             cstmt.setString(5,paymentReprocess[i].getPayment_method_new());
          }
     
          if(paymentReprocess[i].getPayment_type_new() == null) {
              cstmt.setNull(6, Types.VARCHAR);
          }else{
             cstmt.setString(6,paymentReprocess[i].getPayment_type_new());
          }
          if(paymentReprocess[i].getRouting_method_new() == null) {
              cstmt.setNull(7, Types.VARCHAR);
          }else{
             cstmt.setString(7,paymentReprocess[i].getRouting_method_new());
          }
          
          if(paymentReprocess[i].getVendor_acct_no_new() == null) {
              cstmt.setNull(8, Types.VARCHAR);
          }else{
             cstmt.setString(8,paymentReprocess[i].getVendor_acct_no_new());
          }
          
          if(paymentReprocess[i].getVendor_bank_new() == null) {
              cstmt.setNull(9,Types.VARCHAR);
          }else{
             cstmt.setString(9,paymentReprocess[i].getVendor_bank_new());
          }
          
          if(  paymentReprocess[i].getVendor_bank_branch_new() == null) {
              cstmt.setNull(10, Types.VARCHAR);
          }else{
             cstmt.setString(10,  paymentReprocess[i].getVendor_bank_branch_new());
          }
          
          if( paymentReprocess[i].getRouting_bank_code_new() == null) {
              cstmt.setNull(11, Types.VARCHAR);
          }else{
             cstmt.setString(11, paymentReprocess[i].getRouting_bank_code_new());
          }
          
          if(paymentReprocess[i].getSort_code_new() == null) {
              cstmt.setNull(12, Types.VARCHAR);
          }else{
             cstmt.setString(12, paymentReprocess[i].getSort_code_new());
          }
          
         if(paymentReprocess[i].getDebit_acct_no_new() == null) {
              cstmt.setNull(13, Types.VARCHAR);
          }else{
             cstmt.setString(13, paymentReprocess[i].getDebit_acct_no_new());
          }
          
        if(paymentReprocess[i].getDebit_acct_name_new() == null) {
              cstmt.setNull(14, Types.VARCHAR);
          }else{
             cstmt.setString(14, paymentReprocess[i].getDebit_acct_name_new());
          }
          
          if(paymentReprocess[i].getPtystatus_new() == null) {
              cstmt.setNull(15, Types.VARCHAR);
          }else{
             cstmt.setString(15, paymentReprocess[i].getPtystatus_new());
          }
          if(paymentReprocess[i].getApproval_level_new() <= 0) {
              cstmt.setNull(16, Types.INTEGER);
          }else{
             cstmt.setInt(16, paymentReprocess[i].getApproval_level_new());
          }
          if(paymentReprocess[i].getReturn_reason_new() == null) {
              cstmt.setNull(17, Types.VARCHAR);
          }else{
             cstmt.setString(17,paymentReprocess[i].getReturn_reason_new());
          }
           if(paymentReprocess[i].getIcount_new() <= 0) {
              cstmt.setNull(18, Types.INTEGER);
          }else{
             cstmt.setInt(18,paymentReprocess[i].getIcount_new());
          }
          if(paymentReprocess[i].getBatch_reprocess_reason() == null) {
              cstmt.setNull(19, Types.VARCHAR);
          }else{
             cstmt.setString(19,paymentReprocess[i].getBatch_reprocess_reason());
          }
           
           if(paymentReprocess[i].getInitiator_action() <= 0) {
              cstmt.setNull(20, Types.INTEGER);
          }else{
             cstmt.setInt(20,paymentReprocess[i].getInitiator_action());
          }
          
          if(paymentReprocess[i].getCreated_by() == null) {
              cstmt.setNull(21, Types.VARCHAR);
          }else{
             cstmt.setString(21,paymentReprocess[i].getCreated_by());
          }
          if(paymentReprocess[i].getStatus() <  0) {
              cstmt.setNull(22, Types.INTEGER);
          }else{
             cstmt.setInt(22,paymentReprocess[i].getStatus());
          }
                 cstmt.executeUpdate();
                cstmt.registerOutParameter(1, Types.INTEGER);
                returnCode = cstmt.getInt(1) ;
                // System.out.println("returnCode " + returnCode);
                //System.out.println("Insertion to zib_cib_reprocess_payments " + cstmt.getInt(1));
        }
       }
     catch(SQLException sqle)
       {
          sqle.printStackTrace();
           throw sqle;
       }
        finally
              {
               if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
              }

      return returnCode;
     }
     
  
  //This method is called to authorize the reprocessing of Payments by the authorizer
   public int AuthorizeReprocessPayment(PaymentReprocessValue[] paymentReprocess) throws SQLException
    {

     String query =   "{? = call ZENBASENET..zsp_cib_reprocess_payments(?,?,?,?,?,?)}";
     CallableStatement cstmt = null;
     int batchid = 0;
     int returnCode = 0;

     try
       {
          conn = getConnection();
          cstmt = conn.prepareCall(query) ;
        for(int i = 0; i < paymentReprocess.length; i++)
         {  
         /*
           System.out.println(" == Payment Authorization == " + i);
           
           System.out.println(" paymentReprocess[i].getReprocess_id()" + paymentReprocess[i].getReprocess_id());
           System.out.println(" paymentReprocess[i].getBatch_id()" + paymentReprocess[i].getBatch_id());
           System.out.println(" paymentReprocess[i].getPayment_id()" + paymentReprocess[i].getPayment_id());
           System.out.println(" paymentReprocess[i].getCompany_code()" + paymentReprocess[i].getCompany_code());
           System.out.println(" paymentReprocess[i].getAuthorized_by() " + paymentReprocess[i].getAuthorized_by());
           System.out.println(" paymentReprocess[i].getAuthorize_action() " + paymentReprocess[i].getAuthorize_action());
       */
         if(paymentReprocess[i].getReprocess_id() <= 0) {
              cstmt.setNull(2, Types.INTEGER);
          }else{
             cstmt.setInt(2, paymentReprocess[i].getReprocess_id());
          }
          if(batchid <= 0) {
              cstmt.setNull(3, Types.INTEGER);
          }else{
             cstmt.setInt(3, batchid);
          }
          if( paymentReprocess[i].getPayment_id() <= 0) {
              cstmt.setNull(4, Types.DOUBLE);
          }else{
             cstmt.setDouble(4, paymentReprocess[i].getPayment_id());
          }
          if(paymentReprocess[i].getCompany_code() == null) {
              cstmt.setNull(5, Types.VARCHAR);
          }else{
             cstmt.setString(5,paymentReprocess[i].getCompany_code());
          }
         if(paymentReprocess[i].getAuthorized_by() == null) {
              cstmt.setNull(6, Types.VARCHAR);
          }else{
             cstmt.setString(6,paymentReprocess[i].getAuthorized_by());
          }
         if(paymentReprocess[i].getAuthorize_action() <= 0) {
              cstmt.setNull(7, Types.INTEGER);
          }else{
             cstmt.setInt(7, paymentReprocess[i].getAuthorize_action());
          }
                /*cstmt.executeUpdate();
                cstmt.registerOutParameter(1, Types.INTEGER);
                returnCode = cstmt.getInt(1);*/
                //System.out.println("AuthorizeReprocessPayment Method returnedcode -  " + cstmt.getInt(1));
        }
       }
     catch(SQLException sqle)
       {
          sqle.printStackTrace();
           throw sqle;
       }
     finally
              {
               if(conn != null)    
                {
                try  { conn.close();} catch(Exception e) {}
                }
              }
     return returnCode;
     }
   
  
  public PaymentReprocessValue[] getPendingReprocessPaymentBatch(String CompanyCode,String createdatefrom,String createdateto,int status) throws SQLException, Exception
  {
    ArrayList aList = new ArrayList();
    PaymentReprocessValue[] pmtReprocessArray = new PaymentReprocessValue[0];
    PaymentReprocessValue paymentReprocess = new PaymentReprocessValue();
    SimpleDateFormat dformat = new SimpleDateFormat("MM/dd/yyyy");
    SimpleDateFormat dformat1 = new SimpleDateFormat("dd/MM/yyyy");
       
    try
    {
      conn = getConnection();
      
      String SQLQuery = "SELECT distinct batchid,batch_reprocess_reason from ZENBASENET..zib_cib_reprocess_payments ";
      SQLQuery += " WHERE  company_code = '" + CompanyCode + "'" ;
         //transaction date
        if ((!createdatefrom.trim().equalsIgnoreCase("")) && (!createdatefrom.trim().equalsIgnoreCase("")))
        {
          String sDateFrom = dformat.format(dformat1.parse(createdatefrom)).toString();
          String sDateTo = dformat.format(dformat1.parse(createdateto)).toString();
          SQLQuery += " AND create_dt between '" + sDateFrom + "' and '" + sDateTo + " 11:59:59.999 PM'";
        }
        if (status != 2)// 2 - for all request both awaiting authorization & authorized
          SQLQuery += " AND status =  " + status;//awaiting authorization- 0,authorized - 1
          s = conn.createStatement();
          rs = s.executeQuery(SQLQuery);
          
          //System.out.println("SQLQuery getPendingReprocessPaymentBatch" + SQLQuery);
          
      while (rs.next())
      {
        paymentReprocess = new PaymentReprocessValue();
        paymentReprocess.setBatch_id(rs.getInt("batchid"));  
        paymentReprocess.setBatch_reprocess_reason(rs.getString("batch_reprocess_reason"));
        aList.add(paymentReprocess);
      } 
      pmtReprocessArray = new PaymentReprocessValue[aList.size()];
      
      return (PaymentReprocessValue[])aList.toArray(pmtReprocessArray);
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
  
  
  //This method is to retrieve the Payment Reprocess Action for the Initiator and Authorizer
  public PaymentReprocessValue[] getReprocessPaymentAction(String actionType) throws SQLException, Exception
  {
    ArrayList aList = new ArrayList();
    PaymentReprocessValue[] pmtReprocessArray = new PaymentReprocessValue[0];
    Payment pmt = new Payment();
    PaymentReprocessValue paymentReprocess = new PaymentReprocessValue();
    
    try
    {
      conn = getConnection();
      
      String SQLQuery = "SELECT * from ZENBASENET..zib_cib_reprocess_action ";
      SQLQuery += " WHERE action_type = '" + actionType + "'";
      //System.out.println("SQLQuery" + SQLQuery);
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        paymentReprocess = new PaymentReprocessValue();
   
         if (actionType.equalsIgnoreCase("Initiator"))
         {
         paymentReprocess.setInitiator_action(rs.getInt("action_id"));
         paymentReprocess.setInitiator_action_desc(rs.getString("action_desc"));
         }
           
         if (actionType.equalsIgnoreCase("Authorizer"))
         {
         paymentReprocess.setAuthorize_action(rs.getInt("action_id"));
         paymentReprocess.setAuthorizer_action_desc(rs.getString("action_desc"));
         }
             aList.add(paymentReprocess);
      } 
      pmtReprocessArray = new PaymentReprocessValue[aList.size()];
      return (PaymentReprocessValue[])aList.toArray(pmtReprocessArray);
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

  
    
  public PaymentReprocessValue[] getPendingReprocessPayment(String CompanyCode,double batchID) throws SQLException, Exception
  {
    ArrayList aList = new ArrayList();
    PaymentReprocessValue[] pmtReprocessArray = new PaymentReprocessValue[0];
    Payment pmt = new Payment();
    PaymentReprocessValue paymentReprocess = new PaymentReprocessValue();
    
    try
    {
      conn = getConnection();
      //System.out.println("batch id " + batchID );
      String SQLQuery = "SELECT a.*,b.vendor_name,b.amount,c.action_desc from ZENBASENET..zib_cib_reprocess_payments a,ZENBASENET..zib_cib_pmt_payments b";
      SQLQuery += " ,ZENBASENET..zib_cib_reprocess_action c WHERE a.company_code = '" + CompanyCode + "'";
      if (batchID > 0)
      SQLQuery += " AND a.batchid = " + batchID ;
      SQLQuery += " AND a.payment_id = b.payment_id AND a.initiator_action = c.action_id AND c.action_type = 'Initiator'" ;
      System.out.println("SQLQuery " + SQLQuery);
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        
        paymentReprocess = new PaymentReprocessValue();
              
    
   /*     
      ptid                   numeric(38,0) NOT NULL,
    batchid                numeric(38,0) NOT NULL,
    batch_reprocess_reason varchar(250)  NULL,
    payment_id             numeric(30,0) NOT NULL,
    company_code           varchar(50)   NOT NULL,
    payment_due_date_old   datetime      NULL,
    payment_due_date_new   datetime      NULL,
    payment_method_old     varchar(35)   NULL,
    payment_method_new     varchar(35)   NULL,
    payment_type_old       varchar(30)   NULL,
    payment_type_new       varchar(30)   NULL,
    routing_method_old     varchar(30)   NULL,
    routing_method_new     varchar(30)   NULL,
    vendor_acct_no_old     varchar(25)   NULL,
    vendor_acct_no_new     varchar(25)   NULL,
    vendor_bank_old        varchar(80)   NULL,
    vendor_bank_new        varchar(80)   NULL,
    vendor_bank_branch_old varchar(40)   NULL,
    vendor_bank_branch_new varchar(40)   NULL,
    routing_bank_code_old  varchar(12)   NULL,
    routing_bank_code_new  varchar(12)   NULL,
    sort_code_old          varchar(20)   NULL,
    sort_code_new          varchar(20)   NULL,
    debit_acct_no_old      varchar(15)   NULL,
    debit_acct_no_new      varchar(15)   NULL,
    ptystatus_old          varchar(17)   NULL,
    ptystatus_new          varchar(17)   NULL,
    approval_level_old     smallint      NULL,
    approval_level_new     smallint      NULL,
    approval_date_old      datetime      NULL,
    return_reason_old      varchar(250)  NULL,
    return_reason_new      varchar(250)  NULL,
    icount_old             int           NULL,
    icount_new             int           NULL,
    created_by             varchar(30)   NULL,
    create_dt              datetime      DEFAULT GETDATE() NULL,
    authorized_by          varchar(30)   NULL,
    authorized_dt          datetime      NULL,
    status                 smallint      DEFAULT 0 NOT NULL,
   */   
  
   paymentReprocess.setReprocess_id(rs.getInt("ptid"));
   paymentReprocess.setBatch_reprocess_reason(rs.getString("batch_reprocess_reason"));
   paymentReprocess.setBatch_id(rs.getInt("batchid"));
   paymentReprocess.setPayment_id(rs.getDouble("payment_id"));
   
   paymentReprocess.setCompany_code(rs.getString("company_code"));
   paymentReprocess.setVendor_name(rs.getString("vendor_name"));
   paymentReprocess.setAmount(rs.getDouble("amount"));
   paymentReprocess.setPayment_due_date_old(rs.getTimestamp("payment_due_date_old"));
   paymentReprocess.setPayment_due_date_new(rs.getTimestamp("payment_due_date_new") );
   
   paymentReprocess.setPayment_method_old(rs.getString("payment_method_old"));
   paymentReprocess.setPayment_method_new(rs.getString("payment_method_new"));
   
   paymentReprocess.setPayment_type_old(rs.getString("payment_type_old"));
   paymentReprocess.setPayment_type_new(rs.getString("payment_type_new"));
   
   paymentReprocess.setRouting_method_old(rs.getString("routing_method_old"));
   paymentReprocess.setRouting_method_new(rs.getString("routing_method_new"));
   
   paymentReprocess.setVendor_acct_no_old(rs.getString("vendor_acct_no_old"));
   
   paymentReprocess.setVendor_acct_no_new(rs.getString("vendor_acct_no_new"));
   
   paymentReprocess.setVendor_bank_old(rs.getString("vendor_bank_old"));
   paymentReprocess.setVendor_bank_new(rs.getString("vendor_bank_new"));
   
   paymentReprocess.setVendor_bank_branch_old(rs.getString("vendor_bank_branch_old"));
   paymentReprocess.setVendor_bank_branch_new(rs.getString("vendor_bank_branch_new"));
   
   paymentReprocess.setRouting_bank_code_old(rs.getString("routing_bank_code_old"));
   paymentReprocess.setRouting_bank_code_new(rs.getString("routing_bank_code_new"));
   
   paymentReprocess.setSort_code_old(rs.getString("sort_code_old"));
   paymentReprocess.setSort_code_new(rs.getString("sort_code_new"));
   
   paymentReprocess.setDebit_acct_no_old(rs.getString("debit_acct_no_old"));
   paymentReprocess.setDebit_acct_no_new(rs.getString("debit_acct_no_new"));
   
   paymentReprocess.setDebit_acct_name_old(rs.getString("debit_acct_name_old"));
   paymentReprocess.setDebit_acct_name_new(rs.getString("debit_acct_name_new"));
   
   paymentReprocess.setPtystatus_old(rs.getString("ptystatus_old"));
   paymentReprocess.setPtystatus_new(rs.getString("ptystatus_new"));
   
   paymentReprocess.setApproval_level_old(rs.getInt("approval_level_old"));
   paymentReprocess.setApproval_level_new(rs.getInt("approval_level_new"));
   
   paymentReprocess.setReturn_reason_old(rs.getString("return_reason_old"));
   paymentReprocess.setReturn_reason_new(rs.getString("return_reason_new"));
   
   paymentReprocess.setIcount_old(rs.getInt("icount_old"));
   paymentReprocess.setIcount_new(rs.getInt("icount_new"));
   
   paymentReprocess.setCreated_by(rs.getString("created_by"));
   paymentReprocess.setCreate_dt(rs.getTimestamp("create_dt"));
   
   paymentReprocess.setInitiator_action(rs.getInt("initiator_action"));
   paymentReprocess.setInitiator_action_desc(rs.getString("action_desc"));
   paymentReprocess.setAuthorize_action(rs.getInt("authorizer_action"));
   paymentReprocess.setStatus(rs.getInt("status"));
   aList.add(paymentReprocess);
   } 
      pmtReprocessArray = new PaymentReprocessValue[aList.size()];
      
      return (PaymentReprocessValue[])aList.toArray(pmtReprocessArray);
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