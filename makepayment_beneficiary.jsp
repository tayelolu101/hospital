<% response.setHeader("Cache-Control","no-store"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<!--%@ page language="java" import = "com.dwise.util.*, java.util.ArrayList,javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*,com.zenithbank.banking.coporate.ibank.payment.*,java.util.Calendar,com.zenithbank.banking.coporate.ibank.BanKBranch,com.zenithbank.banking.coporate.ibank.Bank,com.zenithbank.banking.coporate.ibank.payment.BeneficiaryValue" errorPage="error.jsp"  session="true" %-->
<%@ page language="java" import = "com.dwise.util.*, java.util.ArrayList,javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*,com.zenithbank.banking.coporate.ibank.payment.*,java.util.Calendar,com.zenithbank.banking.coporate.ibank.BanKBranch,com.zenithbank.banking.coporate.ibank.Bank,com.zenithbank.banking.coporate.ibank.payment.BeneficiaryValue" session="true" %>
<%
java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("EEE, MMMM d, yyyy");
SinglePiontSingOnValue sec = (SinglePiontSingOnValue) session.getAttribute("sec");
RequestValue req = new RequestValue();
com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter acctSummary = new com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter();
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
if (  login == null)
{
response.sendRedirect("/coporate-internetbanking/sessiontimeout.jsp");
}    
if ( login.getPasschange().equals("1"))
{
response.sendRedirect("ChangePwd.jsp");
}
String no_of_days = "";
String[] s = com.zenithbank.banking.coporate.ibank.PaymentHelper.PasswordTrackingDB.DefualtInstance().CheckPasswordExpiryDateDue(login.getLoginId(),Integer.parseInt(login.getRoleid()));
//if (s[0] == "1") //commented to fix non display of password expiry days - //14072010
if (s[0].equals("1"))//added to fix non display of password expiry days - //14072010
{
    out.println("<script>alert('Your password has expired, please change your password!')</script>");
    out.println("<script>window.location='ChangePwd.jsp'</script>");
}
//if (s[0] == "0")  { //commented to fix non display of password expiry days - //14072010
if (s[0].equals("0")){ //added to fix non display of password expiry days - //14072010
no_of_days = s[1]; }

String np = "";
String name = "";
String accesscode ="";
String loginId = "";
String password = "";
String password2 = "";
int rim_no = 0;
BaseAdapter connect = new BaseAdapter();

try{
accesscode=(String) session.getAttribute("accesscode");
loginId=(String) session.getAttribute("loginId");
password=(String) session.getAttribute("password");
name = sec.getRsm_Name();
}catch(ClassCastException ce){
	response.sendRedirect("sessiontimeout.jsp");
}catch(NullPointerException ne){
	response.sendRedirect("sessiontimeout");
}catch(Exception ne){
	response.sendRedirect("sessiontimeout.jsp");
}


java.sql.Connection con1 = connect.getConnection1();
java.sql.Connection con2 = connect.getConnection1();
String sql1 = "select rim_no from phoenix..rm_services where cust_service_key = '"+accesscode+"' and services_id=41";
try
{
java.sql.Statement stmt = con1.createStatement();
java.sql.ResultSet rs = stmt.executeQuery(sql1);
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
String sql2 = "select password from phoenix..rm_services_rel where rim_no = "+rim_no+" and services_id=41";
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




String applType = "";
String acctNo = "";
String refNo  = new com.dwise.util.HtmlUtilily().getUnique(loginId);
long time = Calendar.getInstance().getTime().getTime();
req.setDateTime(new Date(time));
req.setEffectiveDate(new Date(time));
req.setUserName(loginId);
req.setPin(password2);
req.setCardNo(accesscode);
req.setReferenceNo("NET" + refNo );

com.dwise.util.CryptoManager crypto = new com.dwise.util.CryptoManager();
AccountSummaryValue[] sumResult = new AccountSummaryValue[0];
sumResult = acctSummary.getDebitAccountSummaryCP(req,login.getHostCompany(),rim_no);
if (sumResult.length == 0){response.sendRedirect("error2.jsp");}
session.setAttribute("sumResult",sumResult);
/*
AccountSummaryValue[] banklist = new AccountSummaryValue[0];
banklist = acctSummary.getBranchName1();
session.setAttribute("banklist",banklist);

String acc = request.getParameter("accnum");
if (acc == null) {acc = sumResult[0].getAcctNo().trim() + "*" + sumResult[0].getApplicationType().trim() + "*" + sumResult[0].getAcctType().trim() + "*" + sumResult[0].getIso_currency()+ "*" + sumResult[0].getAcctDesc();}

int acc1 = 0;
if (request.getParameter("accnum1") == null) { 
  acc1 = banklist[0].getBranchNumber();
}
else{
  acc1 = Integer.parseInt(request.getParameter("accnum1"));
}

String AcctNum = acc.substring(0,10);
String ApplTp = acc.substring(11,13);
String AcctTp = acc.substring(14,16);
String ISO_cy = acc.substring(17,20);
String rsmName = acc.substring(21);
int branch_No = acc1;

RequestValue AcDtreq = new RequestValue();
AcDtreq.setServicesID(41);
AcDtreq.setEffectiveDate(new Date(time));
AcDtreq.setDateTime(new Date(time));
AcDtreq.setReferenceNo("NET" + refNo);          
AcDtreq.setOffline("N");
AcDtreq.setReversal("N");
AcDtreq.setPin(password);
AcDtreq.setCardNo(accesscode);
AcDtreq.setUserName(loginId);
session.setAttribute("AcDtreq",AcDtreq);

AccountDetailsValue detailValue = new AccountDetailsValue();
detailValue = acctSummary.getAccountDetail(AcDtreq);

//System.out.println(" << TokenValidate >> "+session.getAttribute("TokenValidate"));

String mode = request.getParameter("mode");
mode =( mode == null? "" :mode);
System.out.println(" << mode mode mode >> " + mode);

com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter BeneDetails = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter();
BeneficiaryValue[] BeneResult = new BeneficiaryValue[0];
BeneResult = BeneDetails.getPaymentType();

BeneficiaryValue[] BeneStatusList = new BeneficiaryValue[0];
BeneStatusList = BeneDetails.getPaymentStatus();

String selectType = (String)request.getParameter("AcctInfo1");
selectType =( selectType == null? "" :selectType);

String typechosen = (String)request.getParameter("bankcode");
typechosen = (typechosen == null? "" :typechosen);

String accB = request.getParameter("accnum");
if (accB == null) {accB = BeneResult[0].getpaymenttype() + "*"+ BeneResult[0].getpaymenttypeid();}

String acc1B = "";
if (request.getParameter("accnum1") == null) { 
  acc1B = BeneStatusList[0].getSTATUSID();
}
else{
  acc1B = request.getParameter("accnum1");
}

ArrayList bankBranch = null;
bankBranch = BeneDetails.GetAllZenithBankBranches();

String bankcode = (String)request.getParameter("ddBank");
bankcode =( bankcode == null? "" :bankcode);

ArrayList bankBranchInter = null;
if(request.getParameter("loadbranch") != null)
 {
    bankBranchInter =  BeneDetails.GetAllBankBranches(bankcode.trim());
 }
//bankBranchInter = BeneDetails.GetAllZenithBankBranches();

ArrayList Banknames = null;
Banknames = BeneDetails.GetAllBanks();
*/


com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter BeneDetails = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter();
com.zenithbank.banking.coporate.ibank.payment.BeneficiaryAdapter ba = new com.zenithbank.banking.coporate.ibank.payment.BeneficiaryAdapter();
//BeneficiaryAdapter BeneDetails = new BeneficiaryAdapter();
/*
String zenithsortCode = BeneDetails.getZenithBankSortCode();

ArrayList bankBranch = null;
bankBranch = BeneDetails.GetAllZenithBankBranches();

String bankcode = (String)request.getParameter("ddBank");
bankcode =( bankcode == null? "" :bankcode);

ArrayList Banknames = null;
Banknames = BeneDetails.GetAllBanks();

ArrayList bankBranchInter = null;
if(request.getParameter("loadbranch") != null)
 {
    bankBranchInter =  BeneDetails.GetAllBankBranches(bankcode.trim());
 }
*/

String AcctNo = "";
String AcctName = "";
String AcctCurr = "";
String PaymentType = "";
String BenefCode = "";
String AcctValue = "";
String HostCompany = login.getHostCompany();

// get the parameters
/*AcctNo = request.getParameter("accnum");
AcctCurr = request.getParameter("isocurr");
AcctName = request.getParameter("AcctName");
if (AcctNo == null)
{
  AcctNo = sumResult[0].getAcctNo().trim();
  AcctCurr = sumResult[0].getIso_currency().trim();
  AcctName = sumResult[0].getAcctDesc().trim();
  //AcctNo = "6090112424";
}*/

//
AcctValue = request.getParameter("selAcctList") ;
if (AcctValue == null)
{
//response.sendRedirect("error2.jsp");
  AcctValue = sumResult[0].getAcctNo().trim() + "*" + sumResult[0].getIso_currency().trim() + "*" + sumResult[0].getAcctDesc().trim();
}

//System.out.println("AcctNo "+AcctNo);
//System.out.println("AcctCurr "+AcctCurr);
//System.out.println("AcctName "+AcctName);
//System.out.println("ZWZmZWN0aXZlMA== "+crypto.decode("ZWZmZWN0aXZlMA=="));

PaymentType = request.getParameter("PayType");
if (PaymentType == null)
  PaymentType = "ZENITH/BENEFICIARY";
BenefCode = request.getParameter("benef");
if (BenefCode == null)
{
  BenefCode = "0";
}

//AcctCurr = request.getParameter("isocurr");
//if 

//System.out.println("Acctname >> "+AcctName);
//System.out.println("AcctCurr >> "+AcctCurr);

/* 29032010
PaymentValue pv = new PaymentValue();
if (!BenefCode.trim().equalsIgnoreCase("0"))
{
  BeneficiaryAdapter ba = new BeneficiaryAdapter();
  pv = ba.getBeneficiaryDetails(BenefCode);
  
}
*/

//17022010
/*
String acct_no = "";
String status = "";
String title_1 = "";
String acct_type = "";
String appl_type = "";
String to_acct_no = request.getParameter("to_acct_no");
if (to_acct_no == null) to_acct_no = "";

if (to_acct_no != null)
{
java.sql.Connection con3 = connect.getConnection();
try
{
String sql3 = "SELECT acct_no,status,title_1,acct_type,appl_type FROM phoenix..dp_acct where acct_no = '"+request.getParameter("to_acct_no")+"'";
//System.out.println(sql);
java.sql.Statement stmt = con3.createStatement();
java.sql.ResultSet rs = stmt.executeQuery(sql3);

if (rs.next()){
	acct_no = rs.getString("acct_no"); 
	status = rs.getString("status");
  title_1 = rs.getString("title_1");
  acct_type = rs.getString("acct_type");
  appl_type = rs.getString("appl_type");
}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if (con3 != null) con3.close();
}
}
*/
com.zenithbank.banking.coporate.ibank.BeneficiaryValue[] BeneResult = new com.zenithbank.banking.coporate.ibank.BeneficiaryValue[0];
com.zenithbank.banking.coporate.ibank.payment.BeneficiaryValue[] PaymentTypes = new com.zenithbank.banking.coporate.ibank.payment.BeneficiaryValue[0];
BeneResult = BeneDetails.getPaymentType();
PaymentTypes = ba.getPaymentType("CREDIT");

com.zenithbank.banking.coporate.ibank.BeneficiaryValue[] BeneStatusList = new com.zenithbank.banking.coporate.ibank.BeneficiaryValue[0];
BeneStatusList = BeneDetails.getPaymentStatus();

String mode = request.getParameter("mode");
mode =( mode == null? "" :mode);
//String BranchNameValue = "";

String txtBeneficiaryName = request.getParameter("txtBeneficiaryName");
txtBeneficiaryName =( txtBeneficiaryName == null? "" :txtBeneficiaryName);

String txtBeneficiaryaddress = request.getParameter("txtBeneficiaryaddress");
txtBeneficiaryaddress =( txtBeneficiaryaddress == null? "" :txtBeneficiaryaddress);

String txtcity = request.getParameter("txtcity");
txtcity =( txtcity == null? "" :txtcity);

String txtphone = request.getParameter("txtphone");
txtphone =( txtphone == null? "" :txtphone);

String txtgsmnumber = request.getParameter("txtgsmnumber");
txtgsmnumber =( txtgsmnumber == null? "" :txtgsmnumber);

String txtemailaddress = request.getParameter("txtemailaddress");
txtemailaddress =( txtemailaddress == null? "" :txtemailaddress);

String txtcontactperson = request.getParameter("txtcontactperson");
txtcontactperson =( txtcontactperson == null? "" :txtcontactperson);

String BranchCode = request.getParameter("BranchCode");
BranchCode =( BranchCode == null? "" :BranchCode);
//System.out.println(" << BranchCode >> " + request.getParameter("BranchCode"));

String AllStates = request.getParameter("AllStates");
AllStates =( AllStates == null? "" :AllStates);
//System.out.println(" << AllStates >> " + request.getParameter("AllStates"));

/*
String selectType = (String)request.getParameter("AcctInfo1");//30032010
*/
String selectType = (String)request.getParameter("selPaymentType");

selectType =( selectType == null? "" :selectType);

String typechosen = (String)request.getParameter("bankcode");
typechosen = (typechosen == null? "" :typechosen);

String accB = request.getParameter("accnum");
if (accB == null) {accB = BeneResult[0].getpaymenttype() + "*"+ BeneResult[0].getpaymenttypeid();}

String acc1B = "";
if (request.getParameter("accnum1") == null) { 
  acc1B = BeneStatusList[0].getSTATUSID();
}
else{
  acc1B = request.getParameter("accnum1");
}


ArrayList States = null;
States = BeneDetails.GetAllStates();

//


//


//bankBranchInter = BeneDetails.GetAllZenithBankBranches();


//19032010
String bankcode = (String)request.getParameter("ddBank");
bankcode =( bankcode == null? "" :bankcode);

ArrayList bankBranchInter = null;
if(request.getParameter("loadbranch") != null)
 {
    bankBranchInter =  BeneDetails.GetAllBankBranches(bankcode.trim());
 }
//bankBranchInter = BeneDetails.GetAllZenithBankBranches();

ArrayList Banknames = null;
//15/03/2010- Lanre addded to if stmt show only Banks that are active on Interswitch
if ((mode.equalsIgnoreCase("INTERBANK/BENEFICIARY")) || (mode.equalsIgnoreCase("INTERBANK/DIRECTDEBIT")))
{
Banknames = BeneDetails.GetAllBanks();
}

//15/03/2010- Lanre addded to show only Banks that are active on Interswitch
else if ((mode.equalsIgnoreCase("INTERSWITCH/BENEFICIARY")))
{
Banknames = BeneDetails.GetAllActiveInterswitchBanks();
}

String zenithsortCode = BeneDetails.getZenithBankSortCode();

String acct_no = "";
String status = "";
String title_1 = "";
String acct_type = "";
String appl_type = "";
String branch_no = "";
String name_1 = "";
String short_name = "";
String BranchNameValue = "";
String to_acct_no = request.getParameter("txtAccountNo");
//System.out.println( "<< to_acct_no >> " + to_acct_no);
if (to_acct_no == null) to_acct_no = "";
//if(request.getParameter("submit2") != null)
//{
    //if (to_acct_no != null)
    if (to_acct_no.length() > 0)
    {
    java.sql.Connection con = connect.getConnection();
    try
    {
    //String sql = "SELECT acct_no,status,title_1,acct_type,appl_type FROM phoenix..dp_acct where acct_no = '"+request.getParameter("txtAccountNo")+"'";
	String sql = "SELECT a.acct_no,a.status,a.title_1,a.acct_type,a.appl_type,a.branch_no,b.name_1, b.short_name FROM phoenix..dp_acct a , phoenix..ad_gb_branch b where a.acct_no = '"+request.getParameter("txtAccountNo")+"'";
             sql += " and a.branch_no = b.branch_no ";
    //System.out.println(sql);
    java.sql.Statement stmt = con.createStatement();
    java.sql.ResultSet rs = stmt.executeQuery(sql);
    
    if (rs.next()){
      acct_no = rs.getString("acct_no"); 
      status = rs.getString("status");
      title_1 = rs.getString("title_1");
      acct_type = rs.getString("acct_type");
      appl_type = rs.getString("appl_type");
	  branch_no = rs.getString("branch_no");
      name_1 = rs.getString("name_1");
      short_name = rs.getString("short_name");
    }
    }catch(Exception e){
      e.printStackTrace();
    }finally{
      if (con != null) con.close();
    }
	//System.out.println("name_1.length() " + name_1.length());
    if (name_1.length() <= 0){ BranchNameValue = "";}
    else{ BranchNameValue = name_1 + " - " + short_name;} 
    }
//System.out.println( "<< acct_no >> " + acct_no);
//System.out.println( "<< status >> " + status);
if ( ((mode.trim().equalsIgnoreCase("ZENITH/BENEFICIARY")) || (mode.trim().equalsIgnoreCase("INTRABANK/DIRECTDEBIT"))||(mode.trim().equalsIgnoreCase("ZENITH/FTCREDIT"))||(mode.trim().equalsIgnoreCase("ZENITH/FTDEBIT"))) && (status.trim().equalsIgnoreCase("Active"))){
    //System.out.println( "<< title_1 >> " + title_1);
    txtBeneficiaryName = title_1;
}




%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="resource-type" content="document">
<meta name="generator" content="Microsoft FrontPage 4.0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Page-Enter" content="progid:DXImageTransform.Microsoft.gradientWipe(duration=1)">
<meta name="revisit-after" content="30 days">
<META HTTP-EQUIV="Expires" CONTENT="0">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<meta name="classification" content="Banking">
<meta name="description" content="Welcome to Zenith International Bank. A commercial bank based in Nigeria. www.zenithbank.com,Zenith Bank Offers a wide range of financial services on an online real-time basis.Fourth largest bank in Nigeria.">
<meta name="MSSmartTagsPreventParsing" content="TRUE">
<meta name="keywords" content="Banks, Banks in Nigeria, Banks in Lagos,Nigeria Stock Market,Jim Ovia,Zenith,Banking,Zenith International Bank,Commercial Banks,Finance,Internet Banking, Telephone Banking, Mobile Banking, Zenview, Valucard, Western Union Money Transfer, Current Account, Savings Account, Individual Retirement Account, Corporate Banking, Investment Banking, Corporate Finance, Trade, Treasury,Loans,Nigerian Stock Exchange,domicilliary,currency,funds,forex,management,economy,financial services,corporate finance,business,balance sheet,profit,loss,accounting,ICAN">
<meta name="robots" content="ALL">
<meta name="distribution" content="Global">
<meta name="rating" content="Safe For Kids">
<meta name="copyright" content="(c) 2004-2005 Zenith Bank Plc">
<meta name="author" content="Juliet Obasi & Belinda Okereke">
<meta http-equiv="reply-to" content="ebusiness@zenithbank.com">
<meta name="language" content="English">
<meta name="doc-type" content="Web Page">
<meta name="doc-class" content="Completed">
<meta name="doc-rights" content="Public">
<title>Internet Banking: Make Payment to Beneficiary</title>
<link href="css/zs.css" rel="stylesheet" type="text/css" />
<script src="src1.js" type="text/javascript" language="javascript"></script>
<script src="js/zs.js" type="text/javascript" language="javascript"></script>
<script type="text/javascript" src="js/trim.js"></script>
<script type="text/javascript" src="js/IsBlank.js"></script>
<script type="text/javascript" src="js/IsValid.js"></script>
<script type="text/javascript" src="calendar/calendar.js"></script>
<script type="text/javascript" src="calendar/calendar-en.js"></script>
<script type="text/javascript" src="calendar/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="calendar/calendar-win2k-cold-1.css" title="win2k-cold-1" />
<script type="text/javascript" language="javascript">
function switchAccount(selectBox, thisform)
{
	//location.href="paymentcontroller.jsp?np=makepayment&accnum="+selectBox.value+"&PayType=<%=PaymentType%>&benef=<%=BenefCode%>";
  //thisform.accnum.value = selectBox.value;
  thisform.PayType.value = "<%=PaymentType%>";
  thisform.benef.value = <%=BenefCode%>;
  thisform.isocurr.value = "<%=AcctCurr%>";
  thisform.AcctName.value = "<%=AcctName%>";
  thisform.action.value = "makepayment_beneficiary.jsp";
  thisform.submit();
}
function switchPaymentType(selectBox, thisform)
{
	//location.href="paymentcontroller.jsp?np=makepayment&accnum=<%=AcctNo%>&PayType="+selectBox.value+"&benef=<%=BenefCode%>";
  //thisform.accnum.value = <%=AcctNo%>;
  thisform.PayType.value = selectBox.value;
  thisform.benef.value = <%=BenefCode%>;
  thisform.isocurr.value = "<%=AcctCurr%>";
  thisform.AcctName.value = "<%=AcctName%>";
  thisform.action.value = "makepayment_beneficiary.jsp";
  thisform.submit();

}
function switchBeneLookup(selectBox, thisform)
{
	//location.href="paymentcontroller.jsp?np=makepayment&accnum=<%=AcctNo%>&PayType=<%=PaymentType%>&benef="+selectBox.value;
  //thisform.accnum.value = <%=AcctNo%>;
  thisform.PayType.value = "<%=PaymentType%>";
  thisform.benef.value = selectBox.value;
  thisform.isocurr.value = "<%=AcctCurr%>";
  thisform.AcctName.value = "<%=AcctName%>";
  thisform.action.value = "makepayment_beneficiary.jsp";
  thisform.submit();
}

function validateFields(thisform)
{
  // Validate From Account
	if (IsBlank(thisform.selAcctList, "Please select a source account from the list"))
	{
		thisform.selAcctList.focus();
		return false;
	}
	
	/* 30032010
        // Validate Payment Type 
	if (IsBlank(thisform.selPaymentType, "Please select a payment type from the list"))
	{
		thisform.selPaymentType.focus();
		return false;
	}
        */
  
/*	
  // Validate Beneficiary Lookup
	if (IsBlank(thisform.selBeneficiaryLookup, "Please select a beneficiary"))
	{
		thisform.selBeneficiaryLookup.focus();
		return false;
	}
*/


	// Validate Amount
	if (IsBlank(thisform.AMOUNT0, "Please enter the amount to be paid"))
	{
		thisform.AMOUNT0.focus();
		return false;
	}
  
  	// Validate Currency
	/*if (IsBlank(thisform.selCurrency, "Please select a currency code from the list"))
	{
		thisform.selCurrency.focus();
		return false;
	}*/
  
	// Validate Payment Date
	if (IsBlank(thisform.txtPaymentDate, "Please select a Payment Date using the date picker"))
	{
		thisform.txtPaymentDate.focus();
		return false;
	}
	            var dText1 = thisform.selAcctList.value.substring(0,10); 
				var check_acct = dText1.substring(0,3);
        //var check_acct = "602";
        //alert(check_acct);
					if (check_acct != "602" && check_acct != "621"  && check_acct != "601" && check_acct != "611" && check_acct != "608" && check_acct != "609" && check_acct != "401" && check_acct != "409" && check_acct != "400" && check_acct != "407" && check_acct != "406" && check_acct != "405"  && check_acct != "408")
					{
					alert("Please you cannot transfer from this account");
					thisform.AMOUNT0.focus( );
					return false;
					}
					
					var dText2 = thisform.selPaymentType.value; 
          
          if ( check_acct != "409" && check_acct != "400" && check_acct != "407" && check_acct != "405" && check_acct != "406" && check_acct != "408" && dText2 == "FOREIGN/BENEFICIARY")
					{
					alert("Please you cannot pay a Foreign beneficiary from this account");
					thisform.AMOUNT0.focus( );
					return false;
					}
					
          if (  (check_acct == "400" || check_acct == "407" || check_acct == "405"  || check_acct == "406" || check_acct == "408") && (dText2 == "INTERBANK/BENEFICIARY" ||  dText2 == "DRAFT/ISSUANCE") )
					{
					alert("Please you cannot pay a local beneficiary from this account");
					thisform.AMOUNT0.focus( );
					return false;
					}
          
					if (  check_acct == "400" && check_acct == "407" && check_acct == "405"  && check_acct == "406" && check_acct == "408" && dText2 != "INTERBANK/BENEFICIARY" &&  dText2 != "DRAFT/ISSUANCE")
					{
					alert("Please you cannot pay a local beneficiary from this account");
					thisform.AMOUNT0.focus( );
					return false;
					}
					
	// Validate Payment Ref 
	if (IsBlank(thisform.txtPaymentRef, "Please enter the transaction reference"))
	{
		thisform.txtPaymentRef.focus();
		return false;
	}
  
	sure = confirm("Are you sure you want to make this payment to " + thisform.txtBeneficiaryName.value + " ?");
	if (sure)
  {
		thisform.action = "BeneficiaryPaymentProcessor.jsp";
    thisform.submit();
  }
	else 
  {
		return false;
  }


}

function BankChanged(form)
{
  //var valueselected = document.getElementById("AcctInfo1").value;
  var valueselected = document.getElementById("selPaymentType").value;
  alert(valueselected);
   if(valueselected == ""){           
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit();
     alert("select a Type");
     return false;     
   }else if (valueselected == "ZENITH/BENEFICIARY"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit(); 
   }else if (valueselected == "ZENITH/FTCREDIT"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit(); 
   }else if(valueselected == "ZENITH/FTDEBIT"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit(); 
   }else if (valueselected == "INTRABANK/DIRECTDEBIT"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit(); 
   }else if (valueselected == "INTERBANK/BENEFICIARY"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit();
   }else if (valueselected == "INTERBANK/DIRECTDEBIT"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit(); 
   }
  //lanre added for INTERSWITCH/BENEFICIARY - 22/01/2010
   else if (valueselected == "INTERSWITCH/BENEFICIARY"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit(); 
   }
   
   else if (valueselected == "FOREIGN/BENEFICIARY"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit();     
   }else if (valueselected == "DRAFT/ISSUANCE"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit();     
   }else if (valueselected == "CORPORATE/CHEQUE"){
     form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
     form.submit();     
   }
   
   return true;
}



function BankChangedA(form)
{

      try
      {
          obj = new ActiveXObject("Msxml2.XMLHTTP");
			}
			catch(e)
			{
          try
					{
						obj = new ActiveXObject("Microsoft.XMLHTTP");
      		}
					catch(e1)
					{
						obj = null;
					}
			}
      if(obj == null && typeof XMLHttpRequest != 'undefined')
      {
        obj = new XMLHttpRequest();
      }
			if(obj!=null)
      {
       
				obj.onreadystatechange = ProcessResponse; 
        var bankselected = document.getElementById("ddBank").value;
        if(bankselected == "select a bank")
        {
          alert("select a bank");
           var dddbranch = document.getElementById("ddBranch");
     
          for (var count =dddbranch.options.length-1; count >-1; count--)
          {
            dddbranch.options.options[count] = null;
          }
          return;
        }
		//var url = http://172.29.30.252:8994/coporate-internetbanking/transferBank.jsp?bankcode=" + document.getElementById("ddBank").value
    //var url = "http://172.29.30.241:9020/coporate-internetbanking/transferBank.jsp?bankcode=" + document.getElementById("ddBank").value
    var url = "http://172.29.30.38:8988/coporate-internetbanking/transferBank.jsp?bankcode=" + document.getElementById("ddBank").value
		//var url ="https://icorporate.zenithbank.com/coporate-internetbanking/transferBank.jsp?bankcode=" + document.getElementById("ddBank").value
        obj.open("GET",url ,false);
      	obj.send(null);         
			}
			return false;
  }



function ProcessResponse()
{
  if(obj.readyState == 4)
  {
    if(obj.status == 200)
    {
   
      var dsRoot=obj.responseXML.documentElement;  
      var dddbranch = document.getElementById("ddBranch");
     
      for (var count =dddbranch.options.length-1; count >-1; count--)
      {
        dddbranch.options.options[count] = null;
      }
      
      var branchs = dsRoot.getElementsByTagName('Branch');
      var Sortcodes = dsRoot.getElementsByTagName('SortCode');
      var Branchname = dsRoot.getElementsByTagName('BranchName');
      var text; 
      var banksortcode;
      var bname;
      var listItem;
      var ddbname = document.getElementById("ddBank");
      var bankname = ddbname.options[ddbname.selectedIndex].text;
      for (var count = 0; count < branchs.length; count++)
      {
        // text = (branchs[count].textContent || branchs[count].innerText || branchs[count].text);
        text = branchs[count].text;
        banksortcode = Sortcodes[count].text;
        bname = bankname + " " + Branchname[count].text;
        listItem = new Option(bname, banksortcode,  false, false);
        dddbranch.options[count] = listItem;
      }
      alert(bname);//31032010
    }
    else
    {
      alert("Error retrieving data!" );
    }
  }
}
function dosubmit(form)
{
    var accountno = form.txtAccountNo.value;
    //var valueselected = document.getElementById("AcctInfo1").value;
    var valueselected = document.getElementById("selPaymentType").value;
    form.action = "makepayment_beneficiary.jsp?mode=" + valueselected ;
    form.submit();
}


function IsValid (strString, validchars)
//  check for valid characters in a string
{
   var strValidChars = validchars;
   var strChar;
   var blnResult = true;
   if (strString.length == 0) return false;
   //  test strString consists of valid characters listed above
   for (i = 0; i < strString.length && blnResult == true; i++)
      {
      strChar = strString.charAt(i);
      if (strValidChars.indexOf(strChar) == -1)
         {
         blnResult = false;
         }
      }
   return blnResult;
 }
function doCheckGSM(form){
   var GSMNumber = document.getElementById("txtgsmnumber").value;
   if(GSMNumber.length > 0){
     if (!IsValid(GSMNumber, "0123456789"))
     {
        alert("Invalid character within GSM Number");
        document.getElementById("txtgsmnumber").value="";
        document.getElementById("txtgsmnumber").focus();
        return false;
     }
   }
   return true;
}
function isInteger(s)
{   var i;
    for (i = 0; i < s.length; i++)
    {   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}
function doCheckGSM1(form){
  var GSMNumber = document.getElementById("txtgsmnumber").value;
  var val = GSMNumber.substring(0,4)
  if(GSMNumber.length > 0){
    if ( isInteger(GSMNumber)==false )
    {
      alert("Invalid GSM Number")
      document.getElementById("txtgsmnumber").value=""
		  document.getElementById("txtgsmnumber").focus()
		  return false
    }
    if ((GSMNumber.length > 11)){
       alert("Invalid GSM Number1")
       document.getElementById("txtgsmnumber").value=""
       document.getElementById("txtgsmnumber").focus()
       return false
    }
    if (!( (val == "0802")||(val == "0803")||(val == "0804")||(val == "0805")||(val == "0806")||(val == "0807")||(val == "0808") ))
    {
        alert("Invalid GSM Number2")
        document.getElementById("txtgsmnumber").value=""
        document.getElementById("txtgsmnumber").focus()
        return false
     }
    if (!(GSMNumber.length == 11))    
    {
       alert("Invalid GSM Number3")
       document.getElementById("txtgsmnumber").value=""
       document.getElementById("txtgsmnumber").focus()
       return false
    }
  }
  return true
}
function doCheckEmail(form){  
  var emailadd1 = document.getElementById("txtemailaddress").value;  
  //alert(emailadd1.length);
  if(emailadd1.length > 0){
    if (echeck(emailadd1)==false){
      document.getElementById("txtemailaddress").value="";
      document.getElementById("txtemailaddress").focus();
      return false;
    }
  }
  return true;
}
function echeck(str) {
		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		   alert("Invalid E-mail Address")
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		   alert("Invalid E-mail Address")
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		    alert("Invalid E-mail Address")
		    return false
		}

   if (str.indexOf(at,(lat+1))!=-1){
      alert("Invalid E-mail Address")
      return false
   }

   if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
      alert("Invalid E-mail Address")
      return false
   }

   if (str.indexOf(dot,(lat+2))==-1){
      alert("Invalid E-mail Address")
      return false
   }
  
   if (str.indexOf(" ")!=-1){
      alert("Invalid E-mail Address")
      return false
   }
 	return true					
}


</script>
<style type="text/css">
<!--
#Layer1 {
	position:absolute;
	left:670px;
	top:47px;
	width:251px;
	height:21px;
	z-index:1;
	visibility: visible;
}
.style6 {color: #FF0000}
-->
</style>
</head>

<body id="div_body">
<!--form name="form" action="paymentcontroller.jsp?np=PaymentProcessor" method="post" onsubmit="return validateFields(this);"-->
<form name="form" action="makepayment_beneficiary.jsp" method="post" onsubmit="return validateFields(this);">
	<fieldset>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr><td width="80%" class="style3" style="background-image:url(images/grey_bg.jpg);">
      			<table width="100%" cellpadding="0" cellspacing="0">
      			  <tr><td bgcolor="#FFFFFF" style="padding-top:10px;padding-left:20px;padding-right:20px;">
	  			<h1 class="size16">Make a Payment  </h1>
          
				  <p>&nbsp;</p>
					<div class="hrline4"></div>
					<p>&nbsp;</p>
					<table width="692" >
                      
                
        <!--10022010 begin-->      
    
                      <!--tr>
                        <td width="29%"><label for="payeename" >From Account</label></td>
                        <td width="29%"><span-->
                      <!--input name="to_acct_no" type="text"class="textbox_black_text" size="50" value="<%=to_acct_no%>" /-->
                       <!--input value="<%=acct_no.trim()%>" name="txtAccountNo" id="txtAccountNo" maxlength="30" size="30"  />
                        </span></td>
                        <td width="22%"><div align="center">
   <input name="submit2" type="submit" class="input_button" value="Validate Account" size="auto" onclick="dosubmit(this.form)"/>
                        </div></td>
                        <td width="20%">&nbsp;</td>
                      </tr-->
                    </table>
					<table width="78%" cellpadding="5" cellspacing="5">
					<tr>
                        <td width="34%"><%if( (acct_no != null) && (acct_no != "")){out.print("<font face='Verdana' size='1' color='red'>Account Number : "+acct_no);
			  out.print("<input type=hidden name=acct_no value='"+acct_no+"'>");
			  }else if(!(status.trim().equals("Active"))){
			  out.println("<font face='Verdana' size='1' color='red'>Please Validate the To Account !!!</font>");
			  }else{}
			   %></td>
                        <td width="20%"><%
			 if(status != ""){out.print("<font face='Verdana' size='1' color='red'>Status : "+status);
			 out.print("<input name ='STATUS' type='hidden' value ='"+status+"'>");
       out.print("<input name ='ACCT_TYPE' type='hidden' value ='"+acct_type+"'>");
       out.print("<input name ='APPL_TYPE' type='hidden' value ='"+appl_type+"'>");
			  }
			  %></td>
                        <td width="46%" colspan="2"><%if((title_1 != null)&& (title_1 != "")){out.print("<font face='Verdana' size='1' color='red'>Account Name : "+title_1);
			  out.print("<input type=hidden name=title_1 value='"+title_1+"'>");
			  }

			  %></td>
                      </tr>
				
    
    
        <!--10022010 end-->      
                       <tr>
                        <td width="176" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                          <strong>Source Account</strong>&nbsp;                        </td>
                        <td colspan="2">
                          <!--select name="selAcctList" style="width:auto" onchange="switchAccount(this)" -->
                      <%
                      String isoVal;
                      String[][] arrFromAcct = new String[sumResult.length][2];
                      for (int i=0 ;i<sumResult.length; i++) 
                      { 
                        arrFromAcct[i][0] = sumResult[i].getAcctNo().trim() + "*" + sumResult[i].getIso_currency().trim() + "*" + sumResult[i].getAcctDesc().trim();
                        arrFromAcct[i][1] = sumResult[i].getAcctDesc() + " - " + sumResult[i].getAcctNo();
                      }
                      StringProcessor sp = new StringProcessor();
                      String SelectBox_AcctList = sp.buildSelectBox (arrFromAcct, sumResult.length, "selAcctList", AcctValue, "", "");
                      out.println(SelectBox_AcctList);
                     %>
                        </select> 
                          <input type="HIDDEN" name="hidAcctNo" value="" />                        </td>
                      </tr>
                      
                      
                      
                      
                      
                      <!-- begin payment type -->
                      
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Payment Type:*</strong></td>
                        <td align="left" valign="middle" class="cellwithleftandrightpadding">
                          <!--select name="AcctInfo1" style="width:200px" onchange="BankChanged(this.form)" -->
                          <select name="selPaymentType" style="width:200px" onchange="BankChanged(this.form)">
                          <option value="">Select a Type</option>
                      <%
                      //String isoVal; 17022010
                        for (int i = 0 ; i < PaymentTypes.length; i++) 
                        {                           
                          //String valStr = BeneResult[i].getpaymenttypeid();
                          String valStr = PaymentTypes[i].getpaymenttype(); 
                          %>
                             <option value="<%=PaymentTypes[i].getpaymenttype().trim()%>" <%=(valStr.trim().equalsIgnoreCase(mode)? "SELECTED" : "" )%>><%=PaymentTypes[i].getpaymenttype()%> </option>
                          <% 
                        }
                      %>
                        </select> 
                          
                        </td>
                     <tr>
                        <td colspan=4><hr></td>
                      </tr>
                      <tr>
                        <td colspan=4><b>Beneficiary Details</b></td>
                      </tr>
                     
                     
                      </tr>
                      <% if ((mode.equalsIgnoreCase("ZENITH/BENEFICIARY")) || (mode.equalsIgnoreCase("INTRABANK/DIRECTDEBIT"))|| (mode.equalsIgnoreCase("ZENITH/FTDEBIT"))||(mode.equalsIgnoreCase("ZENITH/FTCREDIT"))){%>                        
                        <tr>
                          <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Bank Name:</strong></td>
                          <td  align="left" valign="middle" class="cellwithleftandrightpadding">
                          <input value="ZENITH BANK PLC" name="txtBankZenith1" id="txtBankZenith1" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary Bank Name.'" onblur="self.status=''" type="text" />
                          <input value="<%=zenithsortCode.trim()%>" name="txtBankZenith" type="hidden">
                          </td>
                        </tr>                        
                        <tr>
                          <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Account Number:*</strong></td>
                          <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input value="<%=acct_no.trim()%>" name="txtAccountNo" id="txtAccountNo" maxlength="30" size="30" onblur="dosubmit(this.form)" type="text" /></td>
                          <td width="34%"><%if( (acct_no != null) && (acct_no != "")){out.print("<font face='Verdana' size='1' color='red'>Status :" + status);
                            //out.print("<input type=hidden name=acct_no value='"+acct_no+"'>");
                            }else if(!(status.trim().equals("Active"))){
                            out.println("<font face='Verdana' size='1' color='red'>Enter Valid Account No !!!</font>");
                            }else{}
                             %></td>                             
                        </tr>						
						<tr>
                          <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Branch&nbsp;Name:*</strong></td>
                          <!--td  align="left" valign="middle" class="cellwithleftandrightpadding"><input name="txtCleringCode" id="txtCleringCode" maxlength="30" size="30" onfocus="self.status='To search for transactions within specific amounts, enter the starting amount.'" onblur="self.status=''" type="text" /></td-->
                          <td  align="left" valign="middle" class="cellwithleftandrightpadding">
                          <input value="<%=BranchNameValue%>" name="BranchCode" type="text" maxlength="30" size="30">                                                     
                        </td>
                        </tr>
                      
                      <%}else if ((mode.equalsIgnoreCase("INTERBANK/BENEFICIARY")) || (mode.equalsIgnoreCase("INTERBANK/DIRECTDEBIT"))|| (mode.equalsIgnoreCase("INTERSWITCH/BENEFICIARY"))){%> <!--lanre added INTERSWITCH/BENEFICIARY 22/01/2010 -->
                        <tr>
                          <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Bank Name:*</strong></td>
                          <td  align="left" valign="middle" class="cellwithleftandrightpadding">
                             <select name="ddBank" style="width:200px" onchange="BankChangedA(this.form)" >
                                  <option value="Select a bank">Select a Bank</option>
                                  <%
                                  //String isoVal1;
                                    for (int i = 0 ; i < Banknames.size(); i++) 
                                    {                      
                                      Bank currentBank = (Bank)Banknames.get(i);                                  
                                      %>
                                         <option value="<%=currentBank.getBankCode()%>" <%=(bankcode.trim().equals(currentBank.getBankCode().trim())? "SELECTED" : "" )%>><%=currentBank.getBankName()%> </option>
                                         
                                      <% 
                                    }
                                  %>
                            </select>                           
                          </td>
                        </tr>  
                      
                        <tr>
                          <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Branch Name:*</strong></td>
                          <!--td  align="left" valign="middle" class="cellwithleftandrightpadding"><input name="txtCleringCode" id="txtCleringCode" maxlength="30" size="30" onfocus="self.status='To search for transactions within specific amounts, enter the starting amount.'" onblur="self.status=''" type="text" /></td-->
                          <td><select name="ddBranch" >
                        <%
                         if(bankcode == null || bankcode == "")
                         {
                        %>
                          <option value="-1" selected="Select Branch">Select Branch</option>
                        <%
                        }
                        else
                        {
                        %>
                          <%if(bankBranchInter != null)
                          {
                          %>
                            <% for(int i = 0; i < bankBranchInter.size(); i++)
                            {
                              BanKBranch bBranch =(BanKBranch)bankBranchInter.get(i);
                            %>
                            <option value="<%=bBranch.getBranchSortCode()%>"><%= bBranch.getBranchName()%></option>
                          <% } %>
                          <%
                          }
                          %>
                        <%
                        }
                        
                      %>
                        </select></td>
                      </tr>
                      
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Account Number:*</strong></td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input name="txtAccountNo" id="txtAccountNo" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary Account Number.'" onblur="self.status=''" type="text" /></td>
                      </tr>
                       <% }else if (mode.equalsIgnoreCase("FOREIGN/BENEFICIARY")){%> 
                          <tr>
                            <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Bank Name:*</strong></td>
                            <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input  name="txtForeignBank" id="txtForeignBank" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary Name.'" onblur="self.status=''" type="text" /></td>
                          </tr>
						  
						   <tr>
    <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Bank Branch Name:*</strong></td>
    <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input  name="txtForeignBankBranch" id="txtForeignBankBranch" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary Name.'" onblur="self.status=''" type="text" /></td>
  </tr>
  
                          <tr>
                            <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Bank Sort Code:*</strong></td>
                            <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input name="txtInternational" id="txtInternational" maxlength="30" size="60" onfocus="self.status='enter the International Bank Sort Code.'" onblur="self.status=''" type="text" /></td>
                          </tr>
						  <tr>
                            <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Swift Code:*</strong></td>
                            <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input name="txtSwiftCode" id="txtSwiftCode" maxlength="30" size="30" onfocus="self.status='enter the International Swift Code .'" onblur="self.status=''" type="text" /></td>
                          </tr>
                          <tr>
                            <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Account Number:*</strong></td>
                            <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input name="txtAccountNo" id="txtAccountNo" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary Account No.'" onblur="self.status=''" type="text" /></td>
                          </tr>
                       <%}
                       else if (mode.equalsIgnoreCase("DRAFT/ISSUANCE")){%>
  <tr>
    <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Bank Name:</td>
    <td  align="left" valign="middle" class="cellwithleftandrightpadding">
    <input readonly="readonly" value="ZENITH BANK AJOSE ADEOGUN" name="txtBankZenith1" id="txtBankZenith1" maxlength="30" size="30" onblur="self.status=''" type="text" />

  </td>
</tr>
<tr>
  <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Account Number:*</td>
  <td  align="left" valign="middle" class="cellwithleftandrightpadding">
  <input readonly="readonly" value="BANKCHEQUE" name="txtAccountNo" id="txtAccountNo" maxlength="30" size="30" type="text" /></td>                                                       
</tr>
<tr>
  <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Branch&nbsp;Name:*</td>
  <td><select name="BranchCode" >
                        <%=new com.dwise.util.HtmlUtilily().getResource1(request.getParameter("BranchCode"),"select branch_name,branch_name from ZENBASENET..zib_nibssgiro_branches where bank_code = '057'")%>
                        </select></td>
 
</tr>

          <%}
                       else if (mode.equalsIgnoreCase("CORPORATE/CHEQUE")){%>
  <tr>
    <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Bank Name:</td>
    <td  align="left" valign="middle" class="cellwithleftandrightpadding">
    <input readonly="readonly" value="ZENITH BANK AJOSE ADEOGUN" name="txtBankZenith1" id="txtBankZenith1" maxlength="30" size="30" onblur="self.status=''" type="text" />

  </td>
</tr>
<tr>
  <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Account Number:*</td>
  <td  align="left" valign="middle" class="cellwithleftandrightpadding">
  <input readonly="readonly" value="BANKCHEQUE" name="txtAccountNo" id="txtAccountNo" maxlength="30" size="30" type="text" /></td>                                                       
</tr>
<tr>
  <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Branch&nbsp;Name:*</td>
  
  <td><select name="BranchCode" >
                        <%=new com.dwise.util.HtmlUtilily().getResource1(request.getParameter("BranchCode"),"select branch_name,branch_name from ZENBASENET..zib_nibssgiro_branches where bank_code = '057'")%>
                        </select></td>
						
</tr>
<%}%>             
                      <!--tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding"><strong>Account Number:</strong></td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input name="txtAccountNo" id="txtAccountNo" maxlength="30" size="30" onfocus="self.status='To search for transactions within specific amounts, enter the starting amount.'" onblur="self.status=''" type="text" /></td>
                      </tr-->
            <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Beneficiary&nbsp;name: *</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input value="<%=txtBeneficiaryName%>" name="txtBeneficiaryName" id="txtBeneficiaryName" maxlength="30" size="30" onfocus="self.status=' enter the Beneficiary Name.'" onblur="self.status=''" type="text"  /></td>
                      </tr>         
                    
                    
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Beneficiary Code:*</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input name="txtBeneRef" id="txtBeneRef" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary Code.'" onblur="self.status=''" type="text" /></td>
                      </tr>
                      
                      
                       <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Beneficiary Address:</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input value="<%=txtBeneficiaryaddress%>" name="txtBeneficiaryaddress" id="txtBeneficiaryaddress" maxlength="100" size="30" onfocus="self.status=' enter the Beneficiary Address.'" onblur="self.status=''" type="text"  /></td>
                      </tr>
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                City:</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input value="<%=txtcity%>" name="txtcity" id="txtcity" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary City.'" onblur="self.status=''" type="text"  /></td>
                      </tr>
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                State:</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding">
                          <select name="AllStates" style="width:200px" >
                              <option value="">Select a Type</option>
                              <%
                              //String isoVal1;
                                for (int i = 0 ; i < States.size(); i++) 
                                {                      
                                  Bank sState = (Bank)States.get(i);                                                                                  
                                  %>                                     
                                     <option value="<%=sState.getState()%>"<%=(AllStates.trim().equals(sState.getState().trim())? "SELECTED" : "" )%>><%=sState.getState()%></option>
                                  <% }     %>
                          </select>                           
                        </td>
                      </tr>
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Phone:</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input value="<%=txtphone%>" name="txtphone" id="txtphone" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary Phone.'" onblur="self.status=''" type="text"  /></td>
                      </tr>
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                GSM Number:</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input value="<%=txtgsmnumber%>" name="txtgsmnumber" id="txtgsmnumber" maxlength="30" size="30" onfocus="self.status='enter the Beneficiary GSM Number.'" onblur="return doCheckGSM(this);" type="text"  />&nbsp;eg. (23408033666666)</td>
                      </tr>
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Email Address:</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding"><input value="<%=txtemailaddress%>" name="txtemailaddress" id="txtemailaddress" maxlength="60" size="30" onfocus="self.status='enter the Beneficiary Email Address.'" onblur="return doCheckEmail(this);" type="text"  /></td>
                      </tr>
                      
                      
                      <tr>
                        <td width="150" height="30" align="left" valign="middle" class="cellwithleftandrightpadding">
                                Active&nbsp;Record:</td>
                        <td  align="left" valign="middle" class="cellwithleftandrightpadding">
         <select name="bankName1" style="width:200px" >                                                    
              <%
              String bankshortName; int branchno1;
                for (int i = 0 ; i < BeneStatusList.length; i++) 
                {                    
                  //String valStr = banklist[i].getbranchName() + "*" + banklist[i].getState();
                  String valStr1 = BeneStatusList[i].getSTATUSID();
                  %>
                    <option value="<%=BeneStatusList[i].getSTATUS()%>" ><%=BeneStatusList[i].getSTATUS()%></option>
                  <%                   
                }
              %>
            </select>                          
                      </td>
                      </tr>
                      <!--end payment type 16022010 -->
                      
                      
                      <!-- delete 20100224% 
                          sp = new StringProcessor();
                          String BenefAcctDetails = sp.getBeneficiaryAccountDetails(PaymentType, BenefCode);
                      if (!BenefCode.trim().equalsIgnoreCase("0"))
                      {
                      %-->                        
                     
                      <tr>
                        <td colspan=4><hr></td>
                      </tr>
                      <tr>
                        <td colspan=4><strong><span class="Headercolor">Payment Details</span></strong></td>
                      </tr>
                      <tr>
                        <td nowrap>Payment Amount</td>
                        <td colspan="2">
                          <!--input type="text" size="25" name="txtAmount" title="Enter the value of the payment" autocomplete=off value=""-->
                          <input name="AMOUNT0" type="text" id="AMOUNT0" size="25" onblur="return Amountformat(this)">                        </td>
                      </tr>
                      <!--tr>
                        <td nowrap>Currency</td>
                        <td>
                        <%
                              String[][] arrCurr = new String[4][2];
                              arrCurr[0][0] = "NGN";
                              arrCurr[0][1] = "NGN";
                              arrCurr[1][0] = "USD";
                              arrCurr[1][1] = "USD";
                              arrCurr[2][0] = "GBP";
                              arrCurr[2][1] = "GBP";
                              arrCurr[3][0] = "EUR";
                              arrCurr[3][1] = "EUR";
                              String SelectBox_Currency = sp.buildSelectBox (arrCurr, 4, "selCurrency", BenefCode, "", "");
                              out.println(SelectBox_Currency);
                        %>
                        </td>
                      </tr-->
                      <tr>
                      <td nowrap>Payment Date</td>
                      <td colspan="2"><input type='text' size='21' name='txtPaymentDate' id='txtPaymentDate' title="Enter the date" autocomplete=off readonly value="">
                      <input name="Button1" id="BUTTON1" type="image" value="" src="images/bttn_calendar.gif" width="16" height="15" onmouseover="openDiv(this,'help','message');" onmouseout="closeDiv(this,'help','message');"/></td>
                      </tr>
                      <tr>
                      <td nowrap>Payment Reference</td>
                      <td width="176"><input type="text" size="25" maxlength="34" name="txtPaymentRef" autocomplete="off" value=""> </td>
                      <td width="324"><span class="style6">N.B. This is your Unique Reference for this Transaction</span> </td>
                      </tr>
                      <tr><td>&nbsp;</td></tr>
                      <tr><td></td>
                        <td colspan="2">
                          <input name="btnSubmit" type="button" value="Submit" class="input_button" onclick="validateFields(this.form);" />                        </td>
                      </tr>
                    </table>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
										
					<p>&nbsp;</p>
	  </td><tr><td></td></tr></table>
</td></tr></table></td>
  </tr>
 
</table>
</fieldset>
</form>
</body>
</html>
<script type="text/javascript">
    Calendar.setup({
        inputField     :    "txtPaymentDate",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "BUTTON1",  // trigger for the calendar (button ID)
        align          :    "Tl",           // alignment (defaults to "Bl")
        singleClick    :    true
    });

</script>
