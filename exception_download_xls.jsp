
<%@ page contentType="text/vnd.ms-excel"   import = "com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.coporate.ibank.payment.Payment,com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*, com.zenithbank.banking.coporate.ibank.payment.*,com.zenithbank.banking.coporate.ibank.PaymentHelper.*,java.util.*,com.zenithbank.stringhelper.*, com.zenithbank.banking.coporate.ibank.form.*" %><%
    //  response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=payments.xls");
    //Taiwo  05092017
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

        String rolegroup = company.getrolegroup();

        Payment[] payments = null;
        Payment payment = new Payment();
        int max_approvalLevel = company.getComauthlevel();
        String companyname = company.getName();
        String benValidation = company.getBeneValidation();
        String authValidation = company.getAuthValidation();
        String ben_routing = company.getBenRouting();
        String two_to_sign = company.getTwotoSign();
        String two_to_sign_group = company.getTwotoSignGroup(); 

        int no_to_sign = company.getNotoSign();
        int noofrestrictedusers = 0;
        int verifierid = 0;
        String autorizer_txn_deletion = company.getAuthorizer_txn_deletion();

        PaymentDB paymentdb = new PaymentDB();
    
                java.sql.Date startdateFrom = null;
                java.sql.Date startDateTo = null;

                String fromDateStr = request.getParameter("fromDate");

                String toDateStr = request.getParameter("toDate");

              //  String dateBy = request.getParameter("dateBy");
                try {
                    startdateFrom = java.sql.Date.valueOf(fromDateStr);
                } catch (Exception exp) {
                    // System.out.println("Error Parsing start date");
                }

                try {
                    startDateTo = java.sql.Date.valueOf(toDateStr);
                } catch (Exception exp) {
                    // System.out.println("Error Parsing end date");
                }
                String beneName = request.getParameter("beneName");
                Double batchId = Double.valueOf(request.getParameter("batchId"));
                System.out.println("BATCH_ID: " + batchId);
                String coy = login.getHostCompany();
                PaymentAdapter pa = new PaymentAdapter();
               // Payment[] payment = null;
  //System.out.println("chkMyQueue " + chkMyQueue);
                
                  payments = pa.getPaymentExceptions(batchId, coy, startdateFrom, startDateTo, beneName);
                 


%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <title>File_Upload_Format (Excel File-Format)</title>    
    </head>
    <body>
        <TABLE frame='Box' rules='All' summary='SUB-table' border='1' cellspacing='0' cellpadding='0' style='width:100%; font-size:1em;'>
            <TR>
<!--                <th>No.</th>-->
                <th>Bene. Name</th>
<!--                <th>Bene. Name in Bank</th>-->
                <th>Trans. Date</th>
<!--                <th>Value Date</th>-->
                <th>Trans. Reference</th>

                <th>Bene. Code</th>
                <th>Bene. Bank</th>
                <th>Bene. Account</th>
                <th>Cur.</th>
                <th>Amount</th>
                <th>Exp. Reason</th>
                <th>Debit Acct Name</th>
                <th>Debit Acct No.</th>                                             
            </TR>

            <%         for (int i = 0; i < payments.length; i++) {

                    String vendor_name = payments[i].getVendor_name();
                    String valid_vendor_name = (payments[i].getValid_vendor_name() == null) ? "" : payments[i].getValid_vendor_name();
                    String timestamp = payments[i].getUploadDate() == null ? "" : sd.format(payments[i].getUploadDate());
                    String transaction_reference = payments[i].getTrans_ref();
                    String vendor_code = payments[i].getVendor_code();
                    String vendor_bank = payments[i].getVendor_bank();
                    String vendor_acct_no = payments[i].getVendor_acct_no();
                    int payment_id = i + 1;
                   // String payment_idAsString = "CIB" + payment_id + "";

                    String payment_currency = payments[i].getPayment_currency();
                    String amount = formatta.formatAmount(Double.toString(payments[i].getAmount()));
                    String Rejection_reason = payments[i].getReject_reason();// == null) ? "" : payments[i].getVendor_category();
                    String value_date = payments[i].getPayment_due_date() == null ? "" : sd.format(payments[i].getPayment_due_date());
                    String account_name = payments[i].getAccount_name();
                    String debit_account_number = payments[i].getDebit_acct_no();

            %>  
            <tr>
<!--                <td><%=payment_id%></td>-->
                <td><%=vendor_name%></td>
<!--                <td><%=valid_vendor_name%></td>-->
                <td><%=timestamp%></td>
<!--                <td><%=value_date%></td>-->
                <td><%=transaction_reference%></td>




                <td><%=vendor_code%></td>
                <td><%=vendor_bank%></td>
                <td><%=vendor_acct_no%></td>


                <td><%=payment_currency%></td>
                <td><%=amount%></td>
                <td><%=Rejection_reason%></td>
                <td><%=account_name%></td>
                <td><%=debit_account_number%></td>
            </tr>
            <%

                    }

                } catch (Exception exp) {
                    exp.printStackTrace();
                }
            %>

        </TABLE>

    </body>
</html>