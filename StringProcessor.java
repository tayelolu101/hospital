package com.zenithbank.banking.coporate.ibank.payment;

import java.util.*;

public class StringProcessor 
{
  public StringProcessor()
  {
  }
  
  public String getBeneficiaryAccountDetails(String PaymentType, String BenefCode) throws Exception
  {
      String rtnString = "";
      if((PaymentType.trim().equalsIgnoreCase("1") || PaymentType.trim().equalsIgnoreCase("2")) && BenefCode.trim().equalsIgnoreCase("0"))
      {
          rtnString += "<tr><td nowrap>Beneficiary Name</td><td><input type='text' size='30' maxlength='35' name='txtBenefName' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td nowrap>Bank Name</td><td><input type='text' size='30' maxlength='35' name='txtBankName' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td nowrap>Bank Address</td><td><textarea cols='30' rows='3' wrap='off' name='txtBankAddress' autocomplete='off'></textarea></td></tr>";
          rtnString += "<tr><td nowrap>Clearing Code</td><td><input type='text' size='30' maxlength='12' name='txtClearingCode' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td nowrap>Account Number</td><td><input type='text' size='30' maxlength='34' name='txtAccountNo' autocomplete='off' value=''></td></tr>";
      }
      else if(PaymentType.trim().equalsIgnoreCase("3") && BenefCode.trim().equalsIgnoreCase("0"))
      {
          rtnString += "<tr><td>Beneficiary Name</td><td><input type='text' size='30' maxlength='35' name='txtBenefName' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td>Bank Name</td><td><input type='text' size='30' maxlength='35' name='txtBankName' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td>Bank Address</td><td><input type=text size='30' maxlength='35' name='txtBankAddress1' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td></td><td><input type='text' size='30' maxlength='35' name='txtBankAddress2' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td></td><td><input type='text' size='30' maxlength='35' name='txtBankAddress3' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td>Clearing Code</td><td><input type='text' size='30' maxlength='12' name='txtClearingCode' autocomplete='off' value=''></td></tr>";
          rtnString += "<tr><td>Account Number</td><td><input type='text' size='30' maxlength='34' name='txtAccountNo' autocomplete='off' value=''></td></tr>";
      }
      return rtnString;
  }
  
  
  
  public String buildSelectBox (String[][] strArray, int arrSize, String SelName, String SelValue, String Style, String JSfunction) throws Exception
  {
    try
    {
        String SelBox = "";
        SelBox += "<select id='" + SelName + "' name='" + SelName + "' class='" + Style + "' " + JSfunction + ">";
        if (SelValue.trim().equalsIgnoreCase(""))
        {
          SelBox += "<option value='' selected></option>";
        }
        
        if(SelName.equalsIgnoreCase("selPaymentType")){
            SelBox += "<option value='-1' selected>Please Select....</option>";
        }
        
        if(SelName.equalsIgnoreCase("selAcctList")){
            SelBox += "<option value=' ' selected>Please Select....</option>";
        }
        
        if(SelName.equalsIgnoreCase("selAcctListTo")){
            SelBox += "<option value=' ' selected>Please Select....</option>";
        }
    
        for (int i=0; i < arrSize; i++)
        {
        	  
        
          if (!strArray[i][0].trim().equalsIgnoreCase(SelValue))
          {
            //SelBox += "<option value='" + strArray[i][0] + "'>" + strArray[i][1] + "</option>" ;
             SelBox += "<option value=\"" + strArray[i][0] + "\">" + strArray[i][1] + "</option>" ;
          }
          else 
          {
        	  //===Updaated select option to display payment name =======//
            // Find the corresponding value displayed in select box for the Selected select box value
            //SelBox += "<option value='" + strArray[i][0] + "' selected>" + strArray[i][1] + "</option>";
            SelBox += "<option value=\"" + strArray[i][0] + "\" selected>" + strArray[i][1] + "</option>";
          }
        }
        SelBox += "</select>";
        return SelBox;
    }
    catch(Exception exp)
    {
    	exp.printStackTrace();
      throw exp;
    }
   
  }
  
  //Bills Payment - Begin
   public String buildBranchSelectBox (String[][] strArray, int arrSize, String SelName, String SelValue, String Style, String JSfunction, int branch_code) throws Exception
    {
      try
      {
          String SelBox = "";
          SelBox += "<select name='" + SelName + "' class='" + Style + "' " + JSfunction + ">";
          //this can be made generic
          SelBox += "<option value='blank'>--Please Select Option--</option>";
          if (SelValue.trim().equalsIgnoreCase(""))
          {
            
            SelBox += "<option value='' selected></option>";
          }
            
          for (int i=0; i < arrSize; i++)
          {
            if (!strArray[i][0].trim().equalsIgnoreCase(SelValue))
            {
              if ( Integer.parseInt(strArray[i][0]) ==  branch_code)
                  SelBox += "<option value='" + strArray[i][0] + "' selected>" + strArray[i][1] + "</option>" ;  
              else
                  SelBox += "<option value='" + strArray[i][0] + "'>" + strArray[i][1] + "</option>" ;
            }
            else 
            {
              // Find the corresponding value displayed in select box for the Selected select box value
            
              SelBox += "<option value='" + strArray[i][0] + "' selected>" + strArray[i][1] + "</option>";
            }
          }
          SelBox += "</select>";
          return SelBox;
      }
      catch(Exception exp)
      {
        throw exp;
      }
     
    }
    
     public String buildDomicileSelectBox (String[][] strArray, int arrSize, String SelName, String SelValue, String Style, String JSfunction, int branch_code) throws Exception
    {
      try
      {
          String SelBox = "";
          SelBox += "<select name='" + SelName + "' class='" + Style + "' " + JSfunction + ">";
          //this can be made generic
          SelBox += "<option value='blank'>--Please Select Option--</option>";
          if (SelValue.trim().equalsIgnoreCase(""))
          {
            
            SelBox += "<option value='' selected></option>";
          }
            
          for (int i=0; i < arrSize; i++)
          {
            if (!strArray[i][0].trim().equalsIgnoreCase(SelValue))
            {
              if ( Integer.parseInt(strArray[i][0]) ==  branch_code)
                  SelBox += "<option value='" + strArray[i][0] + "' selected>" + strArray[i][1] + "</option>" ;  
              else
                  SelBox += "<option value='blank'>--Please Select Option--</option>";
            }
            else 
            {
              // Find the corresponding value displayed in select box for the Selected select box value
            
              SelBox += "<option value='" + strArray[i][0] + "' selected>" + strArray[i][1] + "</option>";
            }
          }
          SelBox += "</select>";
          return SelBox;
      }
      catch(Exception exp)
      {
        throw exp;
      }
     
    }
    
     public String buildSelectBox1 (String[][] strArray, int arrSize, String SelName, String SelValue, String Style, String JSfunction) throws Exception
    {
      try
      {
          String SelBox = "";
          SelBox += "<select name='" + SelName + "' class='" + Style + "' " + JSfunction + ">";
          //this can be made generic
          SelBox += "<option value='blank'>--Please Select Option--</option>";
          if (SelValue.trim().equalsIgnoreCase(""))
          {
            
            SelBox += "<option value='' selected></option>";
          }
            
          for (int i=0; i < arrSize; i++)
          {
            if (!strArray[i][0].trim().equalsIgnoreCase(SelValue))
            {
              //change 1 to 0
              SelBox += "<option value='" + strArray[i][0] + "'>" + strArray[i][0] + "</option>" ;
            }
            else 
            {
              // Find the corresponding value displayed in select box for the Selected select box value
            
              SelBox += "<option value='" + strArray[i][0] + "' selected>" + strArray[i][0] + "</option>";
            }
          }
          SelBox += "</select>";
          return SelBox;
      }
      catch(Exception exp)
      {
        throw exp;
      }
     
    }
    
    
     public String buildListBox (String[][] strArray, int arrSize, String SelName, String SelValue, String Style, String JSfunction) throws Exception
    {
      try
      {
          String SelBox = "";
          SelBox += "<select name='" + SelName + "' size = '9' class='" + Style + "' " + JSfunction + ">";
          //this can be made generic
          SelBox += "<option value='blank'>--Please Select Option--</option>";
          if (SelValue.trim().equalsIgnoreCase(""))
          {
            
            SelBox += "<option value='' selected></option>";
            
          }
            
          for (int i=0; i < arrSize; i++)
          {
            if (!strArray[i][0].trim().equalsIgnoreCase(SelValue))
            {
              
              SelBox += "<option value='" + strArray[i][0] + "'>" + strArray[i][1] + "</option>" ;
              System.out.println("Yes");
            }
            else 
            {
              // Find the corresponding value displayed in select box for the Selected select box value
              //System.out.println("Yes");
              SelBox += "<option value='" + strArray[i][0] + "' selected>" + strArray[i][1] + "</option>";
            }
          }
          SelBox += "</select>";
          return SelBox;
      }
      catch(Exception exp)
      {
        throw exp;
      }
     
    }
    
    
  
  //-bills payments - end
  public static String[] Tokenize(String st,String delimeter)
  {
    StringTokenizer token = new StringTokenizer(st,delimeter);
    String[] s = new String[token.countTokens()];
    int i = -1;
    while(token.hasMoreTokens())
    {
      s[++i] = token.nextToken();
    }
    return s;
  }
 
  public String getStatusImage(String view, double payment_id, String VendorName, String ImagePath,String paymenttype,String transref) throws Exception
  {
      
      String rtnString = "";
      String page_URL = "";
      String link  = " " ;               
      if (view.trim().equalsIgnoreCase("processed"))
      {
        page_URL = "payment_advice.jsp?payment_id=" + payment_id + "&payee=" + VendorName; 
        link  = "<a style='cursor:hand' Onclick=" + (char)34 + "makeNewWindow('" + page_URL + "');return;" + (char)34 + ">"       ;               
          
        
      }
      else
      {
        page_URL = "payment_status.jsp?payment_id=" + payment_id + "&payee=" + VendorName; 
        link  = "<a style='cursor:hand' Onclick=" + (char)34 + "makeNewWindow('" + page_URL + "');return;" + (char)34 + ">"       ;               
          
      }
      
    //String link = "<a style='cursor:hand' Onclick=" + (char)34 + "makeNewWindow('" + page_URL + "');return;" + (char)34 + ">"	;		
    //String link = "<a style='cursor:hand' >"			;
      String Status_Image = "&nbsp;";
      if (view.trim().equalsIgnoreCase("awaiting_approval"))
      {
          rtnString = "";
			}
      else if (view.trim().equalsIgnoreCase("processed"))
      {
          Status_Image = link + "<img src='" + ImagePath + "processed_trans.gif' border='0' alt='Payment Advice'></a>&nbsp;";
      }
      else if (view.trim().equalsIgnoreCase("pending"))
      {
          Status_Image = link + "<img src='" + ImagePath + "pending_trans.gif' border='0' alt='Transaction Status'></a>&nbsp;";
      }
      else if (view.trim().equalsIgnoreCase("failed"))
      {
          Status_Image = link + "<img src='" + ImagePath + "failed_trans.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
      }
      else if (view.trim().equalsIgnoreCase("rejected"))
      {
          Status_Image = link + "<img src='" + ImagePath + "failed_trans.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
      }
      //17/06/2009
      else if (view.trim().equalsIgnoreCase("deleted"))
      {
          Status_Image = link + "<img src='" + ImagePath + "delete.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
      }
       return Status_Image;

  }
  
//22/09/2011 - added for import duty receipt  
    public String getImportDutyReceipt(String view, double payment_id, String VendorName, String ImagePath,String paymenttype,String transref) throws Exception
    {
        
        String rtnString = "";
        String page_URL = "";
        String link  = " " ;               
        if (view.trim().equalsIgnoreCase("processed"))
        {
          //page_URL = "payment_advice.jsp?payment_id=" + payment_id + "&payee=" + VendorName; 
          //link  = "<a style='cursor:hand' Onclick=" + (char)34 + "makeNewWindow('" + page_URL + "');return;" + (char)34 + ">"       ;               
            
          if (paymenttype.equalsIgnoreCase("IMPORTDUTY/PAYMENT"))
            {
                page_URL = "ImportDutyPaymentReceipt.jsp?transref=" + transref; 
                link = "<a style='cursor:hand' Onclick=" + (char)34 + "viewreceipt('" + page_URL + "');return;" + (char)34 + ">"       ;               
            }
        }
        else
        {
          //page_URL = "payment_status.jsp?payment_id=" + payment_id + "&payee=" + VendorName; 
          //link  = "<a style='cursor:hand' Onclick=" + (char)34 + "makeNewWindow('" + page_URL + "');return;" + (char)34 + ">"       ;               
            if (paymenttype.equalsIgnoreCase("IMPORTDUTY/PAYMENT"))
            {
                page_URL = "ImportDutyPaymentReceipt.jsp?transref=" + transref; 
                link = "<a style='cursor:hand' Onclick=" + (char)34 + "viewreceipt('" + page_URL + "');return;" + (char)34 + ">"       ;               
            }
        }
        
      //String link = "<a style='cursor:hand' Onclick=" + (char)34 + "makeNewWindow('" + page_URL + "');return;" + (char)34 + ">" ;               
      //String link = "<a style='cursor:hand' >"                  ;
        String Status_Image = "&nbsp;";
        if (view.trim().equalsIgnoreCase("awaiting_approval"))
        {
            rtnString = "";
                          }
        else if (view.trim().equalsIgnoreCase("processed"))
        {
            Status_Image = link + "<img src='" + ImagePath + "receipt.jpg' border='0' alt='Import Duty Payment Receipt'></a>&nbsp;";
        }
        /*
        else if (view.trim().equalsIgnoreCase("pending"))
        {
            Status_Image = link + "<img src='" + ImagePath + "pending_trans.gif' border='0' alt='Transaction Status'></a>&nbsp;";
        }
        else if (view.trim().equalsIgnoreCase("failed"))
        {
            Status_Image = link + "<img src='" + ImagePath + "failed_trans.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
        }
        else if (view.trim().equalsIgnoreCase("rejected"))
        {
            Status_Image = link + "<img src='" + ImagePath + "failed_trans.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
        }
        //17/06/2009
        else if (view.trim().equalsIgnoreCase("deleted"))
        {
            Status_Image = link + "<img src='" + ImagePath + "delete.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
        }
        */
         return Status_Image;

    }
    
 
  //26/02/2015 - added for eBillsPay receipt  
           public String geteBillsPayReceipt(String view, String eBillsPay, String ImagePath,String paymenttype) throws Exception
           {
               System.out.println("On receipt page: "+eBillsPay);
               String rtnString = "";
               String page_URL = "";
               String link  = " " ;               
               if (view.trim().equalsIgnoreCase("processed"))
               {
                 
                   
                 if (paymenttype.equalsIgnoreCase("eBillsPay"))
                   {
                       //ebills Pay Receipt Demo Link
                       //page_URL = "http://41.58.130.138:8080/eBillsPay/faces/PaymentRef.xhtml?e-BillsPay="+eBillsPay; 
                       page_URL = "https://apps.nibss-plc.com.ng/eBillsPay/faces/PaymentRef.xhtml?e-BillsPay="+eBillsPay; 
                       link = "<a style='cursor:hand' Onclick=" + (char)34 + "viewreceipt('" + page_URL + "');return;" + (char)34 + ">"       ;               
                   }
               }
              
             
               String Status_Image = "&nbsp;";
               if (view.trim().equalsIgnoreCase("awaiting_approval"))
               {
                   rtnString = "";
                                 }
               else if (view.trim().equalsIgnoreCase("processed"))
               {
                   Status_Image = link + "<img src='" + ImagePath + "receipt.jpg' border='0' alt='Import Duty Payment Receipt'></a>&nbsp;";
               }
               
                return Status_Image;

           }
  
    public String getStatusImage(String view, double payment_id, String VendorName, String ImagePath) throws Exception
    {
        String rtnString = "";
        String page_URL = "";
        
        if (view.trim().equalsIgnoreCase("processed"))
        {
          page_URL = "payment_advice.jsp?payment_id=" + payment_id + "&payee=" + VendorName; 
          
        }
        else
        {
          page_URL = "payment_status.jsp?payment_id=" + payment_id + "&payee=" + VendorName; 
          
        }
        
       String link = "<a style='cursor:hand' Onclick=" + (char)34 + "makeNewWindow('" + page_URL + "');return;" + (char)34 + ">" ;               
     //String link = "<a style='cursor:hand' >"                      ;
        String Status_Image = "&nbsp;";
        if (view.trim().equalsIgnoreCase("awaiting_approval"))
        {
            rtnString = "";
                          }
        else if (view.trim().equalsIgnoreCase("processed"))
        {
            Status_Image = link + "<img src='" + ImagePath + "processed_trans.gif' border='0' alt='Payment Advice'></a>&nbsp;";
        }
        else if (view.trim().equalsIgnoreCase("pending"))
        {
            Status_Image = link + "<img src='" + ImagePath + "pending_trans.gif' border='0' alt='Transaction Status'></a>&nbsp;";
        }
        else if (view.trim().equalsIgnoreCase("failed"))
        {
            Status_Image = link + "<img src='" + ImagePath + "failed_trans.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
        }
        else if (view.trim().equalsIgnoreCase("rejected"))
        {
            Status_Image = link + "<img src='" + ImagePath + "failed_trans.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
        }
        //17/06/2009
        else if (view.trim().equalsIgnoreCase("deleted"))
        {
            Status_Image = link + "<img src='" + ImagePath + "delete.jpg' border='0' alt='Transaction Status'></a>&nbsp;";
        }

        return Status_Image;

    }
  
  
  public String getApprovalButtons(int ApprovalLevel, String view) throws Exception
  {
      String PaymentUploadApprovalForm = "";
      if (view.trim().equalsIgnoreCase("awaiting approval") && ApprovalLevel > 1 )
      {
          PaymentUploadApprovalForm += "<br><table width='100%' border='0' cellspacing='1' cellpadding='1' bordercolordark='#FFFFFF'>";
          PaymentUploadApprovalForm +=          "<tr>" ;
          PaymentUploadApprovalForm +=         "<td valign='bottom' colspan='2'>" ;
          PaymentUploadApprovalForm +=           "<input type='hidden' value='' name='Action'>" ;											
          //PaymentUploadApprovalForm +=           "<input Type ='hidden' name='trans_date' value='" & trans_date & "'>" ;
          PaymentUploadApprovalForm +=           "<input Type ='hidden' name='view' value='" + view + "'>" ;
          //PaymentUploadApprovalForm +=           "<input Type ='hidden' name='batchid' value='" + sBatchID + "'>" ;
          PaymentUploadApprovalForm +=           "<input type='button' value='Show summary' name='summary' onclick='showTransactionsSummary(this.form)' class='button'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" ;
          PaymentUploadApprovalForm +=           "<input Type='submit' name='accept_payment'  VALUE='Approve Selected Item(s)' onClick='authorizeTransactions(this.form)' class='button'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" ;
          PaymentUploadApprovalForm +=           "<input Type='submit' name='accept_all_payment'  VALUE='Approve All Item(s)' onClick='authorizeAllTransactions(this.form)' class='button'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" ;
          PaymentUploadApprovalForm +=           "<br><br>Reason for rejecting payment(s): <input type='text' name='reject_reason' maxlength=50 style='font-size:10px'>" ;
          PaymentUploadApprovalForm +=           "&nbsp;<Input Type='submit' name='reject_payment'  VALUE='Reject Payment' onClick= 'declineTransactions(this.form)' class='button'></td>" ;
          PaymentUploadApprovalForm +=       "</tr>" ;
          PaymentUploadApprovalForm +=     "</table>";
      }
      return PaymentUploadApprovalForm;
  }
  
  
  
    //Added String  description to overload the method for page description - //22022013
    public String getViewLinks(String debit_acct_no,String payment_type,String view, String viewImageLink, String FileName,int numRecordsPerPage,String desc_approval,String desc_deleted) throws Exception
    {
       String rtnString = "";
       String viewpage = "<a href='" + FileName + "?DEBIT_ACCT_NO="+debit_acct_no+"&PAYMENT_TYPE="+payment_type+"&view=";
       
       String recordsPerPage = "&recordsPerPage=" + numRecordsPerPage + "'" ;//Lanre Added to resolve pagination 
       
         if (view.trim().equalsIgnoreCase("awaiting approval") || view.trim().equalsIgnoreCase(""))
       {
                                         //view = "awaiting_approval";
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of payments awaiting " + desc_approval + " </b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'awaiting approval'";
                                         //String view_ = "awaiting approval";
                                         
           String viewlink = "";
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Payments Awaiting " + desc_approval + "</b></font> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Awaiting Payments</a> | " ;
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Sucessful Payments</a> | " ;
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | " ;
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Cancelled Payments</a> | " ;//17/06/2009
                                         viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
           
           rtnString = viewlink ;//+ tableHeader;
                         }
                         else if (view.trim().equalsIgnoreCase("pending"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of pending payments</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'pending'";
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting " + desc_approval + "</a> | ";
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Awaiting Payments</b>s</font> | " ;
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Sucessful Payments</a> | ";
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
                                         viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Cancelled Payments</a> | " ;//17/06/2009
           viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
           
           rtnString = viewlink ;//+ tableHeader;
                         }                                               
                         else if (view.trim().equalsIgnoreCase("processed"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of processed payments</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'processed'";                   
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class=''>Payments Awaiting " + desc_approval + "</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class=''>Awaiting Payments</a> | " ;
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Sucessful Payments</b></font> | " ;
                                         viewlink += viewpage + "failed" + recordsPerPage + " class=''>Failed Payments</a> | " ;
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class=''>Rejected Payments</a> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Cancelled Payments</a> | " ;
                                         viewlink += viewpage + "all" + recordsPerPage + " class=''>All Payments</a>";
           
           rtnString = viewlink ;//+ tableHeader;
       }
                         else if (view.trim().equalsIgnoreCase("rejected"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of rejected payments</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'rejected'";
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting " + desc_approval + "</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Awaiting Payments</a> | ";
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Sucessful Payments</a> | " ;
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Rejected Payments</b></font> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Cancelled Payments</a> | " ;
                                         viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
           
           rtnString = viewlink ;//+ tableHeader;
       }
                         else if (view.trim().equalsIgnoreCase("failed"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of failed payments</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting " + desc_approval + "</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Awaiting Payments</a> | " ;
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Sucessful Payments</a> | " ;
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Failed Payments</b></font> | " ;
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Cancelled Payments</a> | " ;
                                         viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
           
           rtnString = viewlink ;//+ tableHeader;
       }
                         else if (view.trim().equalsIgnoreCase("deleted"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of deleted payments</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting " + desc_approval + "</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Awaiting Payments</a> | " ;
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Sucessful Payments</a> | " ;
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Cancelled Payments</b></font> | " ;
           viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
           
           rtnString = viewlink ;//+ tableHeader;
       }
                         else
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of all payments</b></font><p>"   ;                       
                                         //String tmpWhere= "b.zenith_client_id=" + clientID;
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting " + desc_approval + "</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Awaiting Payments</a> | ";
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Sucessful Payments</a> | ";
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | " ;
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Cancelled Payments</a> | " ;
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>All Payments</b></font>";
           
           rtnString = viewlink ;//+ tableHeader;
                         }
       return rtnString;
    }
  
  
  
   //Lanre Added int numRecordsPerPage to method to  resolve pagination issues
  public String getViewLinks(String debit_acct_no,String payment_type,String view, String viewImageLink, String FileName,int numRecordsPerPage) throws Exception
  {
      String rtnString = "";
      String viewpage = "<a href='" + FileName + "?DEBIT_ACCT_NO="+debit_acct_no+"&PAYMENT_TYPE="+payment_type+"&view=";
      
      String recordsPerPage = "&recordsPerPage=" + numRecordsPerPage + "'" ;//Lanre Added to resolve pagination 
      
    	if (view.trim().equalsIgnoreCase("awaiting approval") || view.trim().equalsIgnoreCase(""))
      {
					//view = "awaiting_approval";
					String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of payments awaiting approval</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'awaiting approval'";
					//String view_ = "awaiting approval";
					
          String viewlink = "";
					viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Payments Awaiting Approval</b></font> | " ;
					viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | " ;
					viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | " ;
					viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | " ;
					viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
          viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;//17/06/2009
					viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink ;//+ tableHeader;
			}
			else if (view.trim().equalsIgnoreCase("pending"))
      {
					String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of pending payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'pending'";
					
          String viewlink = "";
					viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | ";
					viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Pending Payment</b>s</font> | " ;
					viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | ";
					viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
					viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
					viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;//17/06/2009
          viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink ;//+ tableHeader;
			}						
			else if (view.trim().equalsIgnoreCase("processed"))
      {
					String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of processed payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'processed'";			
					
          String viewlink = "";
					viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class=''>Payments Awaiting Approval</a> | " ;
					viewlink += viewpage + "pending" + recordsPerPage + " class=''>Pending Payments</a> | " ;
					viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Processed Payments</b></font> | " ;
					viewlink += viewpage + "failed" + recordsPerPage + " class=''>Failed Payments</a> | " ;
					viewlink += viewpage + "rejected" + recordsPerPage + " class=''>Rejected Payments</a> | " ;
          viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;
					viewlink += viewpage + "all" + recordsPerPage + " class=''>All Payments</a>";
          
          rtnString = viewlink ;//+ tableHeader;
      }
			else if (view.trim().equalsIgnoreCase("rejected"))
      {
					String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of rejected payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'rejected'";
					
          String viewlink = "";
					viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | " ;
					viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | ";
					viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | " ;
					viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
					viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Rejected Payments</b></font> | " ;
          viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;
					viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink ;//+ tableHeader;
      }
			else if (view.trim().equalsIgnoreCase("failed"))
      {
					String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of failed payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
					
          String viewlink = "";
					viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | " ;
					viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | " ;
					viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | " ;
					viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Failed Payments</b></font> | " ;
					viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
          viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;
					viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink ;//+ tableHeader;
      }
      			else if (view.trim().equalsIgnoreCase("deleted"))
      {
					String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of deleted payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
					
          String viewlink = "";
					viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | " ;
					viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | " ;
					viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | " ;
					viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
					viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
					viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Deleted Payments</b></font> | " ;
          viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink ;//+ tableHeader;
      }
			else
      {
					String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of all payments</b></font><p>"	;			
					//String tmpWhere= "b.zenith_client_id=" + clientID;
					
          String viewlink = "";
					viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | " ;
					viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | ";
					viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | ";
					viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | " ;
					viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
          viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;
					viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>All Payments</b></font>";
          
          rtnString = viewlink ;//+ tableHeader;
			}
      return rtnString;
  }
  
  
  
  
  //15092014  
      //Lanre Added int numRecordsPerPage to method to  resolve pagination issues
      public String getViewLinks(String debit_acct_no,String payment_type,String view, String viewImageLink, String FileName, String batch_id, String bankcode,int numRecordsPerPage) throws Exception
      {
         String rtnString = "";
         
         String viewpage = "<a href='" + FileName + "?DEBIT_ACCT_NO="+debit_acct_no+"&PAYMENT_TYPE="+payment_type+"&BATCH_ID="+batch_id+"&BankCode="+bankcode+"&view=";
         
         String recordsPerPage = "&recordsPerPage=" + numRecordsPerPage + "'" ;//Lanre Added to resolve pagination 
         
           if (view.trim().equalsIgnoreCase("awaiting approval") || view.trim().equalsIgnoreCase(""))
         {
                                           //view = "awaiting_approval";
                                           String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of payments awaiting approval</b></font><p>";
                                           //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'awaiting approval'";
                                           //String view_ = "awaiting approval";
                                           
             String viewlink = "";
                                           viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Payments Awaiting Approval</b></font> | " ;
                                           viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | " ;
                                           viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | " ;
                                           viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | " ;
                                           viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
             viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;//17/06/2009
                                           viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
             
             rtnString = viewlink ;//+ tableHeader;
                           }
                           else if (view.trim().equalsIgnoreCase("pending"))
         {
                                           String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of pending payments</b></font><p>";
                                           //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'pending'";
                                           
             String viewlink = "";
                                           viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | ";
                                           viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Pending Payment</b>s</font> | " ;
                                           viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | ";
                                           viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
                                           viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
                                           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;//17/06/2009
             viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
             
             rtnString = viewlink ;//+ tableHeader;
                           }                                               
                           else if (view.trim().equalsIgnoreCase("processed"))
         {
                                           String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of processed payments</b></font><p>";
                                           //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'processed'";                   
                                           
             String viewlink = "";
                                           viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class=''>Payments Awaiting Approval</a> | " ;
                                           viewlink += viewpage + "pending" + recordsPerPage + " class=''>Pending Payments</a> | " ;
                                           viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Processed Payments</b></font> | " ;
                                           viewlink += viewpage + "failed" + recordsPerPage + " class=''>Failed Payments</a> | " ;
                                           viewlink += viewpage + "rejected" + recordsPerPage + " class=''>Rejected Payments</a> | " ;
             viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;
                                           viewlink += viewpage + "all" + recordsPerPage + " class=''>All Payments</a>";
             
             rtnString = viewlink ;//+ tableHeader;
         }
                           else if (view.trim().equalsIgnoreCase("rejected"))
         {
                                           String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of rejected payments</b></font><p>";
                                           //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'rejected'";
                                           
             String viewlink = "";
                                           viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | " ;
                                           viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | ";
                                           viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | " ;
                                           viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
                                           viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Rejected Payments</b></font> | " ;
             viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;
                                           viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
             
             rtnString = viewlink ;//+ tableHeader;
         }
                           else if (view.trim().equalsIgnoreCase("failed"))
         {
                                           String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of failed payments</b></font><p>";
                                           //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
                                           
             String viewlink = "";
                                           viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | " ;
                                           viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | " ;
                                           viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | " ;
                                           viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Failed Payments</b></font> | " ;
                                           viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
             viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;
                                           viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
             
             rtnString = viewlink ;//+ tableHeader;
         }
                           else if (view.trim().equalsIgnoreCase("deleted"))
         {
                                           String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of deleted payments</b></font><p>";
                                           //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
                                           
             String viewlink = "";
                                           viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | " ;
                                           viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | " ;
                                           viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | " ;
                                           viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | ";
                                           viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
                                           viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Deleted Payments</b></font> | " ;
             viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Payments</a>";
             
             rtnString = viewlink ;//+ tableHeader;
         }
                           else
         {
                                           String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of all payments</b></font><p>"   ;                       
                                           //String tmpWhere= "b.zenith_client_id=" + clientID;
                                           
             String viewlink = "";
                                           viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Payments Awaiting Approval</a> | " ;
                                           viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Payments</a> | ";
                                           viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Payments</a> | ";
                                           viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Payments</a> | " ;
                                           viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Payments</a> | " ;
             viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Payments</a> | " ;
                                           viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>All Payments</b></font>";
             
             rtnString = viewlink ;//+ tableHeader;
                           }
         return rtnString;
      }

  
  
    //Lanre Added int numRecordsPerPage to method to  resolve pagination issues
    public String getViewChequeConfirmationLinks(String debit_acct_no,String payment_type,String view, String viewImageLink, String FileName,int numRecordsPerPage) throws Exception
    {
       String rtnString = "";
       String viewpage = "<a href='" + FileName + "?DEBIT_ACCT_NO="+debit_acct_no+"&PAYMENT_TYPE="+payment_type+"&view=";
       
       String recordsPerPage = "&recordsPerPage=" + numRecordsPerPage + "'" ;//Lanre Added to resolve pagination 
       
         if (view.trim().equalsIgnoreCase("awaiting approval") || view.trim().equalsIgnoreCase(""))
       {
                                         //view = "awaiting_approval";
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of Cheque confirmation awaiting approval</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'awaiting approval'";
                                         //String view_ = "awaiting approval";
                                         
           String viewlink = "";
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Cheque confirmation Awaiting Approval</b></font> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Cheque confirmation</a> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Cheque confirmation</a> | " ;//17/06/2009
                                         viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Cheque confirmation</a>";
           
           rtnString = viewlink ;//+ tableHeader;
                         }
                         else if (view.trim().equalsIgnoreCase("pending"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of pending Cheque confirmation</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'pending'";
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Cheque confirmation Awaiting Approval</a> | ";
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Pending Cheque confirmation</b>s</font> | " ;
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Cheque confirmation</a> | ";
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Cheque confirmation</a> | ";
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Cheque confirmation</a> | " ;//17/06/2009
           viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Cheque confirmation</a>";
           
           rtnString = viewlink ;//+ tableHeader;
                         }                                               
                         else if (view.trim().equalsIgnoreCase("processed"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of processed Cheque confirmation</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'processed'";                   
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class=''>Cheque confirmation Awaiting Approval</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class=''>Pending Cheque confirmation</a> | " ;
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Processed Cheque confirmation</b></font> | " ;
                                         viewlink += viewpage + "failed" + recordsPerPage + " class=''>Failed Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class=''>Rejected Cheque confirmation</a> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "all" + recordsPerPage + " class=''>All Cheque confirmation</a>";
           
           rtnString = viewlink ;//+ tableHeader;
       }
                         else if (view.trim().equalsIgnoreCase("rejected"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of rejected Cheque confirmation</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'rejected'";
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Cheque confirmation Awaiting Approval</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Cheque confirmation</a> | ";
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Cheque confirmation</a> | ";
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Rejected Cheque confirmation</b></font> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Cheque confirmation</a>";
           
           rtnString = viewlink ;//+ tableHeader;
       }
                         else if (view.trim().equalsIgnoreCase("failed"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of failed Cheque confirmation</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Cheque confirmation Awaiting Approval</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Cheque confirmation</a> | " ;
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Failed Cheque confirmation</b></font> | " ;
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Cheque confirmation</a> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Cheque confirmation</a>";
           
           rtnString = viewlink ;//+ tableHeader;
       }
                         else if (view.trim().equalsIgnoreCase("deleted"))
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of deleted Cheque confirmation</b></font><p>";
                                         //String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Cheque confirmation Awaiting Approval</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Cheque confirmation</a> | ";
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Cheque confirmation</a> | " ;
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>Deleted Cheque confirmation</b></font> | " ;
           viewlink += viewpage + "all" + recordsPerPage + " class='navbarlink'>All Cheque confirmation</a>";
           
           rtnString = viewlink ;//+ tableHeader;
       }
                         else
       {
                                         String tableHeader = "<p>&nbsp;</p><font size='2'face='Verdana, Arial'><b>List of all Cheque confirmation</b></font><p>"   ;                       
                                         //String tmpWhere= "b.zenith_client_id=" + clientID;
                                         
           String viewlink = "";
                                         viewlink += viewpage + "awaiting_approval" + recordsPerPage + " class='navbarlink'>Cheque confirmation Awaiting Approval</a> | " ;
                                         viewlink += viewpage + "pending" + recordsPerPage + " class='navbarlink'>Pending Cheque confirmation</a> | ";
                                         viewlink += viewpage + "processed" + recordsPerPage + " class='navbarlink'>Processed Cheque confirmation</a> | ";
                                         viewlink += viewpage + "failed" + recordsPerPage + " class='navbarlink'>Failed Cheque confirmation</a> | " ;
                                         viewlink += viewpage + "rejected" + recordsPerPage + " class='navbarlink'>Rejected Cheque confirmation</a> | " ;
           viewlink += viewpage + "deleted" + recordsPerPage + " class='navbarlink'>Deleted Cheque confirmation</a> | " ;
                                         viewlink += viewImageLink + "<font size='1'face='Verdana, Arial'><b>All Cheque confirmation</b></font>";
           
           rtnString = viewlink ;//+ tableHeader;
                         }
       return rtnString;
    }
    
  
  
  
  
  
  public String getViewLinksAdmin(String view, String viewImageLink) throws Exception
   {
     
      String rtnString = "";
      String viewpage ="";
    	if (view.trim().equalsIgnoreCase("awaiting approval") || view.trim().equalsIgnoreCase(""))
      {
					//view = "awaiting_approval";
					String tableHeader = "<p><p><font size='2'face='Verdana, Arial'><b>List of payments awaiting approval</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'awaiting approval'";
					//String view_ = "awaiting approval";
					
          String viewlink = "";
					viewlink += viewImageLink + "<font size='2'face='Verdana, Arial'><b>Payments Awaiting Approval</b></font> | " ;
					viewlink +=  "<a href=javascript:loadpage('pending') class='navbarlink'>Pending Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('processed') class='navbarlink'>Processed Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('failed') class='navbarlink'>Failed Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('rejected') class='navbarlink'>Rejected Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('all') class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink + tableHeader;
			}
			else if (view.trim().equalsIgnoreCase("pending"))
      {
					String tableHeader = "<p><p><font size='2'face='Verdana, Arial'><b>List of pending payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'pending'";
					
          String viewlink = "";
          viewlink += "<a href=javascript:loadpage('awaiting_approval') class='navbarlink'>Payments Awaiting Approval</a> | " ;
					viewlink += viewImageLink + "<font size='2'face='Verdana, Arial'><b>Pending Payment</b>s</font> | " ;
					viewlink += "<a href=javascript:loadpage('processed') class='navbarlink'>Processed Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('failed') class='navbarlink'>Failed Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('rejected') class='navbarlink'>Rejected Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('all') class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink + tableHeader;
			}						
			else if (view.trim().equalsIgnoreCase("processed"))
      {
					String tableHeader = "<p><p><font size='2'face='Verdana, Arial'><b>List of processed payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'processed'";			
					
          String viewlink = "";
          viewlink += "<a href=javascript:loadpage('awaiting_approval') class='navbarlink'>Payments Awaiting Approval</a> | " ;
          viewlink +=  "<a href=javascript:loadpage('pending') class='navbarlink'>Pending Payments</a> | " ;
					viewlink += viewImageLink + "<font size='2'face='Verdana, Arial'><b>Processed Payments</b></font> | " ;
					viewlink += "<a href=javascript:loadpage('failed') class='navbarlink'>Failed Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('rejected') class='navbarlink'>Rejected Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('all') class='navbarlink'>All Payments</a>";
          
          
          rtnString = viewlink + tableHeader;
      }
			else if (view.trim().equalsIgnoreCase("rejected"))
      {
					String tableHeader = "<p><p><font size='2'face='Verdana, Arial'><b>List of rejected payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'rejected'";
					
          String viewlink = "";
          viewlink += "<a href=javascript:loadpage('awaiting_approval') class='navbarlink'>Payments Awaiting Approval</a> | " ;
          viewlink +=  "<a href=javascript:loadpage('pending') class='navbarlink'>Pending Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('processed') class='navbarlink'>Processed Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('failed') class='navbarlink'>Failed Payments</a> | " ;
					viewlink += viewImageLink + "<font size='2'face='Verdana, Arial'><b>Rejected Payments</b></font> | " ;
          viewlink += "<a href=javascript:loadpage('all') class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink + tableHeader;
      }
			else if (view.trim().equalsIgnoreCase("failed"))
      {
					String tableHeader = "<p><p><font size='2'face='Verdana, Arial'><b>List of failed payments</b></font><p>";
					//String tmpWhere= "b.zenith_client_id=" + clientID + " and ptystatus = 'failed'";
					
          String viewlink = "";
				   viewlink += "<a href=javascript:loadpage('awaiting_approval') class='navbarlink'>Payments Awaiting Approval</a> | " ;
          viewlink +=  "<a href=javascript:loadpage('pending') class='navbarlink'>Pending Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('processed') class='navbarlink'>Processed Payments</a> | " ;
					viewlink += viewImageLink + "<font size='2'face='Verdana, Arial'><b>Failed Payments</b></font> | " ;
					viewlink += "<a href=javascript:loadpage('rejected') class='navbarlink'>Rejected Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('all') class='navbarlink'>All Payments</a>";
          
          rtnString = viewlink + tableHeader;
      }
			else
      {
					String tableHeader = "<p><p><font size='2'face='Verdana, Arial'><b>List of all payments</b></font><p>"	;			
					//String tmpWhere= "b.zenith_client_id=" + clientID;
					
          String viewlink = "";
					viewlink += "<a href=javascript:loadpage('awaiting_approval') class='navbarlink'>Payments Awaiting Approval</a> | " ;
          viewlink +=  "<a href=javascript:loadpage('pending') class='navbarlink'>Pending Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('processed') class='navbarlink'>Processed Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('failed') class='navbarlink'>Failed Payments</a> | " ;
					viewlink += "<a href=javascript:loadpage('rejected') class='navbarlink'>Rejected Payments</a> | " ;
					viewlink += viewImageLink + "<font size='2'face='Verdana, Arial'><b>All Payments</b></font>";
          
          rtnString = viewlink + tableHeader;
			}
      return rtnString;
   }
}