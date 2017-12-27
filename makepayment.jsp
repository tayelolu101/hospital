<% response.setHeader("Cache-Control","no-store"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>

<%@ page language="java" import = "com.dwise.util.*, java.util.ArrayList,javax.naming.*,javax.sql.DataSource,java.sql.*,com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*,com.zenithbank.banking.coporate.ibank.payment.*,java.util.Calendar" errorPage="error.jsp" session="true" %>
<%
java.text.SimpleDateFormat sd  = new java.text.SimpleDateFormat("EEE, MMMM d, yyyy");
SinglePiontSingOnValue sec = (SinglePiontSingOnValue) session.getAttribute("sec");
RequestValue req = new RequestValue();
com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter acctSummary = new com.zenithbank.banking.ibank.account.adapter.AccountServiceHostAdapter();
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
String beneficiary_val = "";
String[] s = com.zenithbank.banking.coporate.ibank.PaymentHelper.PasswordTrackingDB.DefualtInstance().CheckPasswordExpiryDateDue(login.getLoginId(),Integer.parseInt(login.getRoleid()));
    //if (s[0] == "1") //commented to fix non display of password expiry days - //14072010
    if (s[0].equals("1"))//added to fix non display of password expiry days - //14072010
    {
        out.println("<script>alert('Your password has expired, please change your password!')</script>");
        out.println("<script>window.location='ChangePwd.jsp'</script>");
    }
    if (s[0].equals("0")){ //added to fix non display of password expiry days - //14072010
    no_of_days = s[1]; }


String np = "";
String name = "";
String accesscode ="";
String loginId = "";
String tokenLoginID = "";
String password = "";
String password2 = "";
String showBeneficiary = "0";
int rim_no = 0;
BaseAdapter connect = new BaseAdapter();

    try{
    accesscode=(String) session.getAttribute("accesscode");
    loginId=(String) session.getAttribute("loginId");
    password=(String) session.getAttribute("password");
    name = sec.getRsm_Name();
    }catch(ClassCastException ce){
            response.sendRedirect("sessiontimeout.jsp");
    }catch(NullPointerException ne){
            response.sendRedirect("sessiontimeout");
    }catch(Exception ne){
            response.sendRedirect("sessiontimeout.jsp");
    }

    java.sql.Connection con = connect.getConnection1();
    java.sql.Connection con2 = connect.getConnection1();
    java.sql.Connection con3;
    String sql = "select rim_no from phoenix..rm_services where cust_service_key = '"+accesscode+"' and services_id=41";
    try
    {
        java.sql.Statement stmt = con.createStatement();
        java.sql.ResultSet rs = stmt.executeQuery(sql);
    if (rs.next()){
            rim_no = rs.getInt("rim_no"); 
    }
    }catch(Exception e){
            e.printStackTrace();
    }finally{
            if (con != null) con.close();
    }
    
    try
    {
        String sql2 = "select password from phoenix..rm_services_rel where rim_no = "+rim_no+" and services_id=41";
        java.sql.Statement stmt = con2.createStatement();
        java.sql.ResultSet rs = stmt.executeQuery(sql2);
        if (rs.next()){
                password2 = rs.getString("password"); 
        }
    }catch(Exception e){
            e.printStackTrace();
    }finally{
        if (con2 != null) con2.close();
    }
    
    CallableStatement callable = null;
   /* try {
    	
    	System.out.println("Checking for holiday or weekend");
        con3 = connect.getConnection1();
        String query = "{call zenbasenet..zsp_IsHolidayOrWeekend(?)}";
        callable = con3.prepareCall(query);
        long today = new java.util.Date().getTime();
        callable.setDate(1, new Date(today));
        ResultSet rs = callable.executeQuery();

        while(rs.next()) {
            System.out.println(rs.getInt(1));
        }
        System.out.println("Done checking for holiday or weekend ");
    } catch (SQLException ex) {
        System.out.println("Error getting if today is weekend");
        ex.printStackTrace();
    } finally {
        if (con != null) con2.close();
    }
   */

    String applType = "";
    String acctNo = "";
    String refNo  = new com.dwise.util.HtmlUtilily().getUnique(loginId);
    long time = Calendar.getInstance().getTime().getTime();

    req.setUserName(loginId);
    req.setPin(password2);
    req.setCardNo(accesscode);
    req.setOrigReferenceNo("ibank "+request.getRemoteAddr());//PhoenixME
    req.setAcctNo1(String.valueOf(rim_no));
    AccountSummaryValue[] sumResult = new AccountSummaryValue[0];
    
    sumResult = acctSummary.getDebitAccountSummaryCP(req,login.getHostCompany(),rim_no,Integer.parseInt(login.getRoleid()));
    
    if (sumResult.length == 0){response.sendRedirect("error2.jsp");}
    
    session.setAttribute("sumResult",sumResult);
    
    BeneficiaryAdapter BeneDetails = new BeneficiaryAdapter();

    String PaymentType = "";
    String AcctValue = "";
    String HostCompany = login.getHostCompany();
    String multipleuser = "";
    String checkTokenValidateValue = "N";
    



    //Get Token LoginID
    tokenLoginID = login.getLoginId();
    
    //Check for Client Privelege
    com.zenithbank.banking.coporate.ibank.payment.PaymentAdapter pay = new com.zenithbank.banking.coporate.ibank.payment.PaymentAdapter();
    beneficiary_val = pay.IsValidation(login.getHostCompany());
    
    // check for multiple user - 22112012
    com.zenithbank.banking.coporate.ibank.PaymentUserProfile profile = new com.zenithbank.banking.coporate.ibank.BeneficiaryAdapter().GetPaymentProfile(login.getHostCompany(),login.getLoginId());
     multipleuser =  profile.getMultipleUser();
     
   //check for old token users  - 18122012
    com.zenithbank.banking.coporate.ibank.DigipassHostAdapter digipassValidate = new com.zenithbank.banking.coporate.ibank.DigipassHostAdapter();
    /*commented on 22072014 to allow token validation for GO3 Token & inputer for multiple users.
    int checkTokenValidate = digipassValidate.Token_authentication(tokenLoginID,accesscode);

//System.out.println("loginId in make payment " + loginId );
//System.out.println("tokenLoginID in make payment " + tokenLoginID);
//System.out.println("accesscode  in make payment " + accesscode);
//System.out.println("checkTokenValidate  in make payment " + checkTokenValidate );
    if (checkTokenValidate > 0)
                {
                checkTokenValidateValue = "Y" ;
                }
    */
    // Override the beneficiary to false
    //beneficiary_val = "false";

    //Reset Account dropdowm
    AcctValue = request.getParameter("selAcctList") ;
    if (AcctValue == null)
    {
        
        //22112012
        AcctValue = "Please Select....";
        //AcctValue = sumResult[0].getAcctNo().trim() + "*" + sumResult[0].getIso_currency().trim() + "*" + sumResult[0].getAcctDesc().trim() + "*" + sumResult[0].getClassCode();
    }
    
    
    
    //Reset Payment Type dropdowm
    PaymentType = request.getParameter("PayType");
    if (PaymentType == null)
    {
        PaymentType = "Please Select....";
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
<title>Corporate Internet Banking: Make Payment</title>
<link href="css/GenericStylesheet.css" rel="stylesheet" type="Text/CSS" />
<script src="javascript/GenericJavaScript1.js" type="text/javascript" language="javascript"></script>
<script type="text/javascript" src="jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/jquery_ui_173.css" />
<link rel="stylesheet" type="text/css" href="css/jquery_autocomplete.css" />
<link rel="stylesheet" type="text/css" href="css/ui_dialog.css" />
<script type="text/javascript" src="javascript/jquery.autocomplete.js"></script>
<script src="js/src1.js" type="text/javascript" language="javascript"></script>
<script src="js/zs.js" type="text/javascript" language="javascript"></script>
<script type="text/javascript" src="js/trim.js"></script>
<script type="text/javascript" src="javascript/jquery.jsonp.js"></script>
<script type="text/javascript" src="js/IsBlank.js"></script>
<script type="text/javascript" src="js/IsValid.js"></script>
<script type="text/javascript" src="calendar/calendar.js"></script>
<script type="text/javascript" src="calendar/calendar-en.js"></script>
<script type="text/javascript" src="calendar/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="calendar/calendar-win2k-cold-1.css" title="win2k-cold-1" />

<script type="text/javascript" src="js/ui.core.js"></script>
<script type="text/javascript" src="js/ui.draggable.js"></script>
<script type="text/javascript" src="js/ui.position.js"></script>
<script type="text/javascript" src="js/ui.resizable.js"></script>
<script type="text/javascript" src="js/ui.dialog.js"></script>
<script type="text/javascript" src="js/effects.core.js"></script>
<script type="text/javascript" src="js/effects.blind.js"></script>
<script type="text/javascript" src="js/effects.fold.js"></script>

<script type="text/javascript" language="javascript">
$("#clearFields").live("click", function(event) {
    event.preventDefault();
    event.stopPropagation();
})

 $(document).ready(function(){
    $("#limit_notif").dialog({
        modal: true,
        width: 400,
        position: { my: "center top", at: "right top", of: document},
        resizable: false
    });
   $("input:radio[name=chargeType]").click(function() {
            var value = $(this).val();
           // alert(value);
            if(value == "SHA"){
                $("#spChargeType").text("*Note: Sender bears local charge while beneficiary bears offshore charge");        
                $("#chargeType").css("padding-bottom","10px"); 
            }else{
                $("#spChargeType").text("*Note: Sender bears both local and offshore charges (additional 30 Units of the Currency)");
                $("#chargeType").css("padding-bottom","10px");
            }
        });
 });

//01092014
function disableInterSwitchPayment()
{
   //Disable INTERSWITCH/BENEFICIARY option
        


            alert("THE INTERSWITCH/BENEFICIARY OPTION HAS BEEN DISABLED,PLEASE USE THE INTERBANK/BENEFICIARY(NEFT) OPTION");
            thisform.selPaymentType.focus();
            return false;
        
}

function disableForeignPayment()
{
   //Disable FOREIGN/BENEFICIARY option
        
        //var selectedText = $("#selPaymentType option:selected").text();//10092014
        var selectedText = $("input#PayType").val();//10092014
        
        if(selectedText == "FOREIGN/BENEFICIARY"){
        
            $("#dialog-form-ForeignPayment").dialog( "open" ); //14082014- To display Dialog for New Foreign Payment STP
            $("#showForeignFields").hide();
           // thisform.selPaymentType.focus();
            $('#selAcctList').attr('disabled', true);
            $('#selPaymentType').attr('disabled', true);
            $('#AMOUNT0').attr('disabled', true);
            $('#txtPaymentRef').attr('disabled', true);
            $('#txtPaymentRemarks').attr('disabled', true);
            $('#txtPaymentDate').attr('disabled', true);
            $('#btnSubmit').attr('disabled', true);
            
            return false;
          }  
}

//09092014
function enableForeignPayment()
{
   //enable FOREIGN/BENEFICIARY option
            
            $("#showForeignFields").show();
           // thisform.selPaymentType.focus();
            $('#selAcctList').attr('disabled', false);
            $('#selPaymentType').attr('disabled', false);
            $('#AMOUNT0').attr('disabled', false);
            $('#txtPaymentRef').attr('disabled', false);
            $('#txtPaymentRemarks').attr('disabled', false);
            $('#txtPaymentDate').attr('disabled', false);
            $('#btnSubmit').attr('disabled', false);
            
            return false;
}


function validateFields(thisform)
{
    if(!isBvn){
     alert('Selected account does not have a BVN');
     return false;
 }
       //01092014
        //disableInterSwitchPayment();
       
        //Validate Bank Code to ensure a valid Bank is selected
        if( $("#selPaymentType").val() == "DRAFT/ISSUANCE" || $("#selPaymentType").val() == "CORPORATE/CHEQUE" || $("#selPaymentType").val() == "INTERBANK/BENEFICIARY" || $("#selPaymentType").val() == "INTERSWITCH/BENEFICIARY")
        {
             if ( $.trim($("input#hidBankCode").val()) == "") 
             {
                alert("Please select bank from bank list");
                thisform.txtBeneficiaryBank.focus();
                return false;
             }
             
         if ( $.trim($("input#hidBankCode").val()) == "040" || $.trim($("input#hidBankCode").val()) == "056" || $.trim($("input#hidBankCode").val()) == "069" || $.trim($("input#hidBankCode").val()) == "085" || $.trim($("input#hidBankCode").val()) == "014") 
             {
                alert("Please the Bank is no longer valid");
                return false;
             }
        }
        
       
        if( $("#selPaymentType").val() == "FOREIGN/BENEFICIARY")
        {
           
           if (!$("input[name='chargeType']:checked").val()) {
            alert('Please select a charge option');
            return false;
           }
           
           /*
           if ( $.trim($("#txtSwiftCode").val()) == "") 
             {
                alert("Please enter Bank BIC/SwiftCode ");
                //thisform.txtSwiftCode.focus();
                return false;
             }
           */
             if ( $.trim($("#txtSortCode").val()) == "") 
             {
                alert("Please enter Bank Routing No./SortCode ");
                //thisform.txtSortCode.focus();
                return false;
             }
        }
        
        if (IsBlank(thisform.benficiaryName, "Please enter Beneficiary's name"))
        {
            thisform.benficiaryName.focus();
            return false;
        }else{
            thisform.hidBeneficiaryName.value = thisform.benficiaryName.value;
        }
        
        if($("#selPaymentType").val() != "ZENITH/PREPAID")
        {
            if (IsBlank(thisform.txtBeneficiaryBank, "Please enter Beneficiary's bank"))
            {
                thisform.txtBeneficiaryBank.focus();
                return false;
            }
            else
            {
                thisform.hidBeneficiaryBank.value = thisform.txtBeneficiaryBank.value;
            }
        }
                    
        if (IsBlank(thisform.txtBeneficiaryAcctNo, "Please enter Beneficiary's account number"))
        {
            thisform.txtBeneficiaryAcctNo.focus();
            return false;
        }else{
                thisform.hidBeneficiaryAcctNo.value = thisform.txtBeneficiaryAcctNo.value;                                    
        }
                    
        if (thisform.txtBeneficiaryEmail.value != null)
        {            
            thisform.hidBeneficiaryEmail.value = thisform.txtBeneficiaryEmail.value;
        }
        
        if (thisform.txtGSM.value != null)
        {            
            thisform.hidGSM.value = thisform.txtGSM.value;
        }
        
        if ((thisform.txtBeneficiaryBankBranch.value != null) && ((thisform.PayType.value != "DRAFT/ISSUANCE") && (thisform.PayType.value != "CORPORATE/CHEQUE") ))
        {                
            thisform.hidBeneficiaryBankBranch.value = thisform.txtBeneficiaryBankBranch.value;
        }
        
        if (thisform.txtBeneficiaryCode.value != null)
        {            
            thisform.hidBeneficiaryCode.value = thisform.txtBeneficiaryCode.value;
        }
        
        if (thisform.PayType.value == "FOREIGN/BENEFICIARY") 
        { 
           
            //21122012
            if(thisform.txtBeneficiaryaddress.value != null){
                thisform.hidBeneficiaryAddress.value = thisform.txtBeneficiaryaddress.value;
            }
            
             if(thisform.txtcity.value != null){
                thisform.hidBeneficiaryCity.value = thisform.txtcity.value;
            }
           
           
            if(thisform.txtSortCode.value != null){
                thisform.hidFBankSortCode.value = thisform.txtSortCode.value;
            }
            
            if(thisform.txtSwiftCode.value != null){
                thisform.hidSwiftCode.value = thisform.txtSwiftCode.value;
            }
            
            if(thisform.txtIntBankName.value != null){
                thisform.hidIntBankName.value = thisform.txtIntBankName.value;
            }
            if(thisform.txtIntBankAcctNo.value != null){
                thisform.hidIntBankAcctNo.value = thisform.txtIntBankAcctNo.value;
            }
            if(thisform.txtIntBankBIC.value != null){
                thisform.hidIntBankBIC.value = thisform.txtIntBankBIC.value;
            }
            
                  //added to make address mandatory-21122012
               if (IsBlank(thisform.txtBeneficiaryaddress, "Please enter Beneficiary Address "))
                {
                  thisform.txtBeneficiaryaddress.focus();
                  return false;
                }
                
                   //added to make  mandatory-21122012
               if (IsBlank(thisform.txtcity, "Please enter Beneficiary City "))
                {
                  thisform.txtcity.focus();
                  return false;
                }
            
        }
        
        if (thisform.PayType.value == "DRAFT/ISSUANCE" || thisform.PayType.value == "CORPORATE/CHEQUE")
        {
          //14082013-check to ensure the beneiciary branch is not blank and it is selected from the autocomplete list  
            if (IsBlank(thisform.hidBeneficiaryBankBranch, "Please, Select Beneficiary's branch from branch list to collect your draft/cheque"))
            {
                thisform.txtBeneficiaryBankBranch.focus();
                return false;
            }
            /*14082013
            else{
                thisform.hidBeneficiaryBankBranch.value = thisform.txtBeneficiaryBankBranch.value;
            }*/
        }
        
        // Validate From Account
                if (IsBlank(thisform.selAcctList, "Please select a source account from the list"))
                {
            thisform.selAcctList.focus();
            return false;
                }
                
                // Validate Payment Type 
                if (thisform.selPaymentType.options[thisform.selPaymentType.selectedIndex].value == "-1")
        {
            alert("Please select a payment type from the list.");
            thisform.selPaymentType.focus();
            return false;
        }
  
                // Validate Amount
                if (IsBlank(thisform.AMOUNT0, "Please enter the amount to be paid"))
                {
            thisform.AMOUNT0.focus();
            return false;
                }
        
                // Validate Payment Date
                if (IsBlank(thisform.txtPaymentDate, "Please select a Payment Date using the date picker"))
                {
            thisform.txtPaymentDate.focus();
            return false;
                }
        
        if ( (thisform.selPaymentType.value == "FOREIGN/BENEFICIARY") &&   IsBlank(thisform.txtPaymentRemarks, "Please purpose is mandatory for Foreign/Offshore transfers") )
        {
             thisform.txtPaymentRemarks.focus();
             return false;
        }else if(thisform.selPaymentType.value == "FOREIGN/BENEFICIARY"){
            if(Trim(thisform.txtPaymentRemarks.value).length <= 20)
            {
                alert("Please enter a reasonable payment purpose");
                return false;
            }
        }
        
        
        var dText1 = thisform.selAcctList.value.substring(thisform.selAcctList.value.length-3,thisform.selAcctList.value.length); 
        
        var check_acct = dText1.substring(0,3);
        
       
        if (check_acct != "216" && check_acct != "215" && check_acct != "113" && check_acct != "217" && check_acct != "101" && check_acct != "107" && check_acct != "109" && check_acct != "102" && check_acct != "100" && check_acct != "201" && check_acct != "200" && check_acct != "207" && check_acct != "206" && check_acct != "205"  && check_acct != "208" && check_acct != "210" && check_acct != "111" && check_acct != "116" && check_acct != "157" && check_acct != "156")
        {
            alert("Please you cannot transfer from this account");
            thisform.AMOUNT0.focus( );
            return false;
        }
        
        var dText2 = thisform.selPaymentType.value; 

        if ( check_acct != "201" && check_acct != "200" && check_acct != "207" && check_acct != "205" && check_acct != "206" && check_acct != "208" && check_acct != "210" && dText2 == "FOREIGN/BENEFICIARY")
        {
            alert("Please you cannot pay a Foreign beneficiary from this account");
            thisform.AMOUNT0.focus( );
            return false;
        }

        if (( check_acct == "207" || check_acct == "205"  || check_acct == "206" || check_acct == "208" || check_acct == "210") && (dText2 == "INTERBANK/BENEFICIARY" ||  dText2 == "DRAFT/ISSUANCE") )
        {
            alert("Please you cannot pay a local beneficiary from this account");
            thisform.AMOUNT0.focus( );
            return false;
        }

        if (  check_acct == "200" && check_acct == "207" && check_acct == "205"  && check_acct == "206" && check_acct == "208" && check_acct == "210" && dText2 != "INTERBANK/BENEFICIARY" &&  dText2 != "DRAFT/ISSUANCE")
        {
            alert("Please you cannot pay a local beneficiary from this account");
            thisform.AMOUNT0.focus( );
            return false;
        }
                                                                                
                // Validate Payment Ref 
                if (IsBlank(thisform.txtPaymentRef, "Please enter the transaction reference"))
                {
            thisform.txtPaymentRef.focus();
            return false;
                }
  
        //if($("#PayType").val() == "proceed"){ //22112012-uncommented on 22072014 to allow token validation for GO3 Token & inputer for multiple users .
        //if (thisform.multipleuser.value == "Y" || thisform.checkTokenValidateValue.value == "Y"){//20112012-commented on 22072014 to allow token validation for GO3 Token & inputer for multiple users .
        if (thisform.multipleuser.value == "Y" ){//22072014-- disable inputer for multiple users from Token Validation
            sure = confirm("Are you sure you want to make this payment to " + thisform.hidBeneficiaryName.value + " ?");
            if (sure)
            {
            thisform.action = "PaymentProcessor.jsp";
            thisform.submit();
            }
            else 
            {
                return false;
            }  
        }
        else
        {
            sure = confirm("Are you sure you want to make this payment to " + thisform.hidBeneficiaryName.value + " ?");
            if (sure)
            {   
               
                $( "#dialog-form" ).dialog( "open" );    
                $("#txtToken").val("");
                $("#spDialog").text("");
                $("#txtToken").focus();
               
               
            }
            else 
            {
                return false;
            }  
        }
                
}

function CheckBank(){
    if($("#txtBeneficiaryBank").val() == null || $("#txtBeneficiaryBank").val() == "")
    {
        alert("Please enter your bank name");
        $("#txtBeneficiaryBank").focus();
        return false;
    }
}

function ClearAmount(){
    $("#AMOUNT0").val("");
}

function CheckAmount(field)
{
    //Checking for number input using regex expression
    var numberRegex = /^[+-]?\d+(\.\d+)?([eE][+-]?\d+)?$/;
    var str = $.trim($(field).val());
    
    firstString = str.substring(0,str.length-1);
    secondStr = str.substring(str.length-1);
           
    if(numberRegex.test(str)) {
        Amountformat(field);
       $("#AMOUNT0").val(addCommas($("#AMOUNT0").val()));
    }
    else if(numberRegex.test(firstString) && secondStr.toUpperCase() == "K"){
        Amountformat(field);
       $("#AMOUNT0").val(addCommas($("#AMOUNT0").val()));
    }
    else if(numberRegex.test(firstString) && secondStr.toUpperCase() == "M"){
        Amountformat(field);
        $("#AMOUNT0").val(addCommas($("#AMOUNT0").val()));
    }
    else if(numberRegex.test(firstString) && secondStr.toUpperCase() == "B"){
        Amountformat(field);
        $("#AMOUNT0").val(addCommas($("#AMOUNT0").val()));
    }
    else if(numberRegex.test(firstString) && secondStr.toUpperCase() == "T"){
        Amountformat(field);
        $("#AMOUNT0").val(addCommas($("#AMOUNT0").val()));
    }
    else if(numberRegex.test(firstString) && secondStr.toUpperCase() == "H"){
        Amountformat(field);
        $("#AMOUNT0").val(addCommas($("#AMOUNT0").val()));
    }
    else if($.trim($(field).val()) == ""){
        return false;
    }
    else{
        alert("Amount input is not valid");
        $(field).focus();
        return false;
    }
}

function addCommas(nStr)
{
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}

$().ready(function() 
{
    $("#txtBeneficiaryAcctNo").change(function () {
        if ($("#txtBeneficiaryAcctNo").val().length <= 0)
        {
             $("#trAcctDetails").hide();
        }
    });
    
    $("#btnSubmit").click(function (){
    var selectedText = $("#selPaymentType option:selected").text();
        
    if(selectedText == "DRAFT/ISSUANCE" || selectedText == "CORPORATE/CHEQUE"){
        if($("input#hidBeneficiaryName").val() == null || $("input#hidBeneficiaryName").val() == ""){
            if($("#txtBeneficiaryBankBranch").val() == null || $("#txtBeneficiaryBankBranch").val() == ""){
                alert("Please enter a branch name");
                return false;
            }
        }
    }
    });    
    
    $("#btnValidate").click(function() {
        if($("#txtBeneficiaryAcctNo").val().length > 0)
        {
           ValidateAccts();//25072013
            if($("#hidBankCode").val().length > 0){
                var acc_no = $("#txtBeneficiaryAcctNo").val();
                var bankCode = $("#hidBankCode").val();
                
                $("#trAcctDetails").show();
                $("#tdValAccDetails").text("Please Wait...").css("padding-left","190px");
                $.post("makepayment_beneficiarypayment.jsp",{type : "loadBankDetails", acct_no : acc_no, bank_code : bankCode}, displayAccountDetails);
            }else{
                alert("Please enter beneficiary bank name");
                $("#txtBeneficiaryBank").focus();
            }
        }
    });
    
    
    function NUBANvalidateAccountDetails(data){
        if (data.error) // details not found
        {
            alert(data.error);
            alert("Please,amend the Account Number to a NUBAN-Compliant Account from the Beneficiary List");
           //05072013-NUBAN Account Validation for existing Beneficiary
            $('#AMOUNT0').attr('disabled', true);
            $('#txtPaymentRef').attr('disabled', true);
            $('#txtPaymentRemarks').attr('disabled', true);
        }
        else  // Found details. Display details
        {
            data = $.trim(data);
           // alert(data);
           // alert(data.length);
           if (data.length == 0 ){
               //05072013-NUBAN Account Validation for existing Beneficiary
               //alert ("NUBAN OK");
            $('#AMOUNT0').attr('disabled', false);
            $('#txtPaymentRef').attr('disabled', false);
            $('#txtPaymentRemarks').attr('disabled', false);
            }
            
            $("#tdValAccDetails").text(data).css("padding-left","190px");                   
         if (data.length > 0 ){
            alert(data);
            alert("Please,amend the Account Number to a NUBAN-Compliant Account from the Beneficiary List");
              //05072013-NUBAN Account Validation for existing Beneficiary
            $('#AMOUNT0').attr('disabled', true);
            $('#txtPaymentRef').attr('disabled', true);
            $('#txtPaymentRemarks').attr('disabled', true);
         
            $("#spAcct").show();
            $("#spAcct").html("<SPAN style=\'color:#EFOOOO;\'>Account Number is NON-NUBAN Compliant!<\/SPAN>");
            $("#tdValAccDetails").text(data).css("padding-left","190px"); 
           
      
            
            return false;
            }
        
        }
    }
            
    
    
    function displayAccountDetails(data){
        if (data.error) // details not found
        {
            alert( data.error);
        }
        else  // Found details. Display details
        {
            data = $.trim(data);
            
            if($("#hidBankCode").val() == "057") {
                if(data.length > 0){
                     //Store Account Number
                     $("#txtBeneficiaryAcctNo").val(data.split('|')[0]);
                     $("input#hidBeneficiaryAcctNo").val(data.split('|')[0]); 
                    
                     //Store Beneficiary Name
                     $("#benficiaryName").val(data.split('|')[1]);
                     $("input#hidBeneficiaryName").val(data.split('|')[1]);
                     
                    //Store the Bank ID
                     $("input#hidSortCode").val('057150013'); //Default to Head Office
                     
                     //Store the Bank Name
                     $("input#hidBeneficiaryBankBranch").val(data.split('|')[2]);
                     $("#txtBeneficiaryBankBranch").val(data.split('|')[2]);
                     
                     $("#tdValAccDetails").hide();
                                        
                }
                else{
                    $("#tdValAccDetails").text("Account number does not exist").css("padding-left","190px");                   
                }
            }
            else{
                if(data.length > 0){
                    if(data == "Error"){
                        $("#tdValAccDetails").text("Cannot retrieve account information");                   
                    }
                    else{
                        var acct_no = $("#txtBeneficiaryAcctNo").val();
                         //Store Account Number
                         $("#txtBeneficiaryAcctNo").val(acct_no);
                         $("input#hidBeneficiaryAcctNo").val(acct_no); 
                        
                         //Store Beneficiary Name
                         $("#benficiaryName").val(data);
                         $("input#hidBeneficiaryName").val(data);
                         $("#tdValAccDetails").hide();
                    }
                }
                else{
                    $("#tdValAccDetails").text("Account number does not exist").css("padding-left","190px");                    
                }
            }   
        }
    }
    
    //Enable or Disable fields depending on the beneficiary validation
    DisableFields("false",$("#beneficiaryValidation").val());     
    
    //Hide fields tied to Foreign Beneficiaries
    ForeignFields();
    
    //Call this function to get current date
    GetCurrentDate();
    
    //Get current date
    function GetCurrentDate(){
        var d = new Date();

        var month = d.getMonth()+1;
        var day = d.getDate();
        
        var output = ((''+month).length<2 ? '0' : '') + month +  
        '/' + ((''+day).length<2 ? '0' : '') + day + '/' + d.getFullYear();
            
        $("#txtPaymentDate").val(output);
    }   
   
        
     //Dialog box for token validation
     $( "#dialog-form" ).dialog({
            autoOpen: false,
            hide: 'fold',
            show: 'fold',
            draggable: false,    
            resizable: false,  
            modal: true,  
            width: 470,  
            height: 450,
            closeOnEscape: false,
            buttons: { 
                "Submit": function(){
                            var access = $("#hidAccessCode").val();
                            var login = $("#hidLoginID").val();
                            var token = $("#txtToken").val();
                            
                            if(token.length > 6)
                            {
                                $.post("makepayment_tokenValidation.jsp",{token : token, login : login, access : access}, displayTokenResult);
                            }else{
                                $("#spDialog").text("* Your token login is invalid");
                                $("#txtToken").focus();
                                return false;
                            }
                        },
                "Cancel": function(){
                            $( this ).dialog( "close" );
                        }                    
                    },
         open: function(event, ui) { 
                //$(".ui-dialog-titlebar-close").hide(); 
                $('.ui-dialog-buttonpane').find('button:contains("Cancel")').mouseover(function(){
                        $(this).addClass('cancelButtonHover');
                    }).mouseout(function(){
                        $(this).removeClass('cancelButtonHover');
                });
                $('.ui-dialog-buttonpane').find('button:contains("Submit")').mouseover(function(){
                        $(this).addClass('submitButtonHover');
                    }).mouseout(function(){
                        $(this).removeClass('submitButtonHover');
                });
            },
        close: function(event, ui) {
                $('.ui-dialog-buttonpane').find('button:contains("Cancel")').removeClass('cancelButtonHover');
                $('.ui-dialog-buttonpane').find('button:contains("Submit")').removeClass('submitButtonHover');
            } 
      });
      
      
      //Begin-Dialog box for New Foreign Payment
     $( "#dialog-form-ForeignPayment" ).dialog({
            autoOpen: false,
            hide: 'fold',
            show: 'fold',
            draggable: false,    
            resizable: false,  
            modal: true,  
            width: 470,  
            height: 450,
            closeOnEscape: false,
            buttons: { 
                "Continue": function(){
                            $( this ).dialog( "close" );
                        }                                            
                    },
         open: function(event, ui) { 
                $('.ui-dialog-buttonpane').find('button:contains("Continue")').mouseover(function(){
                        $(this).addClass('continueButtonHover');
                    }).mouseout(function(){
                        $(this).removeClass('continueButtonHover');
                });
            },
        close: function(event, ui) {
               // $('.ui-dialog-buttonpane').find('button:contains("Cancel")').removeClass('cancelButtonHover');
                $('.ui-dialog-buttonpane').find('button:contains("Continue")').removeClass('continueButtonHover');
            } 
      });
    //End-Dialog box for New Foreign Payment  
      
      function displayTokenResult(data) {
          if (data.error) 
          {
              alert( data.error);
          }
          else  
          {
             data = $.trim(data);
             
             if(data == "success"){
                $("#infoTokenDiv").addClass("hideDiv");
                $("#inputTokenDiv").addClass("hideDiv");
                $("#spanTokenDiv").addClass("hideDiv");
                $("#successTokenDiv").addClass("validated").show();
                    
                $("input#PayType").val("proceed");
                
                document.forms["mainForm"].action = "PaymentProcessor.jsp";
                document.forms["mainForm"].submit();
                //$("#mainForm").attr("action", "PaymentProcessor.jsp");
                //$("#mainForm").submit();
                $("#spDialog").text("");
             }else if(data == "disabled"){
                $("#spDialog").html("<SPAN style='font-weight:bold; color:#EFOOOO; font-size:1em;'>* Your token has been disabled");
                $("#txtToken").focus();
                return false;
             }else if(data == "weakPin"){
                $("#spDialog").html("<SPAN style='font-weight:bold; color:#EFOOOO; font-size:1em;'>* Your token pin is too weak");
                $("#txtToken").focus();
                return false;
             }else if(data == "invalidLogin"){
                $("#spDialog").html("<SPAN style='font-weight:bold; color:#EFOOOO; font-size:1em;'>* Your token login is invalid");
                $("#txtToken").focus();
                return false;
             }else if(data == "noPin"){
                $("#spDialog").html("<SPAN style='font-weight:bold; color:#EFOOOO; font-size:1em;'>* You supplied no pin");
                $("#txtToken").focus();
                return false;
             }else if(data == "recordNotApproved"){
                $("#spDialog").html("<SPAN style='font-weight:bold; color:#EFOOOO; font-size:1em;'>* Your token record has not been approved");
                $("#txtToken").focus();
                return false;
             }else{
                //tokenNotAssigned
                $("#spDialog").html("<SPAN style='font-weight:bold; color:#EFOOOO; font-size:1em;'>* Your token has not been assigned"); 
                $("#txtToken").focus();
                return false;
            }

          }
      }
      
      //Disable fields where necessary
     function DisableFields(flag, beneVal){
        if(beneVal == "true"){
            $('#benficiaryName').attr('readonly', flag == "true" ? true : false);
            
            $('#txtBeneficiaryBank').attr('disabled', flag == "true" ? true : false);
            $('#txtBeneficiaryBankBranch').attr('disabled', flag == "true" ? true : false);
            $('#txtBeneficiaryAcctNo').attr('disabled', flag == "true" ? true : false);
            
            $('#txtBeneficiaryCode').attr('disabled', flag == "true" ? true : false);
            $("#txtBeneficiaryEmail").attr('disabled', flag == "true" ? true : false);
            $("#txtGSM").attr('disabled', flag == "true" ? true : false);
            
          
            
            $("#fieldsDisabled").val(flag);
            $("#trAcctDetails").hide();
            $("#trBeneValInfo").show();
            
            //21122012- beneficiary address
            if ($("#txtBeneficiaryaddress").length > 0){
                $('#txtBeneficiaryaddress').attr('disabled', flag == "true" ? true : false);
            }
            
            if ($("#txtcity").length > 0){
                $('#txtcity').attr('disabled', flag == "true" ? true : false);
            }
            
            if ($("#txtSortCode").length > 0){
                $('#txtSortCode').attr('disabled', flag == "true" ? true : false);
            }
            
            if ($("#txtSwiftCode").length > 0){
                $('#txtSwiftCode').attr('disabled', flag == "true" ? true : false);
            }
            
            if ($("#txtIntBankBIC").length > 0){
                $('#txtIntBankBIC').attr('disabled', flag == "true" ? true : false);
            }
            if ($("#txtIntBankAcctNo").length > 0){
                $('#txtIntBankAcctNo').attr('disabled', flag == "true" ? true : false);
            }
            if ($("#txtIntBankName").length > 0){
               $('#txtIntBankName').attr('disabled', flag == "true" ? true : false);
            }        
            if(flag == "true"){
                $("#chkBeneficiary").attr("Checked", false);
                $("#spanBeneficiary").hide();
                $("#btnValidate").hide(); 
            }else{
                $("#chkBeneficiary").attr("Checked", false);
                $("#spanBeneficiary").hide();
                $("#btnValidate").show(); 
            }               
        }else{
            $('#benficiaryName').attr('readonly', flag == "true" ? true : false);
            
            $('#txtBeneficiaryBank').attr('disabled', flag == "true" ? true : false);
            $('#txtBeneficiaryBankBranch').attr('disabled', flag == "true" ? true : false);
            $('#txtBeneficiaryAcctNo').attr('disabled', flag == "true" ? true : false);
            $('#txtBeneficiaryCode').attr('disabled', flag == "true" ? true : false);
            $("#txtBeneficiaryEmail").attr('disabled', flag == "true" ? true : false);
            $("#txtGSM").attr('disabled', flag == "true" ? true : false);
            $("#fieldsDisabled").val(flag);
            $("#trAcctDetails").hide();
            $("#trBeneValInfo").hide();
            
            if ($("#txtSortCode").length > 0){
                $('#txtSortCode').attr('disabled', flag == "true" ? true : false);
            }
            
            if ($("#txtSwiftCode").length > 0){
                $('#txtSwiftCode').attr('disabled', flag == "true" ? true : false);
            }
            
            if ($("#txtIntBankBIC").length > 0){
                $('#txtIntBankBIC').attr('disabled', flag == "true" ? true : false);
            }
            if ($("#txtIntBankAcctNo").length > 0){
                $('#txtIntBankAcctNo').attr('disabled', flag == "true" ? true : false);
            }
            if ($("#txtIntBankName").length > 0){
                $('#txtIntBankName').attr('disabled', flag == "true" ? true : false);
            }        
            if(flag == "true"){
                $("#chkBeneficiary").attr("Checked", false);
                $("#spanBeneficiary").hide();
                $("#btnValidate").hide(); 
            }else{
                $("#chkBeneficiary").attr("Checked", false);
                $("#spanBeneficiary").show();
                $("#btnValidate").show(); 
            }  
        }
    }
    
     
    //Clear Fields
     $(function(){
        $("#clearFields").click(function(){   
            $("input#PayType").val("Please Select....");
            $('#selPaymentType option:contains("Please Select....")').attr("selected","selected");
            $("input#hidBeneficiary_ids").val("");
            $("input#benficiaryName").val("");
            
            $("#txtBeneficiaryCode").val("");
            $("#txtBeneficiaryBank").val("");
            $("#txtBeneficiaryBankBranch").val("");
            $("#txtBeneficiaryAcctNo").val("");
            $("#txtBeneficiaryEmail").val("");
            $("#txtGSM").val("");
            
            //21122012-Beneficiary Address
            $("#txtBeneficiaryaddress").val("");
            $("#txtcity").val("");
            
            //Set Hidden Fields
            $("input#hidBankCode").val("");
            $("input#hidSortCode").val("");
            $("input#hidBeneficiaryCode").val("");
            $("input#hidBeneficiaryAddress").val("");
            $("input#hidBeneficiaryCity").val("");
            $("input#hidBeneficiaryState").val("");
            $("input#hidBeneficiaryPhone").val("");
            $("input#hidBeneficiaryEmail").val("");
            $("input#hidBeneficiaryBankBranch").val("");
            $("input#hidBeneficiaryAcctNo").val("");
            $("input#hidBeneficiaryBank").val("");
            $("input#hidBeneficiaryName").val("");
            $("input#hidExistingBeneficiary").val("");
            
            if ($("#txtIntBankBIC").length > 0){
                $("#txtSortCode").val("");
                $("#txtSwiftCode").val("");
                $("#txtIntBankBIC").val("");
                $("#txtIntBankAcctNo").val("");
                $("#txtIntBankName").val("");
                $("input#hidFBankSortCode").val("");
                $("input#hidSwiftCode").val("");
                $("input#hidIntBankName").val("");
                $("input#hidIntBankAcctNo").val("");
                $("input#hidIntBankBIC").val("");
                
                $('#selPaymentType option:contains("Please Select....")').attr("selected","selected");
                $("#showForeignFields").hide();
            }       
            
            $("#AMOUNT0").val("");
            $("#txtPaymentRef").val("");
            $("#txtPaymentRemarks").val("");
            GetCurrentDate();
            
            loadPaymentTypeDropdown();
            //05072013-NUBAN Account Validation for existing Beneficiary
            
            $('#AMOUNT0').attr('disabled', false);
            $('#txtPaymentRef').attr('disabled', false);
            $('#txtPaymentRemarks').attr('disabled', false);
            
            DisableFields("false",$("#beneficiaryValidation").val());
            
            if($("#benficiaryName").length > 0){
                $("#benficiaryName").focus();
            }
            $("#infoOption").text("");
        });
    });
    
 //Autocomplete for Beneficiaries
    $(function(){
        $("#benficiaryName").autocomplete("makepayment_autocomplete.jsp",{
                minChars: 2,
                width: 300,
                                multiple: false,
                                matchContains: true,
                mustMatch: false,
                formatItem: formatBeneficiaryItem,//modified 21/07/2014 to add Code,Account & Bank Details
                formatResult: formatBeneficiaryResult
        });
    });
    
    $("#benficiaryName").result(logBeneficiaries).next().click(function() {
                $(this).prev().search();
    });
    
    function formatBeneficiaryItem(row){
      return  "Name:" + row[0]  + "|Code:" + row[3] + "|Account:" + row[4] + "|Bank:" + row[5] ;
    }
    
    function formatBeneficiaryResult(row) {
        row = row + "";
        var rowFormatted = row.split(',')[0] ;
        return rowFormatted;
    }
  
    
    
    function formatItem(row){
         return row[0];
    }
    
    function formatResult(row) {
        row = row + "";
        var rowFormatted = row.split(',')[0]  ;
        return rowFormatted;
    }
    
    function logBeneficiaries(event, data, formatted) {
         data = data + "";
         var o = data.split(',')[1];
         var p = $.trim(data.split(',')[2]);
         //alert(p);
         //alert(o);
         //Store the Id  of the beneficiary
         $("input#hidBeneficiary_ids").val(o);
                  
         try
         {
            $("input#PayType").val(p);
         }
         catch(e)
         {
            alert(e);
         }
         
         //Load Beneficiary details
         loadBeneficiaryDetails(o);
         //Load Payment type dropdown
         loadPaymentTypeDropdown();        
         DisableFields("true",$("#beneficiaryValidation").val());
         $("#selPaymentType").focus();
         
         if(p.substring(0,2).toUpperCase() == "ZE"){
                $("#selPaymentType").focus();
            }else if(p.substring(0,2).toUpperCase() == "IN"){
               $("#selPaymentType").focus();
            }else if(p.substring(0,2).toUpperCase() == "FO"){
       
       alert("FOREIGN/PAYMENT OPTION HAS BEEN DISABLED,USE THE FOREIGN PAYMENT LINK IN THE PAYMENT MENU");
       
       
//09092014- To allow for only TAX Paymentes for Intels to CBN(FGN FIRS VAT ACCOUNT) or CBN(FGN FIRS WHT ACCOUNT)
//if  ( ($("#hidCompanyCode").val() != "CIB0090009461")   &&  $("#txtBeneficiaryAcctNo").val() != "000000400216698" ||  $("#txtBeneficiaryAcctNo").val() != "000000400216639" )
     
if  ( $("#txtBeneficiaryAcctNo").val() != "000000400216698" &&  $("#txtBeneficiaryAcctNo").val() != "000000400216639" )
                      {
                      disableForeignPayment();//02092014
                      }
                 else
                      {
                      enableForeignPayment();//09092014
                      }
                      
                $("#selPaymentType").focus();
            }else{
                $("#AMOUNTO").focus();
            }
        //alert(p);
         $("#selPaymentType").val(p);
        //alert( $("#selPaymentType").val());
         
       //Disable INTERSWITCH/BENEFICIARY option
        /*if (p == "INTERSWITCH/BENEFICIARY")
         {
         disableInterSwitchPayment();//01092014
         }
         */

         
    }
    
    //Autocomplete for Banks
    $(function AutocompleteBanks(){
       // $("#txtBeneficiaryBank").autocomplete("makepayment_autocompleteBanks.jsp",{//15052013
        $("#txtBeneficiaryBank").autocomplete("makepayment_autocompleteBanks.jsp?bankCode="+ $("#hidBankCode").val(),{
      
                minChars: 1,
                width: 300,
                multiple: false,
                matchContains: true,
                mustMatch: false,
                formatItem: formatItem,
                formatResult: formatResult
        });
    });
    
    $("#txtBeneficiaryBank").result(logBanks).next().click(function() {
                $(this).prev().search();
    });
    
    function logBanks(event, data, formatted) {
         data = data + "";
         var o = data.split(',')[0];
         var p = data.split(',')[1];
         
         //Store the Bank ID
         $("input#hidBankCode").val(p);
         
         //Store the Bank Name
         $("input#hidBeneficiaryBank").val(o);  
         
         AutocompleteBankBranches();
         $("#txtBeneficiaryAcctNo").focus();
         
         if($("input#hidBankCode").val() == "057"){
            $("input#PayType").val("ZENITH/BENEFICIARY");
         }else{
            $("input#PayType").val("INTERBANK/BENEFICIARY");
         }
            $("#trAcctDetails").hide();
            $("#txtBeneficiaryAcctNo").val("")
         loadPaymentTypeDropdown();
         $("#infoOption").text("");
         $("#showForeignFields").hide();
    }
    
     //Autocomplete for Banks
    function AutocompleteBankBranches()
    {
    
    var postingPage = "makepayment_autocompleteBankBranches.jsp?hidBankCode=" + $("#hidBankCode").val();
        //added .unbind('.autocomplete') to prevent previous displaying of search for branches of other banks -16042013
        $("#txtBeneficiaryBankBranch").unbind('.autocomplete').autocomplete(postingPage,{
                minChars: 1,
                width: 300,
                                multiple: false,
                                matchContains: true,
                mustMatch: false,
                formatItem: formatItem,
                formatResult: formatResult
        });
    }
    
    
    $("#txtBeneficiaryBankBranch").result(logBankBranches).next().click(function() {
               
             // $(this).prev().search();16042013
    });
    
    function logBankBranches(event, data, formatted) {
         data = data + "";
         var o = data.split(',')[0];
         var p = data.split(',')[1];
         
         //alert("p in logBankBranches" + p);
         //Store the Bank ID
         $("input#hidSortCode").val(p);
         
         //Store the Bank Name
         $("input#hidBeneficiaryBankBranch").val(o); 
         
         $("#txtBeneficiaryCode").focus();         
    }
    
    //Display fields for Foreign Beneficiaries function
    function ForeignFields(){
        var selectedText = $("#selPaymentType option:selected").text();//10092014
        //var selectedText = $("input#PayType").val();//10092014//commented 10022015
       // alert("selectedtext" + selectedText);
        if(selectedText == "FOREIGN/BENEFICIARY"){
            //$("#dialog-form-ForeignPayment").dialog( "open" ); //14082014- To display Dialog for New Foreign Payment STP
           

            $("#showForeignFields").show();
            $("#FInfo").show();
            $("input#PayType").val(selectedText);
            //09092014-Begin - To show disable ForeignPayment Fields
            
            //if($("#hidCompanyCode").val() != "CIB0090009461") 
            if  ( $("#txtBeneficiaryAcctNo").val() != "000000400216698" &&  $("#txtBeneficiaryAcctNo").val() != "000000400216639" )
            //if ( $("#hidCompanyCode").val() != "CIB0090009461"   && ( $("#txtBeneficiaryAcctNo").val() != "000000400216639" ||  $("#txtBeneficiaryAcctNo").val() != "000000400216698") )            
            {
              disableForeignPayment();
            }
            
            //09092014-End - To show disable ForeignPayment Fields
        }else{
            $("#showForeignFields").hide();
            $("#FInfo").hide();
            $("input#PayType").val(selectedText);
        }
        
        
        if(selectedText == "DRAFT/ISSUANCE" || selectedText == "CORPORATE/CHEQUE"){
         $("#txtBeneficiaryAcctNo").val("BANKCHEQUE");//17042013
            if($("input#hidBeneficiaryName").val() == null || $("input#hidBeneficiaryName").val() == ""){
                if($("#txtBeneficiaryBankBranch").val() == null || $("#txtBeneficiaryBankBranch").val() == ""){
                    $("#infoOption").text("Please type a bank branch to pick up your draft/cheque");
                }else{
                    $("#infoOption").text("");
                }
            }else{
                $("#infoOption").text("");
            }
        }else{
        $("#infoOption").text("");
        }
    }
        
    $("#selPaymentType").change(function() {
        ForeignFields();//10092014//commented 09022015
        //disableForeignPayment();//10092014//commented 09022015

        //disableInterSwitchPayment();//01092014
    });
          
    //Get Beneficiary details from database
    function loadBeneficiaryDetails(beneficiaryID)
    {
        try {
                 $.getJSON("makepayment_beneficiarypayment.jsp",
                {
                    id: beneficiaryID,
                    type: "loadIndividual",
                    format: "json"
                },
                function (data) 
                {
                    if (data != null && data != "") 
                        {
                            $("#txtBeneficiaryCode").val(data.BeneficiaryCode);
                            $("#txtBeneficiaryBank").val(data.BeneficiaryBankName);
                            $("#txtBeneficiaryBankBranch").val(data.BeneficiaryBankBranchName);
                            $("#txtBeneficiaryAcctNo").val(data.BeneficiaryAccountNo);
                            $("#txtBeneficiaryEmail").val(data.BeneficiaryEmail);
                            $("#txtGSM").val(data.BeneficiaryGSM);
                            
                            //Set Hidden Fields
                            $("input#hidBankCode").val(data.BeneficiaryBankID);
                            $("input#hidSortCode").val(data.BeneficiaryBankBranchRecID);
                            $("input#hidBeneficiaryCode").val(data.BeneficiaryCode);
                            $("input#hidBeneficiaryAddress").val(data.BeneficiaryAddress);
                            $("input#hidBeneficiaryCity").val(data.BeneficiaryCity);
                            $("input#hidBeneficiaryState").val(data.BeneficiaryState);
                            $("input#hidBeneficiaryPhone").val(data.BeneficiaryPhone);
                            $("input#hidGSM").val(data.BeneficiaryGSM);
                            $("input#hidBeneficiaryEmail").val(data.BeneficiaryEmail);
                            $("input#hidBeneficiaryBankBranch").val(data.BeneficiaryBankBranchName);
                            $("input#hidBeneficiaryAcctNo").val(data.BeneficiaryAccountNo);
                            $("input#hidBeneficiaryBank").val(data.BeneficiaryBankName);
                            $("input#hidBeneficiaryName").val(data.BeneficiaryName);
                            $("input#PayType").val(data.PaymentType); 
                            $("input#hidExistingBeneficiary").val("exists");
        
                            //added for Foreign Beneficiary address-21122012
                            $("#txtBeneficiaryaddress").val(data.BeneficiaryAddress);
                            $("#txtcity").val(data.BeneficiaryCity);
                            $("#txtSortCode").val(data.BeneficiaryBankBranchRecID);
                            $("#txtSwiftCode").val(data.BeneficiaryBankID);//08022013
                            
                        //Set Dropdown to the payment type//23112012
                        //alert(data.PaymentType);
                        //$('#selPaymentType option:contains("' + data.PaymentType + '")').attr("selected","selected");

                        if ($("#txtIntBankBIC").length > 0){
                            //$("#txtSortCode").val(data.SortCode);
                            //$("#txtSwiftCode").val(data.SwiftCode);
                            $("#txtIntBankBIC").val(data.IntBankBic);
                            $("#txtIntBankAcctNo").val(data.IntAccountNo);
                            $("#txtIntBankName").val(data.IntBankName);
                            //$("input#hidFBankSortCode").val(data.SortCode);
                            //$("input#hidSwiftCode").val(data.SwiftCode);
                            $("input#hidIntBankName").val(data.IntBankName);
                            $("input#hidIntBankAcctNo").val(data.IntAccountNo);
                            $("input#hidIntBankBIC").val(data.IntBankBic);
                        }
                        ValidateAccts();
                        ForeignFields();
                        
                    }

                });

            }
            catch (e) {
                alert(e.message);
            }
        }
  
  
 //05072013-NUBAN Account Validation for existing Beneficiary 
function ValidateAccts()
  {
   
   var fieldVal = $("#txtBeneficiaryAcctNo").val();
       // var numberRegex = /^[+-]?\d+(\.\d+)?([eE][+-]?\d+)?$/;
       // var str = fieldVal;
        //alert($("#selPaymentType").val());//07082014
        
//if ($("#selPaymentType").val() != "FOREIGN/BENEFICIARY" && $("#selPaymentType").val() != "DRAFT/ISSUANCE"  &&  $("#selPaymentType").val() != "CORPORATE/CHEQUE" )    //added 17042013
//begin-added to validate NUBAN for applicable payment types 02092014
if ($("#selPaymentType").val() == "INTERBANK/BENEFICIARY" || $("#selPaymentType").val() == "INTERBANK/DIRECTDEBIT"  
||  $("#selPaymentType").val() == "INTERSWITCH/BENEFICIARY" ||  $("#selPaymentType").val() == "ZENITH/BENEFICIARY" 
||  $("#selPaymentType").val() == "ZENITH/FTCREDIT" ||  $("#selPaymentType").val() == "ZENITH/FTDEBIT")
//end-added to validate NUBAN for applicable payment types 02092014
               { 
                 if( ( $("#txtBeneficiaryAcctNo").val().length < 10 ) || ($("#txtBeneficiaryAcctNo").val().length > 10 ) )
                    {
                       alert("Please,Account Number must be 10 digits");
                       alert("Please,amend the Account Number to a NUBAN-Compliant Account from the Beneficiary List");
                       
                        $('#AMOUNT0').attr('disabled', true);
                        $('#txtPaymentRef').attr('disabled', true);
                        $('#txtPaymentRemarks').attr('disabled', true);
                       // $("#txtBeneficiaryAcctNo").focus();
                        return false;
                    }
                  if($("#txtBeneficiaryAcctNo").val().length == 10 )
                  {
                    if($("#hidBankCode").val().length > 0){
                        var acc_no = $("#txtBeneficiaryAcctNo").val();
                        var bankCode = $("#hidBankCode").val();
                        
                        $("#trAcctDetails").show();
                        $("#tdValAccDetails").text("Please Wait...").css("padding-left","190px");
                        $.post("makepayment_beneficiarypayment.jsp",{type : "NUBANvalidateAccount", acct_no : acc_no, bank_code : bankCode}, NUBANvalidateAccountDetails);
                        return false;
                   }
                   /*
                   else{
                        ////alert("Please enter Account Number");
                        //$("#txtBeneficiaryAcctNo").focus();
                        return false;
                    }
                    */
                 }
            }
            
  }
  
  
    //Reload payment dropdown
    function loadPaymentTypeDropdown()
    {
        var limitName = $("#PayType").val();
        //alert(limitName);
        var companyCode = $("#hidCompanyCode").val();//11092014-added to include company code to check if INTERSWITCH/BENEFICIARY is allowed
        try
        {
           var url = 'makepayment_beneficiarypayment.jsp';
           
           //$.post( "makepayment_beneficiarypayment.jsp",{type : "loadPayment", param : limitName}, displayPaymentTypeResult);//11092014-commented to include company code to check if INTERSWITCH/BENEFICIARY is allowed
           $.post( "makepayment_beneficiarypayment.jsp",{type : "loadPayment", param : limitName,companyID : companyCode}, displayPaymentTypeResult);//11092014-added to include company code to check if INTERSWITCH/BENEFICIARY is allowed
        }
        catch(e)
        {
            alert(e.message);
        }
    }
         
    function displayPaymentTypeResult(data) {
      if (data.error) 
      {
          alert( data.error);
      }
      else 
      {
         data = data + "";
         var options = $("#selPaymentType");
            options
                .find('option')
                .remove()
                .end()
            ;
           
            $("#selPaymentType").append("<option value=\'-1\'>Please Select....<\/option>");
            $(data.split(',')).each(function(value){
            var childData = data.split(',')[value];
            var optionText = childData.split('|')[1];   
            var oText = "<option value=\"" + optionText + "\">" + optionText + "<\/option>";
            $('#selPaymentType').append(oText);
           

        });
      }
      
      var paymentType = $("#PayType").val();
        if(paymentType != "" || paymentType != null){
            $('#selPaymentType option:contains("' + paymentType + '")').attr("selected","selected");
        }else{
            $('#selPaymentType option:contains("Please Select....")').attr("selected","selected");
        }
    }
    
    
    //Validate account field
     $("#txtBeneficiaryAcctNo").blur(function(){
        var fieldVal = $("#txtBeneficiaryAcctNo").val();
        var numberRegex = /^[+-]?\d+(\.\d+)?([eE][+-]?\d+)?$/;
        var str = fieldVal;
        
 
//if ($("#selPaymentType").val() != "FOREIGN/BENEFICIARY" && $("#selPaymentType").val() != "DRAFT/ISSUANCE"  &&  $("#selPaymentType").val() != "CORPORATE/CHEQUE" )    //added 17042013

//begin-added to validate NUBAN for applicable payment types 02092014
if ($("#selPaymentType").val() == "INTERBANK/BENEFICIARY" || $("#selPaymentType").val() == "INTERBANK/DIRECTDEBIT"  
||  $("#selPaymentType").val() == "INTERSWITCH/BENEFICIARY" ||  $("#selPaymentType").val() == "ZENITH/BENEFICIARY" 
||  $("#selPaymentType").val() == "ZENITH/FTCREDIT" ||  $("#selPaymentType").val() == "ZENITH/FTDEBIT")
//end-added to validate NUBAN for applicable payment types 02092014       
       { 
        
         /*
         if( ( $("#txtBeneficiaryAcctNo").val().length < 10 ) || ($("#txtBeneficiaryAcctNo").val().length > 10 ) )
            {
               alert("Please Account Number must be 10 digits");
                $("#txtBeneficiaryAcctNo").focus();
            }
          */  
          if($("#txtBeneficiaryAcctNo").val().length > 0 )
          {
         
            if($("#hidBankCode").val().length > 0){
                var acc_no = $("#txtBeneficiaryAcctNo").val();
                var bankCode = $("#hidBankCode").val();
                
                $("#trAcctDetails").show();
                $("#tdValAccDetails").text("Please Wait...").css("padding-left","190px");
                $.post("makepayment_beneficiarypayment.jsp",{type : "NUBANvalidateAccount", acct_no : acc_no, bank_code : bankCode}, NUBANvalidateAccountDetails);
           
           }
           /*
           else{
                ////alert("Please enter Account Number");
                ////$("#txtBeneficiaryAcctNo").focus();
            }
            */
         }
       }
        
    
       //commented-04102013 to validate for local banks and allow alphanumeric for FOREIGN/BENEFICIARY
       // if ($("#selPaymentType").val() != "DRAFT/ISSUANCE"  &&  $("#selPaymentType").val() != "CORPORATE/CHEQUE" &&  $("#selPaymentType").val() != "FOREIGN/BENEFICIARY")    //added 17042013
       if($("#hidBankCode").val().length > 0)//added-04102013 to validate for local banks and allow alphanumeric for FOREIGN/BENEFICIARY
        {
            
            if(numberRegex.test(str)) {
                $("#spAcct").html("");
                $("#spAcct").hide();
                return false;
            } 
            else if(fieldVal == ""){
                $("#spAcct").html("");
                $("#spAcct").hide();
                return false;
            }
            else {
                $("#txtBeneficiaryAcctNo").focus();
                $("#spAcct").show();
                $("#spAcct").html("<SPAN style=\'color:#EFOOOO;\'>Account Number is Invalid!<\/SPAN>");
                return false;
            }
       }
       

       
     });
     
     //Validate email field
     $("#txtBeneficiaryEmail").blur(function(){
        var fieldVal = $("#txtBeneficiaryEmail").val();
        var emailRegex = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i;
        var str = fieldVal;
        
        if(emailRegex.test(str)) {
            $("#spEmail").html("");
            return false;
        } 
        else if(fieldVal == ""){
            $("#spEmail").html("");
            return false;
        }
        else {
            $("#txtBeneficiaryEmail").focus();
            $("#spEmail").html("<SPAN style=\'color:#EFOOOO;\'>Email Address is Invalid!<\/SPAN>");
            return false;
        }
     });



//    validateBVN($('#selAcctList'));


});

var isBvn = false;
function validateBVN(accts){
//    console.log(accts.validity);
    $('#bvnError').html('');
//    if(accts.val() === '' || accts.val() === undefined){
//        alert('no account');
//    }
    var acctNo = accts.val().split('*');
    
    if(acctNo[1] === 'NGN'){
        isBvn = true;
        return;
    }
    $('select').attr('disabled','disabled');
    $('#btnSubmit').attr('disabled','disabled');
    $('#spinner').show();
    $.getJSON('BVNCheckAjax.jsp?q='+acctNo[0],function(flag){
        $('#spinner').hide();
        $('select').removeAttr('disabled');
        $('#btnSubmit').removeAttr('disabled');
        if(!flag.bvn){
            isBvn = false;
            $('#bvnError').html('<span style="color: red;font-size: 12px;font-weight: bold">**'+acctNo[0]+' does not have a BVN</span>');
        }else{
            isBvn = true;
        }
    }).fail(function(err){
        if (err.status === 403) {
            alert('Your session has expired!');
            location.href = 'sessiontimeout.jsp';            
        }
        $('#spinner').hide();
        $('select').removeAttr('disabled');
        $('#btnSubmit').removeAttr('disabled');
        console.log(err);
    });
}

  
</script>
<style type="text/css">      
    .bordered {
        border: 1px solid #f00;
    }
    
    input.readOnlyTextBox
    {
        background-color: #FFFFFF !important;
        color: #333333;
        outline: none;
    }
    a
    {
        text-decoration: underline;
    }
    a:hover
    {
        text-decoration: none;
    }
    
    .asterisks{
        color: red;
        margin-left: 5px;
    }
    
    .error{
        color:#EFOOOO; font-size:0.9em;
    }
    
    .hideDiv{
        display:none;
    }
    
    strong{
        font-size: 14px;
    }
        
    tr .child{
        margin-top: 5px;
    }
    
    span{
        font-size: 11px;
    }
    
    .dialog-child{
        margin-top: 30px;
    }
    
    .dialogError{
        margin-top: 10px;
        color:#000000;
        font-size: 11px;
    }
    
    .dialog-child{
        margin-top: 20px;
        text-align: center;
        padding-bottom: 5px;
        color: red;
        font-weight: bold;
    }
    
    .validated{
        color: red;
        font-weight: bold;
        font-size: 20px;
        text-align: center;
    }
    
    tr.valDetails > td{
        padding-top: 50px; 
        padding-bottom:5px;
    }
    
    .valFields{
        padding-left: 10px;
    }
    .ac_over {
                background-color: #cccccc;
                color: black;
}

tr.charge > td{
    padding-top:5px;
}
</style>
</head>

<body class="parentBody" id="div_body">
<div id="limit_notif" title="Limit Notification">
  <p>Transactions above =N=2,000,000 will be queued and processed on next business day during weekends and holidays</p>
</div>
<DIV align="center">
<form name="form" id="mainForm" action="makepayment.jsp" method="post" onsubmit="return validateFields(this);">
    <DIV id="dialog-form" title="Token Validation" style="display:none; margin:0px; padding:0px; height:450px; top:200px;">           
       <DIV id="infoTokenDiv" class="dialog-child" style='font-size:0.8em; padding:2px; margin:0px; text-align:justify;'>
            <span style='color:#000000; font-size:0.9em;'>Please enter your PIN and the One-Time Password (OTP) generated by your Hardware Token.</span>
            <div style='margin-top:15px; text-align:center;'>Note that the Token Code expires in One (1) Minute.</div>
       </DIV>
       <DIV id="inputTokenDiv" style="text-align: center; margin-top:5px;">
            <INPUT type="password" style="width:200px" id="txtToken" name="txtToken" value="" />
       </DIV>
       <DIV id="spanTokenDiv" style="text-align: left; margin-top:20px;">
         <span class="dialogError" id="spDialog"></span>
        </DIV>
        <DIV id="successTokenDiv" style="display:none;">
            <TABLE frame='Void' rules='None' summary='Body-table' border='0' cellspacing='0' cellpadding='0' style='width:100%; margin:0px 0% 0px 0%; background-color:#FFFFFF; color:#000000;'>
                <TR>
                    <TD>
                        <img id="tokenIMG" src="images/TokenValidated.gif" alt="Token Validated" style='margin:3px; 0px none transparent;'/>
                    </TD>
                    <TD>
                        <DIV style='font-size:1.1em; font-weight:bold; margin-bottom:30px;'>Token validation <B>successful</B></DIV>
                        <DIV><img src="images/ProcessingTrans.gif" alt="Processing transaction..." style='0px none transparent;'/></DIV>
                    </TD>
                </TR>
            </TABLE>
        </DIV>
    </DIV>
    <!--14082014-Begin- To display Dialog for New Foreign Payment STP-->
    <DIV id="dialog-form-ForeignPayment" title=" Introducing the New Foreign Payment " style="display:none; margin:0px; padding:0px; height:450px; top:200px;">           
       <DIV id="infoForeignPaymentDiv" class="dialog-child" style='font-size:0.8em; padding:2px; margin:0px; text-align:justify;'>
            <br>
            <span style='color:#000000; font-size:0.9em;display:block;'>
            Dear Valued Customer,
            </span>
             <br>
            <span style='color:#000000; font-size:0.9em;display:block;'>
            <!--From September 1st 2014,the <span style='color:red;font-size:1em;'>Foreign/Beneficiary payment type</span> will be discontinued;-->
            Effective September 1st 2014,the <span style='color:red;font-size:1em;'>Foreign/Beneficiary payment type</span> has been discontinued;
            it has been replaced with the <span style='color:red;font-size:1em;'>Foreign Payment link</span> which offers a faster and simpler way to make foreign payments.
            </span><br>
            
            <span style='color:#000000; font-size:0.9em;display:block;'>
            The Foreign Payment link is to be used for foreign currency transfers to other local banks as well as offshore banks.
            </span><br>
            
            <span style='color:#000000; font-size:0.9em;display:block;'>
            
            Please note that payments to Zenith Bank beneficiaries will still be made with the Zenith/Beneficiary payment type option using the Single Payment link.
            </span><br>
            <span style='color:#000000; font-size:0.9em;display:block;'>
           
            <!--To use the new Foreign Payment link now, click on Foreign Payment in the Payment Menu.--> 
            Please,use the new Foreign Payment link by clicking on Foreign Payment in the Payment Menu.
            </span>
            <br>
            
            <span style='color:#000000; font-size:0.9em;display:block;'>
            
            <!--To use the current Foreign/Beneficiary option, click Continue.-->
            
            </span>
            <!--div style='margin-top:15px; text-align:center;'>Note that the Token Code expires in One (1) Minute.</div-->
       </DIV>
       <!--DIV id="inputTokenDiv" style="text-align: center; margin-top:5px;">
            <INPUT type="password" style="width:200px" id="txtToken" name="txtToken" value="" />
       </DIV>
       <DIV id="spanTokenDiv" style="text-align: left; margin-top:20px;">
         <span class="dialogError" id="spDialog"></span>
        </DIV>
        <DIV id="successTokenDiv" style="display:none;">
            <TABLE frame='Void' rules='None' summary='Body-table' border='0' cellspacing='0' cellpadding='0' style='width:100%; margin:0px 0% 0px 0%; background-color:#FFFFFF; color:#000000;'>
                <TR>
                    <TD>
                        <img id="tokenIMG" src="images/TokenValidated.gif" alt="Token Validated" style='margin:3px; 0px none transparent;'/>
                    </TD>
                    <TD>
                        <DIV style='font-size:1.1em; font-weight:bold; margin-bottom:30px;'>Token validation <B>successful</B></DIV>
                        <DIV><img src="images/ProcessingTrans.gif" alt="Processing transaction..." style='0px none transparent;'/></DIV>
                    </TD>
                </TR>
            </TABLE>
        </DIV-->
    </DIV>
  <!--14082014-end- To display Dialog for New Foreign Payment STP-->  
    
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
                        <DIV class='HeaderText1' style='text-align:center;'>Make a Payment</DIV>
                        <DIV class='HeaderTailText' style='text-align:center;'>This feature allows the user to enter payment instructions </DIV>
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
                                <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                  <TBODY>
                                   <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='BlackBoldText_Right'>Source Account:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                         <%
                                         
                                              String isoVal;
                                              String[][] arrFromAcct = new String[sumResult.length][2];
                                              for (int i=0 ;i<sumResult.length; i++) { 
                                              
                                           	  
                                       	  		arrFromAcct[i][0] = sumResult[i].getAcctNo().trim() + "*" + sumResult[i].getIso_currency().trim() + "*" + sumResult[i].getAcctDesc().trim().replaceAll("\"","") + "*" + sumResult[i].getClassCode();
                                                arrFromAcct[i][1] = sumResult[i].getAcctDesc().replaceAll("\"","") + " - "  + sumResult[i].getIso_currency().trim() +  " - " + sumResult[i].getAcctNo()  ;
                                              }
                                              StringProcessor sp = new StringProcessor();
                                              
                                              String SelectBox_AcctList = sp.buildSelectBox (arrFromAcct, sumResult.length, "selAcctList", AcctValue, "Selectbox", "onchange=\"validateBVN($(this))\"");
                                              out.println(SelectBox_AcctList);
                                              
                                         %>
                                         <img id="spinner" src="images/spinner.gif" style="margin: 0px 5px;display: none"/>
                                         <INPUT type="HIDDEN" name="hidAcctNo" value="" />
                                      </TD>
                                    </TR>
                                    <tr class="child">                            
                                        <td></td>
                                        <td id="bvnError"></td>
                                    </tr> 
                                  </TBODY>
                                </TABLE>
                             </TD>
                           </TR>
                           <TR>
                             <TD class='GenericTableCell' style='width:100%;'>                                                   
                                <DIV style='border-bottom:1px solid #333333;' class='BlackBoldText'>Payment Details&nbsp;<A href='' class='BlueMenuLinks' id="clearFields" style='margin-left:100px;'>Clear Fields</A></DIV>
                             </TD>
                           </TR>
                           <TR id="trBeneValInfo">
                             <TD class='GenericTableCell' style='width:100%;'>                                                   
                                <SPAN style="color:red">Please note that since your beneficiary validation is turned on, this beneficiary would be added to the database</SPAN>
                             </TD>
                           </TR>
                           <TR>
                             <TD class='GenericTableCell' style='width:100%;'>
                                <DIV style=''>
                                <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                  <TBODY>   
                                  <tr>
                                  <td colspan="3" align="center">
                                     <SPAN style="color:red">Please&nbsp;type&nbsp;the&nbsp;first&nbsp;two(2)&nbsp;letters&nbsp;of&nbsp;the&nbsp;name&nbsp;to&nbsp;select&nbsp;an&nbsp;existing&nbsp;beneficiary</span>
                                  </td>
                                  </tr>
                                   <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Name:</DIV></TD>
                                      <TD class='GenericTableCell' id='tdName' style='width:75%;' nowrap="nowrap">
                                          <INPUT name="benficiaryName" id="benficiaryName" class='Textbox' style='width:40%' value="" type="text" size="60"/>* 
                                     </TD>
                                         
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Bank:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtBeneficiaryBank" id="txtBeneficiaryBank" class='Textbox' style='width:40%' value="" type="text" />*
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Account Number/IBAN:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtBeneficiaryAcctNo" id="txtBeneficiaryAcctNo" class='Textbox' style='width:40%' value="" type="text" />*
                                          <INPUT type="button" style='width:40%; margin-left:20px;' name="btnValidate" id="btnValidate" value="Validate Account" class="Button1" />
                                              &nbsp;&nbsp;<DIV class="error" id="spAcct" style='display:none;'></DIV>                                          
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Bank Branch:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtBeneficiaryBankBranch" id="txtBeneficiaryBankBranch" class='Textbox' style='width:40%' value="" type="text" onfocus="CheckBank()"/>
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Beneficiary Code:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtBeneficiaryCode" id="txtBeneficiaryCode" class='Textbox' style='width:40%' value="" type="text" />
                                      </TD>
                                    </TR>
                                    <TR id="trAcctDetails" style="display:none;">
                                      <TD colspan='2' class='GenericTableCell' style='width:100%; text-align:center; background-color:#666666; color:#FFFFFF; padding:3px;' id='tdValAccDetails'>
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Email Address:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtBeneficiaryEmail" id="txtBeneficiaryEmail" class='Textbox' style='width:40%' value="" type="text" />
                                          &nbsp;<SPAN class="error" id="spEmail"></SPAN>
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>GSM Number:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtGSM" id="txtGSM" class='Textbox' style='width:40%' value="" type="text" />
                                      </TD>
                                    </TR>
                                    <TR id="spanBeneficiary">
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Add Beneficiary to my Beneficiary List:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <SPAN>
                                            <INPUT type="checkbox" id="chkBeneficiary" name="chkBeneficiary" value="checked" />
                                          </SPAN>
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD colspan='2' class='GenericTableCell' style='width:100%; color:#FF0000; padding:2px;'>
                                          
                                          <INPUT type="HIDDEN" id="hidCompanyCode" name="hidCompanyCode" value="<%=HostCompany%>"/>
                                          <INPUT type="HIDDEN" id="multipleuser" name="multipleuser" value="<%=multipleuser%>"/>
                                          <INPUT type="HIDDEN" id="checkTokenValidateValue" name="checkTokenValidateValue" value="<%=checkTokenValidateValue%>"/>
                                          <INPUT type="HIDDEN" id="hidAccessCode" name="hidAccessCode" value="<%=accesscode%>"/>
                                          <INPUT type="HIDDEN" id="hidLoginID" name="hidLoginID" value="<%=tokenLoginID%>"/>
                                          <INPUT type="HIDDEN" id="beneficiaryValidation" name="beneficiaryValidation" value="<%=beneficiary_val%>"/>
                                          <INPUT type="HIDDEN" id="fieldsDisabled" name="fieldsDisabled" value=""/>
                                          <INPUT type="HIDDEN" id="hidBeneficiary_ids" name="hidBeneficiary_ids" value=""/>    
                                          <INPUT type="HIDDEN" id="PayType" name="PayType" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryBankBranch" name="hidBeneficiaryBankBranch" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryAcctNo" name="hidBeneficiaryAcctNo" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryBank" name="hidBeneficiaryBank" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryName" name="hidBeneficiaryName" value="" />
                                          <INPUT type="HIDDEN" id="hidBankCode" name="hidBankCode" value="" />
                                          <INPUT type="HIDDEN" id="hidSortCode" name="hidSortCode" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryCode" name="hidBeneficiaryCode" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryAddress" name="hidBeneficiaryAddress" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryCity" name="hidBeneficiaryCity" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryState" name="hidBeneficiaryState" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryPhone" name="hidBeneficiaryPhone" value="" />
                                          <INPUT type="HIDDEN" id="hidGSM" name="hidGSM" value="" />
                                          <INPUT type="HIDDEN" id="hidBeneficiaryEmail" name="hidBeneficiaryEmail" value="" />
                                          <INPUT type="HIDDEN" id="hidFBankSortCode" name="hidFBankSortCode" value="" /> 
                                          <INPUT type="HIDDEN" id="hidSwiftCode" name="hidSwiftCode" value="" /> 
                                          <INPUT type="HIDDEN" id="hidIntBankName" name="hidIntBankName" value="" /> 
                                          <INPUT type="HIDDEN" id="hidIntBankAcctNo" name="hidIntBankAcctNo" value="" /> 
                                          <INPUT type="HIDDEN" id="hidIntBankBIC" name="hidIntBankBIC" value="" />
                                          <INPUT type="HIDDEN" id="hidExistingBeneficiary" name="hidExistingBeneficiary" value="" />
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
                     <TD colspan='3' align='left' style='padding:0px 3px 0px 3px;'>
                        <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                          <TR>
                             <TD class='GenericTableCell' style='width:100%;'>                                                   
                                <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                  <TBODY>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='BlackBoldText_Right'>Payment Type:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                         <%
                                         
                                         
                                            BeneficiaryAdapter ba = new BeneficiaryAdapter();
                                            BeneficiaryValue[] PaymentTypes = new BeneficiaryValue[0] ;
                                            //added to retrieve Payment Types of CREDIT Payment Type Intruction
                                            //PaymentTypes = ba.getPaymentType("CREDIT");//01092014--Payment Type Restriction
                                            PaymentTypes = ba.getPaymentType("CREDIT",HostCompany); //01092014-Payment Type Restriction

                                            String[][] arrPaymentType = new String[PaymentTypes.length][2];
                                            for (int i=0; i<PaymentTypes.length; i++)
                                            {
                                              //arrPaymentType[i][0] = PaymentTypes[i].getpaymenttypeid();
                                              
                                              arrPaymentType[i][0] = PaymentTypes[i].getpaymenttype();
                                              ///====added getpayment name to array ===//
                                              arrPaymentType[i][1] = PaymentTypes[i].getPaymentName();
                                             //arrPaymentType[i][2] = PaymentTypes[i].getPaymentName();
                                           
                                            }
                                            String SelectBox_PaymentType = sp.buildSelectBox (arrPaymentType, PaymentTypes.length, "selPaymentType", PaymentType, "Selectbox", "");
                                            out.println(SelectBox_PaymentType);
                                        %>
                                        &nbsp;<SPAN id="infoOption" style="color:red; padding-left:2px;"></SPAN>
                                      </TD>
                                    </TR>
                                  </TBODY>
                                </TABLE>
                             </TD>
                          </TR>
                          <TR>
                            <TD colspan='2' class='GenericTableCell' style='width:100%;'>
                                 <DIV id="showForeignFields" style="display:none; color:#333333;">
                                    <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                   
                                    <!--tr style="width:100%" valign="top" class="charge">
                                    <td colspan="2" bgcolor="#FFFFFF" valign="top" ><div align="left" class="mainHeaderx"><strong>Charge Details </strong></div></td>
                                    </tr-->
                                    <tr class="charge">
                                        <td class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Charge Option:</DIV></td>
                                        <td class='GenericTableCell' style='width:75%;' id="chargeType" colspan="2">
                                            <input type="radio" id="allCharge" name="chargeType" value="OUR"  />All Charges |
                                            <input type="radio" id="localCharge" name="chargeType" value="SHA" />Local Withdrawal Charge Only<br/>
                                            
                                        </td>
                                        <!--td align="left"-->
                                            <span id="spChargeType"  style="color:red; font-size:11px;"></span>
                                        <!--/td-->
                                    </tr>
                                           
                                      
                                      <TR>
                                        <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Beneficiary Address:</DIV></TD>
                                        <TD class='GenericTableCell' style='width:75%;'>
                                            <INPUT name="txtBeneficiaryaddress" id="txtBeneficiaryaddress" class='Textbox' style='width:40%' value="" type="text" />
                                        </TD>
                                      </TR>
                                      
                                      
                                     <TR>
                                        <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Beneficiary City:</DIV></TD>
                                        <TD class='GenericTableCell' style='width:75%;'>
                                            <INPUT name="txtcity" id="txtcity" class='Textbox' style='width:40%' value="" type="text" />
                                        </TD>
                                      </TR>
                                      
                                      
                                      
                                       <TR>
                                        <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Bank Sort Code/Routing No.:</DIV></TD>
                                        <TD class='GenericTableCell' style='width:75%;'>
                                            <INPUT name="txtSortCode" id="txtSortCode" class='Textbox' style='width:40%' value="" type="text" />
                                        </TD>
                                      </TR>
                                      <TR>
                                        <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Swift Code:</DIV></TD>
                                        <TD class='GenericTableCell' style='width:75%;'>
                                            <INPUT name="txtSwiftCode" id="txtSwiftCode" class='Textbox' style='width:40%' value="" type="text" />
                                        </TD>
                                      </TR>
                                      <TR>
                                        <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Intemediary Bank Name:</DIV></TD>
                                        <TD class='GenericTableCell' style='width:75%;'>
                                            <INPUT name="txtIntBankName" id="txtIntBankName" class='Textbox' style='width:40%' value="" type="text" />
                                        </TD>
                                      </TR>
                                      <TR>
                                        <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Intemediary Bank Account No:</DIV></TD>
                                        <TD class='GenericTableCell' style='width:75%;'>
                                            <INPUT name="txtIntBankAcctNo" id="txtIntBankAcctNo" class='Textbox' style='width:40%' value="" type="text" onblur="return CheckAccount(this)" />
                                        </TD>
                                      </TR>
                                      <TR>
                                        <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Intemediary Bank Swift Code:</DIV></TD>
                                        <TD class='GenericTableCell' style='width:75%;'>
                                            <INPUT name="txtIntBankBIC" id="txtIntBankBIC" class='Textbox' style='width:40%' value="" type="text" />
                                        </TD>
                                      </TR>
                                    </TABLE>
                                 </DIV>
                            </TD>
                          </TR>                          
                          <TR>
                             <TD class='GenericTableCell' style='width:100%;'>
                                <DIV style='border-bottom:1px solid #333333;' class='BlackBoldText'>Payment Details</DIV>
                             </TD>
                          </TR>
                          <TR>
                             <TD class='GenericTableCell' style='width:100%;'>
                                 <DIV style=''>
                                 <TABLE frame='Void' rules='None' summary='SUB-table' border='0' cellspacing='0' cellpadding='0' style='width:100%;'>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Payment Amount:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="AMOUNT0" id="AMOUNT0" class='Textbox' style='width:40%' onfocus="ClearAmount();" onblur="return CheckAmount(this)" type="text" />*
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Payment Date:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtPaymentDate" id="txtPaymentDate" maxlength="30" class='Textbox' style='width:40%' title='Enter the date' autocomplete="off" readonly type="text" />
                                          <INPUT name="BUTTON1" id="BUTTON1" type="image" value="" src="images/bttn_calendar.gif" style='width:16px; height:15px;' onmouseover="openDiv(this,'help','message');" onmouseout="closeDiv(this,'help','message');" />
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Payment Reference:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtPaymentRef" id="txtPaymentRef" maxlength="34" class='Textbox' style='width:40%' autocomplete="off" value="" type="text" />
                                          &nbsp;<span class="NavyText">N.B. This is your Unique Reference for this Transaction</span>
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'><DIV class='NavyText_Right' style='font-weight:bold;'>Purpose:</DIV></TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                          <INPUT name="txtPaymentRemarks" id="txtPaymentRemarks" maxlength="34" class='Textbox' style='width:40%' autocomplete="off" value="" type="text" />
                                          &nbsp;<span id="FInfo" style="display:none" class="NavyText"><font color="Red">Mandatory for Foreign/Offshore Transfers (e.g. Purchase of office equipments)</font></span>
                                      </TD>
                                    </TR>
                                    <TR>
                                      <TD class='GenericTableCell' style='width:25%;'>&nbsp;</TD>
                                      <TD class='GenericTableCell' style='width:75%;'>
                                           <INPUT type="button" style='width:40%;' name="btnSubmit" id="btnSubmit" value="Submit" class="Button1" onclick="validateFields(this.form);" />
                                      </TD>
                                    </TR>
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


<script type="text/javascript">
    Calendar.setup({
        inputField     :    "txtPaymentDate",     // id of the input field
        ifFormat       :    "%m/%d/%Y",      // format of the input field
        button         :    "BUTTON1",  // trigger for the calendar (button ID)
        align          :    "T1",           // alignment (defaults to "Bl")
        singleClick    :    true
    });

function BankChanged(form)
{
  var valueselected = document.getElementById("AcctInfo1").value;
  //alert(valueselected);
   if(valueselected == "Select Type"){           
     form.action = "paymentcontroller.jsp?np=AddBeneficiary&mode=" + valueselected ;
     form.submit();
     alert("select a Type");
     return false;     
   }else if (valueselected == "ZENITH BENEFICIARY"){
     form.action = "paymentcontroller.jsp?np=AddBeneficiary&mode=" + valueselected ;
     form.submit();     
   }else if (valueselected == "INTER-BANK BENEFICIARY"){
     form.action = "paymentcontroller.jsp?np=AddBeneficiary&mode=" + valueselected ;
     form.submit();     
   }else if (valueselected == "FOREIGN BENEFICIARY"){
     form.action = "paymentcontroller.jsp?np=AddBeneficiary&mode=" + valueselected ;
     form.submit();     
   }
   
   return true;
}

function BankChangedA(form)
{

      try
      {
          obj = new ActiveXObject("Msxml2.XMLHTTP");
      }
      catch(e)
      {
          try
            {
                obj = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch(e1)
            {
                    obj = null;
            }
      }
      if(obj == null && typeof XMLHttpRequest != 'undefined')
      {
        obj = new XMLHttpRequest();
      }
      if(obj!=null)
      {
        obj.onreadystatechange = ProcessResponse; 
        var bankselected = document.getElementById("selInterBankName").value;
        if(bankselected == "select a bank")
        {
           alert("select a bank");
           var dddbranch = document.getElementById("selInterBankBranch");
           for (var count =dddbranch.options.length-1; count >-1; count--)
           {
                dddbranch.options.options[count] = null;
           }
           return;
        }
        
        var url = "/coporate-internetbanking/transferBank.jsp?bankcode=" + document.getElementById("selInterBankName").value
        obj.open("GET",url , true);
                obj.send(null);         
        }
        return false;
    }

function ProcessResponse()
{
  if(obj.readyState == 4)
  {
    if(obj.status == 200)
    {
   
      var dsRoot=obj.responseXML.documentElement;  
      var dddbranch = document.getElementById("selInterBankBranch");
     
      for (var count =dddbranch.options.length-1; count >-1; count--)
      {
        dddbranch.options.options[count] = null;
      }
      
      var branchs = dsRoot.getElementsByTagName('Branch');
      var Sortcodes = dsRoot.getElementsByTagName('SortCode');
      var Branchname = dsRoot.getElementsByTagName('BranchName');
      var text; 
      var banksortcode;
      var bname;
      var listItem;
      var ddbname = document.getElementById("selInterBankName");
      var bankname = ddbname.options[ddbname.selectedIndex].text;
      for (var count = 0; count < branchs.length; count++)
      {
        // text = (branchs[count].textContent || branchs[count].innerText || branchs[count].text);
        text = branchs[count].text;
        banksortcode = Sortcodes[count].text;
        bname = bankname + " " + Branchname[count].text;
        listItem = new Option(bname, banksortcode,  false, false);
        dddbranch.options[count] = listItem;
      }
    }
    else
    {
      alert("Error retrieving data!" );
    }
  }
}


</script>
</body>
</html>
