<%@page import="jxl.write.WritableImage"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.net.URL"%>
<%@page import="jxl.write.WritableSheet"%>
<%@page import="com.zenithbank.banking.coporate.ibank.PaymentHelper.AccountStatementEntriesModel"%>
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
<%response.setHeader("Content-Disposition","attachment; filename="+filename);%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
    </head>
    <body>
            
       <%

try{
java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
SinglePiontSingOnValue sec = (SinglePiontSingOnValue) session.getAttribute("sec");
BaseAdapter connect = new BaseAdapter();
RequestValue req = new RequestValue();
RequestValue req2 = new RequestValue();
RequestValue req1 = new RequestValue();//added in PHOENIXME getUncollectedFunds //11082010

Connection con = null;
ResultSet rs;
ResultSet rs1;
Statement st = null;
PreparedStatement ps = null;

//System.out.println(" <<< i am here i am here ");
String ACCOUNTTYPE = request.getParameter("ACCOUNTTYPE");
String ITEM_TYPE = request.getParameter("ITEM_TYPE");

String CHEQUE1 = request.getParameter("CHEQUE1");
String CHEQUE2 = request.getParameter("CHEQUE2");
String DATE1 = request.getParameter("DATE1");
String DATE2 = request.getParameter("DATE2");        
String AMOUNT1 = request.getParameter("AMOUNT1");
String AMOUNT2 = request.getParameter("AMOUNT2");
String applType = "";
String acctNo = "";
String iso = "";
String acctType="";




boolean counter = false;

String name = "";
com.dwise.util.CurrencyNumberformat formatta = new com.dwise.util.CurrencyNumberformat();        
java.text.SimpleDateFormat sd2  = new java.text.SimpleDateFormat("yyyyMMdd");
//System.out.println(" ghfgfgfhdgdfhgdfhgdfh ");
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
//System.out.println(" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
int rim_no = 0;
String password2 = "";
java.sql.Connection con1 = connect.getConnectionsds();
java.sql.Connection con2 = connect.getConnectionsds();
String sql = "select rim_no from phoenix..rm_services where cust_service_key = '"+accesscode+"' and services_id=41";
try
{
java.sql.Statement stmt = con1.createStatement();
java.sql.ResultSet rsA = stmt.executeQuery(sql);
if (rsA.next()){
	rim_no = rsA.getInt("rim_no"); 
}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if (con1 != null) con1.close();
}

try
{
String sql2 = "select password from phoenix..rm_services_rel where rim_no = "+rim_no+" and services_id=41";
java.sql.Statement stmt = con2.createStatement();
java.sql.ResultSet rsB = stmt.executeQuery(sql2);
if (rsB.next()){
	password2 = rsB.getString("password"); 
}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if (con2 != null) con2.close();
}

com.dwise.util.DatetimeFormat dt = new com.dwise.util.DatetimeFormat();

java.sql.Date tranDate = dt.getSQLFormatedDate(Date1Obj);
java.sql.Date valDate = dt.getSQLFormatedDate(Date2Obj);

String ptids="";
int TCount = 0;
String[] s1 = request.getParameterValues("chk");
session.setAttribute("s1",s1);
con =  connect.getConnectionsds();
java.util.List<AccountStatementModel> models = new java.util.ArrayList<AccountStatementModel>();
AccountStatementGenerator statementGenerator = new AccountStatementGenerator();
//java.net.URL companyLogoURL =application.getResource("/zeelogo.JPG");
 for(int ia = 0; ia < s1.length; ia++)
 {    
  
    TCount = TCount + 1;
 
com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter acctOpening = new com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter();

String SQLAccountDetails = " select d.acct_no ,d.acct_type ,(select appl_type from phoenix..ad_gb_acct_type  where acct_type = d.acct_type) as appl_type ";
       SQLAccountDetails += " ,(select iso_code from phoenix..ad_gb_crncy  where crncy_id = d.crncy_id) as iso_code from    phoenix..dp_display d ";
	   
       SQLAccountDetails += " where d.acct_no = '" + s1[ia].trim() + "'" ;

st = con.createStatement();
rs1 = st.executeQuery(SQLAccountDetails);
  
  while (rs1.next()){
      acctNo = rs1.getString("acct_no");
      applType = rs1.getString("appl_type"); 
      acctType = rs1.getString("acct_type");
      iso = rs1.getString("iso_code");
  }


java.sql.Connection con3 = connect.getConnectionsds();
String title_name = "";
try
{
String sql3 = "select title_1 from phoenix..dp_acct  where acct_no = '"+s1[ia].trim()+"'";
java.sql.Statement stmt = con3.createStatement();
java.sql.ResultSet rsC = stmt.executeQuery(sql3);
if (rsC.next()){
	title_name = rsC.getString("title_1"); 
}
}catch(Exception e){
    title_name = "";
	System.out.println(" Unable to get the Title_1 !!! ");
	e.printStackTrace();
}finally{
	if (con3 != null) con3.close();
}

req2.setDate1(Date1Obj);
req2.setUserName(loginId);
req2.setPin(password2);
req2.setCardNo(accesscode);
req2.setOrigReferenceNo("ibank "+request.getRemoteAddr());
req2.setApplType1(applType);
req2.setAcctNo1(acctNo);
req2.setAcctType1(acctType);



req.setUserName(loginId);
req.setPin(password2);
req.setCardNo(accesscode);
req.setOrigReferenceNo("ibank "+request.getRemoteAddr());
req.setApplType1(applType);
req.setAcctType1(acctType);
req.setCheckNo2(999999);
req.setAmount2(999999999);
req.setIsoCurrency(iso);
req.setDate1(Date1Obj);
req.setDate2(Date2Obj);
req.setAcctNo1(acctNo);
req.setTransactionType(1);


req1.setUserName(loginId);
req1.setPin(password2.trim());
req1.setCardNo(accesscode);
req1.setApplType1(applType);					  
req1.setAcctNo1(acctNo);
req1.setAcctType1(acctType);
req1.setAmount1(0);
req1.setOrigReferenceNo("ibank "+request.getRemoteAddr());




    
models.add(statementGenerator.generateArchiveAccountStatement(req, req1, req2));     
}
 
// statementGenerator.writeAccountStatementToExcel(models, filename, "Consolidated Activity Statement");
 
 
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet spreadsheet = workbook.createSheet(filename);
         CellStyle style = workbook.createCellStyle();
            HSSFFont font = workbook.createFont();
            font.setFontName(HSSFFont.FONT_ARIAL);
            font.setFontHeightInPoints((short)10);
            font.setColor(HSSFColor.DARK_RED.index);
            font.setBold(true);
           
        //spreadsheet.autoSizeColumn(7);
         int row = 0;
        for (AccountStatementModel model : models) {
          HSSFRow rowHeaderm = spreadsheet.createRow(row);
          rowHeaderm.createCell(0).setCellValue("");
          HSSFCell cc = rowHeaderm.createCell(1);
          cc.setCellValue(" ZENITH BANK ");
          cc.setCellStyle(style);
          rowHeaderm.createCell(2).setCellValue("");
           
         
        String Header = "ACCOUNT NAME, ACCOUNT NUMBER, BEGIN BALANCE DATE, BEGIN BALANCE";
        String[] arrHeader = Header.split(",");

       
        row++;
        HSSFRow rowHeader = spreadsheet.createRow(row);

        for (int i = 0; i < arrHeader.length; i++) {
            HSSFCell cellTitt = rowHeader.createCell(i);
            cellTitt.setCellValue(arrHeader[i]);
            style.setFont(font);
            cellTitt.setCellStyle(style);
     }
           
        row++;
       
            HSSFRow rower = spreadsheet.createRow(row);

            HSSFCell cell0 = rower.createCell(0);
            cell0.setCellValue(model.getAccountName());
 // System.err.println("1");
            HSSFCell cell1 = rower.createCell(1);
            cell1.setCellValue(model.getAccountNo());
 // System.err.println("2");
            HSSFCell cell2 = rower.createCell(2);
            cell2.setCellValue(model.getOpeningBalanceDate());
 // System.err.println("3");
            HSSFCell cell3 = rower.createCell(3);
            cell3.setCellValue(model.getOpeningBalanceAmount());
//  System.err.println("4");
            row++;
            HSSFRow rowHade = spreadsheet.createRow(row);

            String newHead = "Create Date, Effective Date, Check No, Description/Payee/Memo, Debit Amount, Credit Amount, Balance";
            String[] rowHead = newHead.split(",");

            row++;
            HSSFRow rowHeadd = spreadsheet.createRow(row);

            for (int i = 0; i < rowHead.length; i++) {
                HSSFCell cellTittle = rowHeadd.createCell(i);
                cellTittle.setCellStyle(style);
             }

            AccountStatementEntriesModel[] entries = model.getEntries();  

            for (int i = 0; entries != null && i < entries.length; i++) {
                AccountStatementEntriesModel entry = entries[i];
                row++;
                HSSFRow rowHeade = spreadsheet.createRow(row);

                HSSFCell cell4 = rowHeade.createCell(0);
                cell4.setCellValue(entry.getCreationDate());
  //System.err.println("5");
                HSSFCell cell5 = rowHeade.createCell(1);
                cell5.setCellValue(entry.getEffectiveDate());
  //System.err.println("6");
                HSSFCell cell6 = rowHeade.createCell(2);
                cell6.setCellValue(entry.getCheckNumber());
 // System.err.println("7");
                HSSFCell cell7 = rowHeade.createCell(3);
                cell7.setCellValue(entry.getDescription());
  //System.err.println("8");
                HSSFCell cell8 = rowHeade.createCell(4);
                cell8.setCellValue(entry.getDebitAmount());
  //System.err.println("9");
                HSSFCell cell9 = rowHeade.createCell(5);
                cell9.setCellValue(entry.getCreditAmount());
 // System.err.println("10");
                HSSFCell cell10 = rowHeade.createCell(6);
                cell10.setCellValue(entry.getBalance());
  //System.err.println("11");
            }
            row++;
            HSSFRow rowHaade = spreadsheet.createRow(row);
            row++;
            HSSFRow rowHader = spreadsheet.createRow(row);

            rowHader.createCell(0).setCellValue("");
            rowHader.createCell(1).setCellValue("Total Debits :  " + model.getTotalDebitCount());
            rowHader.createCell(2).setCellValue("");
            rowHader.createCell(3).setCellValue("" + model.getCurrency() + " -" + formatta.formatAmount(Double.toString(model.getTotalDebitAmount())));
 //System.err.println("12");
          
            row++;
            HSSFRow rowHaders = spreadsheet.createRow(row);
            rowHaders.createCell(0).setCellValue("");
            rowHaders.createCell(1).setCellValue("Total Credits : " + model.getTotalCreditCount());
            rowHaders.createCell(2).setCellValue("");
            rowHaders.createCell(3).setCellValue("" + model.getCurrency() + " " + formatta.formatAmount(Double.toString(model.getTotalCreditAmount())));
 //System.err.println("13");
          
            row++;
            HSSFRow rowHaderss = spreadsheet.createRow(row);
            rowHaderss.createCell(0).setCellValue("");
            rowHaderss.createCell(1).setCellValue("Cleared balance as at: "+model.getClosingBalanceDate());
	    rowHaderss.createCell(2).setCellValue("");
            rowHaderss.createCell(3).setCellValue("" + model.getCurrency() + " " + formatta.formatAmount(Double.toString(model.getTotalClearedItem())));
 //System.err.println("14");
          
            row++;
            HSSFRow rowHadersss = spreadsheet.createRow(row);
            rowHadersss.createCell(0).setCellValue("");
            rowHadersss.createCell(1).setCellValue("Uncleared Items:");
  //System.err.println("15");
          
            row++;
            HSSFRow rowHaderssss = spreadsheet.createRow(row);
            rowHaderssss.createCell(0).setCellValue("");
            rowHaderssss.createCell(1).setCellValue("Total debit(s) : " + model.getUnClearedItems().getDebitCount());
            rowHaderssss.createCell(2).setCellValue("");
            rowHaderssss.createCell(3).setCellValue("Total Credit(s): " + model.getUnClearedItems().getCreditCount());
  // System.err.println("16"); 
          
            row++;
            HSSFRow rwHader = spreadsheet.createRow(row);
            rwHader.createCell(0).setCellValue("");
            rwHader.createCell(1).setCellValue("" + model.getCurrency() + " -" + formatta.formatAmount(Double.toString(model.getUnClearedItems().getDebitAmount())));
            rwHader.createCell(2).setCellValue("");
            rwHader.createCell(3).setCellValue("" + model.getCurrency() + " " + formatta.formatAmount(Double.toString(model.getUnClearedItems().getCreditAmount())));
  //   System.err.println("17");
           
            row++;
            HSSFRow rHader = spreadsheet.createRow(row);
            rHader.createCell(0).setCellValue(" Total Cleared is : " + model.getCurrency() + " " + formatta.formatAmount(Double.toString(model.getTotalClearedItem())));
            rHader.createCell(1).setCellValue("");
            rHader.createCell(2).setCellValue(" Total Uncleared is :  " + model.getCurrency() + " " + formatta.formatAmount(Double.toString(model.getTotalUnClearedItem())));
  //System.err.println("18");
          
            row++;
            HSSFRow rHade = spreadsheet.createRow(row);
            rHade.createCell(0).setCellValue("" );
            rHade.createCell(1).setCellValue("" );
            rHade.createCell(2).setCellValue("" + model.getTotalDebitCount() + " Debit(s) , " + model.getTotalCreditCount() + " Credit(s)");
  //System.err.println("19"); 
            
            row++;
            HSSFRow rHadr = spreadsheet.createRow(row);
            rHadr.createCell(0).setCellValue(" Totals ( Cleared + Uncleared Items ):  " + model.getCurrency() + " " + formatta.formatAmount(Double.toString(model.getClosingBalance())));
  //System.err.println("20");
          
            row++;
            HSSFRow rowHeadee = spreadsheet.createRow(row);
            String newHeada = "Total Cheques/ Payments and Debits, Total Deposits and Credits, Ending Balance ";
            String[] rowHeada = newHeada.split(",");
  //System.err.println("21");
           
            row++;
            HSSFRow rowHeaddd = spreadsheet.createRow(row);

            for (int i = 0; i < rowHeada.length; i++) {
                HSSFCell celllTittl = rowHeaddd.createCell(i);
                celllTittl.setCellValue(rowHeada[i]);
               // CellStyle style = workbook.createCellStyle();
              //  HSSFFont font = workbook.createFont();
                font.setBold(true);
                font.setFontName(HSSFFont.FONT_ARIAL);
                font.setFontHeightInPoints((short)10);
                font.setColor(HSSFColor.DARK_BLUE.index);
                style.setFont(font);
                celllTittl.setCellStyle(style);
            }
           
            row++;
            HSSFRow rowHeadddd = spreadsheet.createRow(row);

           rowHeadddd.createCell(0).setCellValue("" + model.getCurrency() + " -" + formatta.formatAmount(Double.toString(model.getTotalDebitAmount())));
           rowHeadddd.createCell(1).setCellValue("" + model.getCurrency() + " " + formatta.formatAmount(Double.toString(model.getTotalCreditAmount())));
           rowHeadddd.createCell(2).setCellValue("" + model.getCurrency() + " " + formatta.formatAmount(Double.toString(model.getClosingBalance())));
   //System.err.println("22");  
             row++;
             HSSFRow rowHeaddddx  = spreadsheet.createRow(row);
             row++;
             HSSFRow rowHeaddddxt = spreadsheet.createRow(row);
             row++;
             HSSFRow rowHeaddddxs = spreadsheet.createRow(row);
             
        }
        ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
        workbook.write(outByteStream);
        byte [] outArray = outByteStream.toByteArray();
        response.setContentType("application/ms-excel");
        response.setContentLength(outArray.length);
        response.setHeader("Expires:", "0"); // eliminates browser caching
        response.setHeader("Content-Disposition", "attachment; filename=" +filename );
        OutputStream outStream = response.getOutputStream();
        outStream.write(outArray);
        outStream.flush();
        workbook.close();   
    

/*statementGenerator.writeAccountStatementToExcel(models, filename, "Consolidated Activity Statement");


File f = new File(filename);
InputStream in = new FileInputStream(f);
ServletOutputStream outs = response.getOutputStream();

byte[] outputByte = new byte[4096];
//copy binary contect to output stream
while(in.read(outputByte, 0, 4096) != -1)
{
	outs.write(outputByte, 0, 4096);
}
outs.flush();
outs.close();
in.close();
out.clear();
out = pageContext.pushBody();

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
} */
}
catch(Exception ex){
  ex.printStackTrace();
}


%>
    <%-- <%

java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
SinglePiontSingOnValue sec = (SinglePiontSingOnValue) session.getAttribute("sec");
BaseAdapter connect = new BaseAdapter();
RequestValue req = new RequestValue();
RequestValue req2 = new RequestValue();
RequestValue req3 = new RequestValue();//added in PHOENIXME getUncollectedFunds //11082010
String password2 = "";

Connection con = null;


ResultSet rs;
ResultSet rs1;
Statement st = null;
PreparedStatement ps = null;

String ACCOUNTTYPE = request.getParameter("ACCOUNTTYPE");
String ITEM_TYPE = request.getParameter("ITEM_TYPE");

String DATE1 = request.getParameter("DATE1");
String DATE2 = request.getParameter("DATE2");        
String AMOUNT1 = request.getParameter("AMOUNT1");
String AMOUNT2 = request.getParameter("AMOUNT2");
String applType = "";
String acctNo = "";
String iso = "";
String acctType="";

String ptids="";
int TCount = 0;


boolean counter = false;

String name = "";
String[] s1 = request.getParameterValues("chk");
session.setAttribute("s1",s1);
con =  connect.getConnectionsds();
 try{
 for(int ia = 0; ia < s1.length; ia++)
 {    
  
  
    TCount = TCount + 1;
 
com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter acctOpening = new com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter();


String SQLAccountDetails = " select d.acct_no ,d.acct_type ,(select appl_type from phoenix..ad_gb_acct_type  where acct_type = d.acct_type) as appl_type ";
       SQLAccountDetails += " ,(select iso_code from phoenix..ad_gb_crncy  where crncy_id = d.crncy_id) as iso_code from    phoenix..dp_display d ";

       SQLAccountDetails += " where d.acct_no = '" + s1[ia].trim() + "'" ;

st = con.createStatement();
rs1 = st.executeQuery(SQLAccountDetails);
  
  while (rs1.next())
  {
      acctNo = rs1.getString("acct_no");
      applType = rs1.getString("appl_type"); 
      acctType = rs1.getString("acct_type");
      iso = rs1.getString("iso_code");
  }
  //rs1.close();

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

//CHUKS 27052008

int rim_no = 0;
java.util.Date Date1Obj = sd1.parse(DATE1);
java.util.Date Date2Obj = sd1.parse(DATE2);
java.util.Date formatedDate2Obj = sd1.parse(formatedDate2);
java.sql.Connection con1 = connect.getConnectionsds();
java.sql.Connection con2 = connect.getConnectionsds();

String sql = "select rim_no from phoenix..rm_services where cust_service_key = '"+accesscode+"' and services_id=41";
try
{
java.sql.Statement stmt = con1.createStatement();
java.sql.ResultSet rsx = stmt.executeQuery(sql);
if (rsx.next()){
	rim_no = rsx.getInt("rim_no"); 
}
rsx.close();
}catch(Exception e){
	e.printStackTrace();
}finally{
if (con1 != null) con1.close();

}

try
{
String sql4 = "select password from phoenix..rm_services_rel where rim_no = "+rim_no+" and services_id=41";
java.sql.Statement stmt = con2.createStatement();
java.sql.ResultSet rsB = stmt.executeQuery(sql4);
if (rsB.next()){
	password2 = rsB.getString("password"); 
}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if (con2 != null) con2.close();
}



java.sql.Connection con3 = connect.getConnectionsds();
String title_name = "";
try
{
String sql3 = "select title_1 from phoenix..dp_acct  where acct_no = '"+s1[ia].trim()+"'";
java.sql.Statement stmt = con3.createStatement();
java.sql.ResultSet rsC = stmt.executeQuery(sql3);
if (rsC.next()){
	title_name = rsC.getString("title_1"); 
}
}catch(Exception e){
    title_name = "";
	System.out.println(" Unable to get the Title_1 !!! ");
	e.printStackTrace();
}finally{
	if (con3 != null) con3.close();
}
//CHUKS 27052008

com.dwise.util.DatetimeFormat dt = new com.dwise.util.DatetimeFormat();

java.sql.Date tranDate = dt.getSQLFormatedDate(Date1Obj);
java.sql.Date valDate = dt.getSQLFormatedDate(Date2Obj);


/*req.setDateTime(Date1Obj);
req.setEffectiveDate(Date2Obj);
req.setUserName(loginId);
req.setPin(password);
req.setCardNo(accesscode);
req.setApplType1(applType);
req.setAcctType1(acctType);
req.setIsoCurrency(iso);
req.setDate1(Date1Obj);
req.setDate2(Date2Obj);
req.setAcctNo1(acctNo);



req.setReferenceNo("NET" + refNo );*/

req2.setDate1(Date1Obj);
req2.setUserName(loginId);
/*
if (password2.length() >= 10 )


{
password2 = password2.substring(0,10);
}
*/


req2.setPin(password2);
req2.setCardNo(accesscode);
req2.setOrigReferenceNo("ibank "+request.getRemoteAddr());
req2.setApplType1(applType);
req2.setAcctNo1(acctNo);
req2.setAcctType1(acctType);

AccountStatementsValue acctStmts  = acctOpening.getAccountOpeningBalance(req2);

req.setUserName(loginId);

/*
if (password2.length() >= 10 )
{
    password2 = password2.substring(0,10);
}
*/

req.setPin(password2);
req.setCardNo(accesscode);
req.setOrigReferenceNo("ibank "+request.getRemoteAddr());
req.setApplType1(applType);
req.setAcctType1(acctType);

//if ( !(CHEQUE1.trim().equalsIgnoreCase(""))){req.setCheckNo1(Integer.parseInt(CHEQUE1));}
//if ( !(CHEQUE2.trim().equalsIgnoreCase(""))){ req.setCheckNo2(Integer.parseInt(CHEQUE2));}

//if ( (CHEQUE2.trim().equalsIgnoreCase("")))
//{
req.setCheckNo2(999999);

//}
//else
//{
//req.setCheckNo2(Integer.parseInt(CHEQUE2));
//}
//if ( !(AMOUNT1.trim().equalsIgnoreCase(""))){req.setAmount1(Double.parseDouble(AMOUNT1));}
//if ( (AMOUNT2.trim().equalsIgnoreCase("")))
//{
req.setAmount2(999999999);
//}
//else
//{ 
//req.setAmount2(Double.parseDouble(AMOUNT2));
//}
//if ( !(ITEM_TYPE.trim().equalsIgnoreCase(""))){req.setTransactionType(Integer.parseInt(ITEM_TYPE));}
req.setIsoCurrency(iso);
req.setDate1(Date1Obj);
req.setDate2(Date2Obj);
req.setAcctNo1(acctNo);
//req.setAmount2(999999999);
//req.setCheckNo2(999999);

System.out.println("acctStmts.getBeginBalance--------"+acctStmts.getBeginBalance());
AccountStatementsItem[] acctStmtsItem = new AccountStatementsItem[0];
AccountUncollected[] acctUcf = new AccountUncollected[0];
//acctStmtsItem  = acctOpening.getAccountStatementsItem(req);
acctStmtsItem  = acctOpening.getAccountStmtItem(req);


  System.out.println("acctStmtsItem.length--------"+acctStmtsItem.length);
//Begin-added in PHOENIXME getUncollectedFunds-11082010
req3.setAcctNo1(acctNo);
req3.setPin(password2.trim());
req3.setCardNo(accesscode);
req3.setApplType1(applType);	
req3.setAcctType1(acctType);
req3.setAmount1(0);
req3.setUserName(loginId);
//req3.setOrigReferenceNo("ibank "+request.getRemoteAddr());
acctUcf = acctOpening.getAccountUncollected(req3);
//End-added in PHOENIXME getUncollectedFunds-11082010
//acctUcf = acctOpening.getAccountUncollected(req);//commented in PHOENIXME getUncollectedFunds-11082010

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
int testing = 0;
String reversal = "2";
String tran_code_desc = "Deposit Renewal";
String tran_code_int = "Interest Withheld - State";
int tran_code = 0;
String tran_code_check = "";
String dr_cr = "CR";
      if( acctStmtsItem.length == 0)
      {
    //  System.out.println("acctStmtsItem.length--------"+acctStmtsItem.length);

      testing = 45;
      }
      else
      { 
     // System.out.println("acctStmtsItem.length--------"+acctStmtsItem.length);	

        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet spreadsheet = workbook.createSheet(filename);
        int row = 0;
         CellStyle style = workbook.createCellStyle();
         HSSFFont font = workbook.createFont();
         font.setFontName(HSSFFont.FONT_ARIAL);
         font.setFontHeightInPoints((short)10);
         font.setColor(HSSFColor.DARK_RED.index);
         font.setBold(true);
         style.setFont(font);
         
        HSSFRow rowHeader = spreadsheet.createRow(row);
        rowHeader.createCell(0).setCellValue("CURRENCY CODE");
        rowHeader.createCell(1).setCellValue(acctStmtsItem[0].getIso_currency());
        
        row++;
        HSSFRow rowH = spreadsheet.createRow(row);
        
        row++;
        HSSFRow rowHe = spreadsheet.createRow(row);
        rowHe.createCell(0).setCellValue("CREATE DATE");
        rowHe.createCell(1).setCellValue("EFFECTIVE  DATE");
        rowHe.createCell(2).setCellValue("CHECK NO");
        rowHe.createCell(3).setCellValue("DESCRIPTION/PAYEE/MEMO");
        rowHe.createCell(4).setCellValue("CREDIT AMOUNT");
        rowHe.createCell(5).setCellValue("DEBIT AMOUNT");
        rowHe.createCell(6).setCellValue("BALANCE");
        
                          
  nEndingBal = nEndingBal + acctStmts.getBeginBalance();  
  for (int i = 0; i < acctStmtsItem.length; i++)
 {
if  (acctStmtsItem[i].getTranOrigin() == 0)
  {
    if (acctStmtsItem[i].getEffectiveDate().before(formatedDate2Obj))
  {
 String checkno = "";
 tran_code = acctStmtsItem[i].getTranCode();
 get_dr_cr = acctStmtsItem[i].getDrCr();
 tran_code_check = acctStmtsItem[i].getTranCodeDesc();
 String dr_cr_val = "";
 if (get_dr_cr != null)  {get_dr_cr = get_dr_cr ;}
  else {get_dr_cr = "";}
  if (tran_code_check != null)  {tran_code_check = tran_code_check ;}
  else {tran_code_check = "";}
   
   
 nAmount = acctStmtsItem[i].getTranAmount();
 acctStmtsItem[i].getReversal();
 if ( acctStmtsItem[i].getReversal().equals(reversal)) 
     nAmount = nAmount * -1;
  if ( !(tran_code_check.trim().equalsIgnoreCase(tran_code_desc)))
//	if ( tran_code != 960 )
    {
     if (get_dr_cr.trim().equalsIgnoreCase(dr_cr))
     {
     totalCredit = totalCredit + 1;
     nTotalCreditAmt = nTotalCreditAmt + nAmount;
     sumTotalCredit = sumTotalCredit + nTotalCreditAmt;
     nEndingBal = nEndingBal + nAmount;
     crAmount = acctStmtsItem[i].getTranAmount();
     }
     else
     {
      totalDebit = totalDebit + 1;
      nTotalDebitAmt = nTotalDebitAmt - nAmount ;
      sumTotalDebit = sumTotalDebit + nTotalDebitAmt ;
	   if ( tran_code_check.trim().equalsIgnoreCase(tran_code_int) )  	  
	  /// if (tran_code == 184)  /// for phoenix me
	     { 
		   nAmount = 0.00; 
		 }
      nEndingBal = nEndingBal - nAmount ;
      drAmount = acctStmtsItem[i].getTranAmount();
     }
    }
  nRunningBal = nEndingBal;
  totalClear = nRunningBal;
  
      row++;
        HSSFRow rowHea = spreadsheet.createRow(row);
        rowHea.createCell(0).setCellValue(new java.text.SimpleDateFormat("dd/MM/yyyy").format(acctStmtsItem[i].getCreateDate()));
        rowHea.createCell(1).setCellValue(new java.text.SimpleDateFormat("dd/MM/yyyy").format(acctStmtsItem[i].getEffectiveDate()));
       if (acctStmtsItem[i].getCheckNumber() == 0){ 
        rowHea.createCell(2).setCellValue("");
       } else{ 
          rowHea.createCell(2).setCellValue(acctStmtsItem[i].getCheckNumber());
             //if (acctStmtsItem[i].getReg_E_Desc() == null){ out.println(acctStmtsItem[i].getHistoryDesc());}  
       if (acctStmtsItem[i].getReg_E_Desc() == null){
            if (acctStmtsItem[i].getHistoryDesc() == null) {
                       rowHea.createCell(3).setCellValue(acctStmtsItem[i].getTranCodeDesc());
             } else{
                       rowHea.createCell(3).setCellValue(acctStmtsItem[i].getHistoryDesc());
                   }
       }else{
			  //if(acctStmtsItem[i].getReg_E_Desc().equalsIgnoreCase("TRADE FINANCE")){
              if(acctStmtsItem[i].getReg_E_Desc().equalsIgnoreCase("ETHIX-Trade")){
                       rowHea.createCell(3).setCellValue(acctStmtsItem[i].getHistoryDesc()); 
               }else{
                       rowHea.createCell(3).setCellValue(acctStmtsItem[i].getReg_E_Desc());
                    }
	      }				  	//out.println(acctStmtsItem[i].getReg_E_Des	  }					
                      
       if (acctStmtsItem[i].getDrCr().trim().equalsIgnoreCase(dr_cr)){
                rowHea.createCell(4).setCellValue(formatta.formatAmount(Double.toString(acctStmtsItem[i].getTranAmount())));
       }else {
                rowHea.createCell(4).setCellValue("");
       }
       
    if (!(acctStmtsItem[i].getDrCr().trim().equalsIgnoreCase(dr_cr))){
              rowHea.createCell(5).setCellValue(formatta.formatAmount(Double.toString(acctStmtsItem[i].getTranAmount() * -1)));
    }else {
              rowHea.createCell(5).setCellValue("");
           }
              rowHea.createCell(6).setCellValue(formatta.formatAmount(Double.toString(nRunningBal)));
                         
        }
          } 
             }
        row++;
        HSSFRow rowHeas = spreadsheet.createRow(row);
        row++;
        HSSFRow rowHeass = spreadsheet.createRow(row);
        rowHeass.createCell(0).setCellValue("TOTAL DEBIT :");
        rowHeass.createCell(1).setCellValue(totalDebit);
        rowHeass.createCell(2).setCellValue("");
        rowHeass.createCell(3).setCellValue("TOTAL CREDIT :");
        rowHeass.createCell(4).setCellValue(totalCredit);
        rowHeass.createCell(5).setCellValue("TOTAL :");
        rowHeass.createCell(6).setCellValue(formatta.formatAmount(Double.toString(nTotalCreditAmt)));
        rowHeass.createCell(7).setCellValue(formatta.formatAmount(Double.toString(nTotalDebitAmt * -1)));
        
        row++;
        HSSFRow rowHeasss = spreadsheet.createRow(row);
        rowHeasss.createCell(0).setCellValue("CLEAR BALANCE AS AT: "+new java.text.SimpleDateFormat("dd-MM-yyyy hh:mm:ss").format(Date2Obj));
        rowHeasss.createCell(1).setCellValue(formatta.formatAmount(Double.toString(nRunningBal)));
        
  if (acctUcf.length >= 0) { 
      row++;
        HSSFRow rowHeassA = spreadsheet.createRow(row);
        rowHeassA.createCell(0).setCellValue("");
        rowHeassA.createCell(1).setCellValue("UNCLEARED ITEMS ");
        rowHeassA.createCell(2).setCellValue("");
        rowHeassA.createCell(3).setCellValue("");
                     
  for (int ii = 0; ii < acctUcf.length; ii++){	
      totalDebit = 0;
      nTotalCreditAmt_Ucf = acctUcf[ii].getAmount();
      totalCredit_Ucf = totalCredit_Ucf + 1 ;
      nTotalCreditAmt_Ucf_Sum = nTotalCreditAmt_Ucf_Sum + nTotalCreditAmt_Ucf;
      nRunningBal_Ucf = nTotalCreditAmt_Ucf + nRunningBal;
      nRunningBal_Ucf_Sum = nRunningBal_Ucf_Sum + nRunningBal_Ucf;
      nRunningBal = nRunningBal_Ucf;
    //  System.out.println("date2 is here plz---------->"+acctUcf[i].getAvailabilityDate());
     // nRunningBal_Ucf = nRunningBal_Ucf + nRunningBal;
   //  System.out.println("date2 is here plz----------> "+formatedDate2Obj);
        availabledate1 = acctUcf[ii].getAvailabilityDate();
       if (availabledate1 != null)
       {
       availabledate = new java.text.SimpleDateFormat("dd/MM/yyyy").format(availabledate1);
       }
       else
       {
       availabledate = "";
       }
	   createdate1 = acctUcf[ii].getCreateDt();
       if (createdate1 != null)
       {
       createdate = new java.text.SimpleDateFormat("dd/MM/yyyy").format(createdate1);
       }
       else
       {
       createdate = "";
       }
       row++;
       HSSFRow rowers = spreadsheet.createRow(row);
       rowers.createCell(0).setCellValue(createdate);
       rowers.createCell(1).setCellValue(availabledate);
       rowers.createCell(2).setCellValue("");
       rowers.createCell(3).setCellValue(acctUcf[ii].getDescription());
       rowers.createCell(4).setCellValue(formatta.formatAmount(Double.toString(nTotalCreditAmt_Ucf)));
       rowers.createCell(5).setCellValue(formatta.formatAmount(Double.toString(nRunningBal_Ucf)));
   }
       row++;
       HSSFRow roweras = spreadsheet.createRow(row);
       row++;
       HSSFRow rowerss = spreadsheet.createRow(row); 
       rowerss.createCell(0).setCellValue("TOTAL DEBITS: ");
       rowerss.createCell(1).setCellValue(totalDebit);
       rowerss.createCell(2).setCellValue("TOTAL CREDITS: ");
       rowerss.createCell(3).setCellValue(totalCredit_Ucf);
       rowerss.createCell(4).setCellValue("TOTAL: ");
       rowerss.createCell(5).setCellValue(formatta.formatAmount(Double.toString(nTotalCreditAmt_Ucf_Sum)));
       rowerss.createCell(6).setCellValue("");
       rowerss.createCell(7).setCellValue(formatta.formatAmount(Double.toString(nRunningBal_Ucf_Sum)));
   }
        
       row++;
       HSSFRow rowerase = spreadsheet.createRow(row);
       rowerase.createCell(0).setCellValue("");
       rowerase.createCell(1).setCellValue("TOTAL CLEARED ITEMS: "+acctStmtsItem[0].getIso_currency()+" "+formatta.formatAmount(Double.toString(totalClear)));
       rowerase.createCell(2).setCellValue("TOTAL UNCLEARED ITEMS: "+acctStmtsItem[0].getIso_currency()+" "+formatta.formatAmount(Double.toString(nTotalCreditAmt_Ucf_Sum)));
       rowerase.createCell(3).setCellValue("");
       
       row++;
       HSSFRow rowerasee = spreadsheet.createRow(row);
       rowerasee.createCell(0).setCellValue((totalDebit + totalDebit_Ucf)+" Debit(s)");
       rowerasee.createCell(1).setCellValue((totalCredit + totalCredit_Ucf)+" Credit(s)");
       rowerasee.createCell(2).setCellValue("");
       rowerasee.createCell(3).setCellValue("TOTAL (Cleared + Uncleared Items ): "+acctStmtsItem[0].getIso_currency()+" "+formatta.formatAmount(Double.toString(nTotalCreditAmt_Ucf_Sum + totalClear)));
    } 
       if( acctStmtsItem.length > 0) {
           row++;
           HSSFRow owerasee = spreadsheet.createRow(row);
           row++;
           HSSFRow rowerasees = spreadsheet.createRow(row);
           rowerasees.createCell(0).setCellValue("");
           rowerasees.createCell(1).setCellValue("TOTAL DEPOSITS & CREDITS: "+formatta.formatAmount(Double.toString(nTotalCreditAmt_Ucf_Sum + nTotalCreditAmt)));
           rowerasees.createCell(2).setCellValue("TOTAL CHEQUES, PAYMENTS & DEBITS: "+formatta.formatAmount(Double.toString(nTotalDebitAmt * -1)));
           
           row++;
           HSSFRow Howerasee = spreadsheet.createRow(row);
           Howerasee.createCell(0).setCellValue("");
           Howerasee.createCell(1).setCellValue("");
           Howerasee.createCell(2).setCellValue("");
           Howerasee.createCell(3).setCellValue("ENDING BALANCE: "+acctStmtsItem[0].getIso_currency()+" "+formatta.formatAmount(Double.toString(nTotalCreditAmt_Ucf_Sum + totalClear)));
           Howerasee.createCell(4).setCellValue("");
           Howerasee.createCell(5).setCellValue("");
           
           row++;
           HSSFRow HoweraseeS = spreadsheet.createRow(row);
           row++;
           HSSFRow HoweraseeD = spreadsheet.createRow(row);
           row++;
           HSSFRow HoweraseeF = spreadsheet.createRow(row);
       }
        workbook.close();
       }
      }
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
in.close();
} catch (IOException ioe) {  
ioe.printStackTrace(System.out); 
}                        
          
         
                                                }catch(Exception ee)
						{
						System.out.println("processor.jsp:: Error while processing request "+ ee);
					//out.println(" Unable to create a new Beneficiary, Contact Ebusiness Team for more Information <br><br><br> ");
					//out.println("<input type='button' name='back' value='Back' onClick='javascript:history.go(-1)'>");
						}
						finally
						{
						  if (con != null) con.close();
						}
					//}   %>       --%>     
  
                  

    </body>
</html>