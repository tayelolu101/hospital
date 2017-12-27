<% response.setHeader("Cache-Control","no-store"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<%@ page language="java" import = "com.zenithbank.banking.coporate.ibank.payment.*" session="true" %>
<%
com.zenithbank.banking.coporate.ibank.form.Login login = (com.zenithbank.banking.coporate.ibank.form.Login) session.getAttribute("login");

MakePaymentAutoComplete m = new MakePaymentAutoComplete();

String type;
String beneficiaries;
System.out.println(" PaymentType *** " + request.getParameter("paymentType")); 
System.out.println(" QQQ " + request.getParameter("q")); 
if(request.getParameter("paymentType") != null)
{
beneficiaries = m.getBeneficiaryByPayType(login.getHostCompany(),request.getParameter("q"),request.getParameter("paymentType"));
}
else
{
    beneficiaries = m.getBeneficiary(login.getHostCompany(),request.getParameter("q"));
}
    if(beneficiaries != null)
    {
        //System.out.println(beneficiaries.toUpperCase());
        beneficiaries = beneficiaries.replaceAll(",", " ");
        out.print(beneficiaries.toUpperCase());
    }
%>