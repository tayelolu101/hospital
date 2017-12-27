$("#verifySchedulerId i").addClass<%-- 
    Document   : payment_ajax
    Created on : Nov 10, 2015, 4:42:09 PM
    Author     : appdev3
--%>

<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.zenithbank.banking.coporate.ibank.payment.PaymentUploader"%>
<%@page import="com.zenithbank.banking.coporate.ibank.payment.ApprovalHistory"%>
<%@page import="com.zenithbank.banking.coporate.ibank.payment.Payment"%>
<%@page import="com.zenithbank.banking.coporate.ibank.PaymentHelper.PaymentDB"%>
<%
    response.setContentType("application/json");
    com.dwise.util.CurrencyNumberformat formatta = new com.dwise.util.CurrencyNumberformat();
    java.text.SimpleDateFormat sd = new java.text.SimpleDateFormat("EEE, MMM d, yyyy");
    java.text.SimpleDateFormat sd1 = new java.text.SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");
//StringProcessor sp = new StringProcessor();
    PaymentDB db = new PaymentDB();
    com.dwise.util.CryptoManager crypto = new com.dwise.util.CryptoManager();
    String tranidcoded = request.getParameter("transactionid");
    String q = request.getParameter("q");
//System.out.println("txnCoded : "+tranidcoded);
    String tranid = crypto.decode(tranidcoded);
//    String tranid = crypto.decode("Mi4yNDU3OTI5RTc="); 2 approvals
    System.out.println("txn : " + tranid);
    if ("upload".equalsIgnoreCase(q)) {
        Payment payment = db.GetPayment(Double.parseDouble(tranid.trim()));
        PaymentUploader[] paymentUploader = db.GetUploaderDetails(payment.getcompany_code(), payment.getBatchid());
        Map m = new HashMap();
        m.put("pmtStatus", payment.getPaymentstatus());
        m.put("pmtBatchid", payment.getBatchid());
        m.put("pmtid", (int) Double.parseDouble(tranid));
        m.put("pmtuploader", paymentUploader);
        out.println(new ObjectMapper().writeValueAsString(m));
    }else if("approval".equalsIgnoreCase(q)){
        ApprovalHistory[] aHist = db.getPaymentTaskHistory(Double.parseDouble(tranid.trim()));
        Map m = new HashMap();
        m.put("aHist", aHist);
        out.println(new ObjectMapper().writeValueAsString(m));
    }

//System.out.println("Payment : "+payment);
    
//System.out.println("Approval History : "+aHist);
//lanre - 05052009


%>
