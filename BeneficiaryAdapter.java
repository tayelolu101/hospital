package com.zenithbank.banking.coporate.ibank.payment;

import com.zenithbank.banking.ibank.common.BaseAdapter;
import java.sql.SQLException;
import java.sql.*;
import java.util.ArrayList;
import java.text.*;

public class BeneficiaryAdapter extends BaseAdapter
{
  private static BeneficiaryAdapter _BeneInstance = null;
  private static BeneficiaryAdapter instance = null;
  private static BeneficiaryAdapter _AddBeneInstance;
  private Connection conn = null;
  //private Connection conn1 = null;
  private CallableStatement  cstmt;
  private ResultSet rs = null;
  private Statement s;
  private PreparedStatement ps;
  private Connection liveCon;
  private SimpleDateFormat sd ;
  //= new java.text.SimpleDateFormat("MM/dd/yyyy");
  private String strToday = null;
  
  public BeneficiaryAdapter()
  {
  }
  public static BeneficiaryAdapter GetBeneInstance()
  {
    if(_BeneInstance == null)
      _BeneInstance = new BeneficiaryAdapter();
      return _BeneInstance;
  }
  public String getBranchName(String branchsortCode)
  {
    String branchName = "";
    String InsertSQL = " select address_line1 ,address_line2  from ZENBASENET..zib_nibssgiro_branches where branch_sortcode = '" + branchsortCode.trim() + "'";
    try{
    conn = getConnection();
    s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
    rs = s.executeQuery(InsertSQL);
     if(rs.next()) {
        branchName = rs.getString("address_line1") + " " + rs.getString("address_line2") ;
     }
    }catch (Exception ee) {
          System.out.println("Error connecting: " + ee);
          ee.printStackTrace();      
        }
    finally
    {
      if(conn != null)    
      {
        try  { conn.close();} catch(Exception e) {}
      }
    }
    return branchName;
  }
  
  public String getBankName(String banksortCode)
  {
    String BankName = "";
    String InsertSQL = " select bank_name from ZENBASENET..zib_nibssgiro_banks where bank_code = '" +banksortCode.trim() + "'";
    try{
    conn = getConnection();
    s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
    rs = s.executeQuery(InsertSQL);
     if(rs.next()) {
        BankName = rs.getString("bank_name");
     }
    }catch (Exception ee) {
          System.out.println("Error connecting: " + ee);
          ee.printStackTrace();      
        }
    finally
    {
      if(conn != null)    
      {
        try  { conn.close();} catch(Exception e) {}
      }
    }
    return BankName;
  }
  //
  public String getZenithBankSortCode()
  {
    String ZenithBankSortCode = "";
    String InsertSQL = " select bank_code from ZENBASENET..zib_nibssgiro_banks where bank_name LIKE '%ZENITH BANK%'";
    try{
    conn = getConnection();
    s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
    rs = s.executeQuery(InsertSQL);
     if(rs.next()) {
        ZenithBankSortCode = rs.getString("bank_code");
     }
    }catch (Exception ee) {
          System.out.println("Error connecting: " + ee);
          ee.printStackTrace();      
        }
    finally
    {
      if(conn != null)    
      {
        try  { conn.close();} catch(Exception e) {}
      }
    }
    return ZenithBankSortCode;
  }
  //select bank_code from ZENBASENET..zib_nibssgiro_banks where bank_name LIKE '%ZENITH BANK%'
  public int getNextVendorId()
  {
    int ptid = 0;
    String InsertSQL = " select isnull(max(vendor_id ) + 1,1) as vendor_id  from ZENBASENET..zib_cib_gb_beneficiary ";
    try{
    conn = getConnection();
    s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
    rs = s.executeQuery(InsertSQL);
     if(rs.next()) {
        ptid = rs.getInt("vendor_id");
     }
    }catch (Exception ee) {
          System.out.println("Error connecting: " + ee);
          ee.printStackTrace();      
        }
    finally
    {
      if(conn != null)    
      {
        try  { conn.close();} catch(Exception e) {}
      }
    }
    return ptid;
  }
  //public BeneficiaryValue InsertBene(String accesscode,String stitle_1,String sto_acct_no,String sdescription,double sissuedAmount) {
  public boolean InsertBene(BeneficiaryValue req) {
        BeneficiaryValue bulktransfervalues = new  BeneficiaryValue();
        boolean success = false;
        int vendorId = getNextVendorId();
        String bankname = getBankName(req.getGenBankName());
        String branchname = bankname + " : " + getBranchName(req.getGenBankClearingCode());
        String InsertSQL = "Insert into ZENBASENET..zib_cib_gb_beneficiary ";
        InsertSQL = InsertSQL + "(vendor_id,vendor_name ,vendor_bankid,vendor_bankname,vendor_bank_branchRecID,vendor_bank_branchName,vendor_acct_no ";
        InsertSQL = InsertSQL + " ,payment_type ,status ) ";        
        InsertSQL = InsertSQL + " values( "+ vendorId + ",'" + req.getBeneficiaryName() + "','" + req.getGenBankName() + "','" + bankname + "','" + req.getGenBankClearingCode() + "','" + branchname + "','";
        InsertSQL = InsertSQL +  req.getBeneficiaryAcctNo() + "','" + req.getpaymenttype() + "','"+req.getSTATUS() + "')";

        try {
            conn = getConnection();
            s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                               java.sql.ResultSet.CONCUR_READ_ONLY);
            s.executeUpdate(InsertSQL); 
            success = true;
        }catch (Exception ee) {
          success = false;
          System.out.println("Error connecting: " + ee);
          ee.printStackTrace();      
        }
        finally
        {
          if(conn != null)    
          {
            try  { conn.close();} catch(Exception e) {}
          }
        }
        //return bulktransfervalues;
        return success;
   }
  
  public BeneficiaryValue[] getPaymentType() {
         BeneficiaryValue[] array = new  BeneficiaryValue[0];
         BeneficiaryValue bulktransferstatement = new  BeneficiaryValue();
         //CallableStatement  cstmt;
          ArrayList list = new ArrayList();

        try {
            conn = getConnection();
            String getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type order by paymenttype "; 

            s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
            rs = s.executeQuery(getBenePaymtType);
           
               if(rs.next()) {
                        /*
                        Map b = new HashMap();
                       for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                           b.put(rs.getMetaData().getColumnName(i).toLowerCase().trim(), "" + i);
                       }
                       */
                       do {
                           bulktransferstatement = new  BeneficiaryValue();
                           bulktransferstatement.setpaymenttypeid(rs.getString("paymenttypeid"));
                           bulktransferstatement.setpaymenttype(rs.getString("paymenttype"));                           
                          
                           list.add(bulktransferstatement);

                       } while(rs.next());
                       array = new  BeneficiaryValue[list.size()];                   
              }
          } catch (Exception ee) {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
              list.add(bulktransferstatement);
          }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
    return (BeneficiaryValue[])list.toArray(array);
    }
   
   
    public BeneficiaryValue[] getPaymentType(String paymentInstructionType) {
         BeneficiaryValue[] array = new  BeneficiaryValue[0];
         BeneficiaryValue bulktransferstatement = new  BeneficiaryValue();
         //CallableStatement  cstmt;
          ArrayList list = new ArrayList();

        try {
            conn = getConnection();
        //String getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where paymentinstructiontype = '" + paymentInstructionType + "' order by paymenttype";//commented30092013
        String getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where paymentinstructiontype in ('" + paymentInstructionType + "') order by paymenttype";//added 30092013-SWIFT/DIRECTDEBIT,OTHERBANKDEBIT included

            s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
            rs = s.executeQuery(getBenePaymtType);
           
               if(rs.next()) {
                        /*
                        Map b = new HashMap();
                       for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                           b.put(rs.getMetaData().getColumnName(i).toLowerCase().trim(), "" + i);
                       }
                       */
                       do {
                           bulktransferstatement = new  BeneficiaryValue();
                           bulktransferstatement.setpaymenttypeid(rs.getString("paymenttypeid"));
                           bulktransferstatement.setpaymenttype(rs.getString("paymenttype"));                           
                           bulktransferstatement.setPaymentName(rs.getString("paymentname"));  
                           
                           System.out.println("=================i========== " + bulktransferstatement.getPaymentName());
                           list.add(bulktransferstatement);

                       } while(rs.next());
                       array = new  BeneficiaryValue[list.size()];                   
              }
          } catch (Exception ee) {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
              list.add(bulktransferstatement);
          }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
    return (BeneficiaryValue[])list.toArray(array);
    }
 
   
   
   
    public BeneficiaryValue[] getPaymentType(String paymentInstructionType,String CompanyCode) {
         BeneficiaryValue[] array = new  BeneficiaryValue[0];
         BeneficiaryValue bulktransferstatement = new  BeneficiaryValue();
         //CallableStatement  cstmt;
          ArrayList list = new ArrayList();
          System.out.println("=============company code ......." + CompanyCode);
        try {
         conn = getConnection();
         s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                       java.sql.ResultSet.CONCUR_READ_ONLY);
        //String getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where paymentinstructiontype = '" + paymentInstructionType + "' order by paymenttype";//commented30092013
        String checkPaymtTypeQry = "select allow_instant_tfr from zib_cib_gb_company where company_code = '" + CompanyCode + "'";
        String allow_instant_tfr = "N" ;
        String getBenePaymtType = "";
        rs = s.executeQuery(checkPaymtTypeQry);
        //System.out.println("checkPaymtTypeQry" + checkPaymtTypeQry);
         if(rs.next()) {
              allow_instant_tfr = (rs.getString("allow_instant_tfr") == null ? "N":rs.getString("allow_instant_tfr"));
                  
              }
        
        if (allow_instant_tfr.equalsIgnoreCase("Y"))
        {
           getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where paymentinstructiontype in ('" + paymentInstructionType + "') order by paymenttype";//added 30092013-SWIFT/DIRECTDEBIT,OTHERBANKDEBIT included
        }
        else
        {
           getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where paymentinstructiontype in ('" + paymentInstructionType + "') and paymenttype not in ('INTERSWITCH/BENEFICIARY') order by paymenttype";//added 30092013-SWIFT/DIRECTDEBIT,OTHERBANKDEBIT included
        }
             //System.out.println("getBenePaymtType" + getBenePaymtType);                            
            rs = s.executeQuery(getBenePaymtType);
               if(rs.next()) {
                        /*
                        Map b = new HashMap();
                       for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                           b.put(rs.getMetaData().getColumnName(i).toLowerCase().trim(), "" + i);
                       }
                       */
                       do { 
                           bulktransferstatement = new  BeneficiaryValue();
                           bulktransferstatement.setpaymenttypeid(rs.getString("paymenttypeid"));
                           bulktransferstatement.setpaymenttype(rs.getString("paymenttype"));   
                           //added payment name  ========//
                           bulktransferstatement.setPaymentName(rs.getString("payment_name"));  
                           System.out.println("=========================== " + bulktransferstatement.getPaymentName());
                           list.add(bulktransferstatement);

                       } while(rs.next());
                       array = new  BeneficiaryValue[list.size()];                   
              }
          } catch (Exception ee) {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
              list.add(bulktransferstatement);
          }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
    return (BeneficiaryValue[])list.toArray(array);
    }
   
   
    
    public BeneficiaryValue getFullDetails(String ptid) {
         //BeneficiaryValue[] array = new  BeneficiaryValue[0];
         BeneficiaryValue bulktransferstatement = new  BeneficiaryValue();
         //CallableStatement  cstmt;
          ArrayList list = new ArrayList();

        try {
            conn = getConnection();
            
            String getBenePaymtType = " select  vendor_acct_no,vendor_name,vendor_bank_branchRecID,vendor_bank_branchName,vendor_bankid,vendor_bankname,vendor_id,status from  ZENBASENET..zib_cib_gb_beneficiary "; 
            getBenePaymtType += " where vendor_id = " + Integer.parseInt(ptid) ;            
            s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
            rs = s.executeQuery(getBenePaymtType);
           
               if(rs.next()) {
                                                 
                           bulktransferstatement = new  BeneficiaryValue();
                           bulktransferstatement.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));
                           bulktransferstatement.setBeneficiaryName(rs.getString("vendor_name"));                           
                           bulktransferstatement.setGenBankClearingCode(rs.getString("vendor_bank_branchRecID")); 
                           bulktransferstatement.setGenBankName(rs.getString("vendor_bankname"));
                           bulktransferstatement.setBanksortcode(rs.getString("vendor_bankid")); //bank sort code 
                           bulktransferstatement.setBranchname(rs.getString("vendor_bank_branchName")); //branch name
                           bulktransferstatement.setSTATUSID(rs.getString("vendor_id"));
                           bulktransferstatement.setSTATUS(rs.getString("status"));
                          
                           //list.add(bulktransferstatement);

                       } 
                       //array = new  BeneficiaryValue[list.size()];                   
              
          } catch (Exception ee) {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
              list.add(bulktransferstatement);
          }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
     //return (BeneficiaryValue[])list.toArray(array);
     return bulktransferstatement;
    }
    
    //select  * from  zib_cib_gb_beneficiary
    //where payment_type = 'ZENITH BENEFICIARY'
    // get payment_type = ZENITH BENEFICIARY
    
    public BeneficiaryValue[] getZENITHBENEFICIARY(String paymenttype , String acctnumber) {
         BeneficiaryValue[] array = new  BeneficiaryValue[0];
         BeneficiaryValue bulktransferstatement = new  BeneficiaryValue();
         //CallableStatement  cstmt;
          ArrayList list = new ArrayList();

        try {
            conn = getConnection();
            
            String getBenePaymtType = " select  vendor_acct_no,vendor_name,vendor_bank_branchRecID,vendor_bankname,vendor_id,status from  ZENBASENET..zib_cib_gb_beneficiary "; 
            getBenePaymtType += " where payment_type = '" + paymenttype + "'";
            if(acctnumber.equalsIgnoreCase("")){ 
                  getBenePaymtType += " and 1 = 1 ";
            }else{
                  getBenePaymtType += " and vendor_acct_no = '" + acctnumber.trim()+"'";
            }
            s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
            rs = s.executeQuery(getBenePaymtType);
           
               if(rs.next()) {
                        /*
                        Map b = new HashMap();
                       for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                           b.put(rs.getMetaData().getColumnName(i).toLowerCase().trim(), "" + i);
                       }
                       */
                       do {
                           bulktransferstatement = new  BeneficiaryValue();
                           bulktransferstatement.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));
                           bulktransferstatement.setBeneficiaryName(rs.getString("vendor_name"));                           
                           bulktransferstatement.setGenBankClearingCode(rs.getString("vendor_bank_branchRecID")); 
                           bulktransferstatement.setGenBankName(rs.getString("vendor_bankname"));                           
                           bulktransferstatement.setSTATUSID(rs.getString("vendor_id"));
                           bulktransferstatement.setSTATUS(rs.getString("status"));
                          
                           list.add(bulktransferstatement);

                       } while(rs.next());
                       array = new  BeneficiaryValue[list.size()];                   
              }
          } catch (Exception ee) {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
              list.add(bulktransferstatement);
          }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
    return (BeneficiaryValue[])list.toArray(array);
    }
    
    
    public BeneficiaryValue[] getPaymentStatus() {
         BeneficiaryValue[] array = new  BeneficiaryValue[0];
         BeneficiaryValue bulktransferstatement = new  BeneficiaryValue();
         //CallableStatement  cstmt;
          ArrayList list = new ArrayList();

        try {
            conn = getConnection();
            String getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_status "; 

            s = conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     java.sql.ResultSet.CONCUR_READ_ONLY);
            rs = s.executeQuery(getBenePaymtType);
           
               if(rs.next()) {
                        /*
                        Map b = new HashMap();
                       for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                           b.put(rs.getMetaData().getColumnName(i).toLowerCase().trim(), "" + i);
                       }
                       */
                       do {
                         
                           bulktransferstatement = new  BeneficiaryValue();
                           bulktransferstatement.setSTATUS(rs.getString("STATUS"));
                           bulktransferstatement.setSTATUSID(rs.getString("STATUSID"));                           
                          
                           list.add(bulktransferstatement);

                       } while(rs.next());
                       array = new  BeneficiaryValue[list.size()];                   
              }
          } catch (Exception ee) {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
              list.add(bulktransferstatement);
          }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
    return (BeneficiaryValue[])list.toArray(array);
    }
  
   public ArrayList GetAllBanks()
  {
    ArrayList alist = new ArrayList();
    try
    {
      conn = getConnection();
      Statement command = conn.createStatement();
      ResultSet reader = command.executeQuery("select bank_code,bank_name,ho_sort_code from ZENBASENET..zib_nibssgiro_banks where bank_name NOT LIKE '%ZENITH BANK%' order by  bank_name ");
      alist = new ArrayList();
      Bank bank = null;
      while(reader.next())
      {
        bank = new Bank();
        bank.setBankCode(reader.getString("bank_code"));
        bank.setBankName(reader.getString("bank_name"));
        alist.add(bank);
      }
      reader.close();
    }
    catch(SQLException sqlexp)
    {
    }
    catch(Exception exp)
    {
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
    return alist;
  }
    
  public ArrayList GetAllBankBranches(String bankCode)
  {
    ArrayList alist = new ArrayList();
    String sqltext = "select bank_code,branch_sortcode,branch_name,address_line1 from ZENBASENET..zib_nibssgiro_branches where bank_code ='" + bankCode +"' order by branch_name";
    try
    {
      alist = GetBankBranches(sqltext);
    }
    catch(Exception exp)
    {
    }
    return alist;
  }
  //select bank_code,bank_name,ho_sort_code from ZENBASENET..zib_nibssgiro_banks where bank_name LIKE '%ZENITH BANK%'
  public ArrayList GetAllZenithBankBranches()
  {
    ArrayList alist = new ArrayList();
    String sqltext = "select bank_code,branch_sortcode,branch_name,address_line1 from ZENBASENET..zib_nibssgiro_branches where bank_code = (" ;
           sqltext += " select bank_code from ZENBASENET..zib_nibssgiro_banks where bank_name LIKE '%ZENITH BANK%')" ;
    try
    {
      alist = GetBankBranches(sqltext);
    }
    catch(Exception exp)
    {
    }
    return alist;
  }
  
  public ArrayList GetBankBranches(String sqlText) 
  {
    ArrayList alist = new ArrayList();
    try
    {
      conn = getConnection();
      Statement command = conn.createStatement();
      ResultSet reader = command.executeQuery(sqlText);
      BankBranch bankbranch = null;
      while(reader.next())
      {
        bankbranch = new BankBranch();
        bankbranch.setBankCode(reader.getString("bank_code"));
        bankbranch.setBranchName(reader.getString("branch_name") + "  " + (reader.getString("address_line1") == null? "" :  reader.getString("address_line1") ));
        bankbranch.setBrachSortCode(reader.getString("branch_sortcode"));
        alist.add(bankbranch);
       }
        reader.close();
        command.close();
        return alist;
    }
    catch(SQLException sqlexp)
    {
    }
    catch(Exception exp)
    {
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
    return alist;
  }
  
  
  public BeneficiaryValue[] getBeneficiaryList(String CompanyId, String PaymentType) throws SQLException, Exception
  {
    BeneficiaryValue[] array = new BeneficiaryValue[0];
    BeneficiaryValue bv = new  BeneficiaryValue();
    //CallableStatement  cstmt;
    ArrayList aList = new ArrayList();
    try
    {
      
      conn = getConnection();
      String SQLQuery = " Select vendor_id, vendor_name, company_id,vendor_code "; //marjor added vendor_code
      SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary ";
      SQLQuery += " where company_id = '" + CompanyId + "'";
      //SQLQuery += " where company_id = '069'";
      SQLQuery += " and status = 'Active' and approved = 1 ";
      SQLQuery += " and payment_type = '" + PaymentType.trim()+"' order  by  vendor_name ";
     /* if (PaymentType.trim().equalsIgnoreCase("ZENITH/BENEFICIARY"))
        SQLQuery += " and payment_type = 'ZENITH/BENEFICIARY' ";
      if (PaymentType.trim().equalsIgnoreCase("INTERBANK/BENEFICIARY"))
        SQLQuery += " and payment_type = 'INTERBANK/BENEFICIARY' ";
      if (PaymentType.trim().equalsIgnoreCase("FOREIGN/BENEFICIARY"))
        SQLQuery += " and payment_type = 'FOREIGN/BENEFICIARY' ";*/
     //System.out.println("SQLQuery " + SQLQuery ); 
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        bv = new BeneficiaryValue();
        bv.setVendorId(rs.getDouble("vendor_id"));
        bv.setVendorName(rs.getString("vendor_name"));
        bv.setCompanyId(rs.getString("company_id"));
        bv.setBeneficiaryRef(rs.getString("vendor_code"));//marjor addded
        aList.add(bv);
      }
      array = new  BeneficiaryValue[aList.size()]; 
      
      return (BeneficiaryValue[])aList.toArray(array);
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
      return (BeneficiaryValue[])aList.toArray(array);
    
  }
  
//implemented for beneficiary assignment/restriction to a user 24/04/2011
    public BeneficiaryValue[] getBeneficiaryList(String CompanyId, String PaymentType,int userId) throws SQLException, Exception
    {
      BeneficiaryValue[] array = new BeneficiaryValue[0];
      BeneficiaryValue bv = new  BeneficiaryValue();
      //CallableStatement  cstmt;
      ArrayList aList = new ArrayList();
      try
      {
        
        conn = getConnection();
        String SQLQuery = " Select vendor_id, vendor_name, company_id,vendor_code,vendor_acct_no,vendor_bankname "; //22-07-2014 added vendor_code,Vendor Account,Vendor Bank
        SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary ";
        SQLQuery += " where company_id = '" + CompanyId + "'";
        //SQLQuery += " where company_id = '069'";
        SQLQuery += " and status = 'Active' and approved = 1 ";
//implemented for beneficiary assignment/restriction to a user 24/04/2011
        SQLQuery += " and vendor_id not in ( select vendor_id from ZENBASENET..zib_cib_beneficiary_restrict where seq = " +  userId + " and company_id = '" + CompanyId + "')";

        SQLQuery += " and payment_type = '" + PaymentType.trim()+"' order  by  vendor_name ";
       /* if (PaymentType.trim().equalsIgnoreCase("ZENITH/BENEFICIARY"))
          SQLQuery += " and payment_type = 'ZENITH/BENEFICIARY' ";
        if (PaymentType.trim().equalsIgnoreCase("INTERBANK/BENEFICIARY"))
          SQLQuery += " and payment_type = 'INTERBANK/BENEFICIARY' ";
        if (PaymentType.trim().equalsIgnoreCase("FOREIGN/BENEFICIARY"))
          SQLQuery += " and payment_type = 'FOREIGN/BENEFICIARY' ";*/
      // System.out.println("SQLQuery " + SQLQuery ); 
        s = conn.createStatement();
        rs = s.executeQuery(SQLQuery);
        while (rs.next())
        {
          bv = new BeneficiaryValue();
          bv.setVendorId(rs.getDouble("vendor_id"));
          bv.setVendorName(rs.getString("vendor_name"));
          bv.setCompanyId(rs.getString("company_id"));
          bv.setBeneficiaryRef(rs.getString("vendor_code"));//addded 22072014
          bv.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));//addded 22072014
          bv.setGenBankName(rs.getString("vendor_bankname"));//addded 22072014
          aList.add(bv);
        }
        array = new  BeneficiaryValue[aList.size()]; 
        
        return (BeneficiaryValue[])aList.toArray(array);
      }
      catch(SQLException sqlExp)
      {
        System.out.println("SQL Exception >> "+ sqlExp.getMessage());
      }
      catch(Exception exp)
      {
        System.out.println("Exception >> "+ exp.getMessage());
      }
      finally
      {
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
        return (BeneficiaryValue[])aList.toArray(array);
      
    }
    
  
  
  
  //marjor added this method to get Beneficiary list by Company code for Beneficiary Ammendmment for Maersk
   public BeneficiaryValue[] getBeneficiaryList(String CompanyId) throws SQLException, Exception
  {
    BeneficiaryValue[] array = new BeneficiaryValue[0];
    BeneficiaryValue bv = new  BeneficiaryValue();
    //CallableStatement  cstmt;
    ArrayList aList = new ArrayList();
    try
    {
      
      conn = getConnection();
      String SQLQuery = " Select vendor_id, vendor_name, company_id,vendor_code "; //marjor added vendor_code
      SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary ";
      SQLQuery += " where company_id = '" + CompanyId + "'";
      //SQLQuery += " where company_id = '069'";
      SQLQuery += " and status = 'Active' and approved = 1 ";
      SQLQuery += " order  by  vendor_name ";
     // SQLQuery += " and payment_type = '" + PaymentType.trim()+"' order  by  vendor_name ";
     /* if (PaymentType.trim().equalsIgnoreCase("ZENITH/BENEFICIARY"))
        SQLQuery += " and payment_type = 'ZENITH/BENEFICIARY' ";
      if (PaymentType.trim().equalsIgnoreCase("INTERBANK/BENEFICIARY"))
        SQLQuery += " and payment_type = 'INTERBANK/BENEFICIARY' ";
      if (PaymentType.trim().equalsIgnoreCase("FOREIGN/BENEFICIARY"))
        SQLQuery += " and payment_type = 'FOREIGN/BENEFICIARY' ";*/
      
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        bv = new BeneficiaryValue();
        bv.setVendorId(rs.getDouble("vendor_id"));
        bv.setVendorName(rs.getString("vendor_name"));
        bv.setCompanyId(rs.getString("company_id"));
        bv.setBeneficiaryRef(rs.getString("vendor_code"));//marjor addded
        aList.add(bv);
      }
      array = new  BeneficiaryValue[aList.size()]; 
      
      return (BeneficiaryValue[])aList.toArray(array);
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
      return (BeneficiaryValue[])aList.toArray(array);
    
  }
 
  
  
  //public BeneficiaryValue[] getBeneficiaryList(String CompanyId,int approvalLevel) throws SQLException, Exception
  public BeneficiaryValue[] getBeneficiaryList(String CompanyId, int approvalLevel, String vendorName, String paymentType, String bankName, String vendorCode)throws SQLException, Exception
  {
    BeneficiaryValue[] array = new BeneficiaryValue[0];
    BeneficiaryValue bv = new  BeneficiaryValue();
    //CallableStatement  cstmt;
    ArrayList aList = new ArrayList();
    try
    {
      
      conn = getConnection();
    /*
      String SQLQuery = " Select * ";
      SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary ";
      SQLQuery += " where company_id = '" + CompanyId + "'";
      if(approvalLevel >= 0) SQLQuery += " and approved = 0 and  approval_level=" + approvalLevel ;
       SQLQuery += " and status = 'Active' order  by  vendor_name ";
       System.out.println(" getBeneficiaryList " + SQLQuery);  
    */
     String SQLQuery = " Select * ";
                 SQLQuery = (new StringBuilder()).append(SQLQuery).append(" FROM ZENBASENET..zib_cib_gb_beneficiary ").toString();
                 SQLQuery = (new StringBuilder()).append(SQLQuery).append(" where company_id = '").append(CompanyId).append("'").toString();
                 if(approvalLevel >= 0)
                     SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and approved = 0 and  approval_level=").append(approvalLevel).toString();
                 if(!vendorCode.equalsIgnoreCase(""))
                     SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_code = '").append(vendorCode).append("'").toString();
                 if(!vendorName.equalsIgnoreCase(""))
                     SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_name like '%").append(vendorName).append("%'").toString();
                 if(!paymentType.equalsIgnoreCase("ALL"))
                     SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and payment_type = '").append(paymentType).append("'").toString();
                 if(!bankName.equalsIgnoreCase(""))
                     SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_bankname like '%").append(bankName).append("%'").toString();
                 SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and status = 'Active' order  by  vendor_name ").toString();
                 
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        bv = new BeneficiaryValue();
        bv.setVendorId(rs.getDouble("vendor_id"));
        bv.setVendorName(rs.getString("vendor_name"));
        //bv.setCompanyId(rs.getString("company_id"));
        bv.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));
        bv.setBeneficiaryRef(rs.getString("vendor_code"));
        bv.setBranchname(rs.getString("vendor_bankname"));
        
       //Begin- lanre added to include sort codes
        bv.setGenBankClearingCode((rs.getString("vendor_bankid") == null) ? "" :rs.getString("vendor_bankid") );
        bv.setBanksortcode((rs.getString("vendor_bank_branchRecID") == null) ? "":rs.getString("vendor_bank_branchRecID"));
       //End- lanre added to include sort codes
        
        bv.setApprovalLevel(rs.getInt("approval_level"));
        bv.setApprovedStatus(rs.getInt("approved"));
        bv.setAuthorizerid(rs.getInt("authorizer_id"));
        aList.add(bv);
      }
      array = new  BeneficiaryValue[aList.size()]; 
      
      return (BeneficiaryValue[])aList.toArray(array);
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
      return (BeneficiaryValue[])aList.toArray(array);
    
  }
  
  
    public BeneficiaryValue[] getBeneficiaryList_Pending(String CompanyId,int approvalLevel) throws SQLException, Exception
    {
      BeneficiaryValue[] array = new BeneficiaryValue[0];
      BeneficiaryValue bv = new  BeneficiaryValue();
      //CallableStatement  cstmt;
      ArrayList aList = new ArrayList();
      try
      {
        
        conn = getConnection();
        String SQLQuery = " Select * ";
        SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary ";
        SQLQuery += " where company_id = '" + CompanyId + "'";
        SQLQuery += " and approved = 0 " ;
        SQLQuery += " and status = 'Active' order  by  vendor_name ";
     System.out.println(" getBeneficiaryList_pending " + SQLQuery);  
        s = conn.createStatement();
        rs = s.executeQuery(SQLQuery);
        while (rs.next())
        {
          bv = new BeneficiaryValue();
          bv.setVendorId(rs.getDouble("vendor_id"));
          bv.setVendorName(rs.getString("vendor_name"));
          //bv.setCompanyId(rs.getString("company_id"));
          bv.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));
          bv.setBeneficiaryRef(rs.getString("vendor_code"));
          bv.setBranchname(rs.getString("vendor_bankname"));
          
         //Begin- lanre added to include sort codes
          bv.setGenBankClearingCode((rs.getString("vendor_bankid") == null) ? "" :rs.getString("vendor_bankid") );
          bv.setBanksortcode((rs.getString("vendor_bank_branchRecID") == null) ? "":rs.getString("vendor_bank_branchRecID"));
         //End- lanre added to include sort codes
          
          bv.setApprovalLevel(rs.getInt("approval_level"));
          bv.setApprovedStatus(rs.getInt("approved"));
          bv.setAuthorizerid(rs.getInt("authorizer_id"));
          aList.add(bv);
        }
        array = new  BeneficiaryValue[aList.size()]; 
        
        return (BeneficiaryValue[])aList.toArray(array);
      }
      catch(SQLException sqlExp)
      {
        System.out.println("SQL Exception >> "+ sqlExp.getMessage());
      }
      catch(Exception exp)
      {
        System.out.println("Exception >> "+ exp.getMessage());
      }
      finally
      {
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
        return (BeneficiaryValue[])aList.toArray(array);
      
    }
    
  
  
    public BeneficiaryValue[] getBeneficiaryList_TwoToSign(String CompanyId,int approvalLevel,String two_to_sign,int Authorizer_id) throws SQLException, Exception
    {
      BeneficiaryValue[] array = new BeneficiaryValue[0];
      BeneficiaryValue bv = new  BeneficiaryValue();
      //CallableStatement  cstmt;
      ArrayList aList = new ArrayList();
      try
      {
        
        conn = getConnection();
        String SQLQuery = " Select * ";
        SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary ";
        SQLQuery += " where company_id = '" + CompanyId + "'";
        if(approvalLevel >= 0) SQLQuery += " and approved = 0 and  approval_level=" + approvalLevel ;
        //SQLQuery += " where company_id = '069'";
        //Begin-02/12/2010 - To prevent the authorizer from approving previously approved beneficairy
        if (two_to_sign.trim().equalsIgnoreCase("Y"))
        SQLQuery += " and authorizer_id != " + Authorizer_id ;
        //End-02122010
        
        SQLQuery += " and status = 'Active' order  by  vendor_name ";
     //System.out.println(" getBeneficiaryList " + SQLQuery);  
        s = conn.createStatement();
        rs = s.executeQuery(SQLQuery);
        while (rs.next())
        {
          bv = new BeneficiaryValue();
          bv.setVendorId(rs.getDouble("vendor_id"));
          bv.setVendorName(rs.getString("vendor_name"));
          //bv.setCompanyId(rs.getString("company_id"));
          bv.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));
          bv.setBeneficiaryRef(rs.getString("vendor_code"));
          bv.setBranchname(rs.getString("vendor_bankname"));
          
         //Begin- lanre added to include sort codes
          bv.setGenBankClearingCode((rs.getString("vendor_bankid") == null) ? "" :rs.getString("vendor_bankid") );
          bv.setBanksortcode((rs.getString("vendor_bank_branchRecID") == null) ? "":rs.getString("vendor_bank_branchRecID"));
         //End- lanre added to include sort codes
          
          bv.setApprovalLevel(rs.getInt("approval_level"));
          bv.setApprovedStatus(rs.getInt("approved"));
          bv.setAuthorizerid(rs.getInt("authorizer_id"));
          aList.add(bv);
        }
        array = new  BeneficiaryValue[aList.size()]; 
        
        return (BeneficiaryValue[])aList.toArray(array);
      }
      catch(SQLException sqlExp)
      {
        System.out.println("SQL Exception >> "+ sqlExp.getMessage());
      }
      catch(Exception exp)
      {
        System.out.println("Exception >> "+ exp.getMessage());
      }
      finally
      {
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }
        return (BeneficiaryValue[])aList.toArray(array);
      
    }
    
  
   //public BeneficiaryValue[] getBeneficiaryList_RoleGroup(String CompanyId,int group_role, int approvalLevel) 
   public BeneficiaryValue[] getBeneficiaryList_RoleGroup(String CompanyId, int group_role, int approvalLevel, String vendorName, String paymentType, String bankName, String vendorCode)
   throws SQLException, Exception
  {
    BeneficiaryValue[] array = new BeneficiaryValue[0];
    BeneficiaryValue bv = new  BeneficiaryValue();
    //CallableStatement  cstmt;
    ArrayList aList = new ArrayList();
    try
    {
      
      conn = getConnection();
      /*
      String SQLQuery = " Select * ";
      SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary a, ZENBASENET..zib_cib_bene_fileupload b ";
      SQLQuery += " where a.company_id = '" + CompanyId + "' and ";
      SQLQuery += " a.batchid = b.batchid and b.group_roleid in (select distinct group_roleid  from ZENBASENET..zib_cib_gb_roleresource_grp where authorise = '1' and roleid = "+group_role+") ";
      if(approvalLevel >= 0) SQLQuery += " and a.approved = 0 and  a.approval_level=" + approvalLevel;
      SQLQuery += " and a.status = 'Active' order  by  a.vendor_name ";
      */
       String SQLQuery = " Select * ";
                   SQLQuery = (new StringBuilder()).append(SQLQuery).append(" FROM ZENBASENET..zib_cib_gb_beneficiary a, ZENBASENET..zib_cib_bene_fileupload b ").toString();
                   SQLQuery = (new StringBuilder()).append(SQLQuery).append(" where a.company_id = '").append(CompanyId).append("' and ").toString();
                   SQLQuery = (new StringBuilder()).append(SQLQuery).append(" a.batchid = b.batchid and b.group_roleid in (select distinct group_roleid  from ZENBASENET..zib_cib_gb_roleresource_grp where authorise = '1' and roleid = ").append(group_role).append(") ").toString();
                   if(approvalLevel >= 0)
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and a.approved = 0 and  a.approval_level=").append(approvalLevel).toString();
                   if(!vendorCode.equalsIgnoreCase(""))
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_code = '").append(vendorCode).append("'").toString();
                   if(!vendorName.equalsIgnoreCase(""))
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_name like '%").append(vendorName).append("%'").toString();
                   if(!paymentType.equalsIgnoreCase("ALL"))
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and payment_type = '").append(paymentType).append("'").toString();
                   if(!bankName.equalsIgnoreCase(""))
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_bankname like '%").append(bankName).append("%'").toString();
                   SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and a.status = 'Active' order  by  a.vendor_name ").toString();
                
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        bv = new BeneficiaryValue();
        bv.setVendorId(rs.getDouble("vendor_id"));
        bv.setVendorName(rs.getString("vendor_name"));
        //bv.setCompanyId(rs.getString("company_id"));
        bv.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));
        bv.setBeneficiaryRef(rs.getString("vendor_code"));
        bv.setBranchname(rs.getString("vendor_bankname"));
        
       //Begin- lanre added to include sort codes
        bv.setGenBankClearingCode((rs.getString("vendor_bankid") == null) ? "" :rs.getString("vendor_bankid") );
        bv.setBanksortcode((rs.getString("vendor_bank_branchRecID") == null) ? "":rs.getString("vendor_bank_branchRecID"));
       //End- lanre added to include sort codes
       
        bv.setApprovalLevel(rs.getInt("approval_level"));
        bv.setApprovedStatus(rs.getInt("approved"));
        bv.setuploadOperator(rs.getString("upload_operator"));
          bv.setAuthorizerid(rs.getInt("authorizer_id"));

        aList.add(bv);
      }
      array = new  BeneficiaryValue[aList.size()]; 
      
      return (BeneficiaryValue[])aList.toArray(array);
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
      return (BeneficiaryValue[])aList.toArray(array);
    
  }
  
//public BeneficiaryValue[] getBeneficiaryList_Auth(String CompanyId,String loginid, int approvalLevel) 
  public BeneficiaryValue[] getBeneficiaryList_Auth(String CompanyId,String loginid, int approvalLevel, String vendorName, String paymentType, String bankName, String vendorCode)
  throws SQLException, Exception
  {
    BeneficiaryValue[] array = new BeneficiaryValue[0];
    BeneficiaryValue bv = new  BeneficiaryValue();
    //CallableStatement  cstmt;
    ArrayList aList = new ArrayList();
    try
    {
      
      conn = getConnection();
      /*
      String SQLQuery = " Select * ";
      SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary a, ZENBASENET..zib_cib_bene_fileupload b ";
      SQLQuery += " where a.company_id = '" + CompanyId + "' and ";
      SQLQuery += " a.batchid = b.batchid ";
      if(approvalLevel >= 0) SQLQuery += " and a.approved = 0 and  a.approval_level=" + approvalLevel;
      //SQLQuery += " a.batchid = b.batchid and b.upload_operator <> '"+loginid+"'";
      SQLQuery += " and a.status = 'Active' order  by  a.vendor_name ";
      */
       String SQLQuery = " Select * ";
                  SQLQuery = (new StringBuilder()).append(SQLQuery).append(" FROM ZENBASENET..zib_cib_gb_beneficiary a, ZENBASENET..zib_cib_bene_fileupload b ").toString();
                  SQLQuery = (new StringBuilder()).append(SQLQuery).append(" where a.company_id = '").append(CompanyId).append("' and ").toString();
                  SQLQuery = (new StringBuilder()).append(SQLQuery).append(" a.batchid = b.batchid ").toString();
                  if(approvalLevel >= 0)
                      SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and a.approved = 0 and  a.approval_level=").append(approvalLevel).toString();
                  if(!vendorCode.equalsIgnoreCase(""))
                      SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_code = '").append(vendorCode).append("'").toString();
                  if(!vendorName.equalsIgnoreCase(""))
                      SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_name like '%").append(vendorName).append("%'").toString();
                  if(!paymentType.equalsIgnoreCase("ALL"))
                      SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and payment_type = '").append(paymentType).append("'").toString();
                  if(!bankName.equalsIgnoreCase(""))
                      SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_bankname like '%").append(bankName).append("%'").toString();
                  SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and a.status = 'Active' order  by  a.vendor_name ").toString();
                 
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        bv = new BeneficiaryValue();
        bv.setVendorId(rs.getDouble("vendor_id"));
        bv.setVendorName(rs.getString("vendor_name"));
        //bv.setCompanyId(rs.getString("company_id"));
        bv.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));
        bv.setBeneficiaryRef(rs.getString("vendor_code"));
        bv.setBranchname(rs.getString("vendor_bankname"));
        
        //Begin- lanre added to include sort codes
        bv.setGenBankClearingCode((rs.getString("vendor_bankid") == null) ? "" :rs.getString("vendor_bankid") );
        bv.setBanksortcode((rs.getString("vendor_bank_branchRecID") == null) ? "":rs.getString("vendor_bank_branchRecID"));
       //End- lanre added to include sort codes
       
        bv.setApprovalLevel(rs.getInt("approval_level"));
        bv.setApprovedStatus(rs.getInt("approved"));
        bv.setuploadOperator(rs.getString("upload_operator"));
        bv.setAuthorizerid(rs.getInt("authorizer_id"));

        aList.add(bv);
      }
      array = new  BeneficiaryValue[aList.size()]; 
      
      return (BeneficiaryValue[])aList.toArray(array);
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
      return (BeneficiaryValue[])aList.toArray(array);
    
  }
  
  
  // public BeneficiaryValue[] getBeneficiaryList_RoleGroup_Auth(String CompanyId,int group_role,String loginid, int approvalLevel) throws SQLException, Exception
   public BeneficiaryValue[] getBeneficiaryList_RoleGroup_Auth(String CompanyId, int group_role, String loginid, int approvalLevel, String vendorName, String paymentType, String bankName, 
             String vendorCode)
  {
    BeneficiaryValue[] array = new BeneficiaryValue[0];
    BeneficiaryValue bv = new  BeneficiaryValue();
    //CallableStatement  cstmt;
    ArrayList aList = new ArrayList();
    try
    {
      
      conn = getConnection();
      /*
      String SQLQuery = " Select * ";
      SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary a, ZENBASENET..zib_cib_bene_fileupload b ";
      SQLQuery += " where a.company_id = '"+CompanyId+"' and ";
      SQLQuery += " a.batchid = b.batchid and b.group_roleid in (select distinct group_roleid  from ZENBASENET..zib_cib_gb_roleresource_grp where authorise = '1' and roleid = " +group_role+ ") ";
       if(approvalLevel >= 0) SQLQuery += " and a.approved = 0 and  a.approval_level=" + approvalLevel;
      SQLQuery += " and a.status = 'Active' order  by  a.vendor_name ";
      */
      
       String SQLQuery = " Select * ";
                   SQLQuery = (new StringBuilder()).append(SQLQuery).append(" FROM ZENBASENET..zib_cib_gb_beneficiary a, ZENBASENET..zib_cib_bene_fileupload b ").toString();
                   SQLQuery = (new StringBuilder()).append(SQLQuery).append(" where a.company_id = '").append(CompanyId).append("' and ").toString();

                   SQLQuery = (new StringBuilder()).append(SQLQuery).append(" a.batchid = b.batchid and b.group_roleid in (select distinct group_roleid  from ZENBASENET..zib_cib_gb_roleresource_grp where authorise = '1' and roleid = ").append(group_role).append(") ").toString();
                   if(approvalLevel >= 0)
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and a.approved = 0 and  a.approval_level=").append(approvalLevel).toString();
                   if(!vendorCode.equalsIgnoreCase(""))
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_code = '").append(vendorCode).append("'").toString();
                   if(!vendorName.equalsIgnoreCase(""))
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_name like '%").append(vendorName).append("%'").toString();
                   if(!paymentType.equalsIgnoreCase("ALL"))
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and payment_type = '").append(paymentType).append("'").toString();
                   if(!bankName.equalsIgnoreCase(""))
                       SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and vendor_bankname like '%").append(bankName).append("%'").toString();
                   SQLQuery = (new StringBuilder()).append(SQLQuery).append(" and a.status = 'Active' order  by  a.vendor_name ").toString();

      
      
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      while (rs.next())
      {
        bv = new BeneficiaryValue();
        bv.setVendorId(rs.getDouble("vendor_id"));
        bv.setVendorName(rs.getString("vendor_name"));
        //bv.setCompanyId(rs.getString("company_id"));
        bv.setBeneficiaryAcctNo(rs.getString("vendor_acct_no"));
        bv.setBeneficiaryRef(rs.getString("vendor_code"));
        bv.setBranchname(rs.getString("vendor_bankname"));
        
        //Begin- lanre added to include sort codes
        bv.setGenBankClearingCode((rs.getString("vendor_bankid") == null) ? "" :rs.getString("vendor_bankid") );
        bv.setBanksortcode((rs.getString("vendor_bank_branchRecID") == null) ? "":rs.getString("vendor_bank_branchRecID"));
       //End- lanre added to include sort codes
       
        bv.setApprovalLevel(rs.getInt("approval_level"));
        bv.setApprovedStatus(rs.getInt("approved"));
        bv.setuploadOperator(rs.getString("upload_operator"));
          bv.setAuthorizerid(rs.getInt("authorizer_id"));

        aList.add(bv); 
      }
      array = new  BeneficiaryValue[aList.size()]; 
      
      return (BeneficiaryValue[])aList.toArray(array);
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }
      return (BeneficiaryValue[])aList.toArray(array);
    
  }
  public BeneficiaryValue[] getBeneficiaryPage(BeneficiaryValue[] BeneficiaryList, int StartIndex, int NumOfRows) throws Exception
  {
  ArrayList alist = new ArrayList();
    try
    {
      if(BeneficiaryList.length > StartIndex)
      {
        for(int i = StartIndex; i < StartIndex + NumOfRows; i++)
        {
          if(i < BeneficiaryList.length)
            alist.add(BeneficiaryList[i]);
        }
      }
    }
    catch(Exception exp)
    {
      System.out.println("Exception Occured >> "+exp.getMessage());
    }
    //System.out.println("arralist length " + alist.size());
    return (BeneficiaryValue[])alist.toArray(new BeneficiaryValue[alist.size()]);
  }
  
    public int GetbeneAuthorizerdetails( String vendor_id, String company_id)
    throws SQLException, Exception
    {
        ArrayList alist = new ArrayList();
        String sqltext = "select authorizer_id from zenbasenet..zib_cib_gb_beneficiary where company_id = '"+company_id.trim()+"' and vendor_id IN ( "+vendor_id+" ) ";
        int auth = 0;
        try {
        conn = getConnection();
        s = conn.createStatement();
        rs = s.executeQuery(sqltext);
        if (rs.next()) {
        auth =  rs.getInt("authorizer_id");
        }
            }catch (Exception ee) {
                  System.out.println("Error connecting: " + ee);
                  ee.printStackTrace();      
                }
            finally
            {
              if(conn != null)    
              {
                try  { conn.close();} catch(Exception e) {}
              }

            }
           // System.out.println("auth "+auth);
        return auth;
    
    }
  
  public void approveBeneficiary(String vendorIDs, boolean ApproveComplete, String CompanyID, int Authorizer_id,String twotosign) throws SQLException, Exception
  {
    try
    {
      conn = getConnection();
      
      String SQLQuery = "UPDATE ZENBASENET..zib_cib_gb_beneficiary SET authorizer_id = "+Authorizer_id+" " ;
      if (ApproveComplete)
      {
        SQLQuery += ", approved = 1";
      }
      if (twotosign.trim().equalsIgnoreCase("N")) {
         SQLQuery += ", approval_level = approval_level + 1 ";   
      }
        if (twotosign.trim().equalsIgnoreCase("Y") && ApproveComplete) {
           SQLQuery += ", approval_level = approval_level + 1 ";   
        }
      SQLQuery +=  " WHERE vendor_id IN (" + vendorIDs + ") AND company_id = '" + CompanyID + "'";
      
      //System.out.println(SQLQuery);
      
      ps = conn.prepareStatement(SQLQuery);
      ps.executeUpdate();
    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception >> "+ sqlExp.getMessage());
    }
    catch(Exception exp)
    {
      System.out.println("Exception >> "+ exp.getMessage());
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }

  }
  
  
  
  public PaymentValue getBeneficiaryDetails(String VendorId) throws SQLException, Exception
  {
    PaymentValue pv = new  PaymentValue();
    try
    {
      conn = getConnection();
      String SQLQuery = " select  vendor_id ";
      SQLQuery += "   ,company_id	";
      SQLQuery += "   ,IsNull(vendor_code, '') as vendor_code	";
      SQLQuery += "   ,IsNull(vendor_name, '') as vendor_name	";
      SQLQuery += "   ,IsNull(vendor_address, '') as vendor_address	";
      SQLQuery += "   ,IsNull(vendor_city, '') as vendor_city	";
      SQLQuery += "   ,IsNull(vendor_state, '') as vendor_state	";
      SQLQuery += "   ,IsNull(vendor_phone, '') as vendor_phone	";
      SQLQuery += "   ,IsNull(vendor_gsm, '') as vendor_gsm	";
      SQLQuery += "   ,IsNull(vendor_email, '') as vendor_email	";
      SQLQuery += "   ,IsNull(vendor_contact_person, '') as vendor_contact_person	";
      SQLQuery += "   ,IsNull(vendor_bankid, '')	 as vendor_bankid	";
      SQLQuery += "   ,IsNull(vendor_bankname, '')	 as vendor_bankname	";
      SQLQuery += "   ,IsNull(vendor_bank_branchRecID, '') as vendor_bank_branchRecID		";
      SQLQuery += "   ,IsNull(vendor_bank_branchName, '')	 as vendor_bank_branchName	";
      SQLQuery += "   ,IsNull(vendor_acct_no, '')	 as vendor_acct_no	";
      SQLQuery += "   ,IsNull(vendor_category, '')	 as vendor_category	";
      SQLQuery += "   ,IsNull(status, '')	 as status	";
      SQLQuery += "   ,IsNull(payment_type, '') as payment_type	";
      //03032010 - intermediary bank details
      SQLQuery += "   ,IsNull(int_bank_name , '') as int_bank_name	";
      SQLQuery += "   ,IsNull(int_bank_acctno, '') as int_bank_acctno	";
      SQLQuery += "   ,IsNull(int_bank_bic, '') as int_bank_bic	";
      SQLQuery += "   ,IsNull(int_bank_addr, '') as int_bank_addr	";
      SQLQuery += " from ZENBASENET..zib_cib_gb_beneficiary where vendor_id = " + VendorId;
      
      //System.out.println(SQLQuery);
      //String SQLQuery = " Select * ";
      //SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary ";
      //SQLQuery += " where vendor_id = " + VendorId;
      
      s = conn.createStatement();
      rs = s.executeQuery(SQLQuery);
      
      if (rs.next())
      {
        pv.setVendorId(rs.getDouble("vendor_id"));
        pv.setCompanyId(rs.getString("company_id"));
        pv.setVendorName(rs.getString("vendor_name"));
        pv.setVendorCode(rs.getString("vendor_code"));
        pv.setVendorAddress(rs.getString("vendor_address"));
        pv.setVendorCity(rs.getString("vendor_city"));
        pv.setVendorState(rs.getString("vendor_state"));
        pv.setVendorPhone(rs.getString("vendor_phone"));
        pv.setVendorGSM(rs.getString("vendor_gsm"));
        pv.setVendorEmail(rs.getString("vendor_email"));
        pv.setVendorContactPerson(rs.getString("vendor_contact_person"));
        pv.setVendorBankID(rs.getString("vendor_bankid"));
        pv.setVendorBankName(rs.getString("vendor_bankname"));
        pv.setVendorBankBranchID(rs.getString("vendor_bank_branchRecID"));//
        pv.setVendorBankBranchName(rs.getString("vendor_bank_branchName"));
        pv.setVendorAccountNumber(rs.getString("vendor_acct_no"));
        pv.setVendorCategory(rs.getString("vendor_category"));
        pv.setVendorStatus(rs.getString("status"));
        pv.setPaymentType(rs.getString("payment_type"));
        
        //03032010 - Intermediary Bank details
        
        pv.setIntermediary_bank_name(rs.getString("int_bank_name"));
        pv.setIntermediary_bank_acctno(rs.getString("int_bank_acctno"));
        pv.setIntermediary_bank_bic(rs.getString("int_bank_bic"));
      }

    }
    catch(SQLException sqlExp)
    {
      System.out.println("SQL Exception getBeneficiaryDetails>> "+ sqlExp.getMessage());
    }
    catch(Exception exp)
    {
      System.out.println("Exception getBeneficiaryDetails>> "+ exp.getMessage());
    }
    finally
    {
      if(conn != null)
         try  { conn.close();} catch(Exception e) {}
    }

      return pv;
  }
  
  
  
    public void deleteBeneficiary(String vendorIDs,String CompanyID) throws SQLException, Exception
    {
      try
      {
        conn = getConnection();
        
 
        String SQLQuery =  "DELETE FROM ZENBASENET..zib_cib_gb_beneficiary  WHERE vendor_id IN (" + vendorIDs + ") AND company_id = '" + CompanyID + "'";
        
        System.out.println(SQLQuery);
        
        ps = conn.prepareStatement(SQLQuery);
        ps.executeUpdate();
      }
      catch(SQLException sqlExp)
      {
        System.out.println("SQL Exception >> "+ sqlExp.getMessage());
      }
      catch(Exception exp)
      {
        System.out.println("Exception >> "+ exp.getMessage());
      }
      finally
      {
        if(conn != null)
           try  { conn.close();} catch(Exception e) {}
      }

    }
  
}