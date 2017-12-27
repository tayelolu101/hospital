<% response.setHeader("Cache-Control","no-store"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<%@ page language="java" import = "com.zenithbank.banking.coporate.ibank.payment.*" session="true" %>
<%
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");

MakePaymentAutoComplete m = new MakePaymentAutoComplete();

String bankBranches;
    bankBranches = m.getBankBranches(request.getParameter("q"), request.getParameter("hidBankCode"));
     if(bankBranches != null)
    {
       out.print(bankBranches);
    }
%>