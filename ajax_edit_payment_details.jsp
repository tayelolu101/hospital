<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.zenithbank.banking.coporate.ibank.payment.BeneficiaryValue"%>
<%@page import="com.zenithbank.banking.coporate.ibank.payment.BeneficiaryAdapter"%>
<%@page import="com.zenithbank.banking.coporate.ibank.payment.PaymentValue"%>
<%@page import="com.zenithbank.banking.coporate.ibank.payment.Payment"%>
<%@page import="com.zenithbank.banking.coporate.ibank.PaymentHelper.PaymentDB"%>
<%@page import="com.dwise.util.CryptoManager"%>
<%@page import="com.zenithbank.banking.coporate.ibank.action.UploadReader"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.zenithbank.banking.coporate.ibank.form.Login"%>
<%@page import="java.sql.*"%>
<%@page import="com.zenithbank.banking.ibank.common.BaseAdapter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
    response.setContentType("application/json");
    response.setCharacterEncoding("utf8");
    
    Login login = (Login) session.getAttribute("login");
    JsonObject json = new JsonObject();
    
    if (login == null) {
        json.addProperty("no_session", true);
        out.println(json.toString());
        return;
    }
    if (login.getPasschange().equals("1")) {
        json.addProperty("change_password", true);
        out.println(json.toString());
        return;
    }
    
    int authorizerId = login.getSeq();
    int approvalLevel = login.getAuthLevel();
    String source = request.getParameter("source");
    SimpleDateFormat sd = new SimpleDateFormat("MM/dd/yyyy");
    UploadReader uploadReader = new UploadReader();
    PaymentDB db = new PaymentDB();
    String[] custom_setup_details = new String [12];
    custom_setup_details = uploadReader.get_CustomUploadSetupDetails(login.getHostCompany());
    String companySetupforCustomUpload = custom_setup_details[0];
    String beneficiaryammend = custom_setup_details[11];

    String tranid = request.getParameter("tranid");

    Payment payment = db.GetPayment(Double.parseDouble(tranid.trim()));
    boolean isSetUpForUpload = companySetupforCustomUpload.equals("1") && beneficiaryammend.equalsIgnoreCase("Y");
    String benefCode = "";
    
    if ("initValues".equals(source)) {
        json.addProperty("amount", payment.getAmount());
        json.addProperty("valueDate", sd.format(payment.getPayment_due_date()).toString());
        json.addProperty("setUpForUpload", isSetUpForUpload);
        json.addProperty("vendorCode", payment.getVendor_code());
        json.addProperty("vendorAccountNum", payment.getVendor_acct_no());
        json.addProperty("vendorName", payment.getVendor_name());
        json.addProperty("vendorBank", payment.getVendor_bank());
        json.addProperty("vendorBankBranch", payment.getVendor_bank_branch());
        json.addProperty("vendorAddress", payment.getVendor_address());
        json.addProperty("vendorCity", payment.getVendor_city());
        json.addProperty("vendorState", payment.getVendor_state());
        
        json.addProperty("tranid", tranid);
        
        
        
        if (isSetUpForUpload) {
            benefCode = request.getParameter("benef");
            BeneficiaryAdapter ba = new BeneficiaryAdapter();
            BeneficiaryValue[] bv = ba.getBeneficiaryList(login.getHostCompany());
            double bvVendorId = bv.length > 0 ? bv[0].getVendorId() : 0;
            PaymentValue pv = new PaymentValue();
            
            if (benefCode == null || benefCode.trim().equalsIgnoreCase("0")) {
                benefCode = "0";
                pv = ba.getBeneficiaryDetails(Double.toString(bvVendorId));
            } else {
                benefCode = benefCode.trim();
                pv = ba.getBeneficiaryDetails(benefCode); 
            }
            
            JsonArray jsonArray1 = new JsonArray();
            for (BeneficiaryValue b: bv) {
                JsonObject jo = new JsonObject();
                jo.addProperty("beneficiaryRef", b.getBeneficiaryRef().trim());
                jo.addProperty("vendorId", b.getVendorId());
                jo.addProperty("vendorName", b.getVendorName());
                jsonArray1.add(jo);
            }
            json.add("beneficiaryValue", jsonArray1);
            
            
            json.addProperty("hidVendorName", pv.getVendorName());
            json.addProperty("hidVendorCode", pv.getVendorCode());
            json.addProperty("hidVendorAddress", pv.getVendorAddress());
            json.addProperty("hidVendorBank", pv.getVendorBankName());
            json.addProperty("hidVendorBankBranch", pv.getVendorBankBranchName());
            json.addProperty("hidVendorAcctNo", pv.getVendorAccountNumber());
            json.addProperty("hidBankCode", pv.getVendorBankID());
            json.addProperty("hidSortCode", pv.getVendorBankBranchID());
            json.addProperty("hidVendorCity", pv.getVendorCity());
            json.addProperty("hidVendorState", pv.getVendorState());
            json.addProperty("hidVendorPhone", pv.getVendorPhone());
            json.addProperty("hidVendorEmail", pv.getVendorEmail());
            
            json.addProperty("benefCode", benefCode);
        }
        out.println(json.toString());
        out.flush();
    }
    
    if ("submit".equalsIgnoreCase(source)) {
        System.out.println("Attempting to submit...");
        String AMOUNTO = request.getParameter("AMOUNT0");
        String valueDate = request.getParameter("txtValueDate");
        String BenefAcctNo = request.getParameter("txtBenefAcctNo");
        String BenefName = request.getParameter("txtBenefName");
        String BenefCode = request.getParameter("txtBenefCode");
        String BenefBank = request.getParameter("txtBenefBank");
        String BenefBranch = request.getParameter("txtBenefBranch");
        String paymentID = request.getParameter("tranid");
        System.out.println("paymentID: " + paymentID);
        String outMsg = "";
        Date dtToday = new Date();
        BaseAdapter connect = new BaseAdapter();
        
        Connection con1 = null;
        Connection con2 = null;
        Connection con3 = null;
        CallableStatement cs = null;
        CallableStatement commandAmt = null;
        PreparedStatement ps = null;
        
        try {
            con1 = connect.getConnection();

            cs = con1.prepareCall("{?=call zenbasenet..zsp_cib_edit_payment_check(?,?,?,?)}");
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setDouble(2, Double.parseDouble(paymentID));
            cs.setString(3, AMOUNTO);
            String[] newdate = valueDate.trim().split("/");

            cs.setString(4,new StringBuffer().append(newdate[1]).append("/").append(newdate[0]).append("/").append(newdate[2]).toString());

            cs.setNull(5,Types.VARCHAR);
            cs.execute();

            if (cs.getInt(1) == 0) {
                String SQLQuery = "";
                SQLQuery = " UPDATE zenbasenet..zib_cib_pmt_payments ";
                SQLQuery += " SET approval_level = 1, ";

                SQLQuery += " amount = " + AMOUNTO + ", ";

                SQLQuery += " payment_due_date = '" + valueDate + "', ";
                SQLQuery += " vendor_acct_no = '" + BenefAcctNo + "', ";
                SQLQuery += " vendor_name = '" + BenefName + "', ";
                SQLQuery += " vendor_code = '" + BenefCode + "', ";
                SQLQuery += " vendor_bank = '" + BenefBank + "', ";
                SQLQuery += " vendor_bank_branch = '" + BenefBranch + "' ";
                SQLQuery += " WHERE payment_id = " + paymentID;
                
                con2 = connect.getConnection();
                ps = con2.prepareStatement(SQLQuery);
                int rCode = ps.executeUpdate();

                if (rCode > 0) {
                   SQLQuery = "insert into zenbasenet..zib_cib_pmt_approvalhistory ";
                   SQLQuery += " (payment_id, authorizer_id, approval_level, status )";
                   SQLQuery += " values  (?,?,?,?)";
                   ps = con2.prepareStatement(SQLQuery);
                   //ps.setDouble(1, newPTID);
                   ps.setDouble(1, Double.parseDouble(paymentID));
                   ps.setInt(2, authorizerId);
                   ps.setInt(3, approvalLevel);
                   ps.setString(4, "Amended: Awaiting Approval");
                   ps.executeUpdate();

                   json.addProperty("success", true);
                   out.println(json.toString());
               }
            } else {
                double globalLimt = 0;
                con3 = connect.getConnection();
                commandAmt = con3.prepareCall("{?=call zenbasenet..zsp_get_global_limit_byID(?)}");
                commandAmt.registerOutParameter(1, Types.DOUBLE);
                commandAmt.setDouble(2, Double.parseDouble(paymentID));

                commandAmt.execute();
                globalLimt = commandAmt.getDouble(1);
                json.addProperty("success", true);
                json.addProperty("limit_exceeded", true);
                json.addProperty("limit_value", globalLimt);
                json.addProperty("value_date", valueDate);
            }       
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e);
            json.addProperty("success", false);
            out.println(json.toString());
        } finally {
            if (con1 != null) { con1.close(); }
            if (con2 != null) { con2.close(); }
            if (con3 != null) { con3.close(); }
            if (commandAmt != null) { commandAmt.close(); }
        }
    }
%>