<%@ page language="java" import = "javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.* ,java.util.Calendar" session="true" %>
<%

java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("EEE, MMMM d, yyyy");
SinglePiontSingOnValue sec = (SinglePiontSingOnValue) session.getAttribute("sec");
RequestValue req = new RequestValue();
com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter acctSummary = new com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter();

String np = "";
String name = "";
String accesscode ="";
String loginId = "";
String password = "";
try{
accesscode=(String) session.getAttribute("accesscode");
loginId=(String) session.getAttribute("loginId");
password=(String) session.getAttribute("password");
name = sec.getRsm_Name();
}catch(ClassCastException ce){
	response.sendRedirect("sessiontimeout.jsp");
}catch(NullPointerException ne){
	response.sendRedirect("sessiontimeout.jsp");
}catch(Exception ne){
	response.sendRedirect("sessiontimeout.jsp");
}

if ( password == null || loginId == null || accesscode == null)
{
response.sendRedirect("sessiontimeout.jsp");
} 


//CIB- Begin
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
String no_of_days = "";
String[] s = com.zenithbank.banking.coporate.ibank.PaymentHelper.PasswordTrackingDB.DefualtInstance().CheckPasswordExpiryDateDue(login.getLoginId(),Integer.parseInt(login.getRoleid()));
//if (s[0] == "1") //Gbolahan commented to fix non display of password expiry days - //14072010
if (s[0].equals("1"))//Gbolahan added to fix non display of password expiry days - //14072010
{
    out.println("<script>alert('Your password has expired, please change your password!')</script>");
    out.println("<script>window.location='ChangePwd.jsp'</script>");
}

//if (s[0] == "0")  { //Gbolahan commented to fix non display of password expiry days - //14072010
if (s[0].equals("0")){ //Gbolahan added to fix non display of password expiry days - //14072010
 
no_of_days = s[1]; }


if (  login == null)
{
response.sendRedirect("/coporate-internetbanking/sessiontimeout.jsp");
} 
BaseAdapter connect = new BaseAdapter();
java.sql.Connection con1 = connect.getConnection1();//pcidss
PreparedStatement pst = null;//pcidss
java.sql.ResultSet rs = null ;//pcidss
int rim_no = 0;
String password2 = "";
try
{
/* pcidss
String sql2 = "select password from phoenix..rm_services_rel where rim_no = "+rim_no+" and services_id=41";
java.sql.Statement stmt = con2.createStatement();
java.sql.ResultSet rs = stmt.executeQuery(sql2);
*/
//pcidss-Begin
String sql = "select password,rim_no from phoenix..rm_services_rel where rim_no = (select rim_no from phoenix..rm_services where cust_service_key = ? and services_id= ?) and services_id= ?";
	
	pst = con1.prepareStatement(sql);
	pst.setString(1,accesscode);
	pst.setInt(2,41);
	//pst.setString(3,loginId.trim());
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
      //if (con2 != null) con2.close();//pcidss
}
System.out.println(" password2 " + password2);
System.out.println(" rim_no " + rim_no);
String refNo  = new com.dwise.util.HtmlUtilily().getUnique(loginId);
long time = Calendar.getInstance().getTime().getTime();
//req.setDateTime(new Date(time));//commented for PhoenixME
//req.setEffectiveDate(new Date(time));//commented for PhoenixME
req.setUserName(loginId);
/*
if (password2.length() >= 10 )
 {
 password2 = password2.substring(0,10);
 }
 */
req.setPin(password2);
req.setCardNo(accesscode);
//req.setReferenceNo("NET" + refNo );//commented for PhoenixME
req.setOrigReferenceNo("ibank "+request.getRemoteAddr());//PhoenixME
req.setAcctNo1(String.valueOf(rim_no));//PhoenixME

AccountSummaryValue[] sumResult = new AccountSummaryValue[0];
sumResult = acctSummary.getAccountSummaryCP(req,Integer.parseInt(login.getRoleid()),rim_no);
//1702014
session.setAttribute("sumResult",sumResult);//17022014


if (sumResult.length == 0){response.sendRedirect("error2.jsp");}
//CIB-End



/*String applType = "";
String acctNo = "";
String refNo  = new com.dwise.util.HtmlUtilily().getUnique(loginId);
long time = Calendar.getInstance().getTime().getTime();
req.setDateTime(new Date(time));
req.setEffectiveDate(new Date(time));
req.setUserName(loginId);
req.setPin(password);
req.setCardNo(accesscode);
req.setReferenceNo("NET" + refNo );
AccountSummaryValue[] sumResult = new AccountSummaryValue[0];
sumResult = acctSummary.getAccountSummary(req);
session.setAttribute("sumResult",sumResult);
*/
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
<title>Internet Banking:Bills Payment</title>
<link href="css/zs.css" rel="stylesheet" type="text/css" />
<script src="js/zs.js" type="text/javascript" language="javascript"></script>
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
.style6 {
	color: #003399;
	font-weight: bold;
	font-size: 12px;
}
.style12 {color: #023DB5}
.style13 {font-size: 12px}
-->
</style>
</head>

<body id="div_body">
<form name="signin" action="login-handler.cfm" method="post" target="_self">
  <fieldset>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"> <table width="100%" cellpadding="0" cellspacing="0">
          <tr>
            <td width="80%" class="style3" style="background-image:url(images/grey_bg.jpg);"> 
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td bgcolor="#FFFFFF" style="padding-top:10px;padding-left:20px;padding-right:20px;"> 
                    <p> 
                    <TABLE cellpadding="0" cellspacing="0">
                      <TR>
<TD width="384"><h1><span class="blue_text style12">Bills Payment </span>for <strong><%=sec.getRim_Name()%></strong></h1></TD>
                      </TR>
                    </TABLE></p>
                    <p>&nbsp;</p>
                    <h1 ><span class="ash_text">Options</span></h1>
                    <p>&nbsp;</p>
                    <p>Use this feature to pay bills e.g.( Multichoice )</p>
                    <p>&nbsp;</p>
                    <table width="100%">
                      <tr> 
                        <td width="18"><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td width="866"><a href="payment-singlepayment.jsp"><span >Make 
                          a payment</span></a></td>
                      </tr>
                      <tr> 
                        <td width="18">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="18"><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="setuppayee.jsp"><span >View, 
                          delete or add a payee</span></a></td>
                      </tr>
                      <tr>
                        <td width="18">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="18"><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="viewamendoraddascheduledpayemnt.jsp"><span >View, 
                          reschedule or cancel a scheduled payment</span></a></td>
                      </tr>
                      <tr> 
                        <td width="18">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="18"><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="viewlistofrecentpayment.jsp"><span >View 
                          a list of successful payments</span></a></td>
                      </tr>
                      <tr> 
                        <td width="18">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="18"><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="viewfailedpayments.jsp"><span >View 
                          a list of failed payments</span></a></td>
                      </tr>
                      
                      
                      
                      <tr> 
                        <td width="18">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="18"><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="newstandingorder.jsp"><span >Create a new Standing Order</span></a></td>
                      </tr>
                      <tr> 
                        <td width="18">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="18"><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="existingstandingorder.jsp"><span >View 
                          or cancel an existing Standing Order</span></a></td>
                      </tr>
                      
                      
                      
                    </table>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p></td>
                <tr>
                  <td></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
  </table>
  </fieldset>
</form>
</body>
</html>
