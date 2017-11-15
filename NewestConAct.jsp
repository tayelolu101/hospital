<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="com.zenithbank.banking.coporate.ibank.audit.AuditValue"%>
<%@page import="com.zenithbank.banking.coporate.ibank.audit.AuditManager"%>
<%@page import="org.apache.poi.hssf.util.HSSFColor"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFFont"%>
<%@page import="org.apache.poi.ss.usermodel.CellStyle"%>
<%@page import="com.zenithbank.banking.ibank.account.AccountUncollected"%>
<%@page import="com.zenithbank.banking.ibank.account.AccountStatementsItem"%>
<%@page import="com.zenithbank.banking.ibank.account.AccountStatementsValue"%>
<%@page import="com.zenithbank.banking.coporate.ibank.PaymentHelper.AccountStatementGenerator"%>
<%@page import="com.zenithbank.banking.coporate.ibank.PaymentHelper.AccountStatementModel"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.zenithbank.banking.ibank.account.RequestValue"%>
<%@page import="com.zenithbank.banking.ibank.common.BaseAdapter"%>
<%@page import="com.zenithbank.banking.ibank.security.SinglePiontSingOnValue"%>
<%@page import="java.util.Calendar"%>
<html>
<head>
    <%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.io.*" %>
<%@ page import = "org.apache.poi.hssf.usermodel.HSSFSheet, org.apache.poi.hssf.usermodel.HSSFWorkbook, org.apache.poi.ss.usermodel.Cell, org.apache.poi.ss.usermodel.Row"%>
<%response.setContentType("application/xls"); %>
<%@page pageEncoding="UTF-8"%>
<%String filename = "ConsolidatedAcctsStatement.xls";%>
<%response.setHeader("Cache-Control","max-age=0"); %> 
<%response.setHeader("Pragma","public");%> 
<%response.setDateHeader ("Expires", 0); %>
<%response.setHeader("Content-Disposition","attachment; filename =" +filename);%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
    </head>
    <%
    java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
SinglePiontSingOnValue sec = (SinglePiontSingOnValue) session.getAttribute("sec");
BaseAdapter connect = new BaseAdapter();
RequestValue req = new RequestValue();
RequestValue req3 = new RequestValue();
RequestValue req2 = new RequestValue();
String ACCOUNTTYPE = request.getParameter("ACCOUNTTYPE");
// String ITEM_TYPE = request.getParameter("ITEM_TYPE");
String ACTIVITY_TYPE = request.getParameter("ACTIVITY_TYPE");


com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
if ( login.getPasschange().equals("1"))
{
response.sendRedirect("ChangePwd.jsp");
} 
if (  login == null)
{
response.sendRedirect("/coporate-internetbanking/sessiontimeout.jsp");
} 

String CHEQUE1 = request.getParameter("CHEQUE1");
String CHEQUE2 = request.getParameter("CHEQUE2");
String DATE1 = request.getParameter("DATE1");
String DATE2 = request.getParameter("DATE2");        
String AMOUNT1 = request.getParameter("AMOUNT1");
String AMOUNT2 = request.getParameter("AMOUNT2");
String applType = "";
String acctNo = "";
String iso = "";
String description = "";
String acctType="";
if ( ACCOUNTTYPE == null)
{
response.sendRedirect("sessiontimeout.jsp");
} 
boolean counter = false;
if  ((ACCOUNTTYPE != "") ) {
applType = ACCOUNTTYPE.substring(0,2);
acctNo = ACCOUNTTYPE.substring(2,12);
iso = ACCOUNTTYPE.substring(12,15);
acctType = ACCOUNTTYPE.substring(15,17);
description = ACCOUNTTYPE.substring(17);
}
String name = "";

com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter acctOpening = new com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter();
com.dwise.util.CurrencyNumberformat formatta = new com.dwise.util.CurrencyNumberformat();        
java.text.SimpleDateFormat sd2  = new java.text.SimpleDateFormat("yyyyMMdd");
int day = Integer.parseInt(DATE2.substring(0, 2));
int mon = Integer.parseInt(DATE2.substring(3, 5));
int year = Integer.parseInt(DATE2.substring(6, 10));
String mt = String.valueOf(mon);
String dy = String.valueOf(day + 1);
String yr = String.valueOf(year);
String formatedDate2 = dy + "/" + mt + "/" + yr;
String accesscode=(String) session.getAttribute("accesscode");
String loginId=(String) session.getAttribute("loginId");
String password=(String) session.getAttribute("password");

String refNo  = new com.dwise.util.HtmlUtilily().getUnique(loginId);
long time = Calendar.getInstance().getTime().getTime();
java.text.SimpleDateFormat sd1  = new java.text.SimpleDateFormat("dd/MM/yyyy");
java.util.Date Date1Obj = sd1.parse(DATE1);
java.util.Date Date2Obj = sd1.parse(DATE2);
java.util.Date formatedDate2Obj = sd1.parse(formatedDate2);

//CHUKS 27052008
int rim_no = 0;
String password2 = "";
/* pcidss
java.sql.Connection con1 = connect.getConnectionsds();
java.sql.Connection con2 = connect.getConnectionsds();
String sql = "select rim_no from phoenix..rm_services where cust_service_key = '"+accesscode+"' and services_id=41";

try
{
java.sql.Statement stmt = con1.createStatement();
java.sql.ResultSet rs = stmt.executeQuery(sql);
if (rs.next()){
	rim_no = rs.getInt("rim_no"); 
}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if (con1 != null) con1.close();
}

try
{
String sql2 = "select password from phoenix..rm_services_rel where rim_no = "+rim_no+" and user_name = '"+loginId.trim()+"' and services_id=41";
java.sql.Statement stmt = con2.createStatement();
java.sql.ResultSet rs = stmt.executeQuery(sql2);
if (rs.next()){
	password2 = rs.getString("password"); 
}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if (con2 != null) con2.close();
}

*/

//pcidss-Begin
java.sql.Connection con1 = connect.getConnectionsds();//pcidss
PreparedStatement pst = null;//pcidss
java.sql.ResultSet rs = null ;//pcidss
try
{
String sql = "select password,rim_no from phoenix..rm_services_rel where rim_no = (select rim_no from phoenix..rm_services where cust_service_key = ? and services_id= ?) and services_id= ?";
	
	pst = con1.prepareStatement(sql);
	pst.setString(1,accesscode);
	pst.setInt(2,41);
	pst.setInt(3,41);
	rs = pst.executeQuery();
//pcidss-end

if (rs.next()){
	password2 = rs.getString("password"); 
        rim_no = rs.getInt("rim_no"); 
        
}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if (pst != null) pst.close(); //pcidss
        if (rs != null)  rs.close(); //pcidss
        if (con1 != null) con1.close();//pcidss
      
}


req2.setDate1(Date1Obj);
req2.setUserName(loginId);



req2.setPin(password2);
req2.setCardNo(accesscode);
req2.setOrigReferenceNo("ibank "+request.getRemoteAddr());
req2.setApplType1(applType);
req2.setAcctNo1(acctNo);
req2.setAcctType1(acctType);
// AccountStatementsValue acctStmts  = acctOpening.getAccountOpeningBalance(req2);

com.dwise.util.DatetimeFormat dt = new com.dwise.util.DatetimeFormat();
java.sql.Date tranDate = dt.getSQLFormatedDate(Date1Obj);
java.sql.Date valDate = dt.getSQLFormatedDate(Date2Obj);

System.out.println(ACCOUNTTYPE);
System.out.println("LoginID : "+loginId);
req.setUserName(loginId);

System.out.println("Password2 : "+password2);
req.setPin(password2);

System.out.println("Access Code : "+accesscode);
req.setCardNo(accesscode);

System.out.println("Reference : "+request.getRemoteAddr());
req.setOrigReferenceNo("ibank "+request.getRemoteAddr());

System.out.println("app1Type : "+applType);
req.setApplType1(applType);

System.out.println("acctType : "+acctType);
req.setAcctType1(acctType);

if ( !(CHEQUE1.trim().equalsIgnoreCase(""))){req.setCheckNo1(Integer.parseInt(CHEQUE1));}



if ((CHEQUE2.trim().equalsIgnoreCase("")))
{
	//req.setCheckNo2(999999999);
	  req.setCheckNo2(2100000000);


}
else
{
	req.setCheckNo2(Integer.parseInt(CHEQUE2));
}
if (!(AMOUNT1.trim().equalsIgnoreCase(""))){req.setAmount1(Double.parseDouble(AMOUNT1));}

if ((AMOUNT2.trim().equalsIgnoreCase("")))
{
	req.setAmount2(999999999);
}
else
{ 
	req.setAmount2(Double.parseDouble(AMOUNT2));
}

// if(!(ITEM_TYPE.trim().equalsIgnoreCase(""))){req.setTransactionType(Integer.parseInt(ITEM_TYPE));}

if(!(ACTIVITY_TYPE.trim().equalsIgnoreCase(""))){req.setTransactionType(Integer.parseInt(ACTIVITY_TYPE));}

System.out.println("iso : "+iso);
req.setIsoCurrency(iso);

System.out.println("Date1Obj : "+Date1Obj);
req.setDate1(Date1Obj);

System.out.println("Date2Obj : "+Date2Obj);
req.setDate2(Date2Obj);

System.out.println("acctNo : "+acctNo);
req.setAcctNo1(acctNo);


System.out.println("Amount 1 : "+req.getAmount1());
System.out.println("Amount 2 : "+req.getAmount2());

System.out.println("CheckNo1 : "+req.getCheckNo1());

System.out.println("CheckNo2 : "+req.getCheckNo2());

System.out.println("Transaction Type : "+req.getTransactionType());


req3.setAcctNo1(acctNo);
req3.setPin(password2);
req3.setCardNo(accesscode);
req3.setApplType1(applType);
req3.setAcctType1(acctType);
req3.setAmount1(0);
req3.setUserName(loginId);

AccountStatementsItem[] acctStmtsItem = new AccountStatementsItem[0];
AccountUncollected[] acctUcf = new AccountUncollected[0];




acctStmtsItem  = acctOpening.getStatementsActivityItem(req);

//acctUcf = acctOpening.getAccountUncollected(req3);

double sumCredit = 0.00d;
double sumDebit = 0.00d;
double netbalance = 0.00d;
double nAmount = 0.0;
double crAmount = 0.0;
double drAmount = 0.0;
double nTotalCreditAmt = 0.00;
double sumTotalCredit = 0.00;
double nTotalDebitAmt = 0.00;
double sumTotalDebit = 0.00;
double nEndingBal = 0.00;
double nbeginingBal = 0.00;
double nRunningBal = 0.00;
double nTotalCreditAmt_Ucf = 0.00;
double totalClear = 0.00;
double nRunningBal_Ucf = 0.00;
double nRunningBal_Ucf_Sum = 0.00;
double nTotalCreditAmt_Ucf_Sum = 0.00;
java.util.Date availabledate1;
java.util.Date createdate1;
String availabledate = "";
String createdate = "";
String get_dr_cr = "";
int totalCredit = 0;
int totalDebit = 0;
int totalCredit_Ucf = 0;
int totalDebit_Ucf = 0;
String reversal = "2";
String tran_code_desc = "Deposit Renewal";
String tran_code_int = "Interest Withheld - State";
int tran_code = 0;
String tran_code_check = "";
String dr_cr = "CR";

//////
         HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet spreadsheet = workbook.createSheet(filename);

          int row = 0;
         java.text.SimpleDateFormat timestamp  = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss a"); 
         AuditManager adm = new AuditManager();//CIB AUDIT
         AuditValue audit = new AuditValue();//CIB AUDIT
         audit.setCompany_code(login.getHostCompany());
         audit.setBranch_code(login.getHostBranch());
         audit.setTable_name("PSP_EX_MAIN2");
         audit.setObj_name("ACCOUNT");
         audit.setAcct_perfmd("View Account Activity ");
         audit.setPrev_value("");
         audit.setCur_value("");
         audit.setIndex_tab_name("");
         audit.setEffective_date(timestamp.format(Calendar.getInstance().getTime()));
         audit.setAcct_date(timestamp.format(Calendar.getInstance().getTime()));
         audit.setIbank_id(login.getIbankid());
         audit.setLogin_id(login.getLoginId());
         audit.setAction_status("SUCCESSFUL");
         adm.createAudit(audit);
         /////
if( acctStmtsItem.length <= 0)
{ 


 // response.sendRedirect("/internetbanking/accountcontroller.jsp?np=noRecord");
   response.sendRedirect("/coporate-internetbanking/noRecord.jsp");   
}
else
{ 
  System.out.println("acctStmtsItem.length--------"+acctStmtsItem.length);
  if( acctStmtsItem.length == 2){			     
	 acctStmtsItem[acctStmtsItem.length - 1].setIso_currency(iso);
  } 
      
 HSSFRow rowHeader = spreadsheet.createRow(row);
 rowHeader.createCell(0).setCellValue("ACCOUNT NAME");
 rowHeader.createCell(1).setCellValue(description);
 rowHeader.createCell(0).setCellValue("BEGIN BALANCE : "+new java.text.SimpleDateFormat("dd/MM/yyyy").format(Date1Obj));
 rowHeader.createCell(1).setCellValue(acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString(acctStmtsItem[0].getTranAmount ())));
 row++;
 HSSFRow rowhead = spreadsheet.createRow(row);
 row++;
 HSSFRow rowheadd = spreadsheet.createRow(row);
 rowheadd.createCell(0).setCellValue("CREATE DATE");
 rowheadd.createCell(1).setCellValue("EFFECTIVE DATE");
 rowheadd.createCell(2).setCellValue("CHECK NO");
 rowheadd.createCell(3).setCellValue("DESCRIPTION/PAYEE/MEMO");
 rowheadd.createCell(4).setCellValue("DEBIT AMOUNT");
 rowheadd.createCell(5).setCellValue("CREDIT AMOUNT");
 rowheadd.createCell(0).setCellValue("BALANCE");
			  		
  nEndingBal = nEndingBal + acctStmtsItem[0].getTranAmount();  

  for (int i = 1; i < acctStmtsItem.length; i++)
  {
  if(i > 1){
   if(acctStmtsItem[i].getTranOrigin() == 0 || (req.getTransactionType()==2 && acctStmtsItem[i].getTranOrigin() == 1 ))
   {  


	 String checkno = "";	 

	 get_dr_cr = acctStmtsItem[i].getDrCr();	 

	 String dr_cr_val = "";
 
	 if (get_dr_cr != null)  
	 {get_dr_cr = get_dr_cr ; }
	 else 
	 {get_dr_cr = "";}
     
     nAmount = acctStmtsItem[i].getTranAmount();   


     if (get_dr_cr.trim().equalsIgnoreCase(dr_cr))
     {
		 totalCredit = totalCredit + 1;
		 nTotalCreditAmt = nTotalCreditAmt + acctStmtsItem[i].getsumtotalCredit();
		 sumTotalCredit = sumTotalCredit + nTotalCreditAmt;
		 nEndingBal =  nAmount;
		 crAmount = acctStmtsItem[i].getsumtotalCredit();
     }
     else
     {
		 totalDebit = totalDebit + 1;
		 nTotalDebitAmt = nTotalDebitAmt - (acctStmtsItem[i].getsumtotalDebit() * -1) ;
		 sumTotalDebit = sumTotalDebit + nTotalDebitAmt ; 
		 nEndingBal = nAmount ;
		 drAmount = acctStmtsItem[i].getsumtotalDebit();

     }
	 

     nRunningBal = nEndingBal;
     totalClear = nRunningBal;
 
  row++;
  HSSFRow rowheaddd = spreadsheet.createRow(row);
  rowheaddd.createCell(0).setCellValue(new java.text.SimpleDateFormat("dd/MM/yyyy").format(acctStmtsItem[i].getCreateDate()));
  rowheaddd.createCell(1).setCellValue(new java.text.SimpleDateFormat("dd/MM/yyyy").format(acctStmtsItem[i].getEffectiveDate()));
  HSSFCell cell0 = rowheaddd.createCell(2);
  if (acctStmtsItem[i].getCheckNumber() == 0){
       cell0.setCellValue("");
  } else{ 
      cell0.setCellValue(acctStmtsItem[i].getCheckNumber());
  }
  rowheaddd.createCell(3).setCellValue(acctStmtsItem[i].getReg_E_Desc());
  HSSFCell cell1 = rowheaddd.createCell(4);
  if (!(acctStmtsItem[i].getDrCr().trim().equalsIgnoreCase(dr_cr))){
     cell1.setCellValue(acctStmtsItem[i].getIso_currency()+" "+formatta.formatAmount(Double.toString(acctStmtsItem[i].getsumtotalDebit()))); 
  }else { 
       cell1.setCellValue("");
  }
  HSSFCell cell2 = rowheaddd.createCell(5);
  if (acctStmtsItem[i].getDrCr().trim().equalsIgnoreCase(dr_cr)){
          cell2.setCellValue(acctStmtsItem[i].getIso_currency()+" "+formatta.formatAmount(Double.toString(acctStmtsItem[i].getsumtotalCredit())));
  }else {
       cell2.setCellValue(""); 
  }
  rowheaddd.createCell(6).setCellValue(acctStmtsItem[i].getIso_currency()+" "+formatta.formatAmount(Double.toString(acctStmtsItem[i].getTranAmount())));
                         
				   } 
				}				   
			 } 
                         
                         
                         
			 if( acctStmtsItem.length == 2){			     
				 acctStmtsItem[acctStmtsItem.length - 1].setIso_currency(iso);
			     nRunningBal = acctStmtsItem[0].getTranAmount(); 
			     totalClear = nRunningBal;


			 } 
  row++;
  HSSFRow roww = spreadsheet.createRow(row);
  row++;
  HSSFRow rowws = spreadsheet.createRow(row);			 
  rowws.createCell(0).setCellValue("TOTAL DEBITS: ");
  rowws.createCell(1).setCellValue(totalDebit);
  rowws.createCell(2).setCellValue("");
  rowws.createCell(3).setCellValue("TOTAL CREDITS: ");
  rowws.createCell(4).setCellValue(totalCredit);

  row++;
  HSSFRow rowww = spreadsheet.createRow(row);
  rowww.createCell(0).setCellValue("TOTAL:");
  rowww.createCell(1).setCellValue("DEBITS: "+acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString(nTotalDebitAmt * -1)));         
  rowww.createCell(2).setCellValue("");     
  rowww.createCell(3).setCellValue("CREDITS: "+acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString(nTotalCreditAmt)));            
        
  row++;
  HSSFRow rowwws = spreadsheet.createRow(row); 
  rowwws.createCell(0).setCellValue("CLEAR BALANCE AT: "+new java.text.SimpleDateFormat("dd-MM-yyyy hh:mm:ss").format(Date2Obj));
  rowwws.createCell(1).setCellValue(acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString(nRunningBal)));                  
                       
  row++;
  HSSFRow rowwwss = spreadsheet.createRow(row); 
  rowwwss.createCell(0).setCellValue("");
  rowwwss.createCell(1).setCellValue("UNCLEARED ITEMS: ");              

	 
	 for (int i = 1; i < acctStmtsItem.length; i++){	
     
	  if( i > 1){
	 

	 if(req.getTransactionType()==1 && acctStmtsItem[i].getTranOrigin() == 1)
      {
	   totalDebit_Ucf = 0;
       nTotalCreditAmt_Ucf = acctStmtsItem[i].getsumtotalCredit();
       totalCredit_Ucf = totalCredit_Ucf + 1 ;
       nTotalCreditAmt_Ucf_Sum = nTotalCreditAmt_Ucf_Sum + nTotalCreditAmt_Ucf;
       nRunningBal_Ucf = acctStmtsItem[i].getTranAmount();
       


	   nRunningBal = nRunningBal_Ucf;
       availabledate1 = acctStmtsItem[i].getEffectiveDate();
       
	   if (availabledate1 != null)
       {
			availabledate =  new java.text.SimpleDateFormat("dd/MM/yyyy").format(availabledate1);
       }
       else
       {
			availabledate = "";
       }
	   
	   createdate1 = acctStmtsItem[i].getCreateDate();
       if (createdate1 != null)
       {
			createdate =  new java.text.SimpleDateFormat("dd/MM/yyyy").format(createdate1);
       }
       else
       {
			createdate = "";
       }
       row++;
       HSSFRow rowa = spreadsheet.createRow(row);
       rowa.createCell(0).setCellValue(createdate);
       rowa.createCell(1).setCellValue(availabledate);
       rowa.createCell(2).setCellValue("");
       rowa.createCell(3).setCellValue(acctStmtsItem[i].getReg_E_Desc());
       rowa.createCell(4).setCellValue("");
       rowa.createCell(4).setCellValue(acctStmtsItem[acctStmtsItem.length -1].getIso_currency()+" "+formatta.formatAmount(Double.toString(nTotalCreditAmt_Ucf)));
       rowa.createCell(4).setCellValue(acctStmtsItem[acctStmtsItem.length -1].getIso_currency()+" "+formatta.formatAmount(Double.toString(acctStmtsItem[i].getTranAmount())));
               
                    }
					  }
                                          
                       }	
       row++;
       HSSFRow rowb = spreadsheet.createRow(row);
       row++;
       HSSFRow rowc = spreadsheet.createRow(row);
       rowc.createCell(0).setCellValue("TOTAL DEBITS: ");
       rowc.createCell(1).setCellValue(totalDebit_Ucf);
       rowc.createCell(2).setCellValue("");
       rowc.createCell(3).setCellValue("TOTAL CREDITS: ");
       rowc.createCell(4).setCellValue(totalCredit_Ucf);

       row++;
       HSSFRow rowd = spreadsheet.createRow(row);
       rowd.createCell(0).setCellValue("TOTALS: ");  
       rowd.createCell(1).setCellValue(acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString(nRunningBal_Ucf_Sum)));
       rowd.createCell(2).setCellValue("");     
       rowd.createCell(3).setCellValue(acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString(nTotalCreditAmt_Ucf_Sum)));  
       rowd.createCell(4).setCellValue("");          
                                             
       row++;
       HSSFRow rowe = spreadsheet.createRow(row);
       rowe.createCell(0).setCellValue("");
       rowe.createCell(1).setCellValue("Totals cleared Items: "+acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString
(totalClear)));
       rowe.createCell(3).setCellValue("");
       rowe.createCell(4).setCellValue("Totals Uncleared Items: "+acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString
(nTotalCreditAmt_Ucf_Sum)));
       rowe.createCell(5).setCellValue("");
 
       row++;
       HSSFRow rowf = spreadsheet.createRow(row);
       rowf.createCell(0).setCellValue(totalDebit + totalDebit_Ucf +" DEBIT(S)");  
       rowf.createCell(1).setCellValue("");
       rowf.createCell(2).setCellValue(totalCredit + totalCredit_Ucf+" CREDIT(S)"); 
       rowf.createCell(3).setCellValue("");
       rowf.createCell(4).setCellValue("Totals( Cleared + Uncleared Items ): "+acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount
(Double.toString(nTotalCreditAmt_Ucf_Sum + totalClear))); 
       rowf.createCell(5).setCellValue("");  
                      
                        }
       row++;
       HSSFRow rowk = spreadsheet.createRow(row); 
       row++;
       HSSFRow rowg = spreadsheet.createRow(row);
       rowg.createCell(0).setCellValue("");
       rowg.createCell(1).setCellValue("Total Cheques, Payments and Debits: "+acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount
(Double.toString(nTotalDebitAmt * -1)));                
       rowg.createCell(2).setCellValue("Total Deposits and Credits :"+acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString
(nTotalCreditAmt_Ucf_Sum + nTotalCreditAmt)));
       rowg.createCell(3).setCellValue("");

       row++;
       HSSFRow rowm = spreadsheet.createRow(row);
       rowm.createCell(0).setCellValue(""); 
       rowm.createCell(1).setCellValue("");
       rowm.createCell(2).setCellValue("Ending Balance: "+acctStmtsItem[acctStmtsItem.length - 1].getIso_currency()+" "+formatta.formatAmount(Double.toString
(nTotalCreditAmt_Ucf_Sum + totalClear)));
       rowm.createCell(3).setCellValue("");
       rowm.createCell(4).setCellValue("");
       rowm.createCell(5).setCellValue("");
      
        row++;	
        HSSFRow rowmm = spreadsheet.createRow(row);       
        row++;	
        HSSFRow rowmmn = spreadsheet.createRow(row);
        row++;	
        HSSFRow rowmmm = spreadsheet.createRow(row);   
        

    try {
          // FileOutputStream stream = new FileOutputStream(filename);
          // workbook.write(stream);
            workbook.close();
            File f = new File(filename);    
InputStream in = new FileInputStream(f); 

ServletOutputStream outs = response.getOutputStream(); 
int bit = 256;
int i = 0;
try{  
while ((bit) >= 0) {
 bit = in.read();  
 outs.write(bit);
}
outs.flush();     
outs.close();
out.clear();
out = pageContext.pushBody();
in.close();
return;
} catch (IOException ioe) {  
ioe.printStackTrace(System.out); 
} 
        } catch (IOException ex) {
            System.out.println(ex);
        }
                  
  %>
</html>
