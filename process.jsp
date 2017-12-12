<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>JSP Example - REST (JSON)</title>
</head>
<body>
<%@include file="./connection.jsp"%>
<%
    // configuration is defined in the configuration.jsp
    Merchant merchant = new Merchant(configuration);
    Parser parser = new Parser(merchant);
    String method = request.getParameter("method");

    String requestUrl = parser.formRequestUrl(request);
    if (merchant.debugMode()) {
        out.print(requestUrl + "<br/><br/>");
    }
    Connection connection = new Connection(merchant);

    String data = "";
    String apiOperation = request.getParameter("apiOperation");
    if ("INITIATE_BROWSER_PAYMENT".equalsIgnoreCase(apiOperation)) {
        data = parser.parseInitiate(request);
    } else if ("CONFIRM_BROWSER_PAYMENT".equalsIgnoreCase(apiOperation) ) {
        data = parser.parseConfirm(request);
    } else {
        data = parser.parse(request);
    }
    if (merchant.debugMode()) {
        out.print(data + "<br/><br/>");
    }

    String resp = "";

    if ("RETRIEVE_TRANSACTION".equalsIgnoreCase(apiOperation)) {
        resp = connection.getTransaction();
    } else {
        resp = connection.sendTransaction(data);
    }
    if (merchant.debugMode()) {
        out.print("Response : "+ resp + "<br/><br/>");
    }
%>
<%@include file="./receipt.jsp"%>
</body>
</html>