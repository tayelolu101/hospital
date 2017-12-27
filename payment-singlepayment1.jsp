<%@ page language="java" import="org.owasp.esapi.*,java.text.DecimalFormat,java.lang.String,java.util.List,java.util.ArrayList,com.zenithbank.visafone.*,com.zenithbank.banking.ibank.account.adapter.*, java.util.*, javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.* ,java.util.Calendar"  session="true" %>
<%

java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("dd/MM/yyyy");
DecimalFormat formatter = new DecimalFormat("#,###,###,###,##0.00");
SinglePiontSingOnValue sec = (SinglePiontSingOnValue) session.getAttribute("sec");

Connection con = null;
Connection con1 = null;
PreparedStatement ps = null;
ArrayList alist = null;
BaseAdapter connect = new BaseAdapter();

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

String refNo  = new com.dwise.util.HtmlUtilily().getUnique(loginId);
long time = Calendar.getInstance().getTime().getTime();

try
{ 
  String sp = request.getParameter("selected_payee");
  int payee = Integer.parseInt(sp);  
  //System.out.println(" selected merchant id is = " + payee);
  alist = PaymentHostAdapter.GetPaymentInstance().GetPayeeMerchantInformation(payee);
}
catch(SQLException sqlexp){
   System.out.println(sqlexp);
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
<title>Internet Banking: Account Summary</title>
<link href="css/zs.css" rel="stylesheet" type="text/css" />
<script src="js/zs.js" type="text/javascript" language="javascript"></script>
<script language="javascript" type="text/javascript" src="src1.js"></script>
<script type="text/javascript" src="calendar/calendar.js"></script>
<script type="text/javascript" src="calendar/calendar-en.js"></script>
<script type="text/javascript" src="calendar/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="calendar/calendar-win2k-cold-1.css" title="win2k-cold-1" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
.style6 {	color: #555555;
	font-weight: bold;
}
.style7 {color: #555555}
-->

.disabled {
   pointer-events: none;
   cursor: default;
}
</style>
<script type="text/javascript" src="js/IsBlank.js"></script>
<script type="text/javascript" src="js/IsValid.js"></script>
<script src="src1.js" type="text/javascript" language="javascript"></script>
<script type="text/javascript" src="js/trim.js"></script>

<link href="css/jquery.autocomplete.css" rel="stylesheet" type="text/css"/> 
<link href="css/smoothness/jquery-ui-1.8.21.custom.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.21.custom.min.js"></script>
<script src="js/jquery.ui.core.js" type="text/javascript"></script>
<script src="js/jquery.ui.widget.js" type="text/javascript"></script>
<script src="js/jquery.ui.position.js" type="text/javascript"></script>
<script src="js/jquery.ui.autocomplete.js" type="text/javascript"></script>
<script src="js/jquery.ui.dialog.js" type="text/javascript"></script>

<script type="text/javascript" src="js/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="js/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="js/jquery.effects.core.js"></script>
<script type="text/javascript" src="js/jquery.effects.blind.js"></script>
<script type="text/javascript" src="js/jquery.effects.fold.js"></script>


</head>

<body id="div_body">
<form name="form" action="tokens.jsp" method="post" target="_self" onSubmit="return validateForm(this);">
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
                    <!--h1 class="size16">Single Payments</h1-->
                    <h1><span class="blue_text style12">Bills Payment</span> for 
                      <strong><%=sec.getRim_Name()%></strong></h1>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
<%
    try
    {
     if(alist.size() > 0)
      {
          BillsMerchant bM = (BillsMerchant)alist.get(1);
          BillsPayee bP = (BillsPayee)alist.get(0);
          String sM[] = bM.getMReqFields();
          String sP[] = bP.getPReqFields();
          String reqFields = "";
          int rNum = bM.getNoOfReqFields();
%>
                    <table id="paymentTable" width="358"  border="1" align="center" cellpadding="3" cellspacing="0" bordercolor="#CCCCCC" bordercolorlight="#000000" bordercolordark="#FFFFFF">
                      <thead>
                      <td colspan="2" class="style4" ><div align="center" ><span class="white_text" style="font-weight:bold;padding-left:5px;font-size:12px;">Payment 
                          Details </span> </div></td></thead>
                      <tr> 
                        <td width="40%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Payee
                            :&nbsp; </div></td>
                        <td height="25" class="boldtext"><span class="style5"><%=ESAPI.encoder().encodeForHTML(bP.getPayeeName())%>&nbsp; 
                          <input type="hidden" name="hidPayee" value="<%=ESAPI.encoder().encodeForHTMLAttribute(bP.getPayeeName())%>">
                          </span></td>
                      </tr>
                      <tr> 
                        <td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">From 
                            Account :&nbsp; </div></td>
                        <td height="25" class="boldtext"><span class="style29"><%=ESAPI.encoder().encodeForHTML(bP.getFromAccountNo())%>&nbsp; 
                          <input type="hidden" name="hidFromAccount" value="<%=ESAPI.encoder().encodeForHTMLAttribute(bP.getFromAccountNo())%>">
                          </span></td>
                      </tr>
                     
                        <% 
                        if(bM.getMerchantId() == 17){
                     
                 
                        	
                        %>
                         <tr id="schedulerIdTr"> 
	                        <td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Schedule Id : &nbsp;</div>
	                        
	                        </td>
	                        <td height="25" class="boldtext"><span class="style29">
	                         <input type="text" name="schedulerId" value="">
	                         <a href="#" id="verifySchedulerId">    <i class="fa fa-home fa-2x"></i> </a>
	                     
	                          </span>
                            </td>
                        </tr>
                        
                        
                      
                       <% 
                        
                          
                        }
                          %>
                  
                      <%

    String amt = "";
    boolean isValid = false;
    for (int i = 0; i < sP.length; i++){
    	
    	System.out.println("sp " + sP.length);
    	System.out.println("SM " +sM[i] );
    }
    for (int i = 0; i < sP.length; i++)
    { if(!sM[i].trim().equalsIgnoreCase("Service Fee")){
%>
	  <tr> 
		<td height="25" bgcolor="#CCCCCC"><div align="right"><%=sM[i]%> 
			: </div></td>
		<td height="25"><%=sP[i]%> </td>
	  </tr>
<%

	 
       if(bM.getMerchantId() != 1 && bM.getMerchantId() != 10){
          isValid = true;
       }

	
       reqFields = reqFields + sP[i] + "/";	          
       if(sM[i].equalsIgnoreCase("Smartcard No.")){
        
        ZenithCoreWebService dstv = new ZenithCoreWebService();	        
        CustomerResult customer = null;
        customer = dstv.validateSmartCard(sP[i]);
        
        if(customer.getDstvCustomerResp().getResponseCode().equalsIgnoreCase("00")){
              isValid = true;
        
        
%>         
 <tr id="custID">
      <input type="hidden" name="customerID" id="customerID" value="<%=customer.getDstvCustomerResp().getCustomerInfo().getCustomerNumber()%>">	
      <td height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right"> 			
      <span>Your Customer ID : </span></div></td>
      <td height="25"><%=customer.getDstvCustomerResp().getCustomerInfo().getCustomerNumber()%> </td>
 </tr>
   
<tr> 
 <td height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right">   
  <span>Bouquet : </span></div></td>
   <td width="15%">                                
   <select name="ddbouquet" id="ddbouquet" >
    <option value="">Please select a bouquet...</option> 							
<%    
    int v = 0;    	
    String bouquet = "";
    String price = "";
    String code = "";
    int pid = 0;
    
    if(bM.getMerchantId() == 1){
       pid = 16;
    }

    if(bM.getMerchantId() == 10){
       pid = 518;
    }

    DstvProductsResult dstvList = null;
    // ZenithCoreWebService dstv = new ZenithCoreWebService();    
    dstvList = dstv.getBouquetList();
    
    if(dstvList.getResponseCode().equalsIgnoreCase("00")){		
		
		if (dstvList.getDstvProducts() != null && !dstvList.getDstvProducts().isEmpty()){
			
			  for (DstvProduct p : dstvList.getDstvProducts() ){
			       bouquet = p.getDescription().trim();
			       price =  String.valueOf(p.getPrice());
			       code  =  p.getProductCode().trim();
                           
                          if((pid==518 && bouquet.trim().startsWith("G"))){
			  %>
				 <option value="<%=ESAPI.encoder().encodeForHTMLAttribute(bouquet)%>-<%=ESAPI.encoder().encodeForHTMLAttribute(price)%>-<%=ESAPI.encoder().encodeForHTMLAttribute(code)%>"><%=bouquet%> - <%=formatter.format(Double.parseDouble(ESAPI.encoder().encodeForHTML(price)))%></option>
			  <% }else if(pid==16 && !bouquet.trim().startsWith("G")){ %>
				 <option value="<%=ESAPI.encoder().encodeForHTMLAttribute(bouquet)%>-<%=ESAPI.encoder().encodeForHTMLAttribute(price)%>-<%=ESAPI.encoder().encodeForHTMLAttribute(code)%>"><%=bouquet%> - <%=formatter.format(Double.parseDouble(ESAPI.encoder().encodeForHTML(price)))%></option>
			  <%    
                               }
			  }
		} 
    }
%>
     </select>	 
   </td>
 </tr>   
    <tr id="numOfMonth">
		<input type="hidden" name="prodCode" id="prodCode" value="">	
		<td height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right"> 			
			<span>No of Month(s) : </span></div></td>
		   <td>
		   <select name="month" id="month" onchange="noOfMonths()"/> 
		     <option value="1" selected>1</option>
           <% 		   
		   for(int j = 2 ; j <= 12 ; ++j){%>	
				<option value="<%=j%>"><%=j%></option> 
           <%}%>
		   </select></td>
   </tr>
<%}else{%>    
<tr> 
    <td height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right">                             
            <span>Error : </span></div></td>
    <td height="25"><span class="style5"><strong class="red_text">Invalid Smart Card Number. Please delete this payee and add a new one with the correct Smart Card Number. </strong></span> 
    <input type="hidden" name="isCardSmart" id="isCardSmart" value="No" ></td>
</tr>
<%   }	
  } 
	  
	if(sM[i].equalsIgnoreCase("Customer No")){	
%>	
	        
<tr> 
 <td height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right">   
  <span>Bouquet : </span></div></td>
   <td width="15%">                                
   <select name="ddbouquet" id="ddbouquet" >   							
<%    
       
        String bouquet = "";
        String price = "";
        String code = "";
        
        int pid = 0;	
        
        if(bM.getMerchantId() == 14){
             pid = 16;
        }
        
        DstvProductsResult dstvList = null;
        ZenithCoreWebService dstv = new ZenithCoreWebService();	
    
        dstvList = dstv.getBouquetList();
        


	if (dstvList.getResponseCode().equalsIgnoreCase("00")) {
        
        if (dstvList.getDstvProducts() != null && !dstvList.getDstvProducts().isEmpty()){
                try
                {
                   for(DstvProduct p : dstvList.getDstvProducts()){
			bouquet = p.getDescription().trim();
			price =  String.valueOf(p.getPrice());
			code  = p.getProductCode().trim();
                 %>
                        <option value="<%=ESAPI.encoder().encodeForHTMLAttribute(bouquet)%>-<%=ESAPI.encoder().encodeForHTMLAttribute(price)%>-<%=ESAPI.encoder().encodeForHTMLAttribute(code)%>"><%=bouquet%> - <%=formatter.format(Double.parseDouble(ESAPI.encoder().encodeForHTML(price)))%></option>
                 <%              
                   }			  
                 
                }catch(Exception e){
                        e.printStackTrace();
                }
        }        
    }
   
%>
     </select>	 
   </td>
<%	
	}
	  }else{ amt  = sP[i].replaceAll(",","");}
    }
%>
		<input type="hidden" id="hidReqFields" name="hidReqFields" value="<%=ESAPI.encoder().encodeForHTMLAttribute(reqFields)%>">
		  <tr> 
			<td height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right">                             
				<span>Amount : </span></div></td>
			<td height="25"><input name="AMOUNT0" type="text" id="AMOUNT0" value="<%=amt%>" size="15" onblur="Amountformat(this)" <% if(!isValid) {out.println("disabled");} %>> 
			  <span class="style28"> </span> </td>
		  </tr>
		</table>
		<p>&nbsp;</p>
		<table width="359" border="1" align="center" cellpadding="3" cellspacing="0" bordercolor="#CCCCCC" bordercolorlight="#000000" bordercolordark="#FFFFFF" bgcolor="#CCCCCC">
		  <tr> 
			<td width="349"> <input name="DueTime" type="radio" onclick="setRadioValue(this.form, 'Immediate')" value="Immediate" /> 
			  &nbsp; Immediate payment </td>
		  </tr>
		  <tr> 
			<td><input type="radio" name="DueTime" onclick="setRadioValue(this.form, 'Scheduled')"  value="Scheduled" /> 
			  &nbsp; Schedule payment for this date &nbsp; <input name="txtPayDate" type="text" size="15" id="txtPayDate" onblur="validateDate(this)" /> 
			  <input name="Button1" type="image" value="" src="images/bttn_calendar.gif" width="16" height="15" 			
			onmouseover="openDiv(this,'help','message');" onmouseout="closeDiv(this,'help','message');"/> 
			  <input type="hidden" name="radioValue" value="" /> </td>
		  </tr>
		</table>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<table width="100%" align="left">
		  <tr> 
			<td align="left"><div align="center"><span class="cellwithleftandrightpadding"> 
				<input type="submit" name="Submit3" value="Make Payment" class="input_button" <% if(!isValid) {out.println("disabled");} %>/>
				<input name="btnCancel" type="button" class="input_button" id="btnCancel" onClick="javascript:history.back(-1)" value="Cancel Payment"/>
				</span></div></td>
		  </tr>
		  <tr> 
			<td align="right">&nbsp;</td>
		  </tr>
		</table>
		<p>&nbsp;</p>
		<input name="hidAcctType" type="hidden" id="hidAcctType" value="<%=ESAPI.encoder().encodeForHTMLAttribute(bM.getMerchantAccountType())%>"> 
		<input name="hidMerchantId" type="hidden" id="hidMerchantId" value="<%=bM.getMerchantId()%>"> 
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
<%
					
/* token type section begins */

com.zenithbank.banking.ibank.token.TokenTransferObject transferObject = new com.zenithbank.banking.ibank.token.TokenTransferObject();

transferObject.setToAccount(bM.getMerchantAccountType().trim()); 
transferObject.setPin(password.trim()); 	
transferObject.setFromAccount(bP.getFromAccountNo().trim()); 	 
transferObject.setAccessCode(accesscode.trim()); 
transferObject.setTypeOfTransfer("Bill Payment"); 						   		
session.setAttribute("transferObject", transferObject);

/* token type section ends */

  }
}catch(Exception exp){
  System.out.print(exp);
}finally{
  if(con != null)    
  {
	try  { con.close();} catch(Exception e) {}
  }
}
 %>
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td colspan="2"><h1>Further Options</h1>
                          <div class="hrline4">&nbsp;</div></td>
                      </tr>
                      <tr> 
                        <td colspan="2"></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="payment-singlepayment.jsp" class="style6">Make 
                          a payment</a><a href="payment-viewamenddeleteoraddapayee.html" class="style6"></a></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><img src="images/botton.jpg" alt="pointer" width="13" height="13"/> 
                        </td>
                        <td width="866"><a href="setuppayee.jsp" class="style7"><strong>View, 
                          delete or add a payee</strong></a> <a href="newstandingorder.htm" class="style6"/></a> 
                        </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td width="866">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td width="866"><a href="viewamendoraddascheduledpayemnt.jsp" class="style7"><strong>View, 
                          reschedule or cancel a scheduled payment</strong></a><a href="newstandingorder.htm" class="style6"></a></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="viewlistofrecentpayment.jsp" class="style7"><strong>View 
                          list of successful payments </strong></a><a href="newstandingorder.htm" class="style6"></a></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="viewfailedpayments.jsp" class="style7"><strong>View 
                          list of failed payments </strong></a><a href="newstandingorder.htm" class="style6"></a></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="newstandingorder.jsp" class="style6">Create 
                          a new Standing Order</a><a href="existingstandingorder.htm" class="style6"></a></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="18"><img src="images/botton.jpg" alt="pointer" width="13" height="13" /></td>
                        <td><a href="existingstandingorder.jsp" class="style6">View 
                          or cancel an existing Standing Order</a><a href="payment-directdebit.html" class="style7"></a></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
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
<script type="text/javascript">
var updatedPenremitFields = false;
var penRemitReturn = null;
if($("#hidMerchantId").val() == 17){

	$("#AMOUNT0").prop({"disabled":true})
}

$("#verifySchedulerId").click(function(e){

	var schedulerId = $("input[name='schedulerId']").val();
	
	if(!schedulerId){
		
		alert("Please Include A Scheduler Id");
		
		return ;
	}
	 $("#verifySchedulerId i").removeClass();

	 $("#verifySchedulerId i").addClass("fa fa-circle-o-notch fa-spin");
	 $("#verifySchedulerId").addClass("disabled");
	 
	 $.ajax( "penremit_ajax.jsp?schedulerId="+schedulerId+"&actionId=1" )
	  .done(function(d) {
	   if(d != null || d != "null"){
		   
		   if(d.Status.toString() !="00"){
			   
			   alert(d.Message.toString());
			   return ;
			   
		   }
		   if(!updatedPenremitFields){
				 $("#paymentTable tbody").append(addInfoForPenremit(d.Result));
				 updatedPenremitFields = true;
			}
		   penRemitReturn = d.Result;
		   updatePenremitValues(d.Result);
	   }else{
		   alert("No Schedule with Id : " + schedulerId + " was found!.");
		   penRemitReturn = null;
 
	   }
	   
	  })
	  .fail(function() {
	    alert( "Unexpected Error Verifying Scheduler Id!." );
	    penRemitReturn = null;
	
	  })
	 .always(function() {
		 $("#verifySchedulerId i").removeClass("fa fa-circle-o-notch fa-spin");
		 $("#verifySchedulerId i").addClass("fa fa-home fa-2x")
		 $("#verifySchedulerId").removeClass("disabled");
   
	 
	 });
	
	
	
	
})

var addInfoForPenremit = function(d){

	var tpl = ' <tr> <td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Employer Code : &nbsp;</div>'+
	'</td> <td height="25" class="boldtext"><span class="style29"><input type="text" name="EmployerCode" value="" disabled="disabled">   </td>   </tr>'+
	'<tr>   <td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Customer Name : &nbsp;</div>'+
	' </td>  <td height="25" class="boldtext"><span class="style29"> <input type="text" name="CustomerName" value="" disabled="disabled"> </span></td> </tr>'+
	/*'<tr> <td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Amount Paid : &nbsp;</div> </td>' +
	'<td height="25" class="boldtext"><span class="style29">  <input type="text" name="AmountPaid" value="" disabled="disabled">  </span> </td> </tr>'+*/
	'<tr> <td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Email Address : &nbsp;</div> </td>' +
	'<td height="25" class="boldtext"><span class="style29">  <input type="text" name="EmailAddress" value="" disabled="disabled">  </span> </td> </tr>'+
	'<tr> <td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Schedule Ref No : &nbsp;</div> '+
	'</td><td height="25" class="boldtext"><span class="style29"> <input type="text" name="ScheduleReferenceNo" value="" disabled="disabled"></span> </td>'+
	'</tr> <tr>    <td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Payee PhoneNo : &nbsp;</div>'+
	' </td>   <td height="25" class="boldtext"><span class="style29"> <input type="text" name="PayeePhoneNo" value="" disabled="disabled"> </span> </td> </tr>'
	/*' <tr><td width="30%" height="25" bgcolor="#CCCCCC" class="darkblue_text"><div align="right" class="smallbluetext">Payment Status: &nbsp;</div>  </td>'+
	' <td height="25" class="boldtext"><span class="style29">  <input type="text" name="PaymentStatus" value="" disabled="disabled">  </span></td></tr>'*/;
	
	
	
	return tpl;
	
}

var updatePenremitValues= function(d){

	$("#AMOUNT0").val(parseInt(d.Amount).toLocaleString('en-US', {minimumFractionDigits: 2}));
	$("input[name='EmployerCode']").val(d.EmployerCode);
	$("input[name='CustomerName']").val(d.CustomerName);
	$("input[name='AmountPaid']").val(parseInt(d.Amount).toLocaleString('en-US', {minimumFractionDigits: 2}));
	$("input[name='ScheduleReferenceNo']").val(d.ScheduleReferenceNo);
	$("input[name='PayeePhoneNo']").val(d.PayeePhoneNo);
	$("input[name='PaymentStatus']").val(d.PaymentStatus);
	$("input[name='EmailAddress']").val(d.EmailAddress);
}


var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   } 
   return this
}

function isDate(dtStr){
	var daysInMonth = DaysArray(12)
	var pos1=dtStr.indexOf(dtCh)
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strMonth=dtStr.substring(0,pos1)
	var strDay=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
	if (pos1==-1 || pos2==-1){
		alert("The date format should be : mm/dd/yyyy")
		return false
	}
	if (strMonth.length<1 || month<1 || month>12){
		alert("Please enter a valid month")
		return false
	}
	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		alert("Please enter a valid day")
		return false
	}
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear)
		return false
	}
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		alert("Please enter a valid date")
		return false
	}
return true
}

function IsNumeric(sText)
{
   var ValidChars = "0123456789.";
   var IsNumber=true;
   var Char;
 
   for (i = 1; i < sText.length && IsNumber == true; i++) 
   { 
      Char = sText.charAt(i); 
      if (ValidChars.indexOf(Char) == -1) 
      {
         IsNumber = false;
      }
   }
   return IsNumber;
}

function validateForm(thisform)
{	
	var MerId = thisform.hidMerchantId.value;	
	

	
	if(parseInt(MerId) == 1 || parseInt(MerId ) == 10){	
    	var noOfMonth = document.getElementById("month").value; 
		var g = thisform.ddbouquet.value;  
		var gsplit = g.split("-");  	
		var params = thisform.hidReqFields.value;    			
		params = params + gsplit[0] + "/null/null/null/" + noOfMonth + "/" + gsplit[2] + "/";		
		thisform.hidReqFields.value = params;	
    }

	if(parseInt(MerId ) == 14){	    	
		var g = thisform.ddbouquet.value;  
		var gsplit = g.split("-");  	
		var params = thisform.hidReqFields.value;    			
		params = params + gsplit[0] + "/null/null/null/1/" + gsplit[2] + "/";
		alert(params);
		thisform.hidReqFields.value = params;	
    }	
	

	if(parseInt(MerId ) == 17){	 
		 var params = thisform.hidReqFields.value; 
		
		var addedParams  = "null/" + penRemitReturn.ScheduleReferenceNo +"/" +  penRemitReturn.CustomerName + "/"
	     +"null/"+  penRemitReturn.EmailAddress +"/" + penRemitReturn.PayeePhoneNo;
		params += addedParams;
		thisform.hidReqFields.value = params;	
		console.log(thisform.hidReqFields.value); 
		$("#hidReqFields").val(params);
		$("#AMOUNT0").prop({"disabled":false})


		
		

		
		
    }	
	
	

	
	if (thisform.radioValue.value == "")
	{
		alert ("Please select a payment period \nEither Immediate or Scheduled payment");
		thisform.AMOUNT0.focus();
		return false;
	}
	
	if (thisform.radioValue.value == "Scheduled" && Trim(thisform.txtPayDate.value) == "")
	{
		alert('You have chosen "Scheduled Payment" \n Please enter the scheduled date');
		thisform.txtPayDate.focus();
		return false;
	}
		
	if (thisform.radioValue.value == "Immediate" && Trim(thisform.txtPayDate.value) != "")
	{
		alert('You have chosen "Immediate Payment" \n You do not need to enter the scheduled date');
		thisform.txtPayDate.focus();
		return false;
	}
	
	
	if(!validateDate(thisform.txtPayDate.value)){
	   thisform.txtPayDate.focus();
	   return false;	
	}		
	
	if (IsBlank(thisform.AMOUNT0,"Amount field must be filled out!"))
	{
	  thisform.AMOUNT0.focus();
	  return false;
	}
	
	if (!IsNumeric(thisform.AMOUNT0.value) || parseFloat(thisform.AMOUNT0.value) < 0.1)
	{
		alert("Amount field must be a numeric value greater than zero")
		thisform.AMOUNT0.focus();
		return false;
	}
  
	sure = confirm("Are you sure you want to make this payment of NGN" + thisform.AMOUNT0.value + " to " + thisform.hidPayee.value + " ?");
	if (sure)
		return true;
	else 
		return false;

}

function validateDate(obj)
{	
if (Trim(obj.value) != "")
	if (!isDate(obj.value)){
		obj.focus();
		return false;
	}
	else return true;
}

function setRadioValue(thisform, val){
	thisform.radioValue.value = val;
}

$('#ddbouquet').change(function(){ 

    var bouquet = $(this).val();
    var bouq = bouquet.split("-");
    var customerID = $("#customerID").val();
		
    if(bouq[2] == "BO" || bouq[0] == "Others"){
		$("#numOfMonth").hide();
                $("#custID").show();
                $("#hidReqFields").val(customerID + "/");
		$('#AMOUNT0').attr("readonly", false);
		$("#AMOUNT0").val("");		
	}else{
		$("#numOfMonth").show();
                $("#custID").hide();
		$("#month").val(1);
		noOfMonths();
		$('#AMOUNT0').attr("readonly", true);
	}
});


function noOfMonths(){
    var noOfMonth = $("#month").val(); 
	var price = $("#ddbouquet").val(); 	
    var prSplit = price.split("-");     	
	var amount = parseFloat(prSplit[1]);	    			
	
	amount = (amount * noOfMonth);	
    amount = addCommas(amount);
		
	if(amount.indexOf(".") == -1)    	
		$("#AMOUNT0").val((amount + '.00'));		
	else 
		$("#AMOUNT0").val(amount);				
}


function addCommas(nStr){    
    nStr += '';
    var x = nStr.split('.');
    var x1 = x[0];
    var x2 = x.length > 1 ? '.' + x[1] : '';
	
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }    
    return x1 + x2;
}



    Calendar.setup({
        inputField     :    "txtPayDate",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "BUTTON1",  // trigger for the calendar (button ID)
        align          :    "Tl",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script> 