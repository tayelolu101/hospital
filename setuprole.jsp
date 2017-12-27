<%@ page language="java" import = "javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.* ,java.util.Calendar,java.util.Hashtable,com.zenithbank.banking.coporate.ibank.audit.*" errorPage="error.jsp" session="true" %><html>
<link href="css/zs.css" rel="stylesheet" type="text/css" />
<table border="0" width="614" bgcolor="#FFFFFF">

<%

java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("dd/MM/yyyy");
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
if (  login == null)
{
response.sendRedirect("/coporate-internetbanking/sessiontimeout.jsp");
}    
if ( login.getPasschange().equals("1"))
{
response.sendRedirect("ChangePwd.jsp");
} 
BaseAdapter connect = new BaseAdapter();
com.dwise.util.HtmlUtilily htmlUtil = new com.dwise.util.HtmlUtilily();
String roleId = request.getParameter("roleId");
String roleid = request.getParameter("C2");
String selres[] = request.getParameterValues("D1");
String assres[] = request.getParameterValues("D2");
String tflag = request.getParameter("tflag");
String company = request.getParameter("COMPANY");

Connection con = null;
Statement stmt = null;

/*Lanre - CIB ADMIN USER AUDIT */
ResultSet rs = null;
String resourceName = "";
String roleName = "";
String companyName = "";
/*Lanre - CIB ADMIN USER AUDIT */

String sql = "";
//System.out.println(roleid);
if (tflag == null) tflag = "0";
//
try{
	if (tflag.equals("1"))
	{
	con = connect.getConnection();
	stmt = con.createStatement();
	for(int i=0;i<selres.length;i++)
	{
		sql = "INSERT INTO ZENBASENET..ZIB_CIB_GB_ROLERESOURCE (RID,ROLEID) VALUES("+selres[i]+","+roleid+")";
		//System.out.println(sql);
		stmt.addBatch(sql);
/*lanre - CIB ADMIN USER AUDIT */
	sql = "SELECT RNAME FROM ZENBASENET..ZIB_CIB_GB_RESOURCE WHERE RID = "+selres[i];
	rs = stmt.executeQuery(sql);
	while(rs.next())
		{
    resourceName = rs.getString("RNAME");
		}

	sql = "SELECT ROLENAME FROM ZENBASENET..ZIB_CIB_GB_ROLE WHERE ROLEID = "+roleid;
	rs = stmt.executeQuery(sql);
	while(rs.next())
		{
    roleName = rs.getString("ROLENAME");
		}

	sql = "SELECT COMPANY_NAME FROM ZENBASENET..ZIB_CIB_GB_COMPANY WHERE COMPANY_CODE = '"+company+"'";
	rs = stmt.executeQuery(sql);
	while(rs.next())
		{
    companyName = rs.getString("COMPANY_NAME");
		}

		java.text.SimpleDateFormat timestamp  = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss a"); 
         AuditManager adm = new AuditManager();
         AuditValue audit = new AuditValue();
         audit.setCompany_code(login.getHostCompany());
         audit.setBranch_code(login.getHostBranch());
         audit.setTable_name("ZIB_CIB_GB_RESOURCE");
         audit.setObj_name("Added Privilege");
         audit.setAcct_perfmd("Added Privilege : "+resourceName+ " for Role:"+ roleName +" of Company :" + companyName);
         audit.setPrev_value("");
         audit.setCur_value("");
         audit.setIndex_tab_name("CREATE");
         audit.setEffective_date(timestamp.format(Calendar.getInstance().getTime()));
         audit.setAcct_date(timestamp.format(Calendar.getInstance().getTime()));
         audit.setIbank_id(login.getIbankid());
         audit.setLogin_id(login.getLoginId());
         audit.setAction_status("SUCCESSFUL");
         adm.createAdminAudit(audit);
/*lanre - CIB ADMIN USER AUDIT */
	}
	//execute now
	stmt.executeBatch();




	//to audit
	sql = "UPDATE ZENBASENET..ZIB_CIB_GB_ROLE SET MODIFIEDBY = '" + login.getLoginId() + "'  , MODIFIEDDT = getdate() WHERE ROLEID = "+roleid;
	stmt.execute(sql);
   // System.out.println(sql);
	//

	}else if (tflag.equals("2"))
	{
    con = connect.getConnection();
	stmt = con.createStatement();
	String para = "";
	for(int i=0;i<assres.length;i++)
		{
		para += ","+assres[i];
		sql = "DELETE FROM ZENBASENET..ZIB_CIB_GB_ROLERESOURCE WHERE RID IN ("+para.substring(1)+") AND ROLEID = "+roleid;
		stmt.addBatch(sql);
		System.out.println(sql);
/*lanre - CIB ADMIN USER AUDIT */
	sql = "SELECT RNAME FROM ZENBASENET..ZIB_CIB_GB_RESOURCE WHERE RID = "+assres[i];
	rs = stmt.executeQuery(sql);
	while(rs.next())
		{
    resourceName = rs.getString("RNAME");
		}

	sql = "SELECT ROLENAME FROM ZENBASENET..ZIB_CIB_GB_ROLE WHERE ROLEID = "+roleid;
	rs = stmt.executeQuery(sql);
	while(rs.next())
		{
    roleName = rs.getString("ROLENAME");
		}

	sql = "SELECT COMPANY_NAME FROM ZENBASENET..ZIB_CIB_GB_COMPANY WHERE COMPANY_CODE = '"+company+"'";
	rs = stmt.executeQuery(sql);
	while(rs.next())
		{
    companyName = rs.getString("COMPANY_NAME");
		}

		java.text.SimpleDateFormat timestamp  = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss a"); 
         AuditManager adm = new AuditManager();
         AuditValue audit = new AuditValue();
         audit.setCompany_code(login.getHostCompany());
         audit.setBranch_code(login.getHostBranch());
         audit.setTable_name("ZIB_CIB_GB_RESOURCE");
         audit.setObj_name("Removed Privilege ");
         audit.setAcct_perfmd("Removed Privilege : "+resourceName+ " for Role : "+ roleName +" of Company :" + companyName);
         audit.setPrev_value("");
         audit.setCur_value("");
         audit.setIndex_tab_name("DELETE");
         audit.setEffective_date(timestamp.format(Calendar.getInstance().getTime()));
         audit.setAcct_date(timestamp.format(Calendar.getInstance().getTime()));
         audit.setIbank_id(login.getIbankid());
         audit.setLogin_id(login.getLoginId());
         audit.setAction_status("SUCCESSFUL");
         adm.createAdminAudit(audit);
/*lanre - CIB ADMIN USER AUDIT */
}
//		stmt.execute(sql);
stmt.executeBatch();


	//to audit
	sql = "UPDATE ZENBASENET..ZIB_CIB_GB_ROLE SET MODIFIEDBY = '" + login.getLoginId() + "'  , MODIFIEDDT = getdate() WHERE ROLEID = "+roleid;
	stmt.execute(sql);
    System.out.println(sql);
	//
	}
}catch(Exception ne){
	System.out.println(ne);
	ne.printStackTrace();
}finally{
	if (stmt != null) stmt .close();
	if (con != null) con.close();
}
//String availableres = "";
//String assignedres = "";

String availableres  = htmlUtil.getResource1("","SELECT RID, RNAME FROM ZENBASENET..ZIB_CIB_GB_RESOURCE WHERE RID NOT IN (SELECT RID FROM ZENBASENET..ZIB_CIB_GB_ROLERESOURCE WHERE  ROLEID = "+roleid+")");
String assignedres = htmlUtil.getResource1(""," SELECT  A.RID, A.RNAME FROM ZENBASENET..ZIB_CIB_GB_RESOURCE A, ZENBASENET..ZIB_CIB_GB_ROLERESOURCE B WHERE A.RID = B.RID AND B.ROLEID = "+roleid+" ORDER BY A.RID ASC");

%>
	<tr>
		
    <td width="608" bgcolor="#666666"><font color="#FFFFFF" face="Verdana" size="2"><b> Role 
      Class Priviledges</b></font></td>
	</tr>
	<tr>
		<td bgcolor="#FFFFFF">
		<form method = "POST" name="priviledges">
		<input type = hidden name = np value = "setuprole">
		<input type = hidden name = 'tflag' value = "0">
		<table border="0" width="611" bgcolor="#FFFFFF" id="table2" cellspacing="1" cellpadding="3">
			<tr>
				
            <td width="59" bgcolor="#C0C0C0"><font face="Verdana" size="1"> Class 
              ID:</font></td>
				<td bgcolor="#C0C0C0" width="144"><font face="Verdana" size="1">
				<input type="hidden" name="C2" size="18" readonly = true value='<%=roleid%>'><%=roleid%></font></td>
				<td bgcolor="#C0C0C0" width="185"><font face="Verdana" size="1">Press Crtl key to Select Multiple </font></td>
				<td width="194" bgcolor="#C0C0C0">&nbsp;				</td>
			</tr>
			<tr>
				<td width="59" bgcolor="#C0C0C0">&nbsp;</td>
				
            <td bgcolor="#C0C0C0" width="144"><font face="Verdana" size="1"> Available 
              Priviledges</font></td>
            <td bgcolor="#C0C0C0" width="185"> <font face="Verdana" size="1">Assigned 
              Priviledge(s)</font></td>
				<td bgcolor="#C0C0C0">
				<input type=button name='add' class="input_button" value='Add' onclick='javascript:doAdd(this.form)'>
              <input type=button name='Del' class="input_button" value='Subtract' onclick='javascript:doDel(this.form)'></td>
			</tr>
			<tr>
				<td width="59" bgcolor="#C0C0C0" valign="top">&nbsp;
				</td>
				<td bgcolor="#C0C0C0" width="144">
				<select size="10" name="D1" multiple><%=availableres%></select></td>
				<td bgcolor="#C0C0C0" width="185">
				<p align="center"> 
                <select size="10" name="D2" multiple>
                  <option value="-1" selected>-- Add Priviledge --</option>
                  <%=assignedres%> 
                </select>
            </td>
				<td bgcolor="#C0C0C0">&nbsp;
				</td>
			</tr>
			
			<tr>
				<td width="59" bgcolor="#C0C0C0">&nbsp;</td>
				<td bgcolor="#C0C0C0" width="144">&nbsp;
				</td>
				<td bgcolor="#C0C0C0" width="185">
				<input name="button" type="button" class="input_button" id="button" value="Close" onClick = "javascript:getSecurityClass()"> 
            </td>
				<td bgcolor="#C0C0C0">&nbsp;</td>
			</tr>
		</table>
		</form>
		</td>
	</tr>
</table>
<script>
function doAdd(form)
{
form.action = "AdminHome.jsp?np=setuprole&COMPANY=<%=company%>";
form.tflag.value = '1'
form.submit();
}
function doDel(form)
{
form.action = "AdminHome.jsp?np=setuprole&COMPANY=<%=company%>";
form.tflag.value = '2'
form.submit();
}

function getSecurityClass(){
window.location ='AdminHome.jsp?np=role3&COMPANY=<%=company%>&ROLEID=<%=roleid%>&voptions=3&STATUS=1'
//window.location ='role.jsp?voptions=3&ROLEID=<%=roleid%>'
}

</script>