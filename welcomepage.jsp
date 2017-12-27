<%@ page language="java" import = "javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.* ,java.util.Calendar"   session="true" %>
<%

response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("EEE, MMMM d, yyyy");
SinglePiontSingOnValue sec = (SinglePiontSingOnValue) session.getAttribute("sec");
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
login.getSignin_date();
RequestValue req = new RequestValue();
com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter acctSummary = new com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter();
com.zenithbank.banking.coporate.ibank.action.CompanyManager company = new com.zenithbank.banking.coporate.ibank.action.CompanyManager();
String rolegroup = company.findBankByCode(login.getHostCompany()).getrolegroup();
com.zenithbank.banking.coporate.ibank.form.Branch branch = company.findCompanyBranchByCode(login.getHostBranch(),login.getHostCompany());
String companyName =  company.findBankByCode(login.getHostCompany()).getName();
String accesscode ="";
String loginId = "";
String password = "";
String name = "";

System.out.println("---------------------> "+rolegroup.trim());

try{
accesscode=(String) session.getAttribute("accesscode");
loginId=(String) session.getAttribute("loginId");
password=(String) session.getAttribute("password");
name = sec.getRsm_Name();
if ( password == null || loginId == null || password ==null)
{
response.sendRedirect("sessiontimeout.jsp");
} 
}catch(ClassCastException ce){
	response.sendRedirect("sessiontimeout.jsp");
}catch(NullPointerException ne){
	response.sendRedirect("sessiontimeout.jsp");
}catch(Exception ne){
	response.sendRedirect("sessiontimeout.jsp");
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
<title>Welcome to Zenith Bank Internet Banking</title>
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
-->
</style><style type="text/css">
.menutitle{
cursor:pointer;
margin-bottom: 5px;
background-color:#ECECFF;
color:#000000;
width:140px;
padding:2px;
text-align:center;
font-weight:bold;
/*/*/border:1px solid #000000;/* */
}

.submenu{
margin-bottom: 0.5em;
}
body {
	background-color: #FFFFFF;
}
.style6 {font-size: 12px; font-family: Arial;}
.style9 {font-size: 12px}
</style>

<script type="text/javascript">

/***********************************************
* Switch Menu script- by Martial B of http://getElementById.com/
* Modified by Dynamic Drive for format & NS4/IE4 compatibility
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/

var persistmenu="yes" //"yes" or "no". Make sure each SPAN content contains an incrementing ID starting at 1 (id="sub1", id="sub2", etc)
var persisttype="sitewide" //enter "sitewide" for menu to persist across site, "local" for this page only

if (document.getElementById){ //DynamicDrive.com change
document.write('<style type="text/css">\n')
document.write('.submenu{display: none;}\n')
document.write('</style>\n')
}

function SwitchMenu(obj){
	if(document.getElementById){
	var el = document.getElementById(obj);
	var ar = document.getElementById("masterdiv").getElementsByTagName("span"); //DynamicDrive.com change
		if(el.style.display != "block"){ //DynamicDrive.com change
			for (var i=0; i<ar.length; i++){
				if (ar[i].className=="submenu") //DynamicDrive.com change
				ar[i].style.display = "none";
			}
			el.style.display = "block";
		}else{
			el.style.display = "none";
		}
	}
}

function get_cookie(Name) { 
var search = Name + "="
var returnvalue = "";
if (document.cookie.length > 0) {
offset = document.cookie.indexOf(search)
if (offset != -1) { 
offset += search.length
end = document.cookie.indexOf(";", offset);
if (end == -1) end = document.cookie.length;
returnvalue=unescape(document.cookie.substring(offset, end))
}
}
return returnvalue;
}

function onloadfunction(){
if (persistmenu=="yes"){
var cookiename=(persisttype=="sitewide")? "switchmenu" : window.location.pathname
var cookievalue=get_cookie(cookiename)
if (cookievalue!="")
document.getElementById(cookievalue).style.display="block"
}
}

function savemenustate(){
var inc=1, blockid=""
while (document.getElementById("sub"+inc)){
if (document.getElementById("sub"+inc).style.display=="block"){
blockid="sub"+inc
break
}
inc++
}
var cookiename=(persisttype=="sitewide")? "switchmenu" : window.location.pathname
var cookievalue=(persisttype=="sitewide")? blockid+";path=/" : blockid
document.cookie=cookiename+"="+cookievalue
}

if (window.addEventListener)
window.addEventListener("load", onloadfunction, false)
else if (window.attachEvent)
window.attachEvent("onload", onloadfunction)
else if (document.getElementById)
window.onload=onloadfunction

if (persistmenu=="yes" && document.getElementById)
window.onunload=savemenustate

</script>
</head>

<body id="div_body">
<form name="form" action="Frameset/GIBMenuInetUser.jsp" method="post" target="_self"  onsubmit="javascript:return Validate()">
	<fieldset>
<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr>
    <td colspan="3" id="header_group">
		<table width="100%">
			<tr>
				<td align="right" class="hpad">
					<table><tr>
					  <td id="layer1" align="center"><span class="spacer_span"><a href="http://www.zenithbank.com/warning.cfm"  target="_blank" tabindex="" onmouseover="setTextColor(this,'#ffffff');"><span class="white_text_10px" >Scam Alert!</span></a>&nbsp;&nbsp;<img src="images/menu_separator.gif" alt="separator image" width="1" height="8" />&nbsp;&nbsp;</span><a href="signOut.jsp" tabindex=""  onmouseover="setTextColor(this,'#ffffff');"><span class="white_text_10px" >Log out </span></a>&nbsp;<img src="images/menu_separator.gif" alt="separator image" width="1" height="8" />&nbsp;&nbsp;</span><a href="http://www.zenithbank.com/contactus.cfm" target="_blank" tabindex=""  onmouseover="setTextColor(this,'#ffffff');"><span class="white_text_10px" >Contact Us</span></a>
					</td>
					</tr></table>
			  </td>
			</tr>
			<tr>
				<td class="hpad">
					<table width="100%">
						<tr>
							<td id="layer2">
								<table cellpadding="0" cellspacing="0">
										<tr>
											<td><a tabindex="" href="http://www.zenithbank.com"><img src="images/logo_animatex.gif" border="0" alt="Zenith Bank" width="50" height="39"/></a></td>
											<td><a tabindex="" href="http://www.zenithbank.com"><img src="images/logo_trim.gif"  border="0" alt="Zenith Bank" width="194" height="24"/></a></td>
										</tr>
							  </table>
							</td>
							<td align="right" id="layer11"><img src="images/ibanklogo.jpg" alt="IBank Logo" /></td>
						</tr>
				  </table>
				</td>
			</tr>
	  </table>
	</td>
</tr>
  <tr>
    <td colspan="3"><table width="100%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
      <tr>
        <td width="20%" rowspan="8" valign="top" bgcolor="#f9f9f9"><br> <br> <br><table width="100%" cellpadding="0" cellspacing="0" bgcolor="#Ffffff">
          <tr>
            <td bgcolor="#FFFFFF"><div class="sidebutton"  onmouseover="setBackgroundColor(this,'#999999');" onmouseout="setBackgroundColor(this,'#666666');" href="internetbanking.cfm">
                <table cellpadding="0" cellspacing="0">
                  <tr>
                    <td><img src="images/greywhite.gif" alt="2" width="14" height="11" /></td>
                    <td valign="middle">&nbsp;<a href="index.jsp"><span class="white_text" style="padding-top:4px;">Back to  Login</span></a></td>
                  </tr>
                </table>
            </div></td>
          </tr>


          <tr>
            <td><div class="sidebutton" style="border-bottom-color:#333333" onmouseover="setBackgroundColor(this,'#999999');" onmouseout="setBackgroundColor(this,'#666666');" href="signout.jsp">
              <table cellpadding="0" cellspacing="0">
                  <tr>
                    <td><img src="images/greywhite.gif" alt="2" width="14" height="11" /></td>
                    <td valign="middle"><a href="signOut.jsp"><span class="white_text" style="padding-top:4px;">&nbsp;Log Out </span></a></td>
                  </tr>
              </table>
            </div></td>
          </tr>
        </table></td>
    <%   
	System.out.println("---------------------> "+rolegroup.trim());
	 if(rolegroup.trim().equalsIgnoreCase("Y"))
         {
    %>
        <td colspan="2" bgcolor="#FFFFFF" class="style3">
		<p><span class="ash_text"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="style6">COMPANY&nbsp;&nbsp;&nbsp; <%=companyName%></span></strong></span> </p>
		<p><span class="ash_text"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="style6">DEPARTMENT &nbsp;&nbsp;&nbsp;<%=branch%></span></strong></span></p>
		
            <p>&nbsp;&nbsp;&nbsp;&nbsp;<span class="ash_text"><strong>&nbsp;<span class="style6">&nbsp;WELCOME <%=login.getLoginId().toUpperCase()%> TO ZENITH COPORATE INTERNET BANKING</span></strong></span></p>          
        </td>
        <% } 
        else 
        { %>
                <td colspan="2" bgcolor="#FFFFFF" class="style3"><p>&nbsp;</p>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;<span class="ash_text"><strong>&nbsp;<span class="style6">&nbsp;WELCOME <%=login.getLoginId().toUpperCase()%> TO ZENITH COPORATE INTERNET BANKING</span></strong></span></p>          
        </td>
        <%}%>
      </tr>
      <tr>
        <td colspan="2" bgcolor="#FFFFFF" class="style3">&nbsp;</td>
      </tr>
      <tr>
        <td width="5%" bgcolor="#FFFFFF" class="style3"> <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp; </p></td>
        <td width="75%" bgcolor="#FFFFFF" class="arial_12_dark_ash">Date of last Log in:  <%=sd.format(login.getSignout_date())%></td>
      </tr>
      <tr>
        <td width="5%" bgcolor="#FFFFFF" class="style3">&nbsp;</td>
        <td bgcolor="#FFFFFF" class="style3"><span class="arial_12_dark_ash">If these details are incorrect please log out and contact us on 234-1-2784000 or e-mail us at <a href="mailto:ebusiness@zenithbank.com" class="arial_12_dark_ash blue_text"> ebusiness@zenithbank.com</a></span> </td>
      </tr>
      <tr>
        <td width="5%" bgcolor="#FFFFFF" class="style3">&nbsp;</td>
        <td bgcolor="#FFFFFF" class="style3">&nbsp;</td>
      </tr>
      <tr>
        <td bgcolor="#FFFFFF" class="style3">&nbsp;</td>
        <td bgcolor="#FFFFFF" class="style3">&nbsp;<input name="kount" type="hidden" value=""  /></td>
      </tr>
	 
      <tr>
        <td colspan="2" bgcolor="#FFFFFF" class="style3"><table width="100%" align="left">
          <tr>
            <td align="left"><div align="right" style="padding-right:20px;">
              <input type="submit" name="Submit322" value="Confirm" class="input_button" />
              <br />
            </div></td>
            </tr>
          <tr>
            <td height="14" align="right"><div class="hrline4"></div></td>
          </tr>
		  <tr>
            <td align="left" > <jsp:include page = "nsa.jsp" flush="true" /></div></td>
          </tr>
        </table></td>
        </tr>
		      
      <tr>
        <td colspan="2" bgcolor="#FFFFFF" class="style3"><p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
         <p>&nbsp;</p>
          </td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td colspan="3"><div id="footer_group"><a href="privacy.cfm" onmouseover="setTextColor(this,'#ffffff');"><span class="white_text_10px">Privacy Policy</span></a>&nbsp;<img src="images/menu_separator.gif" alt="separator image" width="1" height="8"/>&nbsp;&nbsp;<a href="termsuse.cfm" onmouseover="setTextColor(this,'#ffffff');"><span class="white_text_10px">Terms&nbsp;of&nbsp;use</span></a>&nbsp;&nbsp;<span class="white_text_10px">(c)Copyright 2006-2007&nbsp;&nbsp;Zenith Bank Plc.&nbsp;</span><img src="images/menu_separator.gif" alt="separator image" width="1" height="8"/>&nbsp;<a href="mailto:webmaster@zenithbank.com" onmouseover="setTextColor(this,'#ffffff');"><span class="white_text_10px">webmaster@zenithbank.com</span></a></div></td>
  </tr>
</table>
</fieldset>
</form>

</body>
</html>
<script>
var minDigitsInIPhoneNumber = 11

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

function Validate()
{
  var emailID=document.form.emailaddress
  var gsmNo=document.form.gsmnumber
  var ignoreValidate =document.form.kount   
  var PNum = new String(gsmNo.value)
  var val = PNum.substring(0,4)

	if (ignoreValidate.value == 0)
	{
    if ( isInteger(PNum)==false )
    {
      alert("Invalid GSM Number")
      gsmNo.value=""
		  gsmNo.focus()
		  return false
    }
    /* modified by chukwuneta 04/10/2006 to validate when entry into gsm no */
	/* 
	if ((gsmNo.value==null)||(gsmNo.value=="")){
		  alert("Please Enter your GSM Number")
      gsmNo.value=""
		  gsmNo.focus()
		  return false
		}
	*/
if ((gsmNo.value.length > 0)){
    if ((gsmNo.value.length > 11)){
		   alert("Invalid GSM Number")
       gsmNo.value=""
		   gsmNo.focus()
		   return false
		}
    if (!( (val == "0802")||(val == "0803")||(val == "0804")||(val == "0805")||(val == "0806")||(val == "0807")||(val == "0808") ))
    {
        alert("Invalid GSM Number")
        gsmNo.value=""
        gsmNo.focus()
        return false
     }
    if (!(gsmNo.value.length == 11))    
    {
		   alert("Invalid GSM Number")
       gsmNo.value=""
		   gsmNo.focus()
		   return false
		}     
}
    
	  if ((emailID.value==null)||(emailID.value=="")){
		  alert("Please Enter your Email Address")
		  emailID.focus()
		  return false
		}
	  
	  if (echeck(emailID.value)==false){
		  emailID.value=""
		  emailID.focus()
		  return false
		}  
	   return true
	}
	return true;  
}
</script>

