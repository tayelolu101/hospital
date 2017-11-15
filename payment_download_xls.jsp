<%@ page contentType="text/vnd.ms-excel"   import = "com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*, com.zenithbank.banking.coporate.ibank.payment.*,com.zenithbank.banking.coporate.ibank.PaymentHelper.*,java.util.*,com.zenithbank.stringhelper.*, com.zenithbank.banking.coporate.ibank.form.*" %><%
    //  response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=payments.xls");
    try {

        com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");
        java.text.SimpleDateFormat sd1 = new java.text.SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");
        java.text.SimpleDateFormat sd = new java.text.SimpleDateFormat("EEE, MMM d, yyyy");
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MM-yyyy");
        com.dwise.util.CurrencyNumberformat formatta = new com.dwise.util.CurrencyNumberformat();

        com.zenithbank.banking.coporate.ibank.action.CompanyManager companyManager
                = new com.zenithbank.banking.coporate.ibank.action.CompanyManager();
        CompanyOne company = companyManager.findBankByCode(login.getHostCompany());
        String CompanyId = login.getHostCompany();
        String username = login.getLoginId();
        int Authorizer_id = login.getSeq();
        int ApprovalLevel = login.getAuthLevel();
        int currentapprovalLevel = ApprovalLevel;

        System.out.println("Authorizer ==== " + Authorizer_id);
        System.out.println("Approval Level ==== " + ApprovalLevel);
        System.out.println("Current App ==== " + currentapprovalLevel);

        String rolegroup = company.getrolegroup();
        System.out.println("role group ====" + rolegroup);

        Payment[] payments = null;
        Payment payment = new Payment();
        int max_approvalLevel = company.getComauthlevel();//09122013-two to sign + Verifier
//System.out.println("max_approvalLevel " + max_approvalLevel);
        String companyname = company.getName();
        String benValidation = company.getBeneValidation();
        System.out.println("bene validation ====" + benValidation);
        String authValidation = company.getAuthValidation();
        System.out.println("auth vali ====" + authValidation);
        String ben_routing = company.getBenRouting();
        String two_to_sign = company.getTwotoSign();
        String two_to_sign_group = company.getTwotoSignGroup();//added 24/11/2011 

        int no_to_sign = company.getNotoSign();
        int noofrestrictedusers = 0;//authorization restriction for users-02082012
        int verifierid = 0;//05122013 any two to sign with verifier
 /* NLNG */
        String autorizer_txn_deletion = company.getAuthorizer_txn_deletion();

        PaymentDB paymentdb = new PaymentDB();
        String debit_acct_no = request.getParameter("DEBIT_ACCT_NO");
        if (debit_acct_no == null || debit_acct_no.equalsIgnoreCase("ALL")) {
            debit_acct_no = "";
        }

        String payment_type = request.getParameter("PAYMENT_TYPE");
        if (payment_type == null || payment_type.equalsIgnoreCase("ALL")) {
            payment_type = "";
        }

        String batch_id = request.getParameter("BATCH_ID");
        if (batch_id == null || batch_id.equalsIgnoreCase("ALL")) {
            batch_id = "";
        }

        String view = request.getParameter("view");
        view = (view.equals("") ? "awaiting approval" : view);
        view = (view.equalsIgnoreCase("awaiting_approval") ? "awaiting approval" : view);

        String chkMyQueue = request.getParameter("MyQueue");

        Date fromDate = null;
        Date toDate = null;
        double fromAmount = 0;
        double toAmount = 0;

        String currency = request.getParameter("currency");

        String bankCode = request.getParameter("bank");

        String fromDateStr = request.getParameter("fromDate");

        String toDateStr = request.getParameter("toDate");

        String dateBy = request.getParameter("dateBy");

        try {
            fromDate = sdf.parse(fromDateStr);
        } catch (Exception exp) {
            System.out.println("Error Parsing start date");
        }

        try {
            toDate = sdf.parse(toDateStr);
        } catch (Exception exp) {
            System.out.println("Error Parsing end date");
        }

        String fromAmountStr = request.getParameter("fromAmount");
        String toAmountStr = request.getParameter("toAmount");

        try {
            fromAmount = Double.parseDouble(fromAmountStr.replaceAll(",", ""));
        } catch (Exception exp) {
            System.out.println("Error Parsing from amount");
        }

        try {
            toAmount = Double.parseDouble(toAmountStr.replaceAll(",", ""));
        } catch (Exception exp) {
            System.out.println("Error Parsing to amount");
        }

        String beneficiaryName = request.getParameter("beneficiaryName");
        String beneficiaryAcct = request.getParameter("beneficiaryAcct");
        String transactionRef = request.getParameter("transactionRef");

        int draw = Integer.parseInt(request.getParameter("draw"));
        int length = Integer.parseInt(request.getParameter("length"));
        int start = Integer.parseInt(request.getParameter("start"));
        Map<String, String> searchMap = null;
        Map<String, String> orderByMap = null;
        int columns = 0;
        String columnLength = request.getParameter("columnLength");
        if (draw > 1 && columnLength != null && !columnLength.trim().equals("")) {
            columns = Integer.parseInt(columnLength);
            PaymentDataTableUtil dataTableUtil = new PaymentDataTableUtil();
            searchMap = dataTableUtil.getSearchMap(request, columns);
            orderByMap = dataTableUtil.getOrderByMap(request, columns);

        }
        //System.out.println("chkMyQueue " + chkMyQueue);

        if (chkMyQueue != null) {
            if (benValidation.trim().equalsIgnoreCase("y")) {
                if ((authValidation.trim().equalsIgnoreCase("y")) && (rolegroup.trim().equalsIgnoreCase("y"))) { // System.out.println(1);
                    payments = paymentdb.GetPaymentByValidateAuthorizer_RoleGroup(CompanyId, debit_acct_no, payment_type,
                            batch_id, currentapprovalLevel - 1, view, -1,
                            username, login.getSeq(), Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else if (authValidation.trim().equalsIgnoreCase("y")) { // System.out.println(2);
                    payments = paymentdb.GetPaymentByValidateAuthorizer(CompanyId, debit_acct_no, payment_type, batch_id,
                            currentapprovalLevel - 1, view, -1, username,
                            Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else if (rolegroup.trim().equalsIgnoreCase("y")) {// System.out.println(3);
                    payments = paymentdb.GetPaymentByValidateBenefiary_RoleGroup(CompanyId, debit_acct_no,
                            payment_type, batch_id, currentapprovalLevel - 1,
                            view, -1, login.getSeq(), Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate,
                            toDate, fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else {// System.out.println(4);
                    payments = paymentdb.GetPaymentByValidateBenefiary(CompanyId, debit_acct_no, payment_type, batch_id,
                            currentapprovalLevel - 1, view, -1,
                            Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                }
            } else {
                if ((authValidation.trim().equalsIgnoreCase("y")) && (rolegroup.trim().equalsIgnoreCase("y"))) {// System.out.println(5);
                    payments = paymentdb.GetPaymentAuthorizer_RoleGroup(login.getHostCompany(), debit_acct_no,
                            payment_type, batch_id, currentapprovalLevel - 1, view, -1,
                            username, login.getSeq(), Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else if (authValidation.trim().equalsIgnoreCase("y")) {// System.out.println(6);
                    payments = paymentdb.GetPaymentAuthorizer(login.getHostCompany(), debit_acct_no,
                            payment_type, batch_id, currentapprovalLevel - 1, view, -1,
                            username, Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else if (rolegroup.trim().equalsIgnoreCase("y")) {
                    // System.out.println(7); 
                    payments = paymentdb.GetPayment_RoleGroup(login.getHostCompany(), debit_acct_no, payment_type,
                            batch_id, currentapprovalLevel - 1, view, -1, login.getSeq(),
                            Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else {
                   // System.out.println(8);
                    payments = paymentdb.GetPayment(CompanyId, debit_acct_no, payment_type,
                            batch_id, -1, view, -1,
                            Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                }
            }
        } else {
            if (benValidation.trim().equalsIgnoreCase("y")) {
                if ((authValidation.trim().equalsIgnoreCase("y")) && (rolegroup.trim().equalsIgnoreCase("y"))) {
                   // System.out.println(9);
                    payments = paymentdb.GetPaymentByValidateAuthorizer_RoleGroup(CompanyId, debit_acct_no, payment_type,
                            batch_id, -1, view, -1,
                            username, login.getSeq(), Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else if (authValidation.trim().equalsIgnoreCase("y")) { //System.out.println(10);
                    payments = paymentdb.GetPaymentByValidateAuthorizer(CompanyId, debit_acct_no, payment_type, batch_id,
                            -1, view, -1, username,
                            Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else if (rolegroup.trim().equalsIgnoreCase("y")) {
                   // System.out.println(11);
                    payments = paymentdb.GetPaymentByValidateBenefiary_RoleGroup(CompanyId, debit_acct_no,
                            payment_type, batch_id, - 1,
                            view, -1, login.getSeq(), Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else {
                   // System.out.println(12);
                    payments = paymentdb.GetPaymentByValidateBenefiary(CompanyId, debit_acct_no, payment_type, batch_id,
                            - 1, view, -1,
                            Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                }
            } else {
                if ((authValidation.trim().equalsIgnoreCase("y")) && (rolegroup.trim().equalsIgnoreCase("y"))) {
                  //  System.out.println(13);
                    payments = paymentdb.GetPaymentAuthorizer_RoleGroup(login.getHostCompany(), debit_acct_no,
                            payment_type, batch_id, -1, view, -1,
                            username, login.getSeq(), Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else if (authValidation.trim().equalsIgnoreCase("y")) { //System.out.println(14);
                    payments = paymentdb.GetPaymentAuthorizer(login.getHostCompany(), debit_acct_no,
                            payment_type, batch_id, -1, view, -1,
                            username, Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else if (rolegroup.trim().equalsIgnoreCase("y")) {
                    // System.out.println(15);
                    payments = paymentdb.GetPayment_RoleGroup(login.getHostCompany(), debit_acct_no, payment_type,
                            batch_id, -1, view, -1, login.getSeq(),
                            Integer.parseInt(login.getRoleid()),
                            searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);
                } else {// System.out.println(16);
                    payments = paymentdb.GetPayment(CompanyId, debit_acct_no, payment_type,
                            batch_id, -1, view, -1,
                            Integer.parseInt(login.getRoleid()), searchMap, orderByMap, fromDate, toDate,
                            fromAmount, toAmount, currency, dateBy, bankCode, beneficiaryName, beneficiaryAcct, transactionRef);

                }
            }

        }

        payments = paymentdb.getPaymentPage(payments, start, length);


%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <title>File_Upload_Format (Excel File-Format)</title>    
    </head>
    <body>
        <TABLE frame='Box' rules='All' summary='SUB-table' border='1' cellspacing='0' cellpadding='0' style='width:100%; font-size:1em;'>
            <TR>
                <th>Tracking Number</th>
                <th>Bene. Name</th>
                <th>Bene. Name in Bank</th>
                <th>Trans. Date</th>
                <th>Value Date</th>
                <th>Trans. Reference</th>

                <th>Bene. Code</th>
                <th>Bene. Bank</th>
                <th>Bene. Account</th>
                <th>Cur.</th>
                <th>Amount</th>
                <th>Purpose</th>
                <th>Debit Acct Name</th>
                <th>Debit Acct No.</th>                                             
            </TR>

            <%         for (int i = 0; i < payments.length; i++) {

                    String vendor_name = payments[i].getVendor_name();
                    String valid_vendor_name = (payments[i].getValid_vendor_name() == null) ? "" : payments[i].getValid_vendor_name();
                    String timestamp = payments[i].getPayment_due_date() == null ? "" : sd.format(payments[i].getPayment_due_date());
                    String transaction_reference = payments[i].getTrans_ref();
                    String vendor_code = payments[i].getVendor_code();
                    String vendor_bank = payments[i].getVendor_bank();
                    String vendor_acct_no = payments[i].getVendor_acct_no();
                    int payment_id = (int) payments[i].getPayment_id();
                    String payment_idAsString = "CIB" + payment_id + "";

                    String payment_currency = payments[i].getPayment_currency();
                    String amount = formatta.formatAmount(Double.toString(payments[i].getAmount()));
                    String vendor_category = (payments[i].getVendor_category() == null) ? "" : payments[i].getVendor_category();
                    String value_date = payments[i].getPayment_due_date() == null ? "" : sd.format(payments[i].getPayment_due_date());
                    String account_name = payments[i].getAccount_name();
                    String debit_account_number = payments[i].getDebit_acct_no();

            %>  
            <tr>
                <td><%=payment_idAsString%></td>
                <td><%=vendor_name%></td>
                <td><%=valid_vendor_name%></td>
                <td><%=timestamp%></td>
                <td><%=value_date%></td>
                <td><%=transaction_reference%></td>




                <td><%=vendor_code%></td>
                <td><%=vendor_bank%></td>
                <td><%=vendor_acct_no%></td>


                <td><%=payment_currency%></td>
                <td><%=amount%></td>
                <td><%=vendor_category%></td>
                <td><%=account_name%></td>
                <td><%=debit_account_number%></td>
            <tr/>
            <%

                    }

                } catch (Exception exp) {
                    exp.printStackTrace();
                }
            %>

        </TABLE>

    </body>
</html>