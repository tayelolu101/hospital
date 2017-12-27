<%@ page language="java" import = "javazoom.upload.*,javax.naming.*,java.util.*,java.io.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.mail.*,com.zenithbank.banking.ibank.cheque.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.coporate.ibank.*,com.zenithbank.banking.coporate.ibank.payment.UtilityProcessor,com.zenithbank.banking.coporate.ibank.payment.PaymentAdapter,com.zenithbank.banking.coporate.ibank.payment.UserValue,com.zenithbank.banking.ibank.common.*,java.text.*,java.util.Calendar,com.zenithbank.banking.coporate.ibank.audit.*,java.util.Hashtable" errorPage="error.jsp" session="true" %>
<html>
    <head>
        <meta http-equiv="Content-Language" content="en-us">
        <meta http-equiv="pragma" content="NO-CACHE">
        <link href="css/GenericStylesheet.css" rel="stylesheet" type="Text/CSS" />
        <script src="javascript/GenericJavaScript1.js" type="text/javascript" language="javascript"></script>
        <script type='text/javascript' language="javascript">
            function returnMe()
            {
            window.location="BeneficiaryList.jsp";
            }
        </script>
    </head>
    
    <body class="parentBody" id="div_body">
        <DIV align="center">
           <TABLE frame='Void' rules='None' summary='Body-table' border='0' cellspacing='0' cellpadding='0' class='OuterTableCurve'>
               <TBODY>
                  <TR>
                     <TD align='Left' dir='LTR' style='vertical-align:top;'><IMG alt='' src='images/LeftTopFFFFFF.gif' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:top; color:#FFFFFF;'></TD><TD align='Right' dir='RTL' style='vertical-align:top;'><IMG alt='' src='images/RightTopFFFFFF.gif' class='AngularCurves' /></TD>
                  </TR>
               </TBODY>
               <TBODY>
                  <TR>
                     <TD colspan='3' align='center' style='width:100%; padding:0px 2px 0px 2px;'>
                       <TABLE frame='Void' rules='None' summary='Body-table' border='0' cellspacing='0' cellpadding='0' class='InnerTableCurve'>
                         <TBODY>
                           <TR>
                             <TD align='Left' dir='LTR' style='vertical-align:top;'><IMG alt='' src='images/LeftTopCCCCCC.gif' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:top; color:#FFFFFF;'></TD><TD align='Right' dir='RTL' style='vertical-align:top;'><IMG alt='' src='images/RightTopCCCCCC.gif' class='AngularCurves' /></TD>
                           </TR>
                         </TBODY>
                         <TBODY>
                           <TR>
                             <TD colspan='3' align='center' style='padding:0px 3px 0px 3px;'>
                                <DIV class='HeaderText1' style='text-align:center;'>Payment Transaction Report</DIV>
                             </TD>
                           </TR>
                         </TBODY>
                         <TBODY>
                           <TR>
                             <TD align='Left' dir='LTR' style='vertical-align:bottom;'><IMG alt='' src='images/LeftBottomCCCCCC.gif' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:bottom;'></TD><TD align='Right' dir='RTL' style='vertical-align:bottom;'><IMG alt='' src='images/RightBottomCCCCCC.gif' class='AngularCurves' /></TD>
                           </TR>
                         </TBODY>
                       </TABLE>    
                     </TD>
                  </TR>       
                  <TR>
                     <TD colspan='3' align='center' style='width:100%; padding:2px 2px 0px 2px;'>
                       <TABLE frame='Void' rules='None' summary='Body-table' border='0' cellspacing='0' cellpadding='0' class='InnerTableCurve'>
                         <TBODY>
                           <TR>
                             <TD align='Left' dir='LTR' style='vertical-align:top;'><IMG alt='' src='images/LeftTopCCCCCC.gif' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:top; color:#FFFFFF;'></TD><TD align='Right' dir='RTL' style='vertical-align:top;'><IMG alt='' src='images/RightTopCCCCCC.gif' class='AngularCurves' /></TD>
                           </TR>
                         </TBODY>
                         <TBODY>
                           <TR>
                             <TD colspan='3' align='center' style='padding:0px 3px 0px 3px;'>
                            <%
                                response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
                                response.setHeader("Pragma","no-cache"); //HTTP 1.0
                                response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
                               com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
                               com.zenithbank.banking.coporate.ibank.action.CompanyManager company = new com.zenithbank.banking.coporate.ibank.action.CompanyManager(); 
                               String mycompany = company.findBankByCode(login.getHostCompany()).getName();
                               String rolegroup = company.findBankByCode(login.getHostCompany()).getrolegroup();
                            if (  login == null)
                            {
                            response.sendRedirect("/coporate-internetbanking/sessiontimeout.jsp");
                            }  
                                BaseAdapter connect = new BaseAdapter();    
                                int ApprovalLevel = login.getAuthLevel();
                            /*Begin Gbolly added for Beneficiary Level Validation -180909*/
                                    String CompanyID = login.getHostCompany();
                                    String ben_level_val = company.findBankByCode(login.getHostCompany()).getBen_approval_val();
                            int bene_max4Company = company.findBankByCode(login.getHostCompany()).getBen_approval_level();
                            /*End Gbolly added for Beneficiary Level Validation -180909*/
                                BeneficiaryValue req = new BeneficiaryValue();
                                com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter ChangePwd = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter();
                            
                                            SinglePiontSingOnValue sec = null;
                                            try{
                                                    sec = (SinglePiontSingOnValue) session.getAttribute("sec");
                                            }catch(Exception ne){
                                                    response.sendRedirect("sessionTimeOut.jsp");
                                            }
                                            
                                            try{
                                            String accesscode=(String) session.getAttribute("accesscode");
                                            String loginId=(String) session.getAttribute("loginId");
                                            String password=(String) session.getAttribute("password");
                                            String GenBankName = "";
                                            String GenBankClearingCode = "";
                                            String GenBankClearingCode1= ""; 
                            
                            //added 03032010 Begin - Intermediary Bank Details		
                                            String IntermediaryBankName = "";
                                            String IntermediaryBankSwiftCode = "";
                                            String IntermediaryBankAcctNo = "";
                            //added 03032010 End - Intermediary Bank Details    
                                            String BeneficiaryState = "";
                                            
                                            String BeneficiaryName = "";
                                            BeneficiaryName = request.getParameter("txtBeneficiaryName");
                                
                                String BeneficiaryAddress = request.getParameter("txtBeneficiaryaddress");
                                String BeneficiaryCity = request.getParameter("txtCity");
                                //String BeneficiaryState = request.getParameter("AllStates");
                                BeneficiaryState = request.getParameter("AllStates");
                                String BeneficiaryPhone = request.getParameter("txtphone");
                                String BeneficiaryGSM = request.getParameter("txtgsmnumber");
                                String BeneficiaryEmailAddress = request.getParameter("txtemailaddress");
                                String BeneficiaryContactPerson = request.getParameter("txtcontactperson");
                                String paymentType = request.getParameter("AcctInfo1");
                                //System.out.println(" << paymentType >> "+ paymentType);
                            //Gbolly Added New Payment type for INTRABANK/DIRECTDEBIT,ZENITH/FTCREDIT,ZENITH/FTDEBIT - 18092009
                                if ( (paymentType.trim().equalsIgnoreCase("ZENITH/BENEFICIARY")) || (paymentType.trim().equalsIgnoreCase("INTRABANK/DIRECTDEBIT")) || (paymentType.trim().equalsIgnoreCase("ZENITH/FTCREDIT"))|| (paymentType.trim().equalsIgnoreCase("ZENITH/FTDEBIT"))){
                                    String BankNameZenith = request.getParameter("txtBankZenith");
                                    GenBankName = BankNameZenith;
                                    String BankBranchNameZenith =  request.getParameter("BranchCode");
                                    GenBankClearingCode = BankBranchNameZenith;
                                }
                            //Gbolly Added Payment type for INTERBANK/DIRECTDEBIT - 18092009	
                            //Gbolly Added Payment type for INTERSWITCH/BENEFICIARY - 22012010	
                            //added payment type for SWIFT/DIRECTDEBIT - 30092013
                            if ((paymentType.trim().equalsIgnoreCase("INTERBANK/BENEFICIARY"))||(paymentType.trim().equalsIgnoreCase("INTERBANK/DIRECTDEBIT"))||(paymentType.trim().equalsIgnoreCase("INTERSWITCH/BENEFICIARY"))||(paymentType.trim().equalsIgnoreCase("SWIFT/DIRECTDEBIT")) ){    
                                    String BankNameInterBank = request.getParameter("ddBank");
                                    GenBankName = BankNameInterBank;
                                    String BankBranchNameInterBank =  request.getParameter("ddBranch");
                                    GenBankClearingCode = BankBranchNameInterBank;
                                }
                                if ( paymentType.trim().equalsIgnoreCase("FOREIGN/BENEFICIARY")){    
                                    String BankNameForeignBank = request.getParameter("txtForeignBank");
                                    //GenBankName = BankNameForeignBank;//commmented-12022013
                                    String BankBranchForeignBank1 = request.getParameter("txtInternational");//sortcode
                                            String BankBranchForeignBank2 = request.getParameter("txtSwiftCode");
                                            String BankBranchForeignBank3 = request.getParameter("txtForeignBankBranch");
                                    //GenBankClearingCode = "Sort Code: "+BankBranchForeignBank1 + " : Swift Code:" + BankBranchForeignBank2;//12022013
                                            //GenBankClearingCode = ""; //commented-12022013
                                            req.setvendor_bankname(BankNameForeignBank);//bank name-12022013
                                            GenBankClearingCode = BankBranchForeignBank1 ;//sortcode-12022013
                                            GenBankName = BankBranchForeignBank2 ;//swift code - 12022013
                                            GenBankClearingCode1 = BankBranchForeignBank3; //chuks
                            /*added 03032010 Begin - Intermediary Bank Details
                                             IntermediaryBankName = request.getParameter("txtForeignIntBank");
                                             IntermediaryBankSwiftCode = request.getParameter("txtIntSwiftCode");
                                             IntermediaryBankAcctNo = request.getParameter("txtIntBankAccountNo");
                            //added 03032010 End- Intermediary Bank Details
                            */
                               //begin - added 09062014 - FX STP
                                String accountCurrency = request.getParameter("ddAcctCur");
                                String beneficiaryCountry = request.getParameter("ddCountry");
                                String bankCountry = request.getParameter("ddBankCountry");
                                String bankCity = request.getParameter("txtBankCity");
                                req.setAcct_currency(accountCurrency);
                                req.setVendor_country(beneficiaryCountry);
                                req.setVendor_bank_country(bankCountry);
                                req.setVendor_bank_city(bankCity);
                                //end - added 09062014 - FX STP
                                
                               
                            
                                }  
                             if ( paymentType.trim().equalsIgnoreCase("DRAFT/ISSUANCE")){    
                                    String BankNameZenith = request.getParameter("txtBankZenith1");
                                    GenBankName = BankNameZenith;
                                    String BankBranchNameZenith =  request.getParameter("BranchCode");
                                    GenBankClearingCode = BankBranchNameZenith;
                            }
                            if ( paymentType.trim().equalsIgnoreCase("CORPORATE/CHEQUE")){    
                                    String BankNameZenith = request.getParameter("txtBankZenith1");
                                    GenBankName = BankNameZenith;
                                    String BankBranchNameZenith =  request.getParameter("BranchCode");
                                    GenBankClearingCode = BankBranchNameZenith;
                            }
                            
                              
                                                          
                                String BeneficiaryAcctNo = request.getParameter("txtAccountNo");
                                String BeneficiaryRef = request.getParameter("txtBeneRef");
                                String Status = request.getParameter("bankName1");
                                
                                req.setBeneficiaryAcctNo(BeneficiaryAcctNo);
                                req.setBeneficiaryRef(BeneficiaryRef); 
                                req.setBeneficiaryName(BeneficiaryName.replaceAll("'","''"));
                                req.setGenBankName(GenBankName.replaceAll("'","''"));
                                req.setGenBankClearingCode(GenBankClearingCode.replaceAll("'","''"));
                                req.setpaymenttype(paymentType);
                                req.setSTATUS(Status);
                                req.setCompanyCode(login.getHostCompany());
                                req.setBeneficiaryAddress(BeneficiaryAddress.replaceAll("'","''"));
                                req.setBeneficiaryCity(BeneficiaryCity.replaceAll("'","''"));
                                req.setBeneficiaryState(BeneficiaryState.replaceAll("'","''"));
                                req.setBeneficiaryPhone(BeneficiaryPhone);
                                req.setBeneficiaryGSM(BeneficiaryGSM);
                                req.setBeneficiaryEmailAddress(BeneficiaryEmailAddress.replaceAll("'","''"));
                                req.setBeneficiaryContactPerson(BeneficiaryContactPerson.replaceAll("'","''"));
                                req.setBranchname(GenBankClearingCode1.replaceAll("'","''"));
                              
                             /*added 03032010 Begin - Intermediary Bank Details 
                              req.setIntermediary_bank_name(IntermediaryBankName.replaceAll("'","''"));
                              req.setIntermediary_bank_bic(IntermediaryBankSwiftCode);
                              req.setIntermediary_bank_acctno(IntermediaryBankAcctNo);    
                            //added 03032010 Ended - Intermediary Bank Details
                          */
                               
                                boolean changepwd = ChangePwd.InsertBene(req,login.getLoginId(),login.getgrouproleid()); //19/05/2008 - chuks
                                
                                if ( changepwd )
                                { 
                                    try{
                                 String Mailbody = "";
                                   String EmailAddress = "";
                                          String MobileNo = "";
                                          String FullName = "";
                                          String Subject = "Zenith Corporate Internet Banking Beneficiary Request Approval";
                                          String CompanyName = company.findBankByCode(login.getHostCompany()).getName();
                                           UtilityProcessor up = new UtilityProcessor();
                                           PaymentAdapter pa = new PaymentAdapter();
                                           UserValue[] uv;
                            
                            /* commented to resolve issue of sending mails for Beneficiary Level Validation 180909
                                           if(rolegroup.trim().equalsIgnoreCase("Y"))
                                                uv = pa.getUserContactDetailsRolegroup(login.getHostCompany(), ApprovalLevel+1,login.getgrouproleid(),"");
                                          else
                                                uv = pa.getUserContactDetails(login.getHostCompany(), ApprovalLevel+1);
                            */					
                            /*Added to  to resolve issue of sending mails for Beneficiary Level Validation 180909*/					
                            if(rolegroup.trim().equalsIgnoreCase("Y"))
                            {
                                  uv = pa.getUserContactDetailsRolegroup(login.getHostCompany(), ApprovalLevel+1,login.getgrouproleid(),"");
                            }
                            //do not send mails to the next approval if approval level of logon user is equal to 
                            else if (( ben_level_val.trim().equalsIgnoreCase("Y")) && ((ApprovalLevel == bene_max4Company)))
                            {
                               //  uv = pa.getUserContactDetails(CompanyID, max4Company+1);//09092009 max4company should be replaced with bene_max4Company
                              uv = pa.getUserContactDetails(CompanyID, bene_max4Company);//09092009 max4company should be replaced with bene_max4Company
                            //uv = null ;
                            System.out.println(" do not send mail ");
                            }
                            //do not send mails to the next approval if approval level of logon user is equal to 
                            else if (( ben_level_val.trim().equalsIgnoreCase("Y")) && ((ApprovalLevel < bene_max4Company)))
                            {
                               //  uv = pa.getUserContactDetails(CompanyID, max4Company+1);//09092009 max4company should be replaced with bene_max4Company
                              uv = pa.getUserContactDetails(CompanyID, ApprovalLevel+1);//09092009 max4company should be replaced with bene_max4Company
                            //System.out.println(" I got here 1");
                            }
                            else
                              {
                                  uv = pa.getUserContactDetails(CompanyID, ApprovalLevel+1);
                                  //System.out.println(" I got here 2");
                               }   
                                                
                                      StringBuffer MsgBody1 = new StringBuffer();
                                      
                                      for (int i=0; i<uv.length; i++)
                                      {
                                          EmailAddress = uv[i].getEmailAddress();
                                          MobileNo = uv[i].getGsmNo();
                                          FullName = uv[i].getFullName();
                                          String SMSmessage = "";
                                          SMSmessage += login.getFullname() + " has uploaded beneficiary file for your approval on Zenith Corporate Internet Banking." ;
                                          SMSmessage += "Thank you for your patronage.";
                                          up.sendSMS(SMSmessage, MobileNo);
                        
                                          StringBuffer MsgBody = new StringBuffer();
                                          
                                                MsgBody.append("<HEAD>");
                                                MsgBody.append("<TITLE>Zenith Bank Corporate Internet Banking Beneficiary Upload Notification System</TITLE>");
                                                MsgBody.append("</HEAD>");
                                                MsgBody.append("<BODY>");
                                                MsgBody.append("<table><tr></td>");
                                                MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("<tr><td> Dear ")).append(FullName).append(",<br><br>"))));
                                                MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("Zenith Corporate Internet banking beneficiary upload by " + login.getFullname() + " on behalf of " + CompanyName + "  has been sucessful.").append("<br>")))));
                                               MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("You are required to take action on this/these benficiary added.").append("<br><br> ")))));
                                                MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("Thank you for your patronage.").append("<br>")))));
                                                                        
                                              
                                                MsgBody.append("</table>");
                                                MsgBody.append("<br><br>");
                                                MsgBody.append("  Regards, <br><br>");
                                                MsgBody.append(" ZENITH BANK PLC </td></tr>");
                                                MsgBody.append("</BODY>");
                                                MsgBody.append("</HTML>");
                                                String MsgToSend1 = MsgBody.toString();
                                                JXMessage m2 = new JXMessage(EmailAddress,"ebusinessgroup@zenithbank.com","172.29.12.167"); 
                                                m2.setMessage(MsgToSend1);
                                                m2.setMailSubject("Corporate Internet Banking beneficiary Upload ");
                                                //m2.addCCAddress("");
                                                //m2.addCCAddress("");
                                                m2.setHTML(true);
                                                JXMail sender2 = new JXMail(m2);
                                                sender2.send();
                                              
                                                MsgBody1.append("<HEAD>");
                                                MsgBody1.append("<TITLE>Zenith Bank Corporate Internet Banking Beneficiary Upload Notification System</TITLE>");
                                                MsgBody1.append("</HEAD>");
                                                MsgBody1.append("<BODY>");
                                                MsgBody1.append("<table><tr></td>");
                                                 MsgBody1.append(String.valueOf(String.valueOf((new StringBuffer("<tr><td> Dear Zenith Bank Plc<br><br>")))));
                                                MsgBody1.append(String.valueOf(String.valueOf((new StringBuffer("A beneficiary has been manually added to the system by " + login.getLoginId() + " on behalf of " + mycompany + ".").append("<br>")))));
                                               MsgBody1.append("</table>");
                                                MsgBody1.append("<br><br>");
                                                MsgBody1.append("  Regards, <br><br>");
                                                MsgBody1.append(" ZENITH BANK PLC </td></tr>");
                                                MsgBody1.append("</BODY>");
                                                MsgBody1.append("</HTML>");
                                                String MsgToSend2 = MsgBody1.toString();
                                                JXMessage m1 = new JXMessage("ebusiness@zenithbank.com","ebusinessgroup@zenithbank.com","172.29.12.167"); 
                                                m1.setMessage(MsgToSend2);
                                                m1.setMailSubject("Corporate Internet Banking Beneficiary Upload ");
                                              // m.addBCCAddress("juliet.obasi@zenithbank.com");
                                               //m1.addCCAddress("mubarak.alade@zenithbank.com");
                                                                   //m1.addCCAddress("gbolahan.majolagbe@zenithbank.com");
                                                                   
                                                m1.setHTML(true);
                                              JXMail sender1 = new JXMail(m1);
                                              sender1.send();
                                        }
                                    } 
                                    catch(JXMailException jme)
                                    {
                                        jme.printStackTrace();
                                        // out.println("<br>");
                                        System.out.println("Unable to send your message, please Contact Ebusiness for more Information ");
                                        // out.println("<input type='button' name='back' value='Back' onClick='javascript:history.go(-1)'>");
                                        //out.println("<br>");
                                    }
                                %>
                                            <DIV class='NavyText' style='text-align:justify;'>
                                                <DIV style='margin:0px 0px 20px 0px;'>
                                                    The Beneficiary details has been added successfully and it is awaiting approval.
                                                </DIV>
                                                <DIV align='center' style='margin:0px 0px 0px 0px;'>
                                                    <INPUT type="button" style='width:14%;' name="next" id="next" value="Continue" class="Button1" onclick="javascript:returnMe();" />
                                                </DIV>
                                            </DIV>
                                <%                                           
                                   }
                                   else 
                                  {
                                %>
                                        <DIV class='NavyText' style='text-align:justify;'>
                                            <DIV style='margin:0px 0px 20px 0px;'>
                                                Error adding a new Beneficiary details. pls try again!!!
                                            </DIV>
                                            <DIV align='center' style='margin:0px 0px 0px 0px;'>
                                                <INPUT type="button" style='width:10%;' name="back" id="back" value="Back" class="Button1" onclick="javascript:history.go(-1);" />
                                            </DIV>
                                        </DIV>
                                <%                                   
                                  }
                                }
                                catch(Exception ee)
                                {
                                System.out.println("BeneficiaryProcessor.jsp:: Error while processing request "+ee);
                                ee.printStackTrace();
                                }
                            %> 
                         </TD>
                       </TR>
                     </TBODY>
                     <TBODY>
                       <TR>
                         <TD align='Left' dir='LTR' style='vertical-align:bottom;'><IMG alt='' src='images/LeftBottomCCCCCC.gif' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:bottom;'></TD><TD align='Right' dir='RTL' style='vertical-align:bottom;'><IMG alt='' src='images/RightBottomCCCCCC.gif' class='AngularCurves' /></TD>
                       </TR>
                     </TBODY>
                   </TABLE>
                 </TD>
              </TR>
           </TBODY>
           <TBODY>
             <TR>
                 <TD align='Left' dir='LTR' style='vertical-align:bottom;'><IMG alt='' src='images/LeftBottomFFFFFF.gif' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:bottom;'></TD><TD align='Right' dir='RTL' style='vertical-align:bottom;'><IMG alt='' src='images/RightBottomFFFFFF.gif' class='AngularCurves' /></TD>
             </TR>
           </TBODY>
        </TABLE>   
    </DIV>
	
  </body>
</html>