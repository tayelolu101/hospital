<%@ page contentType="application/pdf"  language="java" import = "javax.naming.*,
         com.zenithbank.banking.ibank.security.*,com.zenithbank.banking.ibank.account.*,
         com.zenithbank.banking.ibank.common.* , com.zenithbank.banking.ibank.tradefin.*,
         java.util.Calendar,java.io.*,com.lowagie.text.pdf.*,java.awt.*,com.lowagie.text.BadElementException,
         com.lowagie.text.Document,com.lowagie.text.DocumentException,com.lowagie.text.Element,
         com.lowagie.text.Font,com.lowagie.text.FontFactory,com.lowagie.text.PageSize,com.lowagie.text.Paragraph,
         com.lowagie.text.Rectangle,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfPTable,
         com.lowagie.text.pdf.PdfWriter,com.lowagie.text.Image,com.zenithbank.banking.ibank.security.*,
         com.zenithbank.banking.ibank.account.*,com.zenithbank.banking.ibank.common.*, 
         com.zenithbank.banking.coporate.ibank.payment.*,com.zenithbank.banking.coporate.ibank.PaymentHelper.*,
java.util.*,com.zenithbank.stringhelper.*, com.zenithbank.banking.coporate.ibank.form.*" session="true" %><%
//Taiwo  05092017
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
    String filename = "payments.pdf";

    response.setHeader("Content-Disposition", "attachment;  filename=\"" + filename + "\"");
    Document document = new Document(PageSize.A4.rotate(), 0, 0, 0, 0);

    document.addCreationDate();
    document.addTitle("Payments");

    try {
        PdfWriter.getInstance(document, new FileOutputStream(filename));
        document.open();
        Image image = Image.getInstance(application.getResource("/zeelogo.JPG"));
        document.add(image);

        Font fontBold = new Font();
        fontBold.setColor(Color.DARK_GRAY);
        fontBold.setSize(14f);
        fontBold.setStyle(Font.BOLD);
        

       // String downloadType = request.getParameter("downloadType");

//        if ((downloadType != null && downloadType.equals("invoice_discounting"))) {
//            document.add(new Paragraph("Client invoice discounting payments from CIB", fontBold));
//        } else {
            document.add(new Paragraph("Payment Exceptions from CIB", fontBold));
      //  }

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
     //    Taiwo - 29082017 - changed to fix the search button
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
                 

     

        float[] tWidth = new float[12];
        tWidth[0] = 4f;
        tWidth[1] = 9f;
        tWidth[2] = 5f;
        tWidth[3] = 9f;
        tWidth[4] = 9f;
        tWidth[5] = 9f;
        tWidth[6] = 9f;
        tWidth[7] = 9f;
        tWidth[8] = 4f;
        tWidth[9] = 8f;
        tWidth[10] = 10f;
        tWidth[11] = 8f;
//        tWidth[12] = 8f;

        PdfPTable table = new PdfPTable(12);
        table.setWidthPercentage(100f);
        table.setWidths(tWidth);
        table.setSpacingBefore(20f);

        PdfPCell cell = new PdfPCell(new Paragraph("#No"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Bene. Name in Bank"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

//        cell = new PdfPCell(new Paragraph("Bene. Name in Bank"));
//        cell.setBackgroundColor(Color.LIGHT_GRAY);
//        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Trans. Date"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Rejection Reason"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Trans Ref"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Bene. Code"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Bene. Bank"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Bene. Account"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("CUR."));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Amount"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Debit Account Name"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("Debit Account No"));
        cell.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell);

        for (int i = 0; i < payments.length; i++) {

            String vendor_name = payments[i].getVendor_name();
            String valid_vendor_name = (payments[i].getValid_vendor_name() == null) ? "" : payments[i].getValid_vendor_name();
            String timestamp = payments[i].getUploadDate() == null ? "" : sd.format(payments[i].getUploadDate());
            String transaction_reference = payments[i].getTrans_ref();
            String vendor_code = payments[i].getVendor_code();
            String vendor_bank = payments[i].getVendor_bank();
            String vendor_acct_no = payments[i].getVendor_acct_no();
            String payment_currency = payments[i].getPayment_currency();
            String amount = formatta.formatAmount(Double.toString(payments[i].getAmount()));
            String vendor_category = (payments[i].getVendor_category() == null) ? "" : payments[i].getVendor_category();
            String Rejection_reason = payments[i].getReject_reason();//== null ? "" : sd.format(payments[i].getPayment_due_date());
            String account_name = payments[i].getAccount_name();
            String debit_account_number = payments[i].getDebit_acct_no();
            Font font = new Font();
            font.setSize(10);

            cell = new PdfPCell(new Paragraph((i + 1) + "", font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(vendor_name, font));
            table.addCell(cell);

//            cell = new PdfPCell(new Paragraph(valid_vendor_name, font));
//            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(timestamp, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(Rejection_reason, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(transaction_reference, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(vendor_code, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(vendor_bank, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(vendor_acct_no, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(payment_currency, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(amount, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(account_name, font));
            table.addCell(cell);

            cell = new PdfPCell(new Paragraph(debit_account_number, font));
            table.addCell(cell);

        }
        document.add(table);

        // Added by tobe UCI -- Total amount of transactions
        String nairaTotal = request.getParameter("nairaTotal");
        String dollarTotal = request.getParameter("dollarTotal");
        String poundsTotal = request.getParameter("poundsTotal");

//        StringBuilder totalAmount = new StringBuilder();
//        totalAmount.append("Total Amount: [NGN ").append(nairaTotal).append("] [USD ")
//                .append(dollarTotal).append("] [GBP ").append(poundsTotal).append("]");

        Font font = new Font();
        font.setColor(Color.RED);
        font.setSize(12f);
        fontBold.setStyle(Font.BOLD);

       // document.add(new Paragraph(totalAmount.toString(), font));

        Font fontTiny = new Font();
        fontTiny.setColor(Color.DARK_GRAY);
        fontTiny.setSize(12f);
        fontBold.setStyle(Font.BOLD);
        String tDay = sdf.format(new Date());
        document.add(new Paragraph("Downloaded on " + tDay, font));

        document.close();
        File f = new File(filename);
        InputStream in = new FileInputStream(f);
//response.reset();
//response.setContentType("application/pdf");
        ServletOutputStream outs = response.getOutputStream();
        int bit = 256;
        int i = 0;
        try {
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
    } catch (Exception exp) {
        exp.printStackTrace();
    }


%>

