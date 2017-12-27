package com.zenithbank.banking.coporate.ibank.payment;
import java.util.*;
public class Payment 
{
    private double payment_id;
    private String company_code;
    private String companyName;
    private int batchid;           
    private String vendor_name;
    private String vendor_address;
    private String vendor_city;
    private String vendor_state;
    private String vendor_postcode;
    private String vendor_phone;
    private String vendor_category;
    private String vendor_code;
    private double amount;
    private Date payment_due_date;
    private String payment_currency ;
    private String payment_method;
    private String payment_type;
    private String vendor_acct_no;
    private String vendor_bank;
    private String vendor_bank_branch;
    private String contract_no;
    private String contract_date;
    private String routing_bank_code;
    private String debit_acct_no;
    private String account_currency;
    private String account_name;
    private Date approval_date;
    private int approval_officer;
    private int approval_level;
    private String paymentstatus;    
    private String reject_reason;     
    private String trans_ref;
    private String vendor_acct_type;
    private char cleared ;
    private char processed;
    private char auth_cleared;
    private String return_reason;
    private char rejected;
    private String corresp_bank_bic;
    private String zib_offshore_acct;
    private String telex_ref;
    private Date UploadDate;
    private String int_bank_bic;
    private String int_bank_name;
    private String int_bank_addr;
    private String sort_code ;
    private String vendor_bank_acctno;
    private String invoicenumber;
    private Date create_dt;
    private int SmsFlag;   
    private int sequence_no;   
    private long sequenceno;  
    private String vcodeFromBenTable;
    private String vacctNoFromBenTable;
    
         /* added here */
    private String Bene_gsmnumber;
    private String Bene_email;
    private String Contact_per;
    private String Bank_code;
    private String Bank_Branch_code; 
     /* added here */
     
     /*Gbolahan,11/05/2009 added for Payment Search  */
     private String original_filename;
     private String server_filename;
     private Date file_UploadDate;
     private String uploader_fullname;
     private Date return_dt;
     /*Gbolahan,11/05/2009 added for Payment Search  */
     
    //for zib_user_exception table 
    private double amount2;
    private double dollar_amount;
    private double dollar_amount2;
    private double euro_amount;
    private double euro_amount2;
    private double pounds_amount;
    private double pounds_amount2;
    
    
    //09042013 invoice discount 
     private Date invoice_date       ;
     private int tenor               ;
     private Date invoice_duedate    ;
     private double discounted_amount ;
     private int discounted_days ;    
     
     
    private String amount_s;
    
    
    private String valid_vendor_name;
    
    // CIB FX STP - 11082014
     private String chargeAccount;
     private String vendorCountry;
     private String vendorBankCountry;
     private String vendorBankCity;
     private String natureOfTxn;
     
     //CHIMA UCI TECH - LMT
     private String additionalInfo;
     
     private String transfer_id;
     
    //27052015 - Intra Transfer
    private String routing_method;
     
     
  public Payment()
  {
  }
private boolean isValidBenefiary = true;
private boolean isValidAuthoriser = true;
private boolean isValidUploader = true; // Added 25082016

    public boolean isIsValidUploader() {
        return isValidUploader;
    }

    public void setIsValidUploader(boolean isValidUploader) {
        this.isValidUploader = isValidUploader;
    }


  public void setIsValidBenefiary(boolean isValidBenefiary)
  {
    this.isValidBenefiary = isValidBenefiary;
  }


  public boolean isIsValidBenefiary()
  {
    return isValidBenefiary;
  }


  public void setIsValidAuthoriser(boolean isValidAuthoriser)
  {
    this.isValidAuthoriser = isValidAuthoriser;
  }


  public boolean isIsValidAuthoriser()
  {
    return isValidAuthoriser;
  }

  public void setPayment_id(double payment_id)
  {
    this.payment_id = payment_id;
  }


  public double getPayment_id()
  {
    return payment_id;
  }


  public void setcompany_code(String company_code)
  {
    this.company_code = company_code;
  }


  public String getcompany_code()
  {
    if(company_code == null)
      return "";
    return company_code;
  }


  public void setBatchid(int batchid)
  {
    this.batchid = batchid;
  }


  public int getBatchid()
  {
    return batchid;
  }


  public void setVendor_name(String vendor_name)
  {
    this.vendor_name = vendor_name;
  }


  public String getVendor_name()
  {
    if(vendor_name == null)
      return "";
    return vendor_name;
  }


  public void setVendor_address(String vendor_address)
  {
    this.vendor_address = vendor_address;
  }


  public String getVendor_address()
  {
    if(vendor_address == null)
      return "";
    return vendor_address;
  }


  public void setVendor_city(String vendor_city)
  {
    this.vendor_city = vendor_city;
  }


  public String getVendor_city()
  {
    if(vendor_city == null)
      return "";
    return vendor_city;
  }


  public void setVendor_state(String vendor_state)
  {
    this.vendor_state = vendor_state;
  }


  public String getVendor_state()
  {
    if(vendor_state == null)
      return "";
    return vendor_state;
  }


  public void setVendor_postcode(String vendor_postcode)
  {
    this.vendor_postcode = vendor_postcode;
  }


  public String getVendor_postcode()
  {
    if(vendor_postcode == null)
      return "";
    return vendor_postcode;
  }


  public void setVendor_phone(String vendor_phone)
  {
    this.vendor_phone = vendor_phone;
  }


  public String getVendor_phone()
  {
    if(vendor_phone == null)
      return "";
    return vendor_phone;
  }


  public void setVendor_category(String vendor_category)
  {
    this.vendor_category = vendor_category;
  }


  public String getVendor_category()
  {
    if(vendor_category == null)
      return "";
    return vendor_category;
  }


  public void setVendor_code(String vendor_code)
  {
    this.vendor_code = vendor_code;
  }


  public String getVendor_code()
  {
    if(vendor_code == null)
      return "";
    return vendor_code;
  }


  public void setAmount(double amount)
  {
    this.amount = amount;
  }


  public double getAmount()
  {
    return amount;
  }


  public void setPayment_due_date(Date payment_due_date)
  {
    this.payment_due_date = payment_due_date;
  }


  public Date getPayment_due_date()
  {
    return payment_due_date;
  }


  public void setPayment_currency(String payment_currency)
  {
    this.payment_currency = payment_currency;
  }


  public String getPayment_currency()
  {
    if(payment_currency == null)
      return "";
    return payment_currency;
  }


  public void setPayment_method(String payment_method)
  {
    this.payment_method = payment_method;
  }


  public String getPayment_method()
  {
    if(payment_method == null)
      return "";
    return payment_method;
  }


  public void setPayment_type(String payment_type)
  {
    this.payment_type = payment_type;
  }


  public String getPayment_type()
  {
    if(payment_type == null)
      return "";
    return payment_type;
  }


  public void setVendor_acct_no(String vendor_acct_no)
  {
    this.vendor_acct_no = vendor_acct_no;
  }


  public String getVendor_acct_no()
  {
    if(vendor_acct_no == null)
      return "";
    return vendor_acct_no;
  }


  public void setVendor_bank(String vendor_bank)
  {
    this.vendor_bank = vendor_bank;
  }


  public String getVendor_bank()
  {
    if(vendor_bank == null)
      return "";
    return vendor_bank;
  }


  public void setVendor_bank_branch(String vendor_bank_branch)
  {
    this.vendor_bank_branch = vendor_bank_branch;
  }


  public String getVendor_bank_branch()
  {
    if(vendor_bank_branch == null)
      return vendor_bank_branch;
    return vendor_bank_branch;
  }


  public void setContract_no(String contract_no)
  {
    this.contract_no = contract_no;
  }


  public String getContract_no()
  {
    if(contract_no == null)
      return "";
    return contract_no;
  }


  public void setContract_date(String contract_date)
  {
    this.contract_date = contract_date;
  }


  public String getContract_date()
  {
    if(contract_date == null)
      return "";
    return contract_date;
  }


  public void setRouting_bank_code(String routing_bank_code)
  {
    this.routing_bank_code = routing_bank_code;
  }


  public String getRouting_bank_code()
  {
    if(routing_bank_code == null)
      return "";
    return routing_bank_code;
  }


  public void setDebit_acct_no(String debit_acct_no)
  {
    this.debit_acct_no = debit_acct_no;
  }


  public String getDebit_acct_no()
  {
    if(debit_acct_no == null)
      return "";
    return debit_acct_no;
  }


  public void setAccount_currency(String account_currency)
  {
    this.account_currency = account_currency;
  }


  public String getAccount_currency()
  {
    if(account_currency == null)
      return "";
    return account_currency;
  }


  public void setAccount_name(String account_name)
  {
    this.account_name = account_name;
  }


  public String getAccount_name()
  {
    if(account_name == null)
      return "";
    return account_name;
  }


  public void setApproval_date(Date approval_date)
  {
    this.approval_date = approval_date;
  }


  public Date getApproval_date()
  {
    return approval_date;
  }


  public void setApproval_officer(int approval_officer)
  {
    this.approval_officer = approval_officer;
  }


  public int getApproval_officer()
  {
    return approval_officer;
  }


  public void setApproval_level(int approval_level)
  {
    this.approval_level = approval_level;
  }


  public int getApproval_level()
  {
    return approval_level;
  }


  public void setPaymentstatus(String paymentstatus)
  {
    this.paymentstatus = paymentstatus;
  }


  public String getPaymentstatus()
  {
    if(paymentstatus == null)
      return "";
    return paymentstatus;
  }


  public void setReject_reason(String reject_reason)
  {
    this.reject_reason = reject_reason;
  }


  public String getReject_reason()
  {
    if(reject_reason == null)
      return "";
    return reject_reason;
  }


  public void setTrans_ref(String trans_ref)
  {
    this.trans_ref = trans_ref;
  }


  public String getTrans_ref()
  {
    if(trans_ref == null)
      return "";
    return trans_ref;
  }


  public void setVendor_acct_type(String vendor_acct_type)
  {
    this.vendor_acct_type = vendor_acct_type;
  }


  public String getVendor_acct_type()
  {
    if(vendor_acct_type == null)
      return "";
    return vendor_acct_type;
  }


  public void setCleared(char cleared)
  {
    this.cleared = cleared;
  }


  public char getCleared()
  {
    return cleared;
  }


  public void setProcessed(char processed)
  {
    this.processed = processed;
  }


  public char getProcessed()
  {
    return processed;
  }


  public void setAuth_cleared(char auth_cleared)
  {
    this.auth_cleared = auth_cleared;
  }


  public char getAuth_cleared()
  {
    return auth_cleared;
  }


  public void setReturn_reason(String return_reason)
  {
    this.return_reason = return_reason;
  }


  public String getReturn_reason()
  {
    if(return_reason == null)
      return "";
    return return_reason;
  }


  public void setRejected(char rejected)
  {
    this.rejected = rejected;
  }


  public char getRejected()
  {
    return rejected;
  }


  public void setCorresp_bank_bic(String corresp_bank_bic)
  {
    this.corresp_bank_bic = corresp_bank_bic;
  }


  public String getCorresp_bank_bic()
  {
    if(corresp_bank_bic == null)
      return "";
    return corresp_bank_bic;
  }


  public void setZib_offshore_acct(String zib_offshore_acct)
  {
    this.zib_offshore_acct = zib_offshore_acct;
  }


  public String getZib_offshore_acct()
  {
    if(zib_offshore_acct == null)
      return "";
    return zib_offshore_acct;
  }


  public void setTelex_ref(String telex_ref)
  {
    this.telex_ref = telex_ref;
  }


  public String getTelex_ref()
  {
    if(telex_ref == null)
      return "";
    return telex_ref;
  }


  public void setInt_bank_bic(String int_bank_bic)
  {
    this.int_bank_bic = int_bank_bic;
  }

  public String getInt_bank_bic()
  {
    if(int_bank_bic == null)
      return "";
    return int_bank_bic;
  }


  public void setInt_bank_name(String int_bank_name)
  {
    this.int_bank_name = int_bank_name;
  }


  public String getInt_bank_name()
  {
    if(int_bank_name == null)
      return "";
    return int_bank_name;
  }


  public void setInt_bank_addr(String int_bank_addr)
  {
    this.int_bank_addr = int_bank_addr;
  }


  public String getInt_bank_addr()
  {
    if(int_bank_addr == null)
      return "";
    return int_bank_addr;
  }


  public void setSort_code(String sort_code)
  {
    this.sort_code = sort_code;
  }


  public String getSort_code()
  {
    if(sort_code == null)
      return "";
    return sort_code;
  }


  public void setVendor_bank_acctno(String vendor_bank_acctno)
  {
    this.vendor_bank_acctno = vendor_bank_acctno;
  }


  public String getVendor_bank_acctno()
  {
    if(vendor_bank_acctno == null)
      return "";
    return vendor_bank_acctno;
  }


  public void setSmsFlag(int SmsFlag)
  {
    this.SmsFlag = SmsFlag;
  }


  public int getSmsFlag()
  {
    return SmsFlag;
  }


  public void setUploadDate(Date UploadDate)
  {
    this.UploadDate = UploadDate;
  }


  public Date getUploadDate()
  {
    return UploadDate;
  }


  public void setInvoicenumber(String invoicenumber)
  {
    this.invoicenumber = invoicenumber;
  }


  public String getInvoicenumber()
  {
    return invoicenumber;
  }


  public void setCreate_dt(Date create_dt)
  {
    this.create_dt = create_dt;
  }


  public Date getCreate_dt()
  {
    return create_dt;
  }


  public void setCompanyName(String companyName)
  {
    this.companyName = companyName;
  }


  public String getCompanyName()
  {
    return companyName;
  }
  private int ptid;
    private String PaymentDueDate;




  public void setPtid(int ptid)
  {
    this.ptid = ptid;
  }


  public int getPtid()
  {
    return ptid;
  }


  public void setPaymentDueDate(String PaymentDueDate)
  {
    this.PaymentDueDate = PaymentDueDate;
  }


  public String getPaymentDueDate()
  {
    return PaymentDueDate;
  }
  
   /* added here */
  public void setBank_Branch_code(String Bank_Branch_code)
  {
    this.Bank_Branch_code = Bank_Branch_code;
  }


  public String getBank_Branch_code()
  {
    if(Bank_Branch_code == null)
      return "";
    return Bank_Branch_code;
  }
  
  public void setBank_code(String Bank_code)
  {
    this.Bank_code = Bank_code;
  }


  public String getBank_code()
  {
    if(Bank_code == null)
      return "";
    return Bank_code;
  }
  
  public void setContact_per(String Contact_per)
  {
    this.Contact_per = Contact_per;
  }


  public String getContact_per()
  {
    if(Contact_per == null)
      return "";
    return Contact_per;
  }
  
  public void setBene_email(String Bene_email)
  {
    this.Bene_email = Bene_email;
  }


  public String getBene_email()
  {
    if(Bene_email == null)
      return "";
    return Bene_email;
  }
  
  public void setBene_gsmnumber(String Bene_gsmnumber)
  {
    this.Bene_gsmnumber = Bene_gsmnumber;
  }


  public String getBene_gsmnumber()
  {
    if(Bene_gsmnumber == null)
      return "";
    return Bene_gsmnumber;
  }


  public void setOriginal_filename(String original_filename)
  {
    this.original_filename = original_filename;
  }


  public String getOriginal_filename()
  {
    return original_filename;
  }


  public void setServer_filename(String server_filename)
  {
    this.server_filename = server_filename;
  }


  public String getServer_filename()
  {
    return server_filename;
  }


  public void setFile_UploadDate(Date file_UploadDate)
  {
    this.file_UploadDate = file_UploadDate;
  }


  public Date getFile_UploadDate()
  {
    return file_UploadDate;
  }


  public void setUploader_fullname(String uploader_fullname)
  {
    this.uploader_fullname = uploader_fullname;
  }


  public String getUploader_fullname()
  {
    return uploader_fullname;
  }


  public void setReturn_dt(Date return_dt)
  {
    this.return_dt = return_dt;
  }


  public Date getReturn_dt()
  {
    return return_dt;
  }
  
  /* here */

    public void setCompany_code(String company_code) {
        this.company_code = company_code;
    }

    public String getCompany_code() {
        return company_code;
    }

    public void setSequence_no(int sequence_no) {
        this.sequence_no = sequence_no;
    }

    public int getSequence_no() {
        return sequence_no;
    }

    public void setSequenceno(long sequenceno) {
        this.sequenceno = sequenceno;
    }

    public long getSequenceno() {
        return sequenceno;
    }

    public void setAmount2(double amount2) {
        this.amount2 = amount2;
    }

    public double getAmount2() {
        return amount2;
    }

    public void setDollar_amount(double dollar_amount) {
        this.dollar_amount = dollar_amount;
    }

    public double getDollar_amount() {
        return dollar_amount;
    }

    public void setDollar_amount2(double dollar_amount2) {
        this.dollar_amount2 = dollar_amount2;
    }

    public double getDollar_amount2() {
        return dollar_amount2;
    }

    public void setEuro_amount(double euro_amount) {
        this.euro_amount = euro_amount;
    }

    public double getEuro_amount() {
        return euro_amount;
    }

    public void setEuro_amount2(double euro_amount2) {
        this.euro_amount2 = euro_amount2;
    }

    public double getEuro_amount2() {
        return euro_amount2;
    }

    public void setPounds_amount(double pounds_amount) {
        this.pounds_amount = pounds_amount;
    }

    public double getPounds_amount() {
        return pounds_amount;
    }

    public void setPounds_amount2(double pounds_amount2) {
        this.pounds_amount2 = pounds_amount2;
    }

    public double getPounds_amount2() {
        return pounds_amount2;
    }

    public void setInvoice_date(Date invoice_date) {
        this.invoice_date = invoice_date;
    }

    public Date getInvoice_date() {
        return invoice_date;
    }

    public void setTenor(int tenor) {
        this.tenor = tenor;
    }

    public int getTenor() {
        return tenor;
    }

    public void setInvoice_duedate(Date invoice_duedate) {
        this.invoice_duedate = invoice_duedate;
    }

    public Date getInvoice_duedate() {
        return invoice_duedate;
    }

    public void setDiscounted_amount(double discounted_amount) {
        this.discounted_amount = discounted_amount;
    }

    public double getDiscounted_amount() {
        return discounted_amount;
    }

    public void setDiscounted_days(int discounted_days) {
        this.discounted_days = discounted_days;
    }

    public int getDiscounted_days() {
        return discounted_days;
    }

    public void setAmount_s(String amount_s) {
        this.amount_s = amount_s;
    }

    public String getAmount_s() {
        return amount_s;
    }

    public void setValid_vendor_name(String valid_vendor_name) {
        this.valid_vendor_name = valid_vendor_name;
    }

    public String getValid_vendor_name() {
        return valid_vendor_name;
    }

    public void setChargeAccount(String chargeAccount) {
        this.chargeAccount = chargeAccount;
    }

    public String getChargeAccount() {
        return chargeAccount;
    }

    public void setVendorCountry(String vendorCountry) {
        this.vendorCountry = vendorCountry;
    }

    public String getVendorCountry() {
        return vendorCountry;
    }

    public void setVendorBankCountry(String vendorBankCountry) {
        this.vendorBankCountry = vendorBankCountry;
    }

    public String getVendorBankCountry() {
        return vendorBankCountry;
    }

    public void setVendorBankCity(String vendorBankCity) {
        this.vendorBankCity = vendorBankCity;
    }

    public String getVendorBankCity() {
        return vendorBankCity;
    }

    public void setNatureOfTxn(String natureOfTxn) {
        this.natureOfTxn = natureOfTxn;
    }

    public String getNatureOfTxn() {
        return natureOfTxn;
    }

    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
    }

    public String getAdditionalInfo() {
        return additionalInfo;
    }


  public void setTransfer_id (String transfer_id)
  {
    this.transfer_id = transfer_id;
  }

  public String getTransfer_id ()
  {
    return transfer_id;
  }

    public void setRouting_method(String routing_method) {
        this.routing_method = routing_method;
    }

    public String getRouting_method() {
        return routing_method;
    }

	public String getVcodeFromBenTable() {
		return vcodeFromBenTable;
	}

	public void setVcodeFromBenTable(String vcodeFromBenTable) {
		this.vcodeFromBenTable = vcodeFromBenTable;
	}

	public String getVacctNoFromBenTable() {
		return vacctNoFromBenTable;
	}

	public void setVacctNoFromBenTable(String vacctNoFromBenTable) {
		this.vacctNoFromBenTable = vacctNoFromBenTable;
	}
}
