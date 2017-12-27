<% response.setHeader("Cache-Control","no-store"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>

<%@ page language="java" import = "com.zenithbank.banking.coporate.ibank.payment.*" session="true" %>
<%
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");

MakePaymentAutoComplete m = new MakePaymentAutoComplete();

String type;
String banks;
 
 if((request.getParameter("bankCode") != null) && (request.getParameter("bankCode").equals("057")))
 {
 banks = m.getZenithBank(request.getParameter("q"));
 }
 else
 {
 
    banks = m.getBanks(request.getParameter("q"));
}
    if(banks != null)
    {
       out.print(banks);
    }
%>