<%@ page language="java" import = "javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*, com.zenithbank.banking.coporate.ibank.audit.*, java.util.Calendar,java.util.Hashtable,com.zenithbank.banking.coporate.ibank.*" errorPage="error.jsp"  session="true" %><html>
<%
 String dtUrl ="DataTables-1.10.2";
BaseAdapter connect = new BaseAdapter();
String branch = request.getParameter("BRANCH");
String role_id = request.getParameter("ROLE");
java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
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
//if (s[0] == "1") //Gbolahan commented to fix non display of password expiry days - //14072010
if (s[0].equals("1"))//Gbolahan added to fix non display of password expiry days - //14072010
{
    out.println("<script>alert('Your password has expired, please change your password!')</script>");
    out.println("<script>window.location='ChangePwd.jsp'</script>");
}

//if (s[0] == "0")  { //Gbolahan commented to fix non display of password expiry days - //14072010
if (s[0].equals("0")){ //Gbolahan added to fix non display of password expiry days - //14072010
 
no_of_days = s[1]; }

com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter BeneDetails = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter();
BeneficiaryValue[] transfers = new BeneficiaryValue[0];
com.zenithbank.banking.coporate.ibank.action.CompanyManager company = new com.zenithbank.banking.coporate.ibank.action.CompanyManager();
String rolegroup = company.findBankByCode(login.getHostCompany()).getrolegroup();

BeneficiaryValue[] BeneResult = new BeneficiaryValue[0];
BeneResult = BeneDetails.getPaymentType();

String roleId = "";
String statusA = "";
String selectQuery = "";

Connection con = null;
Statement stmt = null;
ResultSet rs = null;
PreparedStatement ps = null;
String sel = request.getParameter("sel");
String status = request.getParameter("STATUS");
if (status == null) status = "1";
String recstatus = request.getParameter("RECSTATUS");

System.out.println("recstatus"+recstatus);

if (recstatus == null) recstatus = "1";
if (sel == null) sel = "0";

if(status.equalsIgnoreCase("1")){
  statusA = "Active";
}else{
  statusA = "Closed";
}
if (branch == null) branch = "ALL"
;

String Company_Name = login.getHostCompany();
BeneficiaryValue[] BeneResult1 = new BeneficiaryValue[0];
BeneResult1 = BeneDetails.getBeneficiaryListValues(Company_Name,branch,statusA,Integer.parseInt(recstatus),rolegroup.trim(),login.getgrouproleid());

/* chuks pagination*/
/// Added for pagination
int numRecordsPerPage = 0;
if (request.getParameter("recordsPerPage") != null){
  numRecordsPerPage = Integer.parseInt(request.getParameter("recordsPerPage"));
}else{ numRecordsPerPage = 25;}
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
    int numRows = BeneResult1.length;
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
  BeneResult1 = BeneDetails.getBeneficiaryPage(BeneResult1, startIndex, numRecordsPerPage);
 /* chuks */
/*
String selectQuery =  "SELECT * FROM LOGIN where STATUS ='"+status+"' ";
if((branch.equals("000")||branch.equals("ALL"))&&((role_id == null)||(role_id.equals("ALL")))){
	selectQuery = selectQuery + " WHERE HOSTBRANCH <> '000' ";
}else if((branch.equals("ALL")||branch.equals("000")) && (!((role_id == null) || (role_id.equals("ALL"))))){
 	selectQuery = selectQuery + " WHERE ROLEID = '"+role_id+"' ";
	
}else if(!((branch.equals("ALL"))||(branch.equals("000"))) && ((role_id == null) || (role_id.equals("ALL")))){
	selectQuery = selectQuery + " WHERE HOSTBRANCH = '"+branch+"' ";
}else if((branch.equals("ALL"))&&((role_id != null) &&(role_id.equals("ALL")))){	
	selectQuery = selectQuery;
}else{ 
 	selectQuery = selectQuery + " WHERE HOSTBRANCH = '"+branch+"' AND ROLEID = '"+role_id+"' ";		
	// Revisit this Logic later cheers
	//selectQuery = selectQuery;
 } 
 selectQuery = selectQuery + " ORDER BY FULLNAME"; 


String selectQuery =  "SELECT * FROM AP_GB_LOGIN WHERE STATUS ='"+status+"' ";
System.out.println(selectQuery);
if((branch.equals("000")||branch.equals("ALL"))&&((role_id == null)||(role_id.equals("ALL")))){
	selectQuery = selectQuery + " AND HOSTBRANCH <> '000' ";
}else if((branch.equals("ALL")||branch.equals("000")) && (!((role_id == null) || (role_id.equals("ALL"))))){
 	selectQuery = selectQuery + " AND ROLEID = '"+role_id+"' ";
	
}else if(!((branch.equals("ALL"))||(branch.equals("000"))) && ((role_id == null) || (role_id.equals("ALL")))){
	selectQuery = selectQuery + " AND HOSTBRANCH = '"+branch+"' ";
}else if((branch.equals("ALL"))&&((role_id != null) &&(role_id.equals("ALL")))){	
	selectQuery = selectQuery;
}else{ 
 	selectQuery = selectQuery + " AND HOSTBRANCH = '"+branch+"' AND ROLEID = '"+role_id+"' ";		
 } 
 selectQuery = selectQuery + " ORDER BY FULLNAME";
 */ 
 
//chuks 
/*
String selectQuery =  "SELECT * FROM ZENBASENET..ZIB_CIB_GB_LOGIN WHERE HOSTCOMPANY  = '"+login.getHostCompany()+"' AND STATUS ='"+status+"' ";

if((branch.equals(login.getHostBranch())||branch.equals("ALL"))&&((role_id == null)||(role_id.equals("ALL")))){
selectQuery = selectQuery;
	//selectQuery = selectQuery + " AND HOSTBRANCH <> '"+login.getHostBranch()+"' ";
}else if((branch.equals("ALL")||branch.equals(login.getHostBranch())) && (!((role_id == null) || (role_id.equals("ALL"))))){
 	selectQuery = selectQuery + " AND ROLEID = '"+role_id+"' ";
	
}else if(!((branch.equals("ALL"))||(branch.equals(login.getHostBranch()))) && ((role_id == null) || (role_id.equals("ALL")))){
	selectQuery = selectQuery + " AND HOSTBRANCH = '"+branch+"' ";
}else if((branch.equals("ALL"))&&((role_id != null) &&(role_id.equals("ALL")))){	
	selectQuery = selectQuery;
}else{ 
 	selectQuery = selectQuery + " AND HOSTBRANCH = '"+branch+"' AND ROLEID = '"+role_id+"' ";		
 } 
 selectQuery = selectQuery + " ORDER BY FULLNAME";
 */
 //System.out.println(" << branch >>" + branch);

        //selectQuery += " where status = '"+statusA+"' ";
if(rolegroup.trim().equalsIgnoreCase("Y"))
      {
         if (branch.equalsIgnoreCase("ALL") || branch == null)
         { 
                selectQuery =  " select  a.vendor_acct_no,a.vendor_name,a.vendor_bank_branchRecID,a.vendor_bankname,a.vendor_id,a.status from  ZENBASENET..zib_cib_gb_beneficiary a, ZENBASENET..zib_cib_bene_fileupload b ";
                selectQuery += " where a.batchid = b.batchid and b.group_roleid = "+Integer.parseInt(login.getgrouproleid())+" and a.COMPANY_ID  = '"+login.getHostCompany()+"' AND a.status = '"+statusA+"' and a.approved = "+Integer.parseInt(recstatus)+" ";
         }
         else
         {
                selectQuery =  " select  a.vendor_acct_no,a.vendor_name,a.vendor_bank_branchRecID,a.vendor_bankname,a.vendor_id,a.status from  ZENBASENET..zib_cib_gb_beneficiary a, ZENBASENET..zib_cib_bene_fileupload b ";
                selectQuery += " where a.batchid = b.batchid and b.group_roleid = "+Integer.parseInt(login.getgrouproleid())+" and a.COMPANY_ID  = '"+login.getHostCompany()+"' AND a.payment_type = '"+branch+"' and a.status = '"+statusA+"' and a.approved = "+Integer.parseInt(recstatus)+" ";
         }
     }
 else      
     {
         if (branch.equalsIgnoreCase("ALL") || branch == null){ 
                selectQuery =  " select  vendor_acct_no,vendor_name,vendor_bank_branchRecID,vendor_bankname,vendor_id,status from  ZENBASENET..zib_cib_gb_beneficiary ";
                selectQuery += " where COMPANY_ID  = '"+login.getHostCompany()+"' AND status = '"+statusA+"' and approved = "+Integer.parseInt(recstatus)+" ";
         }else{
                selectQuery =  " select  vendor_acct_no,vendor_name,vendor_bank_branchRecID,vendor_bankname,vendor_id,status from  ZENBASENET..zib_cib_gb_beneficiary ";
                selectQuery += " where COMPANY_ID  = '"+login.getHostCompany()+"' AND payment_type = '"+branch+"' and status = '"+statusA+"' and approved = "+Integer.parseInt(recstatus)+" ";
         }
    }
 //chuks */
   //////
         java.text.SimpleDateFormat timestamp  = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss a"); 
         AuditManager adm = new AuditManager();//CIB AUDIT
         AuditValue audit = new AuditValue();//CIB AUDIT
         audit.setCompany_code(login.getHostCompany());
         audit.setBranch_code(login.getHostBranch());
         audit.setTable_name("ZIB_CIB_GB_BENEFICIARY");
         audit.setObj_name("PAYMENT");
         audit.setAcct_perfmd("Viewed Beneficiary List");
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
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Internet Banking: Beneficiaries List</title>
<link href="css/zs.css" rel="stylesheet" type="text/css" />
<link href="css/GenericStylesheet.css" rel="stylesheet" type="Text/CSS" />
<script src="javascript/GenericJavaScript1.js" type="text/javascript" language="javascript"></script>
<script type="text/javascript" charset="utf8" src="<%=dtUrl %>/js/jquery.js"></script>

</head>

<body class="parentBody" id="div_body">
<FORM action="" method = "POST" name='roleform'>
<DIV align="center">
   <TABLE frame='Void' rules='None' summary='Body-table' border='0' cellspacing='0' cellpadding='0' class='OuterTableCurve'>
       <TBODY>
          <TR>
             <TD align='Left' dir='LTR' style='vertical-align:top;'><IMG width='' alt='' src='images/LeftTopFFFFFF.gif' height='' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:top; color:#FFFFFF;'></TD><TD align='Right' dir='RTL' style='vertical-align:top;'><IMG width='' alt='' src='images/RightTopFFFFFF.gif' height='' class='AngularCurves' /></TD>
          </TR>
       </TBODY>
       <TBODY>
          <TR>
             <TD colspan='3' align='center' style='width:100%; padding:0px 2px 0px 2px;'>
               <TABLE frame='Void' rules='None' summary='Body-table' border='0' cellspacing='0' cellpadding='0' class='InnerTableCurve'>
                 <TBODY>
                   <TR>
                     <TD align='Left' dir='LTR' style='vertical-align:top;'><IMG width='' alt='' src='images/LeftTopCCCCCC.gif' height='' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:top; color:#FFFFFF;'></TD><TD align='Right' dir='RTL' style='vertical-align:top;'><IMG width='' alt='' src='images/RightTopCCCCCC.gif' height='' class='AngularCurves' /></TD>
                   </TR>
                 </TBODY>
                 <TBODY>
                   <TR>
                     <TD colspan='3' align='center' style='padding:0px 3px 0px 3px;'>
                        <DIV class='HeaderText1' style='text-align:center;'>Beneficiary List</DIV>
                        <DIV class='HeaderTailText' style='text-align:center;'>This feature allows users to view the list of Beneficiaries</DIV>
	             </TD>
                   </TR>
                 </TBODY>
                 <TBODY>
                   <TR>
                     <TD align='Left' dir='LTR' style='vertical-align:bottom;'><IMG width='' alt='' src='images/LeftBottomCCCCCC.gif' height='' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:bottom;'></TD><TD align='Right' dir='RTL' style='vertical-align:bottom;'><IMG width='' alt='' src='images/RightBottomCCCCCC.gif' height='' class='AngularCurves' /></TD>
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
                     <TD align='Left' dir='LTR' style='vertical-align:top;'><IMG width='' alt='' src='images/LeftTopCCCCCC.gif' height='' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:top; color:#FFFFFF;'></TD><TD align='Right' dir='RTL' style='vertical-align:top;'><IMG width='' alt='' src='images/RightTopCCCCCC.gif' height='' class='AngularCurves' /></TD>
                   </TR>
                 </TBODY>
                 <TBODY>
                   <TR>
                     <TD colspan='3' align='center' style='padding:0px 3px 0px 3px;'>
                         <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
      			   <TR>
                             <TD style='width:100%;'>      			    
	  			<INPUT type = hidden name = np value = "" />
                                <INPUT type = hidden name = sel value = "0" />
                                <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%; font-size:0.9em;'>
                                   <TR>
                                     <TD rowspan='2' class='GenericTableCell' style='width:10%;'><DIV class='NavyText'><STRONG>Filter By:</STRONG></DIV></TD>
                                     <TD class='GenericTableCell' style='width:12%; text-align:right;'><DIV class='NavyText_Right'>Payment Type:</DIV></TD>
                                     <TD class='GenericTableCell' style='width:33%; text-align:left;'>      			    
                                        <SELECT name="BRANCH" onChange="filterUser(this.form)" class='Selectbox' style='width:50%;'>
                                            <OPTION value="ALL" >ALL</OPTION>
                                            <%			   
                                               for(int index = 0; index < BeneResult.length; index++){
                                                   //com.zenithbank.banking.coporate.ibank.form.Branch userBranch = (com.zenithbank.banking.coporate.ibank.form.Branch)branches.elementAt(index);
                                                   //if(userBranch.getCode().equals(branch)){
                                                   String valStr = BeneResult[index].getpaymenttype(); 
                                            %>
                                                   <OPTION value="<%=BeneResult[index].getpaymenttype().trim()%>" <%=(valStr.trim().equalsIgnoreCase(branch)? "SELECTED" : "" )%>><%=BeneResult[index].getpaymenttype()%> </OPTION>
                                            <%       
                                                }
                                            %>
                                        </SELECT>
                                        &nbsp;
                                        <INPUT type="button" style='width:37%;' name="Add" value="Add" class="Button1" onclick="javascript:doAdd(this.form)" />
                                        &nbsp;<INPUT type="button" style='width:20%;' name="SearchBeneficiary" value="Search" class="Button1" onclick="javascript:location.replace('searchBeneficiaries.jsp')" />
                                     </TD>
                                     <TD colspan='2' class='GenericTableCell_Right' style='width:45%;'>
                                         <SPAN class='NavyText_Right'>Status:</SPAN>&nbsp;
                                         <SELECT name="STATUS" id="STATUS" onChange="filterUser(this.form)" class='Selectbox' style='width:35%;'>
                                            <%=new com.dwise.util.HtmlUtilily().getResource1(request.getParameter("STATUS"),"SELECT STATUSID, STATUS FROM ZENBASENET..ZIB_CIB_GB_STATUS ")%> 
                                         </SELECT> 
                                     </TD>
                                   </TR>
                                   <TR>
                                     <TD class='GenericTableCell' style='width:12%; text-align:right;'><DIV class='NavyText_Right'>Record Status:</DIV></TD>
                                     <TD class='GenericTableCell' style='width:33%; text-align:left;'>    
                                         <SELECT name="RECSTATUS" id="RECSTATUS" onChange="filterUser(this.form)" class='Selectbox' style='width:90%;'>
                                            <%=new com.dwise.util.HtmlUtilily().getResource1(request.getParameter("RECSTATUS"),"SELECT RECSTATUSID, RECSTATUS FROM ZENBASENET..ZIB_CIB_GB_RECSTATUS ")%>
                                         </SELECT> 
                                     </TD>
                                     <TD colspan='2' class='GenericTableCell_Right' style='width:45%;'>
                                        <SPAN class='NavyText_Right'>Output Per Page:</SPAN>&nbsp;
                                        <SELECT name="recordsPerPage" id="recordsPerPage" onChange = "filterUser(this.form)" class='Selectbox' style='width:35%;'>
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
                                </TABLE>
                             </TD>
                           </TR>
                           <TR>
                             <TD class='GenericTableCell' style='width:100%;'>
				<DIV align='center' style=''>
                                <TABLE frame='Box' rules='All' summary='SUB-table' border='1' cellspacing='0' cellpadding='0' class='GenericTable1' style='width:100%; font-size:0.9em;'>
                                     <THEAD>
                                       <TR>
                                           <TD class='BACKimage1 GenericTableHeader'><input type="checkbox"  id="allCheckbox" /></TD>
                                          <TD class='BACKimage1 GenericTableHeader'>S/N</TD>
                                          <TD class='BACKimage1 GenericTableHeader'>Account Number</TD>
                                          <TD class='BACKimage1 GenericTableHeader'>Beneficiary Name</TD>
                                          <TD class='BACKimage1 GenericTableHeader'>Beneficiary Code</TD>
                                          <TD class='BACKimage1 GenericTableHeader'>Bank Name</TD>
                                          <TD class='BACKimage1 GenericTableHeader'>Sort Code</TD>
                                          <TD class='BACKimage1 GenericTableHeader'>Status</TD>
                                          <TD class='BACKimage1 GenericTableHeader'>Edit Details</TD>
                                       </TR>
                                     </THEAD>
                                     <%
                                            try {
                                                con = connect.getConnection();
                                                stmt = con.createStatement();
                                                /// System.out.println(selectQuery);
                                                rs = stmt.executeQuery(selectQuery);
                                                int ia = 0;
                                                for ( ia=0; ia < BeneResult1.length; ) {
                                    %>
                                                  <TR>    
                                                  <TD class='GenericTableCell NavyText'>
                                                      <input type="checkbox" data-id ="<%=BeneResult1[ia].getvendor_id()%>"  class="rowCheckbox" />
                                                      </TD>  
                                                    <TD class='GenericTableCell NavyText'><%=startIndex+ia+1%></TD>
                                                    <TD class='GenericTableCell NavyText'><%=BeneResult1[ia].getvendor_acct_no()%></TD>
                                                    <TD class='GenericTableCell NavyText'><%=BeneResult1[ia].getvendor_name()%></TD>
                                                    <TD class='GenericTableCell NavyText'><%=BeneResult1[ia].getvendor_code()%></TD>
                                                    <TD class='GenericTableCell NavyText'><%=BeneResult1[ia].getvendor_bankname()%></TD>
                                                    <TD class='GenericTableCell NavyText'><%=BeneResult1[ia].getvendor_bank_branchRecID()%></TD>
                                                    <TD class='GenericTableCell NavyText'><%=BeneResult1[ia].getSTATUS()%></TD>
                                                    <TD class='GenericTableCell NavyText'><DIV align='center'><A href='EditBeneficiaries.jsp?voptions=2&STATUS=<%=status%>&REGION_CODE=<%=roleId%>&vendor_id=<%=BeneResult1[ia].getvendor_id()%>' class='BlueMenuLinks' /><IMG src="images/detail.gif" border="0"/></A></DIV></TD>
                                                  </TR>
                                    <%
                                                   ia++;
                                                }
                                                /* chuks pagination*/
                                                //added by Okuwa for pagination
                                                String disableNext = "";
                                                String disablePrevious = "";
                                                String disableFirst = "";
                                                String disableLast = "";
                                                System.out.println("startIndex>>"+startIndex);
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
                                                <TD colspan='8' style='font-size:1em;' class='GenericTableCell'>
                                                    <INPUT type="hidden" name="stIndex" value="" />
                                                    <DIV align="center">
                                                       <INPUT type="button" style='width:18%;' name="btnFirst" id="btnFirst" value="First" class="Button1" onclick="doFirst(this.form)" <%=disableFirst%> />
                                                       <INPUT type="button" style='width:18%;' name="btnPrevious" id="btnPrevious" value="Previous" class="Button1" onclick="doPrevious(this.form, <%=numRecordsPerPage%>, <%=startIndex%>)" <%=disablePrevious%> />
                                                       &nbsp;&nbsp;&nbsp;
                                                       <%
                                                            if (numRows == 1) {
                                                       %>
                                                                <SPAN class='BlackBoldText_Center'>Record <%=begin%> of <%=total%></SPAN>
                                                       <%
                                                            }
                                                            else if (numRows == 0) {
                                                        %>
                                                                <SPAN class='BlackBoldText_Center'>No Record</SPAN>
                                                        <%
                                                            }
                                                            else {
                                                        %>
                                                                <SPAN class='BlackBoldText_Center'>Records <%=begin%> to <%=end%> of <%=total%></SPAN>
                                                        <%	
                                                            }	
                                                        %>
                                                        &nbsp;&nbsp;&nbsp;
                                                        <INPUT type="button" style='width:18%;' name="btnNext" id="btnNext" value="Next" class="Button1" onclick="doNext(this.form, <%=numRecordsPerPage%>, <%=startIndex%>)" <%=disableNext%> />
                                                        <INPUT type="button" style='width:18%;' name="btnLast" id="btnLast" value="Last" class="Button1" onclick="doLast(this.form, <%=remain%>, <%=numRows%>)" <%=disableNext%> />
                                                    </DIV>
                                                </TD>
                                                <td> <INPUT type="button" Value="Action" id="doAction" /> </td>
                                              </TR>
                                <%
                                            //end   pagination
                                            /* chuks pagination */
                                            }
                                            catch(Exception ne) {
                                                    System.out.println(ne);
                                            }
                                            finally {
                                                    if (stmt != null) stmt.close();
                                                    if (rs != null) rs.close();
                                                    if (con != null) con.close();
                                            }
                                %>
                               </TABLE>
                               </DIV>                            
                             </TD>
                           </TR>
                        </TABLE>
                     </TD>
                   </TR>
                 </TBODY>
                 <TBODY>
                   <TR>
                     <TD align='Left' dir='LTR' style='vertical-align:bottom;'><IMG width='' alt='' src='images/LeftBottomCCCCCC.gif' height='' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:bottom;'></TD><TD align='Right' dir='RTL' style='vertical-align:bottom;'><IMG width='' alt='' src='images/RightBottomCCCCCC.gif' height='' class='AngularCurves' /></TD>
                   </TR>
                 </TBODY>
               </TABLE>    
             </TD>
          </TR>
       </TBODY>
       <TBODY>
         <TR>
             <TD align='Left' dir='LTR' style='vertical-align:bottom;'><IMG width='' alt='' src='images/LeftBottomFFFFFF.gif' height='' class='AngularCurves' /></TD><TD align='Center' style='vertical-align:bottom;'></TD><TD align='Right' dir='RTL' style='vertical-align:bottom;'><IMG width='' alt='' src='images/RightBottomFFFFFF.gif' height='' class='AngularCurves' /></TD>
         </TR>
       </TBODY>
    </TABLE>
</DIV>
</FORM>



<script type='text/javascript'>

var itemModel = (function(){
       var items =[], 
       addItem  = function(item){  
       if(items.indexOf(item) >-1){
       return false;
       }
       items.push(item);
       return true;
       },
       
       removeItem = function(item){
       var index = items.indexOf(item) ;
       if(index >-1){
        items.splice(index, 1);
        return true;
       }
       return false;
       }, 
       
       addItems = function(array){
       var i ;
         for(i=0; i< array.length; i++){
           addItem(array[i]);
         }
       },
           
       removeItems = function(array){
         var i ;
         for(i=0; i< array.length; i++){
           removeItem(array[i]);
         }
       },
       clear = function(){
        items = [];
       },
       size = function(){
         return items.length;        
        },
        allItems = function(){
        return items.join(",");
        } ;
       
      return{
        addItems : addItems,
        removeItems : removeItems,
        size : size,
        clear : clear,
        allItems : allItems
       };
       
  })();
  
$(function(){
       
       $(".rowCheckbox").click(function(event){
                   var data_id = $(this).attr("data-id");
                   var array = [data_id];
                    event.stopPropagation();
                   if(this.checked){
                      itemModel.addItems(array);
                       }
                  else{
                   itemModel.removeItems(array); 
                   }
         });
         
      $("#allCheckbox").click(function(event){
   
      event.stopPropagation();
      var $checkBoxes =  $(".rowCheckbox");
      var ids =[];
        
        if(this.checked){
          $checkBoxes.each(function(i, obj){
            if(!obj.checked){
              ids.push($(this).attr("data-id"));
              obj.checked = true;
            }
          });
          itemModel.addItems(ids);  
            }
        else{
        
         $checkBoxes.each(function(i, obj){
            if(obj.checked){
              ids.push($(this).attr("data-id"));
              obj.checked = false;
            }
          });   
         itemModel.removeItems(ids);
             }
             
      });
 
     $("#doAction").click(function(event){
         event.stopPropagation();
          if(!itemModel.size()){
          alert("Please select a beneficiary ");
          return;
          }
          else{
          if(  confirm("Are you sure you want to approve "+itemModel.size()+" item(s)" ))
          {
          $.post("setBeneficiaryStatus.jsp", {items : itemModel.allItems()}, function(data){
            console.log(data);
             if(data && data.trim() === "success"){
               window.location = "BeneficiaryList.jsp";
             }
             else{
               alert("Error Occured : " + data);
             }
           });       
          }
          
            return;
          }
     });
     
 });




    function filterUser(form)
    {
    //window.location = "BeneficiaryList.jsp?BRANCH="+form.BRANCH.value+"&ROLE="+form.ROLE.value+"&STATUS="+form.STATUS.value
    window.location = "BeneficiaryList.jsp?BRANCH="+form.BRANCH.value+"&RECSTATUS="+form.RECSTATUS.value+"&STATUS="+form.STATUS.value+"&recordsPerPage="+form.recordsPerPage.value
    }
    
    function doAdd(form)
    {
    window.location = "beneficiaries.jsp"
    }
    function doDel(form)
    {
    if (!checkSelected(form)) return false;
    form.action = "frontendcontroller.jsp";
    form.np.value="BeneficiaryList";
    form.sel.value = '1'
    form.submit();
    }
    function deleteRecord(form){
      //var form = document.forms[0];
      var parString = "";
      var delcount = 0;
      for(var i = 0; i < form.elements.length; ++i)
       if(form.elements[i].type == "checkbox" & form.elements[i].name == 'C2')
        if(form.elements[i].checked == true){
            delcount++;
          parString =  parString + "-" + form.elements[i].value+"-* ";
          }
    
      if(parString == "") {
       window.alert("Select record(s) to delete...");
       return (false);
      }
      else {
            //delcount = delcount - 1;
            ans=window.confirm("You have selected " + delcount + " record(s), for deletion ?")
      if (ans==1){
       form.op.value="DEL";
       form.VAR1.value=parString.substring(0, parString.length -2);
       form.VAR2.value=form.datarows.value;
       form.submit();
       return (true);
            }
       else{
        return (false);
            }
       }
      }
    function checkSelected(form){
      //var form = document.forms[0];
      var parString = "";
      var delcount = 0;
      for(var i = 0; i < form.elements.length; ++i)
       if(form.elements[i].type == "checkbox" & form.elements[i].name == 'C2')
        if(form.elements[i].checked == true){
            delcount++;
          parString =  parString + "-" + form.elements[i].value+"-* ";
          }
    
      if(parString == "") {
       window.alert("Select record(s) to continue...");
       return (false);
      }
      else {
            //delcount = delcount - 1;
            ans=window.confirm("You have selected " + delcount + " record(s), Are your sure ?")
            if (ans == 1)
            return true; 
            else return false 
       }
      }
    
      function doClickAll(form) {
            for (var i = 0; i < form.elements.length; i++) {
                    if ( form.elements[i].type == "checkbox" ) {
                            if ( ! form.elements[i].checked ) { form.elements[i].click();
                            }
                    }
        }
            return true;
      }
    
      function doUnClickAll(form) {
            for (var i = 0; i < form.elements.length; i++) {
                    if ( form.elements[i].type == "checkbox" ) {
                            if (  form.elements[i].checked ) { form.elements[i].checked = false;
                            }
                    }
            }
            return true;
      }
      
      /* chuks pagination */
     
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
    /* chuks pagination */
</script>
</body>
</html>
