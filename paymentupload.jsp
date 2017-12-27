<%@ page language="java" import="javazoom.upload.*,java.util.*,java.io.*,java.text.*,com.zenithbank.banking.ibank.mail.*,javax.naming.*,javax.sql.DataSource,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.coporate.ibank.payment.*,com.zenithbank.banking.ibank.common.* ,com.zenithbank.banking.coporate.ibank.audit.*,java.util.Hashtable"  session="true" %>
<%@ page errorPage="error.jsp" %>

<!--% String directory = "C:/jboss-4.0.4.GA/server/internet/fileupload"; %-->
<!--% String tmpdirectory = "c:/uploads/tmp"; %-->
<% com.zenithbank.banking.coporate.ibank.action.UploadReader UploadReader = new com.zenithbank.banking.coporate.ibank.action.UploadReader();%>
<% String directory = com.zenithbank.banking.coporate.ibank.action.UploadReader.uploadDirectory; %>
<% String tmpdirectory = com.zenithbank.banking.coporate.ibank.action.UploadReader.tmpDirectory;
    boolean bulkDebit = false;
    if (request.getParameter("bulkDebit") != null && request.getParameter("bulkDebit").trim().equalsIgnoreCase("true")) {
        bulkDebit = true;
    }
    System.out.println("bulkDebit parameter " + bulkDebit);
%>

<% boolean createsubfolders = true; %>
<% boolean allowresume = true; %>
<% boolean allowoverwrite = true; %>
<% String encoding = "ISO-8859-1"; %>
<% boolean keepalive = false;%>
<jsp:useBean id="fileMover" scope="page" class="uploadutilities.FileMover" />
<!-- Commons FileUpload parser is used to have a disk cache instead of memory -->
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore" value="<%= directory%>" />
    <jsp:setProperty name="upBean" property="parser" value="<%= MultipartFormDataRequest.CFUPARSER%>"/>
    <jsp:setProperty name="upBean" property="parsertmpdir" value="<%= tmpdirectory%>"/>
    <!--jsp:setProperty name="upBean" property="filesizelimit" value="858993459"/-->
    <!--in bytes,4096000bytes = 4096KB -->
    <jsp:setProperty name="upBean" property="filesizelimit" value="4096000"/>
    <jsp:setProperty name="upBean" property="overwrite" value="<%= allowoverwrite%>"/>
    <jsp:setProperty name="upBean" property="dump" value="true"/>
    <% upBean.addUploadListener(fileMover); %>
</jsp:useBean>

<%
    com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
    com.zenithbank.banking.coporate.ibank.action.CompanyManager company = new com.zenithbank.banking.coporate.ibank.action.CompanyManager();
    String mycompany = company.findBankByCode(login.getHostCompany()).getName();

    if (login == null) {
        response.sendRedirect("/coporate-internetbanking/sessiontimeout.jsp");
    }
    if (login.getPasschange().equals("1")) {
        response.sendRedirect("ChangePwd.jsp");
    }

    String no_of_days = "";
    int ret = 0;
    String[] s = com.zenithbank.banking.coporate.ibank.PaymentHelper.PasswordTrackingDB.DefualtInstance().CheckPasswordExpiryDateDue(login.getLoginId(), Integer.parseInt(login.getRoleid()));
//if (s[0] == "1") //commented to fix non display of password expiry days - //14072010
    if (s[0].equals("1"))//added to fix non display of password expiry days - //14072010
    {
        out.println("<script>alert('Your password has expired, please change your password!')</script>");
        out.println("<script>window.location='ChangePwd.jsp'</script>");
    }
//if (s[0] == "0")  { //commented to fix non display of password expiry days - //14072010
    if (s[0].equals("0")) { //added to fix non display of password expiry days - //14072010
        no_of_days = s[1];
    }

    BaseAdapter connect = new BaseAdapter();
    int maxid = 0;
    java.sql.Connection con = null;
    java.sql.Statement stmt = null;
    java.sql.ResultSet rs = null;
    java.sql.PreparedStatement ps = null;
    com.dwise.util.HtmlUtilily unique = new com.dwise.util.HtmlUtilily();
    String appender = "";
    appender = login.getHostCompany() + "-" + login.getLoginId() + "-" + unique.getUnique1();
    int ApprovalLevel = login.getAuthLevel();

    String rolegroup = company.findBankByCode(login.getHostCompany()).getrolegroup();
    int approvalOnLevel = login.AuthLevelCount(login.getHostCompany(), ApprovalLevel, login.getgrouproleid());
    String userLoggedIn = login.getLoginId();

//request.setCharacterEncoding(encoding);
    //response.setContentType("text/html; charset="+encoding);
    String method = request.getMethod();
  // Head processing to support resume and overwrite features.

    if (method.equalsIgnoreCase("head")) {
        // Rename the file name with the following rule.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
        // fileMover.setPrefix(sdf.format(new Date()));
        fileMover.setPrefix(appender);
        String filename = request.getHeader("relativefilename");
        if (filename == null) {
            filename = request.getHeader("filename");
        }
        if (filename != null) {
            if (keepalive == false) {
                response.setHeader("Connection", "close");
            }
            String account = request.getHeader("account");
            if (account == null) {
                account = "";
            } else if (!account.startsWith("/")) {
                account = "/" + account;
            }
            File fhead = new File(directory + account + "/" + filename);
            if (fhead.exists()) {
                response.setHeader("size", String.valueOf(fhead.length()));
                String checksum = request.getHeader("checksum");
                if ((checksum != null) && (checksum.equalsIgnoreCase("crc"))) {
                    long crc = upBean.computeCRC32(fhead, -1);
                    if (crc != -1) {
                        response.setHeader("checksum", String.valueOf(crc));
                    }
                } else if ((checksum != null) && (checksum.equalsIgnoreCase("md5"))) {
                    String md5 = upBean.hexDump(upBean.computeMD5(fhead, -1)).toLowerCase();
                    if ((md5 != null) && (!md5.equals(""))) {
                        response.setHeader("checksum", md5);
                    }
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            return;
        }
    }
%>
<html>
    <head>
        <title>Coporate ibank upload</title>
        <script type="text/javascript" src="script.js"></script>
        <link href="css/zs.css" rel="stylesheet" type="text/css" />
        <link href="css/GenericStylesheet.css" rel="stylesheet" type="Text/CSS" />
        <script src="javascript/GenericJavaScript1.js" type="text/javascript" language="javascript"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=<%= encoding%>">
    </head>

    <body class="parentBody" id="div_body">
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

        <div id="please_wait" style="position:absolute;visibility: hidden; left:173px; top:184px; width:409px; height:76px; z-index:1; background-color: #FFFFFF;layer-background-color: #FFFFFF; border: 1px none #000000;">
            <div align="center" >
                <p>&nbsp;</p>
                <script type="text/javascript" language="javascript">
                    PleaseWaitMessage();
                </script>            
            </div>
        </div>
        <%
            if (MultipartFormDataRequest.isMultipartFormData(request)) {

                // Rename the file name with the following rule.
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
                //fileMover.setPrefix(sdf.format(new Date())); 
                fileMover.setPrefix(appender);
                // Parse multipart HTTP POST request.
                MultipartFormDataRequest mrequest = null;
                try {
                    mrequest = new MultipartFormDataRequest(request, null, -1, MultipartFormDataRequest.CFUPARSER, encoding, allowresume);
                } catch (Exception e) {
                       // Cancel current upload (e.g. Stop transfer)
                    // Only if allowresume = false
                }
                String todo = null;
                if (mrequest != null) {
                    todo = mrequest.getParameter("todo");
                }
                if ((todo != null) && (todo.equalsIgnoreCase("upload"))) {
                    String account = mrequest.getParameter("account");
                    if (account == null) {
                        account = "";
                    } else if (!account.startsWith("/")) {
                        account = "/" + account;
                    }
                    upBean.setFolderstore(directory + account);
                    Hashtable files = mrequest.getFiles();
                    if ((files != null) && (!files.isEmpty())) {
                        UploadFile file = (UploadFile) files.get("uploadfile");
                        if (file != null) {
                            out.println("<li>Form field : uploadfile" + "<BR> Uploaded file : " + file.getFileName() + " (" + file.getFileSize() + " bytes)" + "<BR> Content Type : " + file.getContentType());
                        }

                        // Folders and subfolders creation support.
                        String relative = mrequest.getParameter("relativefilename");
                        if ((createsubfolders == true) && (relative != null)) {
                            int inda = relative.length();
                            int indb = file.getFileName().length();
                            if (inda > indb) {
                                String subfolder = relative.substring(0, (inda - indb) - 1);
                                subfolder = subfolder.replace('\\', '/').replace('/', java.io.File.separatorChar);
                                upBean.setFolderstore(directory + account + java.io.File.separator + subfolder);
                            }
                        }
                        if (keepalive == false) {
                            response.setHeader("Connection", "close");
                        }
                        // Chunks recomposion support.
                        String chunkidStr = mrequest.getParameter("chunkid");
                        String chunkamountStr = mrequest.getParameter("chunkamount");
                        String chunkbaseStr = mrequest.getParameter("chunkbase");
                        if ((chunkidStr != null) && (chunkamountStr != null) && (chunkbaseStr != null)) {
                            // Always overwrite chunks.
                            upBean.setOverwrite(true);
                            upBean.store(mrequest, "uploadfile");
                            upBean.setOverwrite(allowoverwrite);
                            int chunkid = Integer.parseInt(chunkidStr);
                            int chunkamount = Integer.parseInt(chunkamountStr);
                            if (chunkid == chunkamount) {
                                // recompose file.
                                String fname = upBean.getFolderstore() + java.io.File.separator + chunkbaseStr;
                                File fread = new File(fname);
                                if (fread.canRead() && (upBean.getOverwrite() == false)) {
                                    fname = upBean.loadOverwriteFilter().process(fname);
                                }
                                FileOutputStream fout = new FileOutputStream(fname);
                                byte[] buffer = new byte[4096];
                                for (int c = 1; c <= chunkamount; c++) {
                                    File filein = new File(upBean.getFolderstore() + java.io.File.separator + chunkbaseStr + "." + c);
                                    FileInputStream fin = new FileInputStream(filein);
                                    int read = -1;
                                    while ((read = fin.read(buffer)) > 0) {
                                        fout.write(buffer, 0, read);
                                    }
                                    fin.close();
                                    filein.delete();
                                }
                                fout.close();
                            }
                        } else {
                            upBean.store(mrequest, "uploadfile");
                        }
                        upBean.setFolderstore(directory + account);
                        //out.println("<script>alert('File Upload is successfull !!!')</script>");
                        try {
                            con = connect.getConnection();
                            stmt = con.createStatement();
                            rs = stmt.executeQuery("SELECT ISNULL (MAX(batchid)+1,1) FROM ZENBASENET..ZIB_cib_pmt_fileupload");
                            if (rs.next()) {
                                maxid = rs.getInt(1);
                            }
                            // add bulkdebit
                            String query = "INSERT INTO ZENBASENET..ZIB_cib_pmt_fileupload ("
                                    + "batchid,original_filename,server_filename,COMPANY_CODE,upload_operator,batch_status,Group_Roleid) "
                                    + "VALUES(?,?,?,?,?,?,?)";
                            ps = con.prepareStatement(query);
                            ps.setInt(1, maxid);
                            ps.setString(2, login.getLoginId() + "_" + file.getFileName());
                            ps.setString(3, appender + file.getFileName());
                            ps.setString(4, login.getHostCompany());
                            ps.setString(5, login.getLoginId());
                            ps.setString(6, "PENDING");
                            ps.setInt(7, Integer.parseInt(login.getgrouproleid()));

                            //u can apply bulk debit param here now
                            ps.execute();

                                //out.println("<script>alert('Database successfully Updated!')</script>");
                            //	out.println("<script>window.location = 'roleList.jsp'</script>");
                            //////
                            java.text.SimpleDateFormat timestamp = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss a");
                            AuditManager adm = new AuditManager();//CIB AUDIT
                            AuditValue audit = new AuditValue();//CIB AUDIT
                            audit.setCompany_code(login.getHostCompany());
                            audit.setBranch_code(login.getHostBranch());
                            audit.setTable_name("ZIB_CIB_GB_PAYMENTUPLOAD");
                            audit.setObj_name("PAYMENT");
                            audit.setAcct_perfmd("Payment Upload");
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

                            if (file.getFileSize() <= 858993459) {
                                com.zenithbank.banking.coporate.ibank.action.UploadReader Service = new com.zenithbank.banking.coporate.ibank.action.UploadReader();
                                ret = Service.Get_File_To_Read(maxid, login.getLoginId(), login.getHostCompany());
                                try {
                                    String Mailbody = "";
                                    String EmailAddress = "";
                                    String MobileNo = "";
                                    String FullName = "";
                                    String Subject = "Zenith Corporate Internet Banking Payment Request Approval";
                                    String CompanyName = company.findBankByCode(login.getHostCompany()).getName();
                                    UtilityProcessor up = new UtilityProcessor();
                                    PaymentAdapter pa = new PaymentAdapter();
                                    UserValue[] uv;
                                    if (rolegroup.trim().equalsIgnoreCase("Y")) {
                                        if (approvalOnLevel > 1) {
                                            uv = pa.getUserContactDetailsRolegroup(login.getHostCompany(), ApprovalLevel, login.getgrouproleid(), userLoggedIn.trim());
                                        } else {
                                            uv = pa.getUserContactDetailsRolegroup(login.getHostCompany(), ApprovalLevel + 1, login.getgrouproleid(), "");
                                        }
                                    } else {
                                        uv = pa.getUserContactDetails(login.getHostCompany(), ApprovalLevel + 1);
                                    }

                                    StringBuffer MsgBody1 = new StringBuffer();

                                    for (int i = 0; i < uv.length; i++) {
                                        EmailAddress = uv[i].getEmailAddress();
                                        MobileNo = uv[i].getGsmNo();
                                        FullName = uv[i].getFullName();
                                        String SMSmessage = "";
                                        SMSmessage += login.getFullname() + " has uploaded some payment transaction(s) for your approval on Zenith Corporate Internet Banking.";
                                        SMSmessage += "Thank you for your patronage.";
                                        up.sendSMS(SMSmessage, MobileNo);

                                        StringBuffer MsgBody = new StringBuffer();

                                        MsgBody.append("<HEAD>");
                                        MsgBody.append("<TITLE>Zenith Bank Corporate Internet Banking Payment Upload Notification System</TITLE>");
                                        MsgBody.append("</HEAD>");
                                        MsgBody.append("<BODY>");
                                        MsgBody.append("<table><tr></td>");
                                        MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("<tr><td> Dear ")).append(FullName).append(",<br><br>"))));
                                        MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("Zenith Corporate Internet banking payment upload by " + login.getFullname() + " on behalf of " + CompanyName + "  has been sucessful.").append("<br>")))));
                                        MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("You are required to take action on this/these payment(s).").append("<br><br> ")))));
                                        MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("Thank you for your patronage.").append("<br>")))));
                                        MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("<span class='errortext'>Note: This payment request will not be processed by Zenith Bank Plc until the necessary approvals have been received.</span>").append("<br>")))));

                              //  MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("Processing of the transaction(s) involved will cease at this stage.").append("<br><br> ")))));
                                        //  MsgBody.append(String.valueOf(String.valueOf((new StringBuffer("Thank you for your patronage.").append("<br>")))));
                                        MsgBody.append("</table>");
                                        MsgBody.append("<br><br>");
                                        MsgBody.append("  Regards, <br><br>");
                                        MsgBody.append(" ZENITH BANK PLC </td></tr>");
                                        MsgBody.append("</BODY>");
                                        MsgBody.append("</HTML>");
                                        String MsgToSend1 = MsgBody.toString();
                                        JXMessage m2 = new JXMessage(EmailAddress, "ebusinessgroup@zenithbank.com", "172.29.12.167");
                                        m2.setMessage(MsgToSend1);
                                        m2.setMailSubject("Corporate Internet Banking Payment Upload !! : ");
                              // m.addBCCAddress("");
                                        //m2.addCCAddress("");
                                        m2.setHTML(true);
                                        JXMail sender2 = new JXMail(m2);
                                        sender2.send();

                                        MsgBody1.append("<HEAD>");
                                        MsgBody1.append("<TITLE>Zenith Bank Corporate Internet Banking Payment Upload Notification System</TITLE>");
                                        MsgBody1.append("</HEAD>");
                                        MsgBody1.append("<BODY>");
                                        MsgBody1.append("<table><tr></td>");
                                        MsgBody1.append(String.valueOf(String.valueOf((new StringBuffer("<tr><td> Dear Zenith Bank Plc<br><br>")))));
                                        MsgBody1.append(String.valueOf(String.valueOf((new StringBuffer("A payment file " + appender + file.getFileName() + " has been uploaded to the payments system by " + login.getLoginId() + " on behalf of " + mycompany + ".").append("<br>")))));
                               // MsgBody1.append(String.valueOf(String.valueOf((new StringBuffer("You are required to take action on this/these payment(s).").append("<br><br> ")))));
                                        //MsgBody1.append(String.valueOf(String.valueOf((new StringBuffer("Thank you for your patronage.").append("<br>")))));
                                        //  MsgBody1.append(String.valueOf(String.valueOf((new StringBuffer("<span class='errortext'>Note: This payment request will not be processed by Zenith Bank Plc until duly approved by payment authorization officer(s).</span>").append("<br>")))));
                                        MsgBody1.append("</table>");
                                        MsgBody1.append("<br><br>");
                                        MsgBody1.append("  Regards, <br><br>");
                                        MsgBody1.append(" ZENITH BANK PLC </td></tr>");
                                        MsgBody1.append("</BODY>");
                                        MsgBody1.append("</HTML>");
                                        String MsgToSend2 = MsgBody1.toString();
                                        JXMessage m1 = new JXMessage("ebusiness@zenithbank.com", "ebusinessgroup@zenithbank.com", "172.29.12.167");
                                        m1.setMessage(MsgToSend2);
                                        m1.setMailSubject("Corporate Internet Banking Payment Upload ");
                              // m.addBCCAddress("");
                                        //m1.addCCAddress("");
                                        m1.setHTML(true);
                                        JXMail sender1 = new JXMail(m1);
                                        sender1.send();
                                    }
                                } catch (JXMailException jme) {
                                    jme.printStackTrace();
                                    // out.println("<br>");
                                    System.out.println(" Unable to send your message, please Contact Ebusiness for more Information ");
                  // out.println("<input type='button' name='back' value='Back' onClick='javascript:history.go(-1)'>");
                                    //out.println("<br>");
                                }
                                if (ret == 77) {
                                    out.println("<script>alert('Please check for exceptions!')</script>");
                                    out.println("<script>window.location = 'bulk_exceptions.jsp?batchid=" + maxid + "&hostcompany=" + login.getHostCompany() + "'</script>");
                                } else if (ret == 99) {
                                    out.println("<script>alert('Invalid Payment Upload File, please check your payment upload file !!!')</script>");
                                } else {
                                    out.println("<script>alert('Payment processing not completed, please check your payment upload file !!!')</script>");
                                }
                            }

                        } catch (Exception ne) {
                            System.out.println(ne);
                        } finally {
                            if (stmt != null) {
                                stmt.close();
                            }
                            if (rs != null) {
                                rs.close();
                            }
                            if (ps != null) {
                                ps.close();
                            }
                            if (con != null) {
                                con.close();
                            }
                        }
                    } else {
                        String emptydirectory = mrequest.getParameter("emptydirectory");
                        if ((emptydirectory != null) && (!emptydirectory.equals(""))) {
                            File dir = new File(directory + account + "/" + emptydirectory);
                            dir.mkdirs();
                        }
                        out.println("<li>No uploaded files");
                    }
                } else {
                    out.println("<BR> todo=" + todo);
                }

            }

        %>

        <script type="text/javascript" src="js/trim.js"></script>
        <script type="text/javascript" src="js/IsBlank.js"></script>
        <script type="text/javascript" src="js/IsValid.js"></script>
        <script type="text/javascript" language="javascript">
            function validateFields(thisform)
            {
            if (IsBlank(thisform.uploadfile, "Please select an upload file"))
            {
            thisform.uploadfile.focus();
            return false;
            }

            //alert("validateUploadFile " +  validateUploadFile(thisform));
            validFile = (validateUploadFile(thisform));
            // if(validateUploadFile(thisform))//28042010
            if(validFile)//28042010
            { //28042010
            sure = confirm("Are you sure you want to upload this file " + thisform.uploadfile.value + " ?");
            if (sure)
            {
            thisform.action = "paymentupload.jsp";
            thisform.submit();
            }
            else 
            {
            return false;
            }
            showMessage('please_wait');  
            return true;
            hideMessage('please_wait');

            }
            else //if validFile is false
            {
            return false;
            }


            }//28042010

            //28042010 - Begin
            function validateUploadFile(thisform)
            {
            if (thisform.uploadfile.value != '')
            {
            var FileName = thisform.uploadfile.value;
            //alert(FileName);
            FileName = FileName.substring(FileName.lastIndexOf('\\') + 1);
            //alert( " FileName " + FileName);
            //alert(FileName.lastIndexOf('Card'));
            var FileExt = FileName.substring(FileName.lastIndexOf('.') + 1);//28042010
            // alert(" FileExt " + FileExt);
            // var FileExt = FileName.substring(0,4);
            //alert(FileExt);

            // if ((FileExt == 'gif') || (FileExt == 'jpeg') || (FileExt == 'jpg'))
            if ((FileExt == 'txt') || (FileExt == 'TXT') || (FileExt == 'CSV') || (FileExt == 'csv'))
            {	
            return true;
            }
            else
            {	
            alert('Upload a valid File with .csv or .txt extension');	
            thisform.uploadfile.focus();	
            return false;
            }
            }
            }
            //28042010 - End
        </script>

        <script type="text/javascript" src="jquery.min.js"></script>
        <script type="text/javascript" language="javascript">
            function popupWindow(url, windowName, windowDimension) {
            window.open(url, windowName, windowDimension);
            }

            $(document).live("ready", function(event) {
                $('#cancelBtn').click(function(e){
                location.replace('uploadInterface.jsp?');
                e.preventDefault();
                });
            
            $("DIV#ViewUploadTemplate_Container").slideUp(1);

            $("A#ViewUploadTemplate").live("click", function(event) {
            event.preventDefault();
            event.stopPropagation();
            $("DIV#ViewUploadTemplate_Container").slideToggle(400);
            });
            });
            
        </script>

        <DIV align="center">
            <form method="post" action="paymentupload.jsp" name="upform" enctype="multipart/form-data" onSubmit="return validateFields(this);">
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
                                                <DIV class='HeaderText1' style='text-align:center;'>Upload 25-Field Payment File for&nbsp;<SPAN class='SubHeaderText1'>Processing</SPAN></DIV>
                                                <DIV class='HeaderTailText' style='text-align:center;'>This is suitable for all forms of payments including foreign payments</DIV>
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
                                                            <DIV style='overflow-y:auto; overflow-x:hidden;'>
                                                                <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                                                    <TBODY>
                                                                        <TR>
                                                                            <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Select a file to upload:</DIV></TD>
                                                                            <TD class='GenericTableCell' style='width:75%;'>
                                                                                <INPUT type="file" name="uploadfile"  class="Textbox" style='width:50%' oncontextmenu="return false" onKeyDown="this.blur()" />
                                                                                <INPUT type="hidden" name="todo" class="input_button" value="upload" />
                                                                                <INPUT type="hidden" class="input_button" name="bulkDebit" value="" />
                                                                            </TD>
                                                                        </TR>
                                                                        <TR>
                                                                            <TD class='GenericTableCell' style='width:25%;'>&nbsp;</TD>
                                                                            <TD class='GenericTableCell' style='width:75%;'>
                                                                                <INPUT type="submit" style='width:18%;' name="Submit" class="Button1" value="Upload" />
                                                                                &nbsp;
                                                                                <!--<INPUT type="reset" style='width:18%;' name="Reset" class="Button1" value="Cancel" />-->
                                                                                <button class="Button1" type="button" id="cancelBtn" style='width:18%;'>Cancel</button>
                                                                            </TD>
                                                                        </TR>
                                                                        <TR>
                                                                            <TD colspan='2' class='GenericTableCell' style='width:100%;'>
                                                                                <DIV align='left' id='DownloadProcessorError' style='float:left;'>                                            
                                                                                </DIV>
                                                                                <DIV align='right'>
                                                                                    <A href='' id='ViewUploadTemplate' class='BlueMenuLinks'>View File Specification</A>
                                                                                    &nbsp;<SPAN style='color:#000000;'>|</SPAN>&nbsp; <A href='Generic_Downloader_2.jsp' name='TWENTY-FIVE_FIELD_SALARY_FILE_FORMAT_WITH_SAMPLE_DATA.xls' id='XXXDownloadUploadTemplate' class='BlueMenuLinks'>Download Upload Template</A>                                         
                                                                                </DIV>
                                                                            </TD>
                                                                        </TR>
                                                                        <TR>
                                                                            <TD colspan='2' align='center' style='width:100%;'>
                                                                                <DIV id='ViewUploadTemplate_Container' style='overflow-y:auto;'>
                                                                                    <iframe name="25FieldFormat" id="25FieldFormat" frameborder="0" marginwidth="0px" marginheight="0px" scrolling="auto" src="file_archive/25_Field_Format.pdf" style='' class="GIBBody">Oops! Your browser does not support this feature.</iframe>
                                                                                </DIV>
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
