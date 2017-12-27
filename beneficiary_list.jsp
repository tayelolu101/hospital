<% response.setHeader("Cache-Control","no-store"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<%@ page language="java" import = "javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*, com.zenithbank.banking.coporate.ibank.audit.*,com.zenithbank.banking.coporate.ibank.payment.*,com.zenithbank.banking.coporate.ibank.PaymentHelper.*,java.util.*" errorPage="error.jsp"  session="true" %>

<%
com.dwise.util.CryptoManager crypto = new com.dwise.util.CryptoManager();
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
 com.zenithbank.banking.coporate.ibank.action.CompanyManager company = new com.zenithbank.banking.coporate.ibank.action.CompanyManager(); 
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


int Authorizer_id = login.getSeq();
int ApprovalLevel =  login.getAuthLevel();
String ClientID = login.getHostCompany();
String CompanyName = company.findBankByCode(login.getHostCompany()).getName();
String rolegroup = company.findBankByCode(login.getHostCompany()).getrolegroup();
String authValidation = company.findBankByCode(login.getHostCompany()).getAuthValidation();

//////////////////////////////////ADDED BY DUBIC UZUEGBU
String[] pTypes = null;
   String vendorCode = request.getParameter("vendorCodeText");  vendorCode = (vendorCode == null ? "":vendorCode); 
   String vendorName = request.getParameter("vendorNameText");  vendorName = (vendorName == null ? "": vendorName);
   String paymentType = request.getParameter("paymentTypeSel"); paymentType =(paymentType == null? "ALL":paymentType);//condition not possible
   String bankName = request.getParameter("bankNameText"); bankName =(bankName == null? "": bankName);
   //String recordStatus = request.getParameter("recordStatusSel"); recordStatus =(recordStatus == null? "ALL":recordStatus);//condition not possible
   //String status = request.getParameter("statusSel"); status =(status == null? "ALL":status);//condition not possible
   //String acct_no = request.getParameter("acctNumText"); acct_no =(acct_no == null? "": acct_no);
   //String sortCode = request.getParameter("sortCodeText"); sortCode =(sortCode == null? "": sortCode);
if(request.getParameter("vendorSubmit") != null)
{
    session.setAttribute("vendor name",vendorName);
    session.setAttribute("payment type",paymentType);
    session.setAttribute("bank name",bankName);
    session.setAttribute("vendor code",vendorCode);
}
/////////////////////////////////END ADDED


BeneficiaryAdapter ba = new BeneficiaryAdapter();
//BeneficiaryValue[] bvArr = ba.getBeneficiaryList(ClientID);
BeneficiaryValue[] bvArr = new BeneficiaryValue[0];

 String chkMyQueue = request.getParameter("MyQueue");
 
  if(chkMyQueue != null)
  {

		if ((rolegroup.trim().equalsIgnoreCase("Y")) && (authValidation.trim().equalsIgnoreCase("Y")))
			  {
			  bvArr = ba.getBeneficiaryList_RoleGroup_Auth(ClientID,login.getSeq(),login.getLoginId(),ApprovalLevel-1,vendorName,paymentType,bankName,vendorCode);
			  }
		else if(authValidation.trim().equalsIgnoreCase("Y"))
			  {
                         bvArr = ba.getBeneficiaryList_Auth(ClientID,login.getLoginId(),ApprovalLevel-1,vendorName,paymentType,bankName,vendorCode);
			 }
		else if(rolegroup.trim().equalsIgnoreCase("Y"))
			  {
			  bvArr = ba.getBeneficiaryList_RoleGroup(ClientID,login.getSeq(),ApprovalLevel-1,vendorName,paymentType,bankName,vendorCode);
                         }
		else
			{
			
                        bvArr = ba.getBeneficiaryList(ClientID,ApprovalLevel-1,vendorName,paymentType,bankName,vendorCode);
                        
			}
  }
  else
  {
	
  if ((rolegroup.trim().equalsIgnoreCase("Y")) && (authValidation.trim().equalsIgnoreCase("Y")))
			  {
        
			// bvArr = ba.getBeneficiaryList_RoleGroup_Auth(ClientID,login.getSeq(),login.getLoginId(),ApprovalLevel-1);
			 //bvArr = ba.getBeneficiaryList_RoleGroup_Auth(ClientID,login.getSeq(),login.getLoginId(),-1);
                         bvArr = ba.getBeneficiaryList_RoleGroup_Auth(ClientID,login.getSeq(),login.getLoginId(),-1,vendorName,paymentType,bankName,vendorCode);
			// System.out.println(" *** 5 ");
			  }
		else if(authValidation.trim().equalsIgnoreCase("Y"))
			  {
        
//			 bvArr = ba.getBeneficiaryList_Auth(ClientID,login.getLoginId(),ApprovalLevel-1);
			 //bvArr = ba.getBeneficiaryList_Auth(ClientID,login.getLoginId(),-1);
                         bvArr = ba.getBeneficiaryList_Auth(ClientID,login.getLoginId(),-1,vendorName,paymentType,bankName,vendorCode);
			//System.out.println(" *** 6 "); 
			 }
		else if(rolegroup.trim().equalsIgnoreCase("Y"))
			  {
//			 bvArr = ba.getBeneficiaryList_RoleGroup(ClientID,login.getSeq(),ApprovalLevel-1);
			// bvArr = ba.getBeneficiaryList_RoleGroup(ClientID,login.getSeq(),-1);
                         bvArr = ba.getBeneficiaryList_RoleGroup(ClientID,login.getSeq(),-1,vendorName,paymentType,bankName,vendorCode);
			 //System.out.println(" *** 7 ");
			  }
		else
			{

//			bvArr = ba.getBeneficiaryList(ClientID,ApprovalLevel-1);
			//bvArr = ba.getBeneficiaryList(ClientID,-1);
                        bvArr = ba.getBeneficiaryList(ClientID,-1,vendorName,paymentType,bankName,vendorCode);
			//System.out.println(" *** 8 ");
			}
	
  }
/*
//////
         java.text.SimpleDateFormat timestamp  = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss a"); 
         AuditManager adm = new AuditManager();//CIB AUDIT
         AuditValue audit = new AuditValue();//CIB AUDIT
         audit.setCompany_code(login.getHostCompany());
         audit.setBranch_code(login.getHostBranch());
         audit.setTable_name("ZIB_CIB_GB_BENEFICIARY");
         audit.setObj_name("PAYMENT");
         audit.setAcct_perfmd("APPROVE BENEFICIARY");
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
*/
///Begin- Lanre Added to correct issues for Pagination 17/02/2009

int numRecordsPerPage = 0;
if (request.getParameter("recordsPerPage") != null){
  numRecordsPerPage = Integer.parseInt(request.getParameter("recordsPerPage"));
}else{ numRecordsPerPage = 25;}

///End- Lanre Added to correct issues for Pagination 17/02/2009
 
   /// Added for pagination
 ////  int numRecordsPerPage = 25;
   //added by Okuwa
    String startIndexString = request.getParameter("stIndex");
    String RecordsPerPage = request.getParameter("recordsPerPage");
    if(RecordsPerPage != null)
    {
      numRecordsPerPage = Integer.parseInt(RecordsPerPage);
    }
    
    
    if(startIndexString == null) 
    {
      startIndexString = "0";
    }
    
    int startIndex = Integer.parseInt(startIndexString); 
    int count = 0;
    int totalCols = 0;
    int increment = 1;
    int numRows = bvArr.length;
    //int numRecordsPerPage = 50;
    int numPages = numRows /numRecordsPerPage; 
    int remain = numRows % numRecordsPerPage;
    if(remain != 0)
    {
      numPages = numPages +1;
    }
    
    if((startIndex + numRecordsPerPage) <= numRows) 
    {
      increment = startIndex + numRecordsPerPage;
    }
    else
    {
      if (remain == 0)
      {
        increment = startIndex + numRecordsPerPage;
      }
      else
      {
        increment = startIndex + remain;
      }
    }
	
   

  bvArr = ba.getBeneficiaryPage(bvArr, startIndex, numRecordsPerPage);
   //end

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>untitled</title>
<link href="css/zs.css" rel="stylesheet" type="text/css" />
<link href="css/GenericStylesheet.css" rel="stylesheet" type="Text/CSS" />
<script src="javascript/GenericJavaScript1.js" type="text/javascript" language="javascript"></script>
<script type="text/javascript" language="JavaScript1.2">
if (document.all){
    document.onkeydown = function (){
        var key_f5 = 116; // 116 = F5
        if (key_f5==event.keyCode){
            event.keyCode = 27;
            return false;
        }
    }
}
</script>

<script type="text/javascript" language=JavaScript>
  //Disable right click script III- By Renigade 
 var message="";
 ///////////////////////////////////
 function clickIE() {if (document.all) {(message);return false;}}
 function clickNS(e) {if
 (document.layers||(document.getElementById&&!document.all)) {
 if (e.which==2||e.which==3) {(message);return false;}}}
 if (document.layers)
 {document.captureEvents(Event.MOUSEDOWN);document.onmousedown=clickNS;}
 else{document.onmouseup=clickNS;document.oncontextmenu=clickIE;}
 document.oncontextmenu=new Function("return false")
</script>
</head>

<body class="parentBody" id="div_body">
<DIV align="center">
<form name="frmBeneficiary" action="approve_beneficiary.jsp" method="post" target="_self">
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
                        <DIV class='HeaderText1' style='text-align:center;'>Beneficiary List</DIV>
                        <DIV class='HeaderTailText' style='text-align:center;'>Below is a list of beneficiaries set up for <B><%=CompanyName%></B> and their current status. Disabled checkboxes show that the beneficiary is not available for approval</DIV>
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
                      if(bvArr.length > 0) {
                      %>
                          <DIV style=''>
                              <TABLE frame='Box' rules='All' summary='SUB-table' border='1' cellspacing='0' cellpadding='2' class='GenericTable1' style='width:100%; font-size:0.9em;'>                          
                                  <TR>
                                    <TD colspan='2' class='GenericTableCell'>
                                      <INPUT type="HIDDEN" name="hidAppLevel" value="<%=ApprovalLevel%>" />
                                      <INPUT type="BUTTON" style='width:40%;' name="btnCheckAll" value="Check All" class="Button1" onclick="return checkAll(this.form)" />
                                      &nbsp;&nbsp;<INPUT type="BUTTON" style='width:40%;' name="btnClearAll" value="Clear All" class="Button1" onclick="return clearAll(this.form)" />                                      
                                    </TD>
                                    <TD colspan='3' class='GenericTableCell'>
                                       <INPUT type="CHECKBOX" style='10px;' name="MyQueue" value="checked" <%=(chkMyQueue != null? "checked='checked'":"")%> onclick="RefreshMe();" />
                                       &nbsp;<SPAN class='NavyText'>Show my queue only for beneficiary(ies) awaiting approval</SPAN>
                                       &nbsp;&nbsp;&nbsp;&nbsp;<INPUT type="button" style='width:20%;' name="SearchBeneficiary" value="Search" class="Button1" onclick="javascript:location.replace('searchBeneficiaries.jsp')" />
                                    </TD>
                                    <TD colspan='2' class='GenericTableCell'>
                                      <DIV class='NavyText_Right'>Number of Results Per Page:</DIV>
                                    </TD>
                                    <TD colspan='1' class='GenericTableCell'>
                                      <SELECT name="recordsPerPage" id="recordsPerPage" class='Selectbox' style='width:90%;' onchange="RefreshMe();">
                                        <OPTION value="25" <%=(numRecordsPerPage == 25? "selected='selected'" : "")%>>25</OPTION>
                                        <OPTION value="50" <%=(numRecordsPerPage == 50? "selected='selected'" : "")%>>50</OPTION>
                                        <OPTION value="75" <%=(numRecordsPerPage == 75? "selected='selected'" : "")%>>75</OPTION>
                                        <OPTION value="100" <%=(numRecordsPerPage == 100? "selected='selected'" : "")%>>100</OPTION>
                                        <OPTION value="125" <%=(numRecordsPerPage == 125? "selected='selected'" : "")%>>125</OPTION>
                                        <OPTION value="150" <%=(numRecordsPerPage == 150? "selected='selected'" : "")%>>150</OPTION>
                                        <OPTION value="175" <%=(numRecordsPerPage == 175? "selected='selected'" : "")%>>175</OPTION>
                                        <OPTION value="200" <%=(numRecordsPerPage == 200? "selected='selected'" : "")%>>200</OPTION>
                                      </SELECT>
                                    </TD>
                                  </TR>
                                  <TR>
                                    <TD colspan='1' class='BACKimage1 GenericTableHeader'>*</TD>
                                    <TD colspan='1' class='BACKimage1 GenericTableHeader'>Beneficiary Name</TD>
                                    <TD colspan='1' class='BACKimage1 GenericTableHeader'>Beneficiary Code</TD>
                                    <TD colspan='1' class='BACKimage1 GenericTableHeader'>Beneficiary Number</TD>
                                    <TD colspan='1' class='BACKimage1 GenericTableHeader'>Beneficiary Bank</TD>
                                    <TD colspan='1' class='BACKimage1 GenericTableHeader'>Sort Code</TD>
                                    <TD colspan='1' class='BACKimage1 GenericTableHeader'>Status</TD>
                                    <TD colspan='1' class='BACKimage1 GenericTableHeader'>Details</TD>
                                  </TR> 
                                  <%
                                    String status = "";
                                    String checkbox = "";
                                    String cbStatus = "";
                                    for (int i=0; i<bvArr.length; i++)
                                    {                  
                                        if ((rolegroup.trim().equalsIgnoreCase("Y")) && (authValidation.trim().equalsIgnoreCase("Y")))
                                        {  
                                            if (bvArr[i].getApprovedStatus() > 0)   // completely approved
                                            {
                                                status = "Approved";
                                                checkbox = "&nbsp;";
                                            }
                                            else
                                            {
                                              status = "Awaiting approval";                                    
                                              if (ApprovalLevel == 1)    //  for uploader right
                                              {                                    
                                                  cbStatus = " disabled";
                                              }
                                              else if (bvArr[i].getApprovalLevel() != ApprovalLevel - 1)
                                              {                                    
                                                  cbStatus = " disabled";
                                              }
                                              else
                                              {                                    
                                                  if(bvArr[i].getBeneficiaryRef().equalsIgnoreCase("441-222-777-111")){
                                                     // System.out.println(" eeeeeeee "+bvArr[i].getApprovalLevel());
                                                     // System.out.println(" ApprovalLevel "+ApprovalLevel);
                                                  }
                                                  
                                                  if ( bvArr[i].getuploadOperator().trim().equalsIgnoreCase(login.getLoginId().trim())) {
                                                    cbStatus = " disabled";
                                                  }
                                                  else if (bvArr[i].getApprovalLevel() == ApprovalLevel-1 ) {                                     
                                                     if (bvArr[i].getAuthorizerid() == Authorizer_id)
                                                     {                                     
                                                        cbStatus = "disabled";
                                                     }
                                                     else
                                                     {
                                                        cbStatus = "";
                                                     }
                                                  }
                                                  else if (bvArr[i].getApprovalLevel() == ApprovalLevel) {
                                                     //cbStatus = "";//commented on 21072010 to correct Beneficiary Approval issue
                                                     cbStatus = "disabled";
                                                  }
                                                  else{
                                                     cbStatus = " disabled";                                                            
                                                  }
                                              }
                                              checkbox = "<input type='checkbox' name='chk' value='" + bvArr[i].getVendorId() + "'" + cbStatus + ">";
                                            }
                                        }
                                        else if ((authValidation.trim().equalsIgnoreCase("Y")))
                                        { 
                                            if (bvArr[i].getApprovedStatus() > 0)   // completely approved
                                            {
                                                status = "Approved";
                                                checkbox = "&nbsp;";
                                            }
                                            else
                                            {
                                                status = "Awaiting approval";
                                                if (ApprovalLevel == 1)    //  for uploader right
                                                {
                                                    cbStatus = " disabled";
                                                }
                                                else
                                                {
                                                    if ( bvArr[i].getuploadOperator().trim().equalsIgnoreCase(login.getLoginId().trim())) { 
                                                         cbStatus = " disabled";
                                                    }
                                                    else if (bvArr[i].getApprovalLevel() == ApprovalLevel-1 ) {
                                                        if (bvArr[i].getAuthorizerid() == Authorizer_id)
                                                        {
                                                            cbStatus = "disabled";
                                                        }
                                                        else
                                                        {
                                                            cbStatus = "";
                                                        }
                                                    }
                                                    else if (bvArr[i].getApprovalLevel() == ApprovalLevel) {
                                                        //cbStatus = "";//commented on 21072010 to correct Beneficiary Approval issue
                                                        cbStatus = "disabled";
                                                    }
                                                    else {
                                                        cbStatus = " disabled";                                                            
                                                    }
                                                }
                                                checkbox = "<input type='checkbox' name='chk' value='" + bvArr[i].getVendorId() + "'" + cbStatus + ">";
                                            }
                                        }
                                        else{                      
                                            if (bvArr[i].getApprovedStatus() > 0)   // completely approved
                                            {
                                                status = "Approved";
                                                checkbox = "&nbsp;";
                                            }
                                            else
                                            {
                                                status = "Awaiting approval";
                                                if (ApprovalLevel == 1)    //  for uploader right
                                                {
                                                  cbStatus = " disabled";
                                                }
                                                else
                                                {
                                                    if (bvArr[i].getApprovalLevel() == ApprovalLevel-1 )
                                                    {
                                                        if (bvArr[i].getAuthorizerid() == Authorizer_id)
                                                        {
                                                            cbStatus = "disabled";
                                                        }
                                                        else
                                                        {
                                                            cbStatus = "";
                                                        }
                                                    }                          
                                                    else if (bvArr[i].getApprovalLevel() == ApprovalLevel)
                                                    {
                                                        //cbStatus = "";//commented on 21072010 to correct Beneficiary Approval issue
                                                        cbStatus = "disabled";
                                                    }                          
                                                    else
                                                    {
                                                        cbStatus = " disabled";
                                                    }                          
                                                }
                                                checkbox = "<input type='checkbox' name='chk' value='" + bvArr[i].getVendorId() + "'" + cbStatus + ">";
                                            }
                                        }
                                        String pageDetails_URL = "beneficiary_details.jsp?vendor_id=" + crypto.encode(String.valueOf(bvArr[i].getVendorId())) ;
                                        String DetailsLink = "<A style='font-size:1em;' class='BlueMenuLinks' Onclick=" + (char)34 + "CreateWindow('" + pageDetails_URL + "','300','600');return;" + (char)34 + ">";
                                  %>            
                                        <TR>
                                          <TD class='GenericTableCell'><DIV class='NavyText'><%=checkbox%></DIV></TD>
                                          <TD class='GenericTableCell'><DIV class='NavyText'><%=DetailsLink%><%= bvArr[i].getVendorName()%></A></DIV></TD>
                                          <TD class='GenericTableCell'><DIV class='NavyText'><%=bvArr[i].getBeneficiaryRef()%></DIV></TD>
                                          <TD class='GenericTableCell'><DIV class='NavyText'><%=bvArr[i].getBeneficiaryAcctNo() %></DIV></TD>
                                          <TD class='GenericTableCell'><DIV class='NavyText'><%= bvArr[i].getBranchname() %></DIV></TD>
                                          <TD class='GenericTableCell'><DIV class='NavyText'><%= bvArr[i].getBanksortcode() %></DIV></TD>
                                          <TD class='GenericTableCell'><DIV class='NavyText'><%=status%></DIV></TD>
                                          <TD class='GenericTableCell'><DIV class='NavyText'><%=DetailsLink%><IMG src="images/detail.gif" border="0"/></A></DIV></TD>						  	
                                        </TR>
                                  <%
                                    }
                                      //added by Okuwa for pagination
                                      String disableNext = "";
                                      String disablePrevious = "";
                                      String disableFirst = "";
                                      String disableLast = "";
                                      //System.out.println("startIndex>>"+startIndex);
                                      //System.out.println("increment>>"+increment);
                                      //System.out.println("numRecordsPerPage>>"+numRecordsPerPage);
                                      //System.out.println("numRows>>"+numRows);
                                      //System.out.println("remain>>"+remain);
                                      if (startIndex <= 0)
                                      {
                                        disableFirst = " disabled";
                                      }
                                      if ((startIndex - numRecordsPerPage) < 0)
                                      {
                                        disablePrevious = " disabled";
                                      }
                                      if ((numRecordsPerPage + startIndex) >= numRows)
                                      {
                                        disableNext = " disabled";
                                      }
                                      if ((numRecordsPerPage + startIndex) >= numRows)
                                      {
                                        disableLast = " disabled";
                                      }
                                      
                                      int begin = startIndex+1;
                                      int end = 0;
                                      //if (remain == 0)
                                      //  end = startIndex+remain;
                                      //else
                                      //  end = increment;
                                      if (startIndex+numRecordsPerPage > numRows)
                                        end = numRows;
                                      else
                                        end = startIndex+numRecordsPerPage;
                                      int total = numRows;  
                                  %>
                                        <TR>
                                          <TD colspan='2' class='GenericTableCell_Center'>
                                            <INPUT type="hidden" name="stIndex" value="" />
                                            <INPUT type="button" style='width:40%;' name="btnFirst" id="btnFirst" value="First" class="Button1" onClick="doFirst(this.form)" <%=disableFirst%> />
                                            &nbsp;&nbsp;<INPUT type="button" style='width:40%;' name="btnPrevious" id="btnPrevious" value="Previous" class="Button1" onClick="doPrevious(this.form, <%=numRecordsPerPage%>, <%=startIndex%>)" <%=disablePrevious%> />
                                          </TD>
                                          <TD colspan='3' class='GenericTableCell_Center'>
                                             <%
                                                if (numRows == 1)
                                                {
                                             %>
                                                   <DIV class='BlackBoldText_Center'>Record <%=begin%> of <%=total%></DIV>
                                             <%
                                                }
                                                else
                                                {
                                             %>
                                                   <DIV class='BlackBoldText_Center'>Records <%=begin%> to <%=end%> of <%=total%></DIV>
                                             <%	
                                                }	
                                             %>
                                          </TD>
                                          <TD colspan='3' class='GenericTableCell_Center'>
                                            <INPUT type="button" style='width:40%;' name="btnNext" id="btnNext" value="Next" class="Button1" onClick="doNext(this.form, <%=numRecordsPerPage%>, <%=startIndex%>)" <%=disableNext%> />
                                            &nbsp;&nbsp;<INPUT type="button" style='width:40%;' name="btnLast" id="btnLast" value="Last" class="Button1" onClick="doLast(this.form, <%=remain%>, <%=numRows%>)" <%=disableNext%> />                    
                                          </TD>
                                        </TR>
                                        <TR>
                                          <TD colspan='4' class='GenericTableCell_Left'>
                                            <INPUT type="submit" style='width:70%;' name="Approve" id="Approve" value="Approve" class="Button1" onClick="return ApproveSelectedItems();" />
                                          </TD>
                                          <TD colspan='4' class='GenericTableCell_Right'>
                                            <INPUT type="button" style='width:70%;' name="approvea_ll" id="approvea_ll" value="Approve all items" class="Button1" onClick="viewPopupWindow('ben_popup_all.jsp')" />
                                          </TD>
                                        </TR>
                             </TABLE>
                          </DIV>
                      <%
                      }
                      else {
                      %>
                          <DIV style='height:200px; overflow-y:auto; overflow-x:hidden;'>
                            <TABLE frame='Box' rules='All' summary='SUB-table' border='1' cellspacing='0' cellpadding='2' class='GenericTable1' style='width:100%;'>                          
                              <TR>
                                <TD align='center' style='padding:0px 3px 0px 3px;'>
                                   <DIV class='HeaderText1' style='text-align:justify;'>There is (are) no beneficiary to be approve for this level.</DIV>
                                </TD>
                              </TR>
                            </TABLE>
                          </DIV>
                      <%  
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
</form>
</DIV>



<script type="text/javascript" language="Javascript">    
    var theWindow;
    function CreateWindow(strUrl, height, width) {
      var Left;
      var Top;
      
      if (!theWindow || theWindow.closed) {
        now = new Date();
        id = now.getTime();
      
        Left =(window.screen.width/2) - (width/2 + 10)
        //half the screen width minus half the new window width (plus 5 pixel borders).
      
        Top = (window.screen.height/2) - (height/2 + 50)
        //half the screen height minus half the new window height (plus title and status bars).
      
        features='toolbar=no,location=no,directories=no,status=no,menubar=no,';
        features += 'height=' + height +  ',width=' + width;
        features += ',scrollbars=yes,resizable=yes' ;
        //features += ',left='+ Left + ',top=' + Top + ",screenX=' + Left + ',screenY=' + Top
        theWindow = window.open(strUrl,id,features);
      } else {
        // window's already open bring to front
        theWindow.focus();		
      } // End If
    } // end function
    
    function RefreshMe()
    {
     document.frmBeneficiary.action = "beneficiary_list.jsp";
     document.frmBeneficiary.stIndex.value = <%=startIndex%>;
      document.frmBeneficiary.submit();
    }
    
    function ApproveSelectedItems()
    {
      var count = 0;
      var num = 0;
      num = document.frmBeneficiary.chk.length;
      if(num == null || num == "undefined")
      {
        if(document.frmBeneficiary.chk.checked)
        {
            var comfirmtext = "Are you sure you want to approve the selected beneficiary";
            var bconfirm = confirm(comfirmtext);
            return bconfirm;
        }
        else
        {
          alert("You must select a beneficiary to approve");
          return false;
        }
      }
            if (num > 0)
      {
                    for (var i=0; i < num; i++)
        {
                            if (document.frmBeneficiary.chk[i].checked)
          {
                                    count++;
                            }
                    }
        //alert (count);
            }
        if(count > 0)
        {
            var comfirmtext = "You have selected " + count + " record(s) to approve. Are you sure";
            var bconfirm = confirm(comfirmtext);
            return bconfirm;
        }
        else
        {
         alert("You must select a beneficiary to approve");
          return false;
        }
      return false;
    }
    
    
    
    
    function checkAll(form)
    {
      var elements = form.elements;
            //var ids = new Array();
            for (i =0; i < elements.length; i++){			
                    if (elements[i].name.indexOf("chk") != -1 && !elements[i].disabled){
                            elements[i].checked = true;
                    }
            }
    }
    
    
    function clearAll(form)
    {
      var elements = form.elements;
            //var ids = new Array();
            for (i =0; i < elements.length; i++){			
                    if (elements[i].name.indexOf("chk") != -1 && !elements[i].disabled){
                            elements[i].checked = false;
                    }
            }
    }
    
    function viewPopupWindow(url)
    {
      //alert("Please do not click on the OK button until a review window pops up.\n\nThis may take a few minutes.");
      
      var args='width=600,height=600,left=100,top=80,toolbar=0,';
            args+='location=0,status=0,menubar=0,scrollbars=yes,resizable=0';  
            window.open(url,null,args); 
      
      /*if (confirm("You selected all records for processing.  Are you sure?  \n\nOnce executed it can't be reversed.  Please confirm before you proceed."))
                            return true;
      else
          return false;*/
     
    
      
    }
    // Pagination
    function doFirst(thisform)
    {
            thisform.stIndex.value = 0;
            thisform.action = "";
            thisform.submit();
    }
    
    function doPrevious(thisform, numRecordsPerPage, startIndex)
    {
            thisform.stIndex.value = startIndex - numRecordsPerPage;
            thisform.action = "";
            thisform.submit();
    }
    
    function doNext(thisform, numRecordsPerPage, startIndex)
    {
            thisform.stIndex.value = numRecordsPerPage + startIndex;
            thisform.action = "";
      thisform.submit();
    }
    
    function doLast(thisform, remain, numRows)
    {
            thisform.stIndex.value = numRows - remain;
            thisform.action = "";
            thisform.submit();
    }
    //end
</script>
</body>
</html>
