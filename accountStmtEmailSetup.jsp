 <%@ page language="java" import = "javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.* ,java.util.Calendar,java.util.Hashtable" session="true" %><html>
<%
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");

if (login == null)
{
response.sendRedirect("/coporate-internetbanking/sessiontimeout.jsp");
}    
if ( login.getPasschange().equals("1"))
{
response.sendRedirect("ChangePwd.jsp");
}

String no_of_days = "";
int maxid = 0;
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
BaseAdapter connect = new BaseAdapter();
java.util.Vector cart = new java.util.Vector();
String username = login.getLoginId();
String fullname = login.getFullname();
int roleid = Integer.parseInt(login.getRoleid());
int userid = login.getSeq();
String accessCode = login.getAccesscode();
String CompanyId = login.getHostCompany();
String buttonName = request.getParameter("Save");
if (buttonName == null) buttonName = "";
//if(buttonName.trim().length() > 0){
String companyCode = CompanyId;
String tableid = request.getParameter("TABLEID");
System.out.println(" tableid " + tableid);
String email = request.getParameter("email");
String accountNo = request.getParameter("ACCOUNT_NO");
String accountName = request.getParameter("ACCOUNT_NAME");//
String status = request.getParameter("STATUS");

/*ISW Charge account & Amount*/
String charge_acct_no = request.getParameter("charge_acct_no");
if (charge_acct_no == null) charge_acct_no = "";
String charge_amount = request.getParameter("CHARGE_AMOUNT");
double charge_amount_d = 0.00 ;
if ((charge_amount == null) || (charge_amount.trim().equalsIgnoreCase(""))) 
charge_amount = "0.00";//default
charge_amount_d = Double.parseDouble(charge_amount);
String bulk_isw_charge = request.getParameter("BULK_ISW_CHARGE");
if(bulk_isw_charge == null) bulk_isw_charge = "N";
/*ISW Charge account & Amount*/

Connection con = null;
PreparedStatement ps = null;
Statement stmt = null;
ResultSet rs = null;

String option = request.getParameter("voptions");

//System.out.println("option " + option);
if (tableid == null) tableid = "";
if (option == null) option = "";
if (companyCode == null) companyCode = "";

if(email == null) email = "";
if(accountNo == null) accountNo = "";
if(accountName == null) accountName = "";

String acct_no = "";
String acct_status = "";
String title_1 = "";
String acct_type = "";
String appl_type = "";
String branch_no = "";
String name_1 = "";
String short_name = "";
String BranchNameValue = "";

//if(request.getParameter("submit2") != null)
//{
    //if (to_acct_no != null)

/*
    if (accountNo.length() > 0)
    {
//    java.sql.Connection con = connect.getConnection();
       con = connect.getConnection();
    try
    {
    //String sql = "SELECT acct_no,status,title_1,acct_type,appl_type FROM phoenix..dp_acct where acct_no = '"+request.getParameter("txtAccountNo")+"'";
	String sql = "SELECT a.acct_no,a.status,a.title_1,a.acct_type,a.appl_type,a.branch_no,b.name_1, b.short_name FROM phoenix..dp_acct a , phoenix..ad_gb_branch b where a.acct_no = '"+request.getParameter("ACCOUNT_NO")+"'";
             sql += " and a.branch_no = b.branch_no ";
    //System.out.println(sql);
    //java.sql.Statement stmt = con.createStatement();
    stmt = con.createStatement();
    //java.sql.ResultSet rs = stmt.executeQuery(sql);
    rs = stmt.executeQuery(sql);
    
    if (rs.next()){
      acct_no = rs.getString("acct_no"); 
      acct_status = rs.getString("status");
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
	System.out.println("name_1.length() " + name_1.length());
    if (name_1.length() <= 0){ BranchNameValue = "";}
    else{ BranchNameValue = name_1 + " - " + short_name;} 
    }
    accountName = title_1;
System.out.println("accountName " + accountName);
System.out.println("BranchNameValue " + BranchNameValue);
*/



//System.out.println( "<< acct_no >> " + acct_no);
//System.out.println( "<< status >> " + status);
/*
if (mode.trim().equalsIgnoreCase("ZENITH/BENEFICIARY") && status.trim().equalsIgnoreCase("Active")){
    //System.out.println( "<< title_1 >> " + title_1);
    txtBeneficiaryName = title_1;
}
*/

//

int duplicate = -1;
java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("dd/MM/yyyy");
			
			try
			{
      
      //begin
      
        if (accountNo.length() > 0)
    {
//    java.sql.Connection con = connect.getConnection();
       con = connect.getConnection();
    try
    {
    //String sql = "SELECT acct_no,status,title_1,acct_type,appl_type FROM phoenix..dp_acct where acct_no = '"+request.getParameter("txtAccountNo")+"'";
	String sql = "SELECT a.acct_no,a.status,a.title_1,a.acct_type,a.appl_type,a.branch_no,b.name_1, b.short_name FROM phoenix..dp_acct a , phoenix..ad_gb_branch b where a.acct_no = '"+request.getParameter("ACCOUNT_NO")+"'";
             sql += " and a.branch_no = b.branch_no ";
    //System.out.println(sql);
    //java.sql.Statement stmt = con.createStatement();
    stmt = con.createStatement();
    //java.sql.ResultSet rs = stmt.executeQuery(sql);
    rs = stmt.executeQuery(sql);
    
    if (rs.next()){
      acct_no = rs.getString("acct_no"); 
      acct_status = rs.getString("status");
      title_1 = rs.getString("title_1");
      acct_type = rs.getString("acct_type");
      appl_type = rs.getString("appl_type");
	    branch_no = rs.getString("branch_no");
      name_1 = rs.getString("name_1");
      short_name = rs.getString("short_name");
    }
    }catch(Exception e){
      e.printStackTrace();
      
    }
    
   /* close connection in the outer finally block
    finally{
      if (con != null) con.close(); 
    }
    */
    
    
	///System.out.println("name_1.length() " + name_1.length());
    if (name_1.length() <= 0){ BranchNameValue = "";}
    else{ BranchNameValue = name_1 + " - " + short_name;} 
    }
    accountName = title_1;
///System.out.println("accountName " + accountName);
///System.out.println("BranchNameValue " + BranchNameValue);
///System.out.println("acct_status " + acct_status);
//end
	if (option.equals("1"))
			{
			try{
    con = connect.getConnection();
    stmt = con.createStatement();
	rs = stmt.executeQuery("SELECT COMPANY_CODE FROM ZENBASENET..zib_cib_gb_acctstmt_email WHERE COMPANY_CODE ='"+companyCode+"' AND USERID ='"+userid+"' AND email = '"+email+"'");
	 if (rs.next())
	 { duplicate = 1;  }
   }catch(Exception ne)
   {
   ne.printStackTrace();
   }finally{if (stmt != null) stmt.close();
            if (con != null) con.close();
   }
	             con = connect.getConnection();
			     stmt = con.createStatement();
	             rs = stmt.executeQuery("SELECT ISNULL (MAX(TABLE_ID)+1,1) FROM ZENBASENET..zib_cib_gb_acctstmt_email");
	             if (rs.next()) { maxid = rs.getInt(1);}
			
				con = connect.getConnection();
                ps = con.prepareStatement("INSERT INTO ZENBASENET..zib_cib_gb_acctstmt_email (COMPANY_CODE,USERID,ROLEID,ACCESSCODE,EMAIL,CREATEDBY,FULLNAME) VALUES(?,?,?,?,?,?,?)"); 
				ps.setString(1,companyCode);
                                ps.setInt(2,userid);
                                ps.setInt(3,roleid);
                                ps.setString(4,accessCode);
				ps.setString(5,email);
				ps.setString(6,username);
                                ps.setString(7,fullname);
                                
                        
       			
		       	
        		
				if (duplicate == -1)
               {
				ps.executeUpdate();
				out.println("<script>window.location = 'accountStmtEmailList.jsp'</script>");
		}
		else
         {
        out.println("<script>alert('Duplicate Set up,This user is already setup ')</script>");
        out.println("<script>window.location = 'accountStmtEmailSetup.jsp'</script>");
        }
			}else if (option.equals("2"))
			{
				con = connect.getConnection();
				stmt = con.createStatement();
				rs = stmt.executeQuery("SELECT * FROM ZENBASENET..zib_cib_gb_acctstmt_email WHERE COMPANY_CODE ='"+companyCode+"' and TABLE_ID = "+request.getParameter("TABLEID")+"");
				if (rs.next())
				{
				tableid = String.valueOf(rs.getInt("TABLE_ID"));
				companyCode = rs.getString("COMPANY_CODE");
                                email = rs.getString("email");
                                fullname = rs.getString("fullname");
	                      
				}		
			}else if (option.equals("3")){
                        
                        
					con = connect.getConnection();
					ps = con.prepareStatement("UPDATE ZENBASENET..zib_cib_gb_acctstmt_email SET EMAIL = ?,MODIFIEDBY = ?,MODIFIED = GETDATE() WHERE COMPANY_CODE = ? and TABLE_ID = ? ");
					ps.setString(1,request.getParameter("email"));
					ps.setString(2,username);
					ps.setString(3,companyCode);
					ps.setInt(4,Integer.parseInt(request.getParameter("TABLEID")));
 			                ps.executeUpdate();
         

              out.println("<script>window.location = 'accountStmtEmailList.jsp'</script>");			
				}
			}catch(Exception ne){
				System.out.println(ne);
				ne.printStackTrace();
			}finally{
				if (ps != null) ps.close();
				if (con != null) con.close();
			}
%>
<html>
  <head>
    <meta http-equiv="Content-Language" content="en-us">
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <meta http-equiv = "PRAGMA" content ="NO-CACHE">
    <link href="css/GenericStylesheet.css" rel="stylesheet" type="Text/CSS" />
    <script src="javascript/GenericJavaScript1.js" type="text/javascript" language="javascript"></script>
    <title>Account Statement Email Setup</title>
    <script src="js/jssecure.js" type="text/javascript" language="javascript"></script>
    <script  type="text/javascript">
        function dosubmit(form)
        {
            //var accountno = form.ACCOUNT_NO.value;
            var email = form.email.value;
            form.action = "accountStmtEmailSetup.jsp" ;
            form.submit();
        }
        
        function doAccount(form)
        {
        form.action = "AdminHome.jsp?np=accountStmtEmailSetup";
        form.sel.value 
        form.AccessCode.value 
        form.COMPANY_CODE.value 
        form.submit();
        }
        function doSave(form)
        {
        
        if (!(validateEntry(form))) return false
        
        form.action = "accountStmtEmailSetup.jsp";
        var selected = "2" ;
        
        if(form.B1.value == "Create"){
               
                form.voptions.value = "1"
                
                }
                if(form.B1.value == "Save"){
                form.voptions.value = "3"
                }
        form.submit();
        }//
        function validateEntry(form)
        {
          if (!(form.email.value.length > 0))
            {
            alert('Please enter the email address ')
            form.email.focus()
            return false;
            }
          
          validateEmailAddress();  
            
            
            
        /*
        if (!(form.ACCOUNT_NO.value.length > 0))
        {
        alert('Please enter the account no')
        form.ACCOUNT_NO.focus()
        return false;
        }
        
        if (!(form.ACCOUNT_NAME.value.length > 0))
        {
        alert('Please , the Account Name cannot be blank')
        form.ACCOUNT_NO.focus()
        return false;
        }
        
        if(form.B1.value == "Submit"){
                if (!((form.ACCOUNT_STATUS.value == "Active")||(form.ACCOUNT_STATUS.value == "ACTIVE")))
                {
                alert('Please enter an Account Number that is Active');
                form.ACCOUNT_NO.focus();
                return false;
                }
        }
        
        //else return true
         
           */
           return true;
        }
        
        function validateEmailAddress()
            {
                var x=form.email.value;
                var atpos=x.indexOf("@");
                var dotpos=x.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
              {
              alert("Not a valid e-mail address");
              form.email.focus()
              return false;
              }
            }
      
      //  }
    </script>
  </head>
  
  <body class="parentBody" id="div_body">
    <DIV align="center">
        <form method = "POST" name='form' onSubmit="return validateEntry(this);">	
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
                                <DIV class='HeaderText1' style='text-align:center;'>Email Setup for Monthly Account Statement </DIV>
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
                                <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                   <TR>
                                     <TD class='GenericTableCell' style='width:100%;'>
                                        <INPUT type = hidden name = 'np' value = "region" />
                                        <INPUT type = hidden name = 'voptions' value = "0" />	
                                        <INPUT type = "hidden" name = "sel" value="0" />
                                        <INPUT type = hidden name = 'TABLENAME' value = "REGION" />
                                        <INPUT type = hidden name = 'ROWLOCATOR' value = "REGION_CODE" />
                                        <INPUT type = hidden name = 'VALLOCATOR' value = "<%=companyCode%>" />
                                        <DIV style='height:250px; overflow-y:auto; overflow-x:hidden;'>
                                        <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                          <TBODY>
                                            <%
                                                if( tableid.trim() != "") {
                                            %>
                                                    <TR>
                                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'><LABEL for="ID">ID:</LABEL></DIV></TD>
                                                      <TD class='GenericTableCell' style='width:30%;'>
                                                        <INPUT name="TABLEID" value="<%=tableid%>"  id="TABLEID" maxlength ="10" readonly = "readonly" class='Textbox' style='width:100%' type="text" />
                                                      </TD>
                                                      <TD class='GenericTableCell' style='width:45%;'>&nbsp;</TD>
                                                    </TR>
                                            <%  
                                                }
                                            %>
                                                   
                                                   <TR>
                                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'><LABEL for="Email">
                      FullName
                     </label></DIV></TD>
                                                      <TD class='GenericTableCell' style='width:30%;'>
                                                        <%      
                                                            if ((option == null)||(option.equals(""))||(option.equals("0"))) {
                                                        %>
                                                               
                                                                <INPUT name="fullname" id="fullname" value="<%=fullname%>" size="53" class='Textbox' style='width:100%' type="text" />			 
                                                        <%  
                                                            }
                                                            else{
                                                        %>
                                                                <INPUT name="fullname" value="<%=fullname%>" size="53" class='Textbox' style='width:100%' type="text" /> 
                                                        <%
                                                            }
                                                        %>
                                                      </TD>
                                                      <TD class='GenericTableCell' style='width:45%;'>&nbsp;</TD>
                                                    </TR>
                                                   
                                                   
                                                    <TR>
                                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'><LABEL for="Email">Email:</LABEL></DIV></TD>
                                                      <TD class='GenericTableCell' style='width:30%;'>
                                                        <%      
                                                            if ((option == null)||(option.equals(""))||(option.equals("0"))) {
                                                        %>
                                                                <!--INPUT name="email" id="email" value="<%=email.trim()%>" size="53" onBlur="dosubmit(this.form)" class='Textbox' style='width:100%' type="text" /-->			 
                                                                <INPUT name="email" id="email" value="<%=email.trim()%>" size="53" class='Textbox' style='width:100%' type="text" />			 
                                                        <%  
                                                            }
                                                            else{
                                                        %>
                                                                <INPUT name="email" value="<%=email.trim()%>" size="53" class='Textbox' style='width:100%' type="text" /> 
                                                        <%
                                                            }
                                                        %>
                                                      </TD>
                                                      <TD class='GenericTableCell' style='width:45%;'>&nbsp;</TD>
                                                    </TR>
                                                                                
                                            <TR>
                                              <TD class='GenericTableCell' style='width:25%;'>&nbsp;</TD>
                                              <TD class='GenericTableCell_Center' style='width:30%;'>
                                                <INPUT type="button" style='width:40%;' name="B1" <%if((option == null)||(option.equals("")||(option.equals("0")))){%>value="Create" <%}else{%>value="Save"<%}%> onClick="javascript:doSave(this.form)" />
                                              </TD>
                                              <TD class='GenericTableCell' style='width:45%;'>
                                                <INPUT type="button" style='width:40%;' name="button" value="Close" class="Button1" onClick="location.replace('accountStmtEmailList.jsp')" />
                                              </TD>
                                            </TR>
                                          </TBODY>
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
  </body>
</html>
