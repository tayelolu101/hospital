<%!

  // [Snippet] howToParseResponse - start
  public static String getJsonFieldValue(String jsonFieldName, String resp) {
    jsonFieldName = "\"" + jsonFieldName + "\":";
    String jsonFieldValue = null;
    int index = resp.indexOf(jsonFieldName);
    if (index != -1) {
      int startIndex = index + jsonFieldName.length() + 1;
      int endIndex = resp.indexOf("\"", startIndex);
      jsonFieldValue = resp.substring(startIndex, endIndex);
    }
    return jsonFieldValue;
  }
  // [Snippet] howToParseResponse - end

%>
<%

    //a HTML error was received
    if (resp == null || resp.length() == 0) {
      out.print("JSON decode failed. Please review server response (enable debug in configuration.jsp).<br/><br/>");
    } else {
     //Form error string if error is triggered
     String result = getJsonFieldValue("result", resp);
     String errorMessage = null;
     String errorCode = null;
     String gatewayCode = null;
     // Form error string if error is triggered
     if (result != null && result.equals("ERROR")) {
       String failureExplanations = getJsonFieldValue("explanation", resp);
       String supportCode = getJsonFieldValue("supportCode", resp);
       if (failureExplanations != null) {
         errorMessage = failureExplanations;
       } else if (supportCode != null) {
         errorMessage = supportCode;
       } else {
         errorMessage = "Reason unspecified.";
       }
       String failureCode = getJsonFieldValue("failureCode", resp);
       if (failureCode != null) {
         errorCode = "Error (" + failureCode + ")";
       } else {
         errorCode = "Error (UNSPECIFIED)";
       }
   } else {
     gatewayCode = getJsonFieldValue("gatewayCode", resp);
     if (gatewayCode == null) {
       gatewayCode = "Response not received.";
     }
   }
%>

<!--    The following is a simple HTML page to display the response to the transaction.
        This should never be used in your integration -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<link rel="stylesheet" type="text/css" href="./assets/paymentstyle.css" />
<head>
<title>DirectApi Example</title>
<meta http-equiv="Content-Type" content="text/html, charset=iso-8859-1">
</head>
<body>

<center>
<h1><br />
DirectApi JSP REST(JSON) Example</h1>
</center>
<center>
<h3>Receipt Page</h3>
</center>
<br />
<br />

<table width="60%" align="center" cellpadding="5" border="0">

  <%
      // echo HTML displaying Error headers if error is found
          if (errorCode != null || errorMessage != null) {
  %>
  <tr class="title">
    <td colspan="2" height="25">
    <P><strong>&nbsp;Error Response</strong></P>
    </td>
  </tr>
  <tr>
    <td align="right" width="50%"><strong><i><%=errorCode%>:
    </i></strong></td>
    <td width="50%"><%=errorMessage%></td>
  </tr>
  <%
      } else {
  %>
  <tr class="title">
    <td colspan="2" height="25">
    <P><strong>&nbsp;<%=gatewayCode%></strong></P>
    </td>
  </tr>
  <tr>
    <td align="right" width="50%"><strong><i>Result:</i></strong></td>
    <td width="50%"><%=result%></td>
  </tr>
  <%
      }
  %>

  <tr class="title">
    <td colspan="2" height="20">
    <P><strong>&nbsp; JSON Response</strong></P>
    </td>
  </tr>
  <tr>
    <td colspan="2" height="20">
    <p>The display of the below response is intended to be for this
    example only. In your integration, you should parse this response to
    extract and use the response fields required.</p>
    </td>
  </tr>

  <tr>
    <td colspan="2" align="center" width="100%"><textarea rows="20"
      cols="118" name="outContent" id="outContent"><%=resp%></textarea></td>
  </tr>
  <tr>
    <td colspan="2" align="center" width="100%">
    <p>Note: The above response has been formatted to make it easier
    to read. The reformatting also changes amounts to be strictly defined
    JSON numbers. This means 0's are removed from after the decimal place
    i.e. 1.00 is displayed as 1 and 1.10 is displayed as 1.1. <br />
    <a href="javascript:displayRawJSON()">Click here to display the
    unformatted JSON Response</a> <br />
    <a href="javascript:formatTextarea()">Click here to display the
    formatted JSON Response</a></p>

    </td>
  </tr>

</table>
<%
    }
%>
<script type="text/javascript" src="assets/json2.js"></script>
<script type="text/javascript" src="assets/jsonformatter.js"></script>
<script type="text/javascript" src="assets/jquery-1.3.2.js"></script>

<script>
  var orginalJSON;
  function formatTextarea() {
    var sJSON = $("#outContent").val();
    var oJSON = JSON.parse(sJSON);
    sJSON = FormatJSON(oJSON);
    $("#outContent").val(sJSON);
  }
  function fullSize() {
    var text_area = document.getElementById('outContent');
    text_area.style.height = 0;
    text_area.style.height = (text_area.scrollHeight + 10) + "px";
  }
  function initialise() {
    orginalJSON = $("#outContent").val();
  }
  initialise();
  formatTextarea();
  fullSize();
  function displayRawJSON() {
    $("#outContent").val(orginalJSON);
  }
</script>
<br />
<br />
</body>
</html>

