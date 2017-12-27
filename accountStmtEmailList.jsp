<%@ page language="java" import = "javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.* ,java.util.Calendar,java.util.Hashtable" errorPage="error.jsp" session="true" %>
<%
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
BaseAdapter connect = new BaseAdapter();
String username = login.getLoginId();
String companyCode = login.getHostCompany(); //added chuks 08012009
java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
String roleId = "";
Connection con = null;
Statement stmt = null;
ResultSet rs = null;
PreparedStatement ps = null;
String status = request.getParameter("STATUS");
if (status == null) status = "1";
String sel = request.getParameter("sel");
if (sel == null) sel = "0";
%>
<html>
    <head>
        <link href="css/GenericStylesheet.css" rel="stylesheet" type="Text/CSS" />
        <script src="javascript/GenericJavaScript1.js" type="text/javascript" language="javascript"></script>
        <link href="css/zs.css" rel="stylesheet" type="text/css" />
        <meta http-equiv = "PRAGMA" content ="NO-CACHE">        
    </head>
    
    <body class="parentBody" id="div_body">
        <DIV align="center">
            <form action='' method = "POST" name='roleform'>
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
                                <DIV class='HeaderText1' style='text-align:center;'>Email List for Monthly Account Statement </DIV>
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
                       <INPUT type="hidden" name= "np" value = "" />
                       <INPUT type="hidden" name= "sel" value = "0" />
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
                                        <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                          <TR>
                                            <TD class='GenericTableCell_Center' style='width:20%;'>
                                                &nbsp;
                                            </TD>
                                            <TD class='GenericTableCell_Center' style='width:20%;'>
                                                <INPUT type="button" style='width:70%;' name="Add" value="Add" class="Button1" onclick="javascript:doAdd(this.form)" />
                                            </TD>
                                            <TD class='GenericTableCell_Center' style='width:20%;'>
                                                <INPUT type="button" style='width:70%;' name="Remove" value="Delete" class="Button1" onclick="javascript:doDel(this.form)" />
                                            </TD>
                                            <TD class='GenericTableCell_Center' style='width:20%;'>
                                                <DIV class='NavyText_Right' style='font-weight:bold;'>Status:</DIV>
                                            </TD>
                                            <TD class='GenericTableCell_Center' style='width:20%;'>
                                                <SELECT name="STATUS" id="STATUS" onChange="filterUser(this.form)" class='Selectbox' style='width:70%;'>
                                                    <%=new com.dwise.util.HtmlUtilily().getResource1(request.getParameter("STATUS"),"SELECT STATUSID, STATUS FROM ZENBASENET..ZIB_CIB_GB_STATUS ")%>
                                                </SELECT>
                                            </TD>
                                          </TR>
                                        </TABLE>
                                        <DIV style='margin-top:5px;'></DIV>
                                        <DIV style='height:600px; overflow-y:auto; overflow-x:hidden;'>
                                            <TABLE frame='Box' rules='All' summary='SUB-table' border='1' cellspacing='0' cellpadding='0' class='GenericTable1' style='width:100%; font-size:0.9em;'>
                                              <TBODY>
                                                 <THEAD>
                                                     <TR>
                                                        <TD class='BACKimage1 GenericTableCell_Center'>
                                                            <INPUT type="checkbox" name="CheckAll" value="ON" onClick="if (this.checked) {doClickAll(this.form)} else {doUnClickAll(this.form)}" />
                                                        </TD>
                                                        <TD class='BACKimage1 GenericTableHeader'>ID</TD>
                                                        <TD class='BACKimage1 GenericTableHeader'>EMAIL</TD>
                                                        <!--TD class='BACKimage1 GenericTableHeader'>Debit Account Name</TD>
                                                        <TD class='BACKimage1 GenericTableHeader'>Interswitch Charge Account</TD>
                                                        <TD class='BACKimage1 GenericTableHeader'>Interswitch Charge Amount</TD-->
                                                     </TR>
                                                 </THEAD>
                                                 <%
                                                    try {
                                                        con = connect.getConnection();
                                                        if (sel.equals("1")) {
                                                            String[] rolevalues = request.getParameterValues("C2");
                                                            String para = "";
                                                            for (int i=0; i<rolevalues.length; i++)
                                                                para += ","+rolevalues[i];
                                                            //System.out.println(para);
                                                            ps = con.prepareStatement("UPDATE ZENBASENET..zib_cib_gb_acctstmt_email SET STATUS = '0' WHERE COMPANY_CODE ='"+companyCode+"' and TABLE_ID IN ("+para.substring(1)+")"); //added chuks 08012009
                                                            ps.executeUpdate();
                                                        }
                                                        stmt = con.createStatement();
                                                        rs = stmt.executeQuery("SELECT * FROM ZENBASENET..zib_cib_gb_acctstmt_email WHERE COMPANY_CODE ='"+companyCode+"' and STATUS = '"+status+"'"); 
                                                        //
                                                        while(rs.next()) {
                                                            roleId = String.valueOf(rs.getInt("TABLE_ID"));
                                                            status = rs.getString("STATUS");
                                                %>
                                                            <TR style='font-size:0.9em;'>
                                                                  <TD class='GenericTableCell_Center'><INPUT type="checkbox" name="C2" value="<%=roleId%>" /></TD>
                                                                  <TD class='GenericTableCell FontCode1'><A style='font-size:1em;' class='BlueMenuLinks' href='accountStmtEmailSetup.jsp?voptions=2&STATUS=<%=status%>&TABLEID=<%=roleId%>'><%=roleId%></A></TD>
                                                                  <TD class='GenericTableCell FontCode1'><%=rs.getString("EMAIL")%></TD>                                                            
                                                            </TR>
                                                <%
                                                        }
                                                    }catch(Exception ne){
                                                        System.out.println(ne);
                                                    }finally{
                                                        if (stmt != null) stmt.close();
                                                        if (rs != null) rs.close();
                                                        if (con != null) con.close();
                                                    }
                                                %>                               
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

        <script type='text/javascript'>
            function filterUser(form)
            {
            window.location = "accountStmtEmailList.jsp?STATUS="+form.STATUS.value
            }
            function doAdd(form)
            {
            window.location = "accountStmtEmailSetup.jsp"
            }
            function doDel(form)
            {
            if (!checkSelected(form)) return false;
            form.action = "accountStmtEmailList.jsp";
            
            form.sel.value = '1'
            form.submit();
            }
            function doResource(form)
            {
            if (!checkSelected(form)) return false;
            form.action = "setuprole.jsp";
            //form.np.value="setuprole";
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
                    else return false; 
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
        </script>
    </body>
</html>