package com.zenithbank.banking.coporate.ibank.payment;

import com.interbankClient.WebServiceInterface;

import com.zenithbank.banking.coporate.OtherBankStmt.PostilionStmtValue;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import com.zenithbank.banking.ibank.common.BaseAdapter;
import com.zenithbank.nfp.INibbsFasterPayProxy;//15102015- NIP V2
import com.zenithbank.stringhelper.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


public class MakePaymentBeneficiaryPayment extends BaseAdapter {
    com.zenithbank.banking.ibank.transfer.adapter.getNIBSSNIPSession nip = new com.zenithbank.banking.ibank.transfer.adapter.getNIBSSNIPSession();
    com.interbankClient.WebServiceInterface client = new com.interbankClient.WebServiceInterface();
    INibbsFasterPayProxy nipProxy = new INibbsFasterPayProxy();//15102015- NIP V2
    com.zenithbank.xml.XmlStringReader xmlReader = new com.zenithbank.xml.XmlStringReader();
    com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter acctSummary = new com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter();


    private Connection conn = null;
    private ResultSet rs = null;
    private Statement s;
    private PreparedStatement ps;
    StringBuilder vendorBuilder = new StringBuilder();   
     
    //select top 1 * from ZENBASENET..zib_cib_pmt_fileupload where company_code = ?   and upload_operator = ? order by upload_date desc

     /*
     b.setUpload_operator(reader.GetString("upload_operator"));
     b.setUpload_date(reader.GetDate("upload_date"));
     b.setServer_filename(reader.GetString("server_filename"));
     b.setOriginal_filename(reader.GetString("original_filename"));
     b.setBulk_file_upload(reader.GetString("bulk_file_upload"));
     b.setBatchid(reader.GetDouble("batchid"));
     b.setBatch_status(reader.GetString("batch_status"));
     b.setApproval_operator(reader.GetInt("approval_operator"));
     b.setApproval_date(reader.GetDate("approval_date"));
     b.setUpload_date_timestamp(reader.GetTimeStamp("upload_date"));
     
     b.setProcess_count(reader.GetInt("process_count")); //23022014-batch payment upload
     b.setFailed_count(reader.GetInt("failed_count")); //23022014-batch payment upload
     b.setTotal_count(reader.GetInt("total_count")); //23022014-batch payment upload
     b.setMsg(reader.GetString("msg"));
     b.setStatus(reader.GetString("status"));
     */
     public String getBatchDetails(String company_code, String uploader) throws SQLException, Exception
     {
         JSONObject jsObject = new JSONObject();
       if(company_code != null)  {
           try
           {
             conn = getConnection();
             String SQLQuery = " select top 1  ";
             SQLQuery += "   IsNull(upload_operator, '') as upload_operator   ";
             SQLQuery += "   ,IsNull(upload_date, '') as upload_date   ";
             SQLQuery += "   ,IsNull(server_filename, '') as server_filename     ";
             SQLQuery += "   ,IsNull(original_filename, '') as original_filename   ";
             SQLQuery += "   ,IsNull(bulk_file_upload, '') as bulk_file_upload ";
             SQLQuery += "   ,IsNull(batchid, 0) as batchid ";
             SQLQuery += "   ,IsNull(batch_status, '') as batch_status    ";
             SQLQuery += "   ,IsNull(approval_operator, 0) as approval_operator ";
             
             SQLQuery += "   ,IsNull(approval_date, '') as approval_date ";
             SQLQuery += "   ,IsNull(upload_date, '') as upload_date ";
             
             SQLQuery += "   ,IsNull(process_count, 0) as process_count    ";
             SQLQuery += "   ,IsNull(failed_count, 0) as failed_count ";
             SQLQuery += "   ,IsNull(total_count, 0) as total_count    ";
             SQLQuery += "   ,IsNull(msg, '') as msg ";
             SQLQuery += "   ,IsNull(status, '') as status ";
             
             
             SQLQuery += " from ZENBASENET..zib_cib_pmt_fileupload where company_code = '" + company_code + "' and upload_operator = '" + uploader + "' order by upload_date desc";
             
             //System.out.println("***" + SQLQuery);
             
             s = conn.createStatement();
             rs = s.executeQuery(SQLQuery);
           
               while(rs.next())
               {
                   //jsObject.put("BeneficiaryID", rs.getDouble("vendor_id"));
                   jsObject.put("upload_operator", rs.getString("upload_operator"));
                   jsObject.put("upload_date",rs.getDate("upload_date"));
                   jsObject.put("server_filename",rs.getString("server_filename"));
                   jsObject.put("original_filename", rs.getString("original_filename"));
                   jsObject.put("bulk_file_upload", rs.getString("bulk_file_upload"));
                   jsObject.put("batchid", rs.getDouble("batchid"));
                   jsObject.put("batch_status", rs.getString("batch_status"));
                   jsObject.put("approval_operator", rs.getInt("approval_operator"));
                   jsObject.put("approval_date", rs.getDate("approval_date"));
                   jsObject.put("upload_date", rs.getDate("upload_date"));
                   jsObject.put("process_count",rs.getInt("process_count"));
                   jsObject.put("failed_count", rs.getInt("failed_count"));
                   jsObject.put("total_count", rs.getInt("total_count"));
                   jsObject.put("msg", rs.getString("msg"));
                   jsObject.put("status",rs.getString("status"));//04062013
               
               }
           }
           catch(SQLException sqlExp)
           {
             System.out.println("SQL Exception getBatchDetails>> "+ sqlExp.getMessage());
           }
           catch(Exception exp)
           {
             System.out.println("Exception getBatchDetails>> "+ exp.getMessage());
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
       }else{
           jsObject.toString(0);
       }
         return jsObject.toString();
     }
    
    
    
    public String getBeneficiaryDetails(String VendorId) throws SQLException, Exception
    {
        JSONObject jsObject = new JSONObject();
      if(VendorId != null)  {
          try
          {
            conn = getConnection();
            String SQLQuery = " select  vendor_id ";
            SQLQuery += "   ,company_id       ";
            SQLQuery += "   ,IsNull(vendor_code, '') as vendor_code   ";
            SQLQuery += "   ,IsNull(vendor_name, '') as vendor_name   ";
            SQLQuery += "   ,IsNull(vendor_address, '') as vendor_address     ";
            SQLQuery += "   ,IsNull(vendor_city, '') as vendor_city   ";
            SQLQuery += "   ,IsNull(vendor_state, '') as vendor_state ";
            SQLQuery += "   ,IsNull(vendor_phone, '') as vendor_phone ";
            SQLQuery += "   ,IsNull(vendor_gsm, '') as vendor_gsm     ";
            SQLQuery += "   ,IsNull(vendor_email, '') as vendor_email ";
            SQLQuery += "   ,IsNull(vendor_contact_person, '') as vendor_contact_person       ";
            SQLQuery += "   ,IsNull(vendor_bankid, '')         as vendor_bankid       ";
            SQLQuery += "   ,IsNull(vendor_bankname, '')       as vendor_bankname     ";
            SQLQuery += "   ,IsNull(vendor_bank_branchRecID, '') as vendor_bank_branchRecID           ";
            SQLQuery += "   ,IsNull(vendor_bank_branchName, '')        as vendor_bank_branchName      ";
            SQLQuery += "   ,IsNull(vendor_acct_no, '')        as vendor_acct_no      ";
            SQLQuery += "   ,IsNull(vendor_category, '')       as vendor_category     ";
            SQLQuery += "   ,IsNull(status, '')        as status      ";
            SQLQuery += "   ,IsNull(payment_type, '') as payment_type ";
            //03032010 - intermediary bank details
            SQLQuery += "   ,IsNull(int_bank_name , '') as int_bank_name      ";
            SQLQuery += "   ,IsNull(int_bank_acctno, '') as int_bank_acctno   ";
            SQLQuery += "   ,IsNull(int_bank_bic, '') as int_bank_bic ";
            SQLQuery += "   ,IsNull(int_bank_addr, '') as int_bank_addr       ";
            SQLQuery += " from ZENBASENET..zib_cib_gb_beneficiary where vendor_id = " + VendorId;
            
            //System.out.println("***" + SQLQuery);
            //String SQLQuery = " Select * ";
            //SQLQuery += " FROM ZENBASENET..zib_cib_gb_beneficiary ";
            //SQLQuery += " where vendor_id = " + VendorId;
            
            s = conn.createStatement();
            rs = s.executeQuery(SQLQuery);
          
              while(rs.next())
              {
                  jsObject.put("BeneficiaryID", rs.getDouble("vendor_id"));
                  jsObject.put("CompanyID", rs.getString("company_id"));
                  jsObject.put("BeneficiaryName",rs.getString("vendor_name"));
                  jsObject.put("BeneficiaryCode",rs.getString("vendor_code"));
                  jsObject.put("BeneficiaryAddress", rs.getString("vendor_address"));
                  jsObject.put("BeneficiaryCity", rs.getString("vendor_city"));
                  jsObject.put("BeneficiaryState", rs.getString("vendor_state"));
                  jsObject.put("BeneficiaryPhone", rs.getString("vendor_phone"));
                  jsObject.put("BeneficiaryGSM", rs.getString("vendor_gsm"));
                  jsObject.put("BeneficiaryEmail", rs.getString("vendor_email"));
                  jsObject.put("BeneficiaryContactPerson", rs.getString("vendor_contact_person"));
                  jsObject.put("BeneficiaryBankID",rs.getString("vendor_bankid"));
                  jsObject.put("BeneficiaryBankName", rs.getString("vendor_bankname"));
                  jsObject.put("BeneficiaryBankBranchRecID", rs.getString("vendor_bank_branchRecID"));
                  jsObject.put("BeneficiaryBankBranchName", rs.getString("vendor_bank_branchName"));
                  jsObject.put("BeneficiaryAccountNo",rs.getString("vendor_acct_no").trim());//04062013
                  jsObject.put("BeneficiaryCategory", rs.getString("vendor_category"));
                  jsObject.put("Status", rs.getString("status"));
                  jsObject.put("PaymentType", rs.getString("payment_type"));
                  //jsObject.put("SortCode", rs.getString("payment_type")); // Issue with this fields
                  //jsObject.put("SwiftCode", rs.getString("payment_type")); // 
                  jsObject.put("IntBankName", rs.getString("int_bank_name"));
                  jsObject.put("IntAccountNo", rs.getString("int_bank_acctno"));
                  jsObject.put("IntBankBic", rs.getString("int_bank_bic"));
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
      }else{
          jsObject.toString(0);
      }
        return jsObject.toString();
    }
    
    public String getPaymentType(String param) {
        try {
            conn = getConnection();
            String getBenePaymtType = null;
            int group=0;
            
            if(param.substring(0,2).equalsIgnoreCase("ZE") || param.substring(0,2).equalsIgnoreCase("DR") || param.substring(0,2).equalsIgnoreCase("CO")){
                group=1;
            }else if(param.substring(0,2).equalsIgnoreCase("IN")){
                group=2;
            }else if(param.substring(0,2).equalsIgnoreCase("FO")){
                group=3;
            }
            
            if(group>0){
                getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where  paymenttypegroup = " + group + " order by paymenttype desc";              
            }else{
                getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where  paymentinstructiontype = 'Credit' order by paymenttype"; 
            }
            
            s = conn.createStatement();
            rs = s.executeQuery(getBenePaymtType);
            int i=0;
              while(rs.next())
              {
                  if(i > 0) 
                  {
                      vendorBuilder.append(",\n");
                  }
                  vendorBuilder.append(rs.getString("paymenttypeid")).append("|").
                  append(rs.getString("paymenttype"));
                  ++i;
              }
              } catch (Exception ee) {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
          }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
    return vendorBuilder.toString();
    }
    
  //11092014-method added to include Company Code  
    public String getPaymentType(String param,String companyCode) {
        try {
            conn = getConnection();
            String getBenePaymtType = null;
            int group=0;
            
            if(param.substring(0,2).equalsIgnoreCase("ZE") || param.substring(0,2).equalsIgnoreCase("DR") || param.substring(0,2).equalsIgnoreCase("CO")){
                group=1;
            }else if(param.substring(0,2).equalsIgnoreCase("IN")){
                group=2;
            }else if(param.substring(0,2).equalsIgnoreCase("FO")){
                group=3;
            }
            
            /*commented on 11092014
            if(group>0){
                getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where  paymenttypegroup = " + group + " order by paymenttype desc";              
            }else{
                getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where  paymentinstructiontype = 'Credit' order by paymenttype"; 
            }
            */
          s = conn.createStatement();
           
        //begin-11092014 
    
          String checkPaymtTypeQry = "select allow_instant_tfr from zib_cib_gb_company where company_code = '" + companyCode + "'";
          String allow_instant_tfr = "N" ;
          rs = s.executeQuery(checkPaymtTypeQry);
          //System.out.println("checkPaymtTypeQry" + checkPaymtTypeQry);
           if(rs.next()) {
                allow_instant_tfr = (rs.getString("allow_instant_tfr") == null ? "N":rs.getString("allow_instant_tfr"));
                    
                }
          
                  if(group>0 && allow_instant_tfr.equalsIgnoreCase("Y")){
                      getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where  paymenttypegroup = " + group + " order by paymenttype desc";              
                  }
                  else if(group>0 && allow_instant_tfr.equalsIgnoreCase("N")){
                      getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where  paymenttypegroup = " + group + " and paymenttype not in ('INTERSWITCH/BENEFICIARY') order by paymenttype desc";              
                  }
                  else if(group == 0 && allow_instant_tfr.equalsIgnoreCase("Y")) {
                      getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where  paymentinstructiontype = 'Credit' order by paymenttype"; 
                  }
                  else if(group == 0 && allow_instant_tfr.equalsIgnoreCase("N")) {
                      getBenePaymtType = " select * from ZENBASENET..zib_cib_gb_payment_type  where  paymentinstructiontype = 'Credit' and paymenttype not in ('INTERSWITCH/BENEFICIARY') order by paymenttype"; 
                  }
          //System.out.println("getBenePaymtType " + getBenePaymtType);
          
          //end-11092014  
            rs = s.executeQuery(getBenePaymtType);
            int i=0;
              while(rs.next())
              {
                  if(i > 0) 
                  {
                      vendorBuilder.append(",\n");
                  }
                  vendorBuilder.append(rs.getString("paymenttypeid")).append("|").
                  append(rs.getString("paymenttype"));
                  ++i;
              }
              } catch (Exception ee) {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
          }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
    return vendorBuilder.toString();
    }
    
    
    //method to validate Bank Account for NUBAN Compliance
    public String NUBANvalidateAccount(String bankcode,String accountNumber){
        /*
        System.out.println(" bankcode " + bankcode);
        System.out.println(" accountNumber " + accountNumber );
        */
        
        String error_text = acctSummary.NUBANvalidateAccount(bankcode,accountNumber);
        
        System.out.println(" error_text " + error_text );
        
        return error_text ;
    }
    
    
    public String getBankDetails(String acct_no) {        
        
        // Swap to new account number for Zenith Bank Beneficiaries
        String new_acct_no = acctSummary.swapAccount(acct_no);   
        
        try
        {
            conn = getConnection1();
                                    
            String sql = " SELECT ltrim(rtrim(a.acct_no)) as acct_no,a.title_1,b.name_1 FROM phoenix..dp_acct a, phoenix..ad_gb_branch b where a.branch_no = b.branch_no and a.acct_no = '"+ new_acct_no +"' and a.status = 'active' ";
            
           // System.out.println(sql);
            s = conn.createStatement();
            rs = s.executeQuery(sql);

            int i=0;
              while(rs.next())
              {
                  if(i > 0) 
                  {
                      vendorBuilder.append(",\n");
                  }
                vendorBuilder.append(rs.getString("acct_no")).append("|").
                append(rs.getString("title_1")).append("|").
                append(rs.getString("name_1"));
                ++i;
            }
            System.out.println("Details: " + vendorBuilder.toString());
        }
        catch(Exception e){
                e.printStackTrace();
                System.out.println(e.getMessage());
        }
          finally
          {
            if(conn != null)    {
                  try  { conn.close();} catch(Exception e) {}
                }
          }
          
       return vendorBuilder.toString();
    }
    
    /* old NIP Implementation - 15102015
    public String getOtherBankDetails(String acct_no, String bankcode, String nbURL) throws SQLException, 
                                                              Exception {
        String func =  "nameenquirysingleitem";
        String xml = "";
        String sessionID ="";
        String nibssResult = "";
        String nibssResp = "";
        try{ 
            sessionID = nip.getNIBSSSessionID("057", bankcode.trim());
                             
            xml = "<?xml version='1.0' encoding='UTF-8'?><NESingleRequest><SessionID>"+sessionID+"</SessionID><DestinationBankCode>"+bankcode+"</DestinationBankCode><ChannelCode>2</ChannelCode><AccountNumber>"+acct_no+"</AccountNumber></NESingleRequest>"; 
                   
            System.out.println(" the xml  is -------  " + xml);                      
        
            
            nibssResult = client.CallNIBSSWebService(func.trim(), xml.trim(), nbURL.trim());
        
            System.out.println(" the nibss result is -------  " + nibssResult);                   
        
            org.w3c.dom.Document doc = xmlReader.parseString(nibssResult);  
            nibssResp  =  xmlReader.getXmlTagname("ResponseCode",doc); 
            nibssResult = xmlReader.getXmlTagname("AccountName",doc);    
        }
        catch(Exception e){            
            e.printStackTrace();
        }
        return nibssResult;
        
    }
    */
    
    // new NIP V2 Implementation - 15102015
     public String getOtherBankDetails(String acct_no, String bankcode, String nbURL) throws SQLException, 
                                                               Exception {
         String func =  "nameenquirysingleitem";
         String xml = "";
         String sessionID ="";
         String nibssResult = "";
         String nibssResp = "";
         try{ 
             sessionID = nip.getNIBSSSessionID("057", bankcode.trim());
                              
             xml = "<?xml version='1.0' encoding='UTF-8'?><NESingleRequest><SessionID>"+sessionID+"</SessionID><DestinationBankCode>"+bankcode+"</DestinationBankCode><ChannelCode>2</ChannelCode><AccountNumber>"+acct_no+"</AccountNumber></NESingleRequest>"; 
                    
             System.out.println(" the xml  is -------  " + xml);                      
         
             
             //nibssResult = client.CallNIBSSWebService(func.trim(), xml.trim(), nbURL.trim());
             nipProxy.setEndpoint(nbURL);
             nibssResult = nipProxy.nameenquirysingleitem(xml.trim());
         
             System.out.println(" the nibss result is -------  " + nibssResult);                   
             System.out.println(" the nibss result.length() is -------  " + nibssResult.length());                   
             if(nibssResult.length() > 5){
             org.w3c.dom.Document doc = xmlReader.parseString(nibssResult);  
             nibssResp  =  xmlReader.getXmlTagname("ResponseCode",doc); 
             nibssResult = xmlReader.getXmlTagname("AccountName",doc);
             }
         }
         catch(Exception e){            
             e.printStackTrace();
         }
         return nibssResult;
         
     }
    
    
    
    public String getAllBankDebitAccount(String company_code, String Status,String bankcode,int roleid)
    {
        
        ArrayList listValue = new ArrayList();
                     
        String SQL = " select a.acct_no,b.title_1 from ZENBASENET..zib_cib_gb_salary_account a,phoenix..dp_acct b where a.authorise = '1' and a.acct_no = b.acct_no and a.company_code = '"+company_code+"'";
        SQL += " AND a.ACCT_NO NOT IN (select ACCT_NO from ZENBASENET..zib_cib_gb_debit_acct_restrict where roleid = "+roleid+")";
        SQL += " UNION select a.acct_no,a.acct_name from ZENBASENET..zib_cib_gb_debit_acct_other_bk a where a.status = '1' and  a.company_code = '"+company_code+"'";
        SQL += " AND a.ACCT_NO NOT IN (select ACCT_NO from ZENBASENET..zib_cib_gb_debit_acct_restrict where roleid = "+roleid+")";
        SQL += " UNION select a.acct_no,b.title_1 from ZENBASENET..zib_cib_gb_debit_acct a,phoenix..dp_acct b where a.authorise = '1' and a.acct_no = b.acct_no and a.company_code = '"+company_code +"'" ;
        SQL += " AND a.ACCT_NO NOT IN (select ACCT_NO from ZENBASENET..zib_cib_gb_debit_acct_restrict where roleid = "+roleid+")";
        SQL += " ORDER BY b.title_1 " ;
        
        //System.out.println( " SQL " + SQL);
        
        StringBuilder accountBuilder = new StringBuilder();
        accountBuilder.append("<SELECT id=\"DEBIT_ACCT_NO\" name=\"DEBIT_ACCT_NO\" class=\"Selectbox\" style=\"width:40%;\"  onchange=\"DebitAccountChanged()\">");
        
        
        try
        {
            conn = getConnection();
            s = conn.createStatement(1004, 1007);
            rs = s.executeQuery(SQL);
            //
             int i=0;
               while(rs.next())
               {
                   String displayText = rs.getString("title_1");
                   System.out.println(displayText);
                  //  displayText = displayText.replace('.',' ');
                   //displayText = displayText.replace('-',' ');
                  //  System.out.println(displayText);
                   if(i == 0) 
                   {
                       accountBuilder.append("<OPTION style=\"width:40%;\" value=\"").append("-1");
                       accountBuilder.append("\">").append("PLEASE SELECT ").append("</OPTION>");
                   }
                   accountBuilder.append("<OPTION VALUE=\"").append(rs.getString("acct_no"));
                   accountBuilder.append("\">").append(displayText).append("</OPTION>");
                   ++i;
                   
                   /*if(i > 0) 
                   {
                       vendorBuilder.append(",\n");
                   }
                   vendorBuilder.append(rs.getString("acct_no")).append("|").
                   append(rs.getString("title_1"));
                   ++i;*/
               }
            
            //
            
        }
        catch(Exception ee)
        {
            System.out.println("Error connecting: " + ee);
        }
        finally
        {
            if(conn != null)
                try
                {
                    conn.close();
                }
                catch(Exception exception1) { }
        }
        accountBuilder.append("</SELECT>");
        System.out.println(accountBuilder.toString());
        return accountBuilder.toString();
        
        
        //return vendorBuilder.toString();
    }
    
    public String getotherBankDebitAccountByBankCode(String companycode, String Status,String bankcode,int roleid)
    {
        //PostilionStmtValue poststmtvalues[] = new PostilionStmtValue[0];
        //PostilionStmtValue poststmtvalue = null;
        ArrayList listValue = new ArrayList();
        
        String SQL = " SELECT a.acct_no,a.acct_name,c.bankid,c.bankname,c.bank_cbn_alphacode FROM ";
        SQL = SQL + " ZENBASENET..ZIB_CIB_GB_DEBIT_ACCT_OTHER_BK a, ZENBASENET..zib_cib_gb_company b , ";
        SQL = SQL + " ZENBASENET..zib_tb_banks c  where a.company_code = b.company_code and a.company_code = '" + companycode + "'"; 
        SQL = SQL + " and a.status = '" + Status + "' and substring(a.COMPANY_PAN,1,6) <> '627629' " ;
        SQL = SQL + " and substring(a.COMPANY_PAN,1,6) = c.bankid and  c.bank_cbn_alphacode = '" + bankcode + "'" ;
        SQL = SQL + " AND a.ACCT_NO NOT IN (select ACCT_NO from ZENBASENET..zib_cib_gb_debit_acct_restrict where roleid = "+roleid+" )";
         
                 
        //System.out.println( "getotherBankDebitAccountByBankCode SQL " + SQL);
        
        StringBuilder accountBuilder = new StringBuilder();
        accountBuilder.append("<SELECT id=\"DEBIT_ACCT_NO\" name=\"DEBIT_ACCT_NO\" class=\"Selectbox\" style=\"width:40%;\"  onchange=\"DebitAccountChanged()\">");
        
        try
        {
            conn = getConnection();
            s = conn.createStatement(1004, 1007);
            rs = s.executeQuery(SQL);
            //
             int i=0;
               while(rs.next())
               {
                  String displayText = rs.getString("acct_name");
                  System.out.println(displayText);
                 // displayText = displayText.replace('.',' ');
                 //  displayText = displayText.replace('-',' ');
                 //  System.out.println(displayText);
                   
                   if(i == 0) 
                   {
                       accountBuilder.append("<OPTION style=\"width:40%;\" value=\"").append("-1");
                       accountBuilder.append("\">").append("PLEASE SELECT ").append("</OPTION>");
                   }
                   accountBuilder.append("<OPTION VALUE=\"").append(rs.getString("acct_no"));
                   accountBuilder.append("\">").append(displayText).append("</OPTION>");
                   ++i;
                  /* if(i > 0) 
                   {
                       vendorBuilder.append(",\n");
                   }
                   vendorBuilder.append(rs.getString("acct_no")).append("|").
                   append(rs.getString("acct_name"));
                   ++i;*/
               }
            
            //
            
        }
        catch(Exception ee)
        {
            System.out.println("Error connecting: " + ee);
        }
        finally
        {
            if(conn != null)
                try
                {
                    conn.close();
                }
                catch(Exception exception1) { }
        }
        accountBuilder.append("</SELECT>");
        System.out.println(accountBuilder.toString());
        return accountBuilder.toString();
        
        //return vendorBuilder.toString();
    }
    
    /*
     * 
     String getBenePaymtType = " select a.acct_no,b.title_1 from ZENBASENET..zib_cib_gb_salary_account a,phoenix..dp_acct b where a.authorise = '1' and a.acct_no = b.acct_no and a.company_code = '"+company_code+"'";
     getBenePaymtType += " AND a.ACCT_NO NOT IN (select ACCT_NO from ZENBASENET..zib_cib_gb_debit_acct_restrict where roleid = "+roleid+")";
     getBenePaymtType += " UNION select a.acct_no,a.acct_name from ZENBASENET..zib_cib_gb_debit_acct_other_bk a where a.status = '1' and  a.company_code = '"+company_code+"'";
     getBenePaymtType += " AND a.ACCT_NO NOT IN (select ACCT_NO from ZENBASENET..zib_cib_gb_debit_acct_restrict where roleid = "+roleid+")";
     getBenePaymtType += " UNION select a.acct_no,b.title_1 from ZENBASENET..zib_cib_gb_debit_acct a,phoenix..dp_acct b where a.authorise = '1' and a.acct_no = b.acct_no and a.company_code = '"+company_code +"'" ;
     getBenePaymtType += " AND a.ACCT_NO NOT IN (select ACCT_NO from ZENBASENET..zib_cib_gb_debit_acct_restrict where roleid = "+roleid+")";
     getBenePaymtType += " ORDER BY b.title_1 " ;
     
     * 
     */
    
    
    public String getZenithBankDebitAccountByBankCode(String companycode, String Status,String bankcode,int roleid)
    {
        //PostilionStmtValue poststmtvalues[] = new PostilionStmtValue[0];
        //PostilionStmtValue poststmtvalue = null;
        ArrayList listValue = new ArrayList();
                 
        String SQL = " SELECT a.acct_no,c.title_1 FROM ";
        SQL = SQL + " ZENBASENET..ZIB_CIB_GB_DEBIT_ACCT a, ZENBASENET..zib_cib_gb_company b , ";
        SQL = SQL + " phoenix..dp_acct c  where a.company_code = b.company_code and a.company_code = '" + companycode + "'"; 
        SQL = SQL + " AND a.authorise = '" + Status + "' and a.acct_no = c.acct_no " ;
        SQL = SQL + " AND a.ACCT_NO NOT IN (select ACCT_NO from ZENBASENET..zib_cib_gb_debit_acct_restrict where roleid = "+roleid+" )";
        
        //System.out.println( " SQL " + SQL);
        
        StringBuilder accountBuilder = new StringBuilder();
        accountBuilder.append("<SELECT id=\"DEBIT_ACCT_NO\" name=\"DEBIT_ACCT_NO\" class=\"Selectbox\" style=\"width:40%;\"  onchange=\"DebitAccountChanged()\">");
        
        
        try
        {
            conn = getConnection();
            s = conn.createStatement(1004, 1007);
            rs = s.executeQuery(SQL);
            //
             int i=0;
               while(rs.next())
               {
                   String displayText = rs.getString("title_1");
                   System.out.println(displayText);
                  //  displayText = displayText.replace('.',' ');
                   //displayText = displayText.replace('-',' ');
                  //  System.out.println(displayText);
                   if(i == 0) 
                   {
                       accountBuilder.append("<OPTION style=\"width:40%;\" value=\"").append("-1");
                       accountBuilder.append("\">").append("PLEASE SELECT ").append("</OPTION>");
                   }
                   accountBuilder.append("<OPTION VALUE=\"").append(rs.getString("acct_no"));
                   accountBuilder.append("\">").append(displayText).append("</OPTION>");
                   ++i;
                   
                   /*if(i > 0) 
                   {
                       vendorBuilder.append(",\n");
                   }
                   vendorBuilder.append(rs.getString("acct_no")).append("|").
                   append(rs.getString("title_1"));
                   ++i;*/
               }
            
            //
            
        }
        catch(Exception ee)
        {
            System.out.println("Error connecting: " + ee);
        }
        finally
        {
            if(conn != null)
                try
                {
                    conn.close();
                }
                catch(Exception exception1) { }
        }
        accountBuilder.append("</SELECT>");
        System.out.println(accountBuilder.toString());
        return accountBuilder.toString();
        
        
        //return vendorBuilder.toString();
    }
    
    
  
  
   public static void main(String args[])
     {
         MakePaymentBeneficiaryPayment m = new MakePaymentBeneficiaryPayment();//14052014
         String nip_add = "http://172.29.30.251:8080/NibssFasterPay/services/NibssFasterPay";
         String result = "" ;
    try
    {
         result = m.getOtherBankDetails("0004934809","058",nip_add);
         System.out.println(result);
     }
         catch(Exception e)
                     {
                         System.out.println("Error");
                     }
     }
    
    
}




