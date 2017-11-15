<%-- 
    Document   : newTable
    Created on : Jun 8, 2017, 12:16:51 PM
    Author     : appdev2
--%>
<%@page import="com.lowagie.text.pdf.PdfPCell"%>
<%@page import="com.lowagie.text.pdf.PdfPTable"%>
<%@page import="com.lowagie.text.pdf.PdfWriter"%>
<%@page import="com.lowagie.text.*"%>
<%@ page contentType="application/pdf"  language="java" import = "javax.naming.*,
com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,
com.zenithbank.banking.ibank.common.* ,
java.util.Calendar,java.io.*,java.text.*, java.sql.*,java.awt.*,com.lowagie.text.Image,com.zenithbank.banking.ibank.security.*,
com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*, 
com.zenithbank.banking.coporate.ibank.payment.*,com.zenithbank.banking.coporate.ibank.PaymentHelper.*,
java.util.*,com.dwise.util.*, com.zenithbank.stringhelper.*, com.zenithbank.banking.coporate.ibank.form.*" session="true" %>
<%
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server


String names = request.getParameter("name");
String ages = request.getParameter("age");
String sexes = request.getParameter("sex");
String addresse = request.getParameter("address");
String phones = request.getParameter("phone");

//  System.out.println("NAME "  + names);

    
String filename = "infor.pdf";
response.setHeader("Content-Disposition", "attachment;  filename=\""+filename+"\"");   
%>



<%
try
{
    
     OutputStream fos = new FileOutputStream(new File(filename));
     
     Document document = new Document();
     PdfWriter.getInstance(document, fos);
             
      document.open();
      document.add(new Chunk(""));
             
      PdfPTable table = new PdfPTable(5); 
     
      PdfPCell cell1  = new PdfPCell(new Paragraph("NAME"));
      PdfPCell cell2  = new PdfPCell(new Paragraph("AGE"));
      PdfPCell cell3  = new PdfPCell(new Paragraph("SEX"));
      PdfPCell cell4  = new PdfPCell(new Paragraph("ADDRESS"));
      PdfPCell cell5  = new PdfPCell(new Paragraph("PHONE"));
      PdfPCell cell6  = new PdfPCell(new Paragraph(names));
      PdfPCell cell7  = new PdfPCell(new Paragraph(ages));
      PdfPCell cell8  = new PdfPCell(new Paragraph(sexes));
      PdfPCell cell9  = new PdfPCell(new Paragraph(addresse));
      PdfPCell cell10 = new PdfPCell(new Paragraph(phones));
      
     
       table.addCell(cell1);
       table.addCell(cell2);
       table.addCell(cell3);
       table.addCell(cell4);
       table.addCell(cell5);
       table.addCell(cell6);
       table.addCell(cell7);
       table.addCell(cell8);
       table.addCell(cell9);
       table.addCell(cell10);
 
       
       document.add(table);
       document.close();
       fos.close();
       
       File f = new File(filename);  
InputStream in = new FileInputStream(f); 

ServletOutputStream outs = response.getOutputStream(); 
int bit = 512;
int i = 0;
try{  
while ((bit) >= 0) {
bit = in.read();  
outs.write(bit);  
 
}    
} catch (IOException ioe) {  
ioe.printStackTrace(System.out); 
}                        
outs.flush();       
outs.close();                  
in.close();     




}catch(Exception ex){
    ex.printStackTrace();
}
%>
