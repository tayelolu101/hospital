<%@ page import="javazoom.upload.*,java.util.*,java.io.*,java.text.*,
com.zenithbank.banking.ibank.mail.*,javax.naming.*,javax.sql.DataSource,
com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,
com.zenithbank.banking.coporate.ibank.payment.*,com.zenithbank.banking.ibank.common.* ,
com.zenithbank.banking.coporate.ibank.audit.*,java.util.Hashtable,com.zenithbank.banking.coporate.ibank.action.*,
com.zenithbank.banking.coporate.ibank.PaymentHelper.*, com.zenithbank.banking.remitta.services.*"  session="true"  contentType="text/html;charset=windows-1252"%>

<% 

//System.out.println(Runtime.class.getPackage().getImplementationVersion());
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

String mycompany = company.findBankByCode(login.getHostCompany()).getName();


com.dwise.util.HtmlUtilily unique = new com.dwise.util.HtmlUtilily();
String appender = "";
appender = login.getHostCompany()+"-"+login.getLoginId()+"-"+unique.getUnique1();
int ApprovalLevel = login.getAuthLevel();

String rolegroup = company.findBankByCode(login.getHostCompany()).getrolegroup();
int approvalOnLevel = login.AuthLevelCount(login.getHostCompany(),ApprovalLevel,login.getgrouproleid());
String userLoggedIn = login.getLoginId();

List<String> errors = new ArrayList<String>();
String successMessage = "";
UploadReader uploadReader = new UploadReader();
SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy");

String directory = UploadReader.uploadDirectory;
String tmpdirectory = UploadReader.tmpDirectory ; 
//directory = "C:\\Users\\elijah.edih\\Documents\\docs\\cibtest\\";
UploadReader.uploadDirectory = directory;
System.out.println(directory);
System.out.println(tmpdirectory);
System.out.println(UploadReader.uploadDirectory);
System.out.println("check");


 boolean createsubfolders = true; 
 boolean allowresume = true; 
 boolean allowoverwrite = true;
 String encoding = "ISO-8859-1";
 boolean keepalive = false; 
 
 boolean bulkDebit =false;
Date payment_due_date =null;
String paymentDueDate="";
String transaction_ref ="";
 
 %>
 
<jsp:useBean id="fileMover" scope="page" class="uploadutilities.FileMover" />
 <jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
  <jsp:setProperty name="upBean" property="folderstore" value="<%=directory%>" />
  <jsp:setProperty name="upBean" property="parser" value="<%= MultipartFormDataRequest.CFUPARSER %>"/>
  <jsp:setProperty name="upBean" property="parsertmpdir" value="<%= tmpdirectory %>"/>
  <!--jsp:setProperty name="upBean" property="filesizelimit" value="858993459"/-->
  <!--in bytes,4096000bytes = 4096KB -->
  <jsp:setProperty name="upBean" property="filesizelimit" value="4096000"/>
  
  <jsp:setProperty name="upBean" property="overwrite" value="<%= allowoverwrite %>"/>
  <jsp:setProperty name="upBean" property="dump" value="true"/>
  <!--jsp:setProperty name="upBean" property="whitelist" value="*.txt,*.csv" /-->
  <% upBean.addUploadListener(fileMover); 
  
  
  %>
</jsp:useBean>

<% 
String method = request.getMethod();
 if (method.equalsIgnoreCase("head"))
  {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
        fileMover.setPrefix(appender);
    String filename = request.getHeader("relativefilename");
    if (filename == null) filename = request.getHeader("filename");
    if (filename!=null)
    {
    	if (keepalive == false) response.setHeader("Connection","close");
    	String account = request.getHeader("account");
 	if (account == null) account="";
    	else if (!account.startsWith("/")) account = "/"+account;
    	File fhead = new File(directory+account+"/"+filename);
    	if (fhead.exists())
    	{
    	   response.setHeader("size", String.valueOf(fhead.length()));
    	   String checksum = request.getHeader("checksum");
    	   if ((checksum != null) && (checksum.equalsIgnoreCase("crc")))
    	   {
		long crc = upBean.computeCRC32(fhead,-1);
		if (crc != -1) response.setHeader("checksum", String.valueOf(crc));
    	   }
    	   else if ((checksum != null) && (checksum.equalsIgnoreCase("md5")))
    	   {
		String md5 = upBean.hexDump(upBean.computeMD5(fhead,-1)).toLowerCase();
		if ((md5 != null) && (!md5.equals(""))) response.setHeader("checksum", md5);
    	   }
    	}
    	else response.sendError(HttpServletResponse.SC_NOT_FOUND);
       return;
    }
  }
  
  
  else
   if(method.equalsIgnoreCase("get")){


if(request.getParameter("bulkDebit") != null && 
            request.getParameter("bulkDebit").trim().equalsIgnoreCase("true")){
                  bulkDebit=true;
                  
       }
       if(request.getParameter("paymentDueDate") != null && 
            !request.getParameter("paymentDueDate").trim().equalsIgnoreCase("")){
         try{   
             paymentDueDate = request.getParameter("paymentDueDate").trim();
             payment_due_date =  sdf2.parse(paymentDueDate);
             }
             catch(ParseException exp){
               payment_due_date = null;
             }
            }
            
         if(request.getParameter("transactionReference") != null && 
            !request.getParameter("transactionReference").trim().equalsIgnoreCase("")){         
               transaction_ref =request.getParameter("transactionReference").trim();       
            }
   
   }
   
   else
   if(method.equalsIgnoreCase("post")){
   errors.clear();//gb
   int maxid = 0;
   
    if (MultipartFormDataRequest.isMultipartFormData(request))
              {                
                int ret = 0;
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
                fileMover.setPrefix(appender);
                 MultipartFormDataRequest mrequest = null;
                 try
                 {
                    mrequest = new MultipartFormDataRequest(request,null,-1,MultipartFormDataRequest.CFUPARSER,encoding,allowresume);
                 } catch (Exception e)
                   { errors.add("Request is not a multipart request");
                     //System.out.println("Casting Request to multipart failed");
                   }
                    if(  mrequest.getParameter("bulkDebit") != null && mrequest.getParameter("bulkDebit").equalsIgnoreCase("true")){
                        bulkDebit=true;              
                      }
                 
                  
                   if(bulkDebit && mrequest.getParameter("paymentDueDate") != null && 
            !mrequest.getParameter("paymentDueDate").trim().equalsIgnoreCase("")){
         try{   
             paymentDueDate =mrequest.getParameter("paymentDueDate").trim();
             payment_due_date =  sdf2.parse(paymentDueDate);
             }
             catch(ParseException exp){
               errors.add("Date Format Should be like dd-mm-yyyy ");
               payment_due_date = null;
             }
            }
            
         if(bulkDebit && mrequest.getParameter("transactionReference") != null && 
            !mrequest.getParameter("transactionReference").trim().equalsIgnoreCase("")){         
               transaction_ref =mrequest.getParameter("transactionReference").trim();       
            }
            /*
           System.out.println("bulk debit :"+bulkDebit );   
          System.out.println("trans ref :"+  transaction_ref);   
           System.out.println("payment due date :"+ payment_due_date);  
              */     
                if(bulkDebit  && (transaction_ref ==null || transaction_ref.trim().equals("") || payment_due_date == null) ) 
                {
                 errors.add("Please supply Transaction Reference, and Payment Due Date");
                 //System.out.println("Some fields are not dia");
                }
                
                else{// continue the upload
                
                   String account = mrequest.getParameter("account");
                   if (account == null) account="";
                   else if (!account.startsWith("/")) 
                   account = "/"+account;
                   
                   upBean.setFolderstore(directory+account);
                   Hashtable files = mrequest.getFiles();
                   if( (files != null) && (!files.isEmpty()) &&
                   ( (UploadFile) files.get("uploadfile") != null && ( (UploadFile) files.get("uploadfile")).getFileSize() > 1 ))
                   {
                      UploadFile file = (UploadFile) files.get("uploadfile");
    
                     String relative = mrequest.getParameter("relativefilename");
                     if ((createsubfolders == true) && (relative != null))
                     {
                       int inda=relative.length();
                       int indb=file.getFileName().length();
                       if (inda > indb)
                       {
                         String subfolder = relative.substring(0,(inda-indb)-1);
                         subfolder = subfolder.replace('\\','/').replace('/',java.io.File.separatorChar);
                         upBean.setFolderstore(directory+account+java.io.File.separator+subfolder);
                       }
                     }
                     if (keepalive == false) response.setHeader("Connection","close");
                     // Chunks recomposion support.
                     String chunkidStr = mrequest.getParameter("chunkid");
                     String chunkamountStr = mrequest.getParameter("chunkamount");
                     String chunkbaseStr = mrequest.getParameter("chunkbase");
                     // if it is uploading by chunks
                     if ((chunkidStr != null) && (chunkamountStr != null) && (chunkbaseStr != null))
                     {
                       // Always overwrite chunks.
                       upBean.setOverwrite(true);
                       upBean.store(mrequest, "uploadfile");
                       upBean.setOverwrite(allowoverwrite);
                       int chunkid = Integer.parseInt(chunkidStr);
                       int chunkamount = Integer.parseInt(chunkamountStr);
                       if (chunkid == chunkamount)
                       {
                         // recompose file.
                         String fname = upBean.getFolderstore()+java.io.File.separator+chunkbaseStr;
                         File fread = new File(fname);
                         if (fread.canRead() && (upBean.getOverwrite()==false)) fname = upBean.loadOverwriteFilter().process(fname);
                         FileOutputStream fout = new FileOutputStream(fname);
                         byte[] buffer = new byte[4096];
                         for (int c=1;c<=chunkamount;c++)
                         {
                           File filein = new File(upBean.getFolderstore()+java.io.File.separator+chunkbaseStr+"."+c);
                           FileInputStream fin = new FileInputStream(filein);
                           int read = -1;
                           while ((read = fin.read(buffer)) > 0) fout.write(buffer,0,read);
                           fin.close();
                           filein.delete();
                         }
                         fout.close();
                       }
                     }
                     // upload straight
                     else {
                     upBean.store(mrequest, "uploadfile");
                     }
                     //anyway 
                     upBean.setFolderstore(directory+account);
                       successMessage ="Form field : uploadfile"+"<BR> Uploaded file : "+file.getFileName()+" ("+file.getFileSize()+" bytes)"+"<BR> Content Type : "+file.getContentType();
                       // now do the processing
                       
                                //String serverFileName =  appender+file.getFileName();
                                
                                //System.out.println(serverFileName);

                                // CHIMA UCI TECH 20141105
                                
                                UploadReader Service = new UploadReader();
                                  String serverFileName =  appender+file.getFileName(); 
                                  String serverFileName1 = directory + appender+file.getFileName();                          
                                 /*
                                 System.out.println("appender " + appender);
                                 System.out.println("directory " + directory);
                                 System.out.println("file name " + file.getFileName());
                                  */
           
                                 String ext =  Service.getFileExt(serverFileName1) ;
                                 //System.out.println("file extension " + ext);
                                  if(ext.equalsIgnoreCase("xls") || ext.equalsIgnoreCase("xlsx") || ext.equalsIgnoreCase("xltx")){
                                   System.out.println("File is  excel, Get the CSV name " + serverFileName1);                                                          
                                   serverFileName = Service.produceCSVFromExcell(serverFileName1);
                                   System.out.println("New File name is "+ serverFileName);
                                  }
                                            
                                //
                                
                                
                                
                                PaymentDB paymentDB = new PaymentDB();
                                maxid = paymentDB.generateBatchId();
                                int success =  paymentDB.insertUploadPaymentFileDetails(maxid,login.getLoginId()+"_"+file.getFileName() ,
                                serverFileName,login.getHostCompany(), login.getLoginId(),
                                Integer.parseInt(login.getgrouproleid()), bulkDebit);
                                
                           
                                paymentDB.createPaymentFileUploadAudit(login);
                                
                            if(bulkDebit){
                              ret=Service.Get_File_To_Read_Salary_BULK(maxid,login.getLoginId(), login.getHostCompany(),
                                                                                            sdf2.format(payment_due_date), transaction_ref);
                              
                              
                              System.out.println("======================Bulk Debit===================");
                              System.out.println(ret);
                            }
                            else{
                            	
                            	
                              ret = Service.Get_File_To_Read_Salary(maxid,login.getLoginId(), login.getHostCompany());
                              System.out.println("======================Not Bulk Debit===================");
                              System.out.println(ret);
                           }
                        // call service and parse batchID if validate inretbank was cselected  
                            try{
                               CIBHelperService  cibService = new CIBHelperService();
                               
                               // added 24022016
                               if (bulkDebit) {
                                   String state = cibService.insertValidAccountNamesForBatchBulk(maxid);
                                   System.out.println("Called CIBHelper insertValidAccountNamesForBatchBulk  action:" + state);
                               } else {
                                   String state = cibService.insertValidAccountNamesForBatch( maxid);
                                   System.out.println("Called CIBHelper insertValidAccountNamesForBatch  action:"+state); 
                               }
                            }
                            catch(Exception exp){
                                exp.printStackTrace();
                            }
                        
                        
                        System.out.println("Skipping validation of names");
                      
                      PaymentAdapter pa = new PaymentAdapter();       
                      UserValue[] uv ;
                     if(rolegroup.trim().equalsIgnoreCase("Y")){
                          if(approvalOnLevel > 1){
                                uv = pa.getUserContactDetailsRolegroup(login.getHostCompany(), ApprovalLevel,login.getgrouproleid(),userLoggedIn.trim());
                          }else{
                                uv = pa.getUserContactDetailsRolegroup(login.getHostCompany(), ApprovalLevel+1,login.getgrouproleid(),"");
                          }                  
                      }else 
                            uv = pa.getUserContactDetails(login.getHostCompany(), ApprovalLevel+1);     
                  
                 System.out.println("====================================")   ;
                 System.out.println(ret);
                 System.out.println("====================================")   ;
                if (ret == 77)
                {
                 // we know thier are exceptions
                 out.println("<script>alert('Please check for exceptions!')</script>");
                 out.println("<script>window.location = 'bulk_exceptions.jsp?batchid="+maxid+"&hostcompany="+login.getHostCompany()+"'</script>");
                            // To send emails only if the file is ok
                            paymentDB.sendSMSsForPaymentFileUpload(login, uv);
                            paymentDB.sendEmailsForPaymentFileUpload(login, mycompany, uv);
                            paymentDB.sendNotificationEmailToZenithBank(login, "A file " + appender+file.getFileName(), mycompany);
                            
                }
                else
                if(ret == 11){
                  // we know have some invalid account number errors
                  errors.add("Invalid File Contents, only a single account number is to be specified for bulk debit!");
                }
                else if (ret == 13) {
                    errors.add("Payment type must be one of the three, 'INTERSWITCH/BENEFICIARY',"
                            + " 'ZENITH/BENEFICIARY', or 'INTERBANK/BENEFICIARY', for bulk payment");
                }
                else if (ret == 99)
                {// invalid uploaded file
                 errors.add("Invalid Uploaded File !");
                }
                else
                { // was successfull.
                successMessage  += "<br/>File Uploaded and Processed Successfully";
                
                }
                                                
          
                         
                 }
                   else
                   {
                     String emptydirectory = mrequest.getParameter("emptydirectory");
                     if ((emptydirectory != null) && (!emptydirectory.equals("")))
                     {
                       File dir = new File(directory+account+"/"+emptydirectory);
                       dir.mkdirs();
                     }
                     //System.out.println("No File Uploaded");
                     errors.add("Please select a CSV or Excell file and upload");
                    // no files uploadded
                   }
                 
                 }
                 //end
                 
                
                        
              } 
              
              else{
              //is not a multipart request
              }
   
              }

%>

<html>  
  <head>
        <title>Coporate ibank upload</title>
        <script type="text/javascript" src="script.js"></script>
        <link href="css/GenericStylesheet.css" rel="stylesheet" type="Text/CSS" />
        <link rel="stylesheet" type="text/css" href="jquery-ui-1.11.4.custom/jquery-ui.css"/>
        <script src="javascript/GenericJavaScript1.js" type="text/javascript" language="javascript"></script>
          <script src="js/zs.js" type="text/javascript" language="javascript"></script>
          <script type="text/javascript" src="DataTables-1.10.2/js/jquery.js"></script>
          <script type="text/javascript" src="jquery-ui-1.11.4.custom/jquery-ui.js"></script>
          <!--script type="text/javascript" charset="utf8" src="jquery-ui-1.11.1.custom/jquery-ui.min"></script-->
          <!--script type="text/javascript" src="jquery.min.js"></script-->
          
 <style type="text/css">
 .page-label{
 border-bottom: solid 1px #c0c0c0;
font-weight: bold;
text-align: left;
padding: 0px 5px;
color: #58595B;
 }
 .container{
 margin:10px;
 padding:10px;
 }
body{
font-family:Arial, Helvetica, sans-serif; 
font-size:13px;
}

.info, .success, .warning, .error, .validation {
border: 1px solid;
margin: 10px 0px;
padding:15px 10px 15px 50px;
background-repeat: no-repeat;
background-position: 10px center;

}
.info {
color: #00529B;
background-color: #BDE5F8;
background-image: url('info.png');
}
.success {
color: #4F8A10;
background-color: #DFF2BF;
background-image:url('success.png');
}
.warning {
color: #9F6000;
background-color: #FEEFB3;
background-image: url('warning.png');
}
.error {
color: #D8000C;
background-color: #FFBABA;
background-image: url('error.png');
}

.validation {
color: #D63301;
background-color: #FFCCBA;
background-image: url('validation.png');
}
.bulkdebits{
    display: none;
}
</style>
           
    </head>
    
  <body>
  <!--gb-->
           <script language="javascript">
           
        </script>
        <!--gb-->
  <!--gb-->
  <div id="please_wait" style="position:absolute;visibility: hidden; left:173px; top:184px; width:409px; height:76px; z-index:1; background-color: #FFFFFF;layer-background-color: #FFFFFF; border: 1px none #000000;">
          <div align="center" >
            <p>&nbsp;</p>
            <script  language="javascript" type="text/javascript">
               PleaseWaitMessage();
            </script>                
          </div>
        </div>
  <!--gb-->
<!--  <script type="text/javascript" src="js/trim.js"></script>
        <script type="text/javascript" src="js/IsBlank.js"></script>
        <script type="text/javascript" src="js/IsValid.js"></script>-->
        
  <script> 
//    var jq = $.noConflict();
     $(document).ready(function(){
        
        $(".datePicker").datepicker({ dateFormat: "dd-mm-yy",
            beforeShow: function(){    
           $(".ui-datepicker").css('font-size', 12) 
    }});
    
    
    $('#bulkDebit').change(function(){
        if($(this).is(':checked')){
            $('.bulkdebits').show();
            $('#bulkparam').val('true');
        }else{
            $('.bulkdebits').hide();
            $('#bulkparam').val('false');
        }
    });
    
    $('#cancelBtn').click(function(e){
        location.replace('uploadInterface.jsp?');
        e.preventDefault();
    });
    
    $("DIV#ViewUploadTemplate_Container").slideUp(1);
                
    $("A#ViewUploadTemplate").on("click", function(event) {
       event.preventDefault();
       event.stopPropagation();
       $("DIV#ViewUploadTemplate_Container").slideToggle(400);
    });
    var tooltipContent = '<strong>By selecting this option, you acknowledge that:</strong>'
    + '<p>A single debit entry will be recorded in your account for this payment.</p>'
    + '<ul><li>Only the first 3 digits of the Bank sort code are required for the <strong><em>"Bank Sort Code"</em></strong> entry in the payment file.</li>'
    + '<li>Beneficiaries with Stanbic IBTC, Standard Chartered, Jaiz, Heritage and Citi Bank accounts cannot be paid using this option.</li>'
    + '<li>This option is not available to borrowing customers whose accounts are not funded.</li>'
    + '<li>Payments above 10 Million naira can be made subject to your maximum daily limit.</li></ul>';
    $( '#bulkDebit' ).tooltip({
        content: tooltipContent,
        items: 'input[type="checkbox"]'
    });
    /*
    jq("#uploadForm").click(
    
    function() {
            jq("#showLoading").show();
    }
    
    );
    */
        });
       
        
    </script>
    <!--gb-->
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
                                        thisform.action = "salaryupload.jsp";
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
                                //alert(" FileExt " + FileExt);
                                // var FileExt = FileName.substring(0,4);
                                 //alert(FileExt);
                                 
                               // if ((FileExt == 'gif') || (FileExt == 'jpeg') || (FileExt == 'jpg'))
                                 if ((FileExt == 'txt') || (FileExt == 'TXT') || (FileExt == 'CSV') || (FileExt == 'csv') || (FileExt == 'xls') || (FileExt == 'xlsx') || (FileExt == 'xltx'))
                                {	
                                return true;
                                }
                               else
                              {	
                                alert('Upload a valid CSV,Text or Excel File with .csv or .txt or .xls or .xlsx extension');	
                                thisform.uploadfile.focus();	
                                return false;
                              }
                            }
                    }
            //28042010 - End
       
        
        
            function popupWindow(url, windowName, windowDimension) {
                window.open(url, windowName, windowDimension);
            }
        </script>
    <!--gb-->
    
     <!--div class="page-container"  align="center"-->
     <div align="center">
      <!--div class="page-label">8-Field Payment File Upload</div-->
      
      <!--div class="container"-->
      <!--div><img  id="showLoading" style="display:none" src="images/spiffygif1.gif" alt="loading..." /></div-->
      <form  method="post"  action="salaryupload.jsp" name="upform" enctype="multipart/form-data" onSubmit="return validateFields(this);">
     <!--gb-->
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
                                    <!--DIV class='HeaderText1' style='text-align:center;'>Upload 25-Field Payment File for&nbsp;<SPAN class='SubHeaderText1'>Processing</SPAN></DIV>
                                    <DIV class='HeaderTailText' style='text-align:center;'>This is suitable for all forms of payments including foreign payments</DIV-->
									<DIV class='HeaderText1' style='text-align:center;'>Upload 8-Field Payment File for&nbsp;<SPAN class='SubHeaderText1'>Processing</SPAN></DIV>
                                    <DIV class='HeaderTailText' style='text-align:center;'>This can be used for salary, vendor, and contractors payments. However, it is not suitable for foreign payments</DIV>
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
                                              <!--TBODY-->
                                                <TR>
												<!--gb-->
												 <% 
      if(!errors.isEmpty()){
        %> <ul class="error">
                 <%
                 for(String error : errors){
                   out.println("<li>" +error+ " </li>");
                 }
                 %>
             </ul>
        <%
      }
      %>
      <%
       if(!successMessage.equals("")){
        %>   <div class="success">
                   <%= successMessage %>
                 </div>
        <%
      }
      %>
      
												<!--gb-->
                                                  <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Select a file to upload:</DIV></TD>
                                                  <TD class='GenericTableCell' style='width:75%;'>
                                                       <INPUT type="file" name="uploadfile"  class="Textbox" style='width:50%' oncontextmenu="return false" onKeyDown="this.blur()" />
                                                       <INPUT type="hidden" name="todo" class="input_button" value="upload" />
                                                  </TD>
                                                </TR>
												
					<!--CIB001484-->							
		 <tr <!--%if(!"CIB001484".equals(login.getHostCompany())) {out.print("style='display:none'");}%-->>
                   
                   <!--INPUT type="file" name="uploadfile"  class="Textbox" /-->
                
                 <td class='GenericTableCell' style='width:40%;'>
                <INPUT type="hidden" name="bulkDebit" id="bulkparam" value="<%=bulkDebit%>" />
                <DIV class='NavyText_Right' style='font-weight:bold;'>Single debit multiple credits</div></td>
                
                <td class='GenericTableCell' style='width:60%;'>
                    <INPUT type="checkbox" id="bulkDebit" />
<!--                <span class='HeaderTailText'>Check this for single debit multiple credit</span>-->
                </td> 
                   </tr>
                   
                   <!--tr-->
                  
                   <tr class="bulkdebits">
                   <td  class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Payment Due Date</div></td>
                   
                   <td class='GenericTableCell' style='width:75%;'> <input type="text" id="paymentDueDate" name="paymentDueDate" class="datePicker" value="<%=paymentDueDate%>"  /></td>
                   </tr>
                   <tr  class="bulkdebits"> <td class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Transaction Reference</div></td>
                   <td class='GenericTableCell' style='width:75%;'> <input type="text" id="transactionReference" name="transactionReference" value="<%=transaction_ref%>"  /></td>
                   </tr>     
                   
               
                <!--/tr-->
												<!--gb-->
												
                                                <TR>
                                                  <TD class='GenericTableCell' style='width:25%;'>&nbsp;</TD>
                                                  <TD class='GenericTableCell' style='width:75%;'>
                                                       <INPUT type="submit" style='width:18%;' name="Submit" class="Button1" value="Upload" />
                                                       &nbsp;
                                                       <!--<INPUT type="reset" style='width:18%;' name="Reset" class="Button1" value="Cancel" />-->
                                                       <button class="Button1" id="cancelBtn" style='width:18%;'>Cancel</button>
                                                  </TD>
                                                </TR>
                                                <TR>
                                                  <TD colspan='2' class='GenericTableCell' style='width:100%;' nowrap>
                                                     <DIV align='left' id='DownloadProcessorError' style='float:left;'>                                            
                                                     </DIV>
                                                     <!--DIV align='left'>
                                                         <A href='Banks_HO_SortCode.jsp' id='ViewFXPurposeCode' class='BlueMenuLinks'>View Bank Sort Code</A>
                                                         &nbsp;<SPAN style='color:#000000;'>|
                                                          <A href='fxtransfer_purposeCode.jsp' id='ViewFXPurposeCode' class='BlueMenuLinks'>View Foreign Transfer Purpose Code</A>
                                                         &nbsp;<SPAN style='color:#000000;'>|</SPAN>&nbsp; 
                                                         <A href='' id='ViewUploadTemplate' class='BlueMenuLinks'>View File Specification</A>
                                                         &nbsp;<SPAN style='color:#000000;'>|</SPAN>&nbsp; 
                                                         
                                                         <A href='Generic_Downloader_2.jsp' name='TWENTY-FIVE_FIELD_SALARY_FILE_FORMAT_WITH_SAMPLE_DATA.xls' id='XXXDownloadUploadTemplate' class='BlueMenuLinks'>Download Upload Template</A>                                         
                                                     </DIV-->
													 <DIV align='right'>
                                                         <A href='' id='ViewUploadTemplate' class='BlueMenuLinks'>View File Specification</A><!--SEVEN_FIELD_SALARY_FILE_FORMAT_WITH_SAMPLE_DATA-->
                                                         &nbsp;<SPAN style='color:#000000;'>|</SPAN>&nbsp; <A href='Generic_Downloader_1.jsp' name='ABC' id='XXXDownloadUploadTemplate' class='BlueMenuLinks'>Download Upload Template</A>                                         
                                                     </DIV>
                                                  </TD>
                                                </TR>
                                                <TR>
                                                  <TD colspan='2' align='center' style='width:100%;'>
                                                     <DIV id='ViewUploadTemplate_Container' style='overflow-y:auto;'>
                                                        <!--iframe name="25FieldFormat" id="25FieldFormat" frameborder="0" marginwidth="0px" marginheight="0px" scrolling="auto" src="file_archive/25_Field_Format.pdf" style='' class="GIBBody">Oops! Your browser does not support this feature.</iframe-->
														<iframe name="8FieldFormat" id="8FieldFormat" frameborder="0" marginwidth="0px" marginheight="0px" scrolling="auto" src="file_archive/8_Field_Format.pdf" style='' class="GIBBody">Oops! Your browser does not support this feature.</iframe>
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
                  <!--gb-->
                  
      </form>
      <!--/div-->
      </div>
  
  </body>
</html>