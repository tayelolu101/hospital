<%@ page language="java" import = "com.zenithbank.banking.coporate.ibank.payment.*" session="true" %>
<%
    MakePaymentBeneficiaryPayment m = new MakePaymentBeneficiaryPayment();
    
    String data="";
    String type="";
    String acct_no="";
    String bank_code="";
    String nip_add="";
    String parameter="";
    
    type = request.getParameter("type");
    
    /*
    if(type == null)
    {
        System.out.println("Type is empty");
        
    }
    else
    {
        System.out.println(type);
    }

    */
    
    parameter = request.getParameter("param");
    acct_no = request.getParameter("acct_no");
    bank_code = request.getParameter("bank_code");
    //demo
    //nip_add = "http://172.29.30.251:8080/NibssFasterPay/services/NibssFasterPay";
    ////nip_add = "http://172.29.8.51:8080/NibssFasterPay/services/NibssFasterPay";
        nip_add = "http://172.29.30.251/NibssFasterPayOut/Service.svc";
    //nip_add = "http://172.29.8.226:8080/NibssFasterPay/services/NibssFasterPay";//02072015
    
    
    
    if(type.equalsIgnoreCase("bulkPaymentUploadStatus")){
        data = m.getBatchDetails(request.getParameter("companyID"),request.getParameter("uploaderID"));
        if(data != null)
        {
            out.print(data);
        }
         
    }
    
    
    if(type.equalsIgnoreCase("loadIndividual")){
        data = m.getBeneficiaryDetails(request.getParameter("id"));
        if(data != null)
        {
            out.print(data);
        }
         
    }
    
    if(type.equalsIgnoreCase("loadPayment")){
        System.out.println(parameter);
        data = m.getPaymentType(parameter,request.getParameter("companyID"));
        if(data != null)
        {
            out.print(data);
        }
    }
    
    
    if(type.equalsIgnoreCase("NUBANvalidateAccount")){
  
            try{
                data = m.NUBANvalidateAccount(bank_code,acct_no);
                if(data != null)
                {
                    out.print(data);
                }
            }
            catch(Exception e)
            {
               out.print("Error");
            }
    }
    
    
    
    if(type.equalsIgnoreCase("loadBankDetails")){
        if(bank_code.equalsIgnoreCase("057")){
            data = m.getBankDetails(acct_no);
            if(data != null)
            {
                out.print(data);
            }
        }else{
            try{
                data = m.getOtherBankDetails(acct_no,bank_code,nip_add);
                if(data != null)
                {
                    out.print(data);
                }
            }
            catch(Exception e)
            {
               out.print("Error");
            }
        }
        
     
    }
        
     //18022013
      if(type.equalsIgnoreCase("loadFundingBankAccountNo")){
       // System.out.println("bank_code " + bank_code);
        //System.out.println("companycode " + request.getParameter("companycode"));
        String roleID = request.getParameter("roleID") ;
        int role_ID = Integer.parseInt(roleID) ;
       try{ 
    
          if(bank_code.equalsIgnoreCase("ALL")){
            data = m.getAllBankDebitAccount(request.getParameter("companycode"),"1",bank_code,role_ID);
            if(data != null)
            {
                out.print(data);
            }   
            }
            
            else if(bank_code.equalsIgnoreCase("057")){
            data = m.getZenithBankDebitAccountByBankCode(request.getParameter("companycode"),"1",bank_code,role_ID);
            if(data != null)
            {
                out.print(data);
            }   
            }
            else{
             data = m.getotherBankDebitAccountByBankCode(request.getParameter("companycode"),"1",bank_code,role_ID);
            if(data != null)
            {
                out.print(data);
            }
            }
        }
        catch(Exception e)
            {
               out.print("Error");
            }
    }
%>