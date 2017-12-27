package com.zenithbank.banking.coporate.ibank.payment;
import java.util.Date;

public class PaymentValue 
{

  private String CompanyId;
  private double VendorId;
  private String vendorNumber;
  private String VendorName;
  private String vendorAddress;
  private String vendorCity;
  private String vendorState;
  private String vendorPhone;
  private String vendorGSM;
  private String vendorContactPerson;
  private String vendorEmail;
  private String vendorBankID;
  private String vendorBankName;
  private String vendorBankBranchID;
  private String vendorBankBranchName;
  private String vendorAccountNumber;
  private String vendorCategory;
  private String vendorStatus;
  private String PaymentType;
  private String transRef;
  private String vendorCode;
  private double Amount;
  private Date paymentDueDate;
  private String pmtDueDate;
  private String paymentCurrency;
  private String PaymentMethod;
  private String paymentType;
  private String debitAccountNo;
  private String AccountCurrency;
  private String accountCurrency;
  private String accountName;
  private String accountNo;
  private String contractNo;
  private Date contractDate;
  private String routingMethod;
  private String routingBankCode;
  private String sortCode;
  private String zenithClientID;
  private String processingBranchNo;
  private double batchID;
  private int paymentID;
  
  //03032010  - Intermediary Bank details 
  private String intermediary_bank_name;
  private String intermediary_bank_acctno;
  private String intermediary_bank_bic;
  private String intermediary_bank_branch;
  //03032010 - Intermediary Bank details 
  
   //08112010 - Import Duty Payment field mapping
   private String telex_ref;//RAR_Bill_of_Lading
   private String invoice_number;//asycuda_no
    //08112010 - Import Duty Payment field mapping

 //04042011 - cheque confirmation field mapping   
   private String vendor_acct_type;
   private String transfer_id;//ip address
   private String user_id;
//04042011 - cheque confirmation field mapping   
  
 //13022013
 private String chargeOption;//for FX Charge=SHA or OUR
 
 //09042013 invoice discount 
  private Date invoice_date       ;
  private int tenor               ;
  private Date invoice_duedate    ;
  private double discounted_amount ;
  private int discounted_days ;
  
  private boolean isNewBen;
  private String benID;
  
  private double authorizerID;
  
  //30092013 SWIFT/DIRECTDEBIT Debit Bank BIC for beneficiary addition
  private String corresp_bank_bic ;
  
  //NIBSS eBillsPay
  private double charge_amt;
  
  //27052015 - intraTransfer
  private String paymentStatus;
  
  
  public PaymentValue()
  {
  }


  public void setCompanyId(String CompanyId)
  {
    this.CompanyId = CompanyId;
  }


  public String getCompanyId()
  {
    return CompanyId;
  }


  public void setVendorId(double VendorId)
  {
    this.VendorId = VendorId;
  }


  public double getVendorId()
  {
    return VendorId;
  }


  public void setVendorName(String VendorName)
  {
    this.VendorName = VendorName;
  }


  public String getVendorName()
  {
    return VendorName;
  }


  public void setVendorAddress(String vendorAddress)
  {
    this.vendorAddress = vendorAddress;
  }


  public String getVendorAddress()
  {
    return vendorAddress;
  }


  public void setVendorCity(String vendorCity)
  {
    this.vendorCity = vendorCity;
  }


  public String getVendorCity()
  {
    return vendorCity;
  }


  public void setVendorState(String vendorState)
  {
    this.vendorState = vendorState;
  }


  public String getVendorState()
  {
    return vendorState;
  }


  public void setVendorPhone(String vendorPhone)
  {
    this.vendorPhone = vendorPhone;
  }


  public String getVendorPhone()
  {
    return vendorPhone;
  }


  public void setVendorGSM(String vendorGSM)
  {
    this.vendorGSM = vendorGSM;
  }


  public String getVendorGSM()
  {
    return vendorGSM;
  }


  public void setVendorContactPerson(String vendorContactPerson)
  {
    this.vendorContactPerson = vendorContactPerson;
  }


  public String getVendorContactPerson()
  {
    return vendorContactPerson;
  }


  public void setVendorEmail(String vendorEmail)
  {
    this.vendorEmail = vendorEmail;
  }


  public String getVendorEmail()
  {
    return vendorEmail;
  }


  public void setVendorBankID(String vendorBankID)
  {
    this.vendorBankID = vendorBankID;
  }


  public String getVendorBankID()
  {
    return vendorBankID;
  }


  public void setVendorBankName(String vendorBankName)
  {
    this.vendorBankName = vendorBankName;
  }


  public String getVendorBankName()
  {
    return vendorBankName;
  }


  public void setVendorBankBranchID(String vendorBankBranchID)
  {
    this.vendorBankBranchID = vendorBankBranchID;
  }


  public String getVendorBankBranchID()
  {
    return vendorBankBranchID;
  }


  public void setVendorBankBranchName(String vendorBankBranchName)
  {
    this.vendorBankBranchName = vendorBankBranchName;
  }


  public String getVendorBankBranchName()
  {
    return vendorBankBranchName;
  }


  public void setVendorAccountNumber(String vendorAccountNumber)
  {
    this.vendorAccountNumber = vendorAccountNumber;
  }


  public String getVendorAccountNumber()
  {
    return vendorAccountNumber;
  }


  public void setVendorCategory(String vendorCategory)
  {
    this.vendorCategory = vendorCategory;
  }


  public String getVendorCategory()
  {
    return vendorCategory;
  }


  public void setVendorStatus(String vendorStatus)
  {
    this.vendorStatus = vendorStatus;
  }


  public String getVendorStatus()
  {
    return vendorStatus;
  }


  public void setPaymentType(String PaymentType)
  {
    this.PaymentType = PaymentType;
  }


  public String getPaymentType()
  {
    return PaymentType;
  }


  public void setVendorNumber(String vendorNumber)
  {
    this.vendorNumber = vendorNumber;
  }


  public String getVendorNumber()
  {
    return vendorNumber;
  }


  public void setTransRef(String transRef)
  {
    this.transRef = transRef;
  }


  public String getTransRef()
  {
    return transRef;
  }


  public void setVendorCode(String vendorCode)
  {
    this.vendorCode = vendorCode;
  }


  public String getVendorCode()
  {
    return vendorCode;
  }


  public void setAmount(double Amount)
  {
    this.Amount = Amount;
  }


  public double getAmount()
  {
    return Amount;
  }


  public void setPaymentDueDate(Date paymentDueDate)
  {
    this.paymentDueDate = paymentDueDate;
  }


  public Date getPaymentDueDate()
  {
    return paymentDueDate;
  }


  public void setPaymentCurrency(String paymentCurrency)
  {
    this.paymentCurrency = paymentCurrency;
  }


  public String getPaymentCurrency()
  {
    return paymentCurrency;
  }


  public void setPaymentMethod(String PaymentMethod)
  {
    this.PaymentMethod = PaymentMethod;
  }


  public String getPaymentMethod()
  {
    return PaymentMethod;
  }


  public void set_paymentType(String paymentType)
  {
    this.paymentType = paymentType;
  }


  public String get_paymentType()
  {
    return paymentType;
  }


  public void setDebitAccountNo(String debitAccountNo)
  {
    this.debitAccountNo = debitAccountNo;
  }


  public String getDebitAccountNo()
  {
    return debitAccountNo;
  }


  public void setAccountCurrency(String AccountCurrency)
  {
    this.AccountCurrency = AccountCurrency;
  }


  public String getAccountCurrency()
  {
    return AccountCurrency;
  }


  public void setAccountName(String accountName)
  {
    this.accountName = accountName;
  }


  public String getAccountName()
  {
    return accountName;
  }


  public void setAccountNo(String accountNo)
  {
    this.accountNo = accountNo;
  }


  public String getAccountNo()
  {
    return accountNo;
  }


  public void setContractNo(String contractNo)
  {
    this.contractNo = contractNo;
  }


  public String getContractNo()
  {
    return contractNo;
  }


  public void setContractDate(Date contractDate)
  {
    this.contractDate = contractDate;
  }


  public Date getContractDate()
  {
    return contractDate;
  }


  public void setRoutingMethod(String routingMethod)
  {
    this.routingMethod = routingMethod;
  }


  public String getRoutingMethod()
  {
    return routingMethod;
  }


  public void setRoutingBankCode(String routingBankCode)
  {
    this.routingBankCode = routingBankCode;
  }


  public String getRoutingBankCode()
  {
    return routingBankCode;
  }


  public void setSortCode(String sortCode)
  {
    this.sortCode = sortCode;
  }


  public String getSortCode()
  {
    return sortCode;
  }


  public void setZenithClientID(String zenithClientID)
  {
    this.zenithClientID = zenithClientID;
  }


  public String getZenithClientID()
  {
    return zenithClientID;
  }


  public void setProcessingBranchNo(String processingBranchNo)
  {
    this.processingBranchNo = processingBranchNo;
  }


  public String getProcessingBranchNo()
  {
    return processingBranchNo;
  }


  public void setBatchID(double batchID)
  {
    this.batchID = batchID;
  }


  public double getBatchID()
  {
    return batchID;
  }


  public void set_accountCurrency(String accountCurrency)
  {
    this.accountCurrency = accountCurrency;
  }


  public String get_accountCurrency()
  {
    return accountCurrency;
  }


  public void setPaymentID(int paymentID)
  {
    this.paymentID = paymentID;
  }


  public int getPaymentID()
  {
    return paymentID;
  }


  public void setPmtDueDate(String pmtDueDate)
  {
    this.pmtDueDate = pmtDueDate;
  }


  public String getPmtDueDate()
  {
    return pmtDueDate;
  }


  public void setIntermediary_bank_name(String intermediary_bank_name)
  {
    this.intermediary_bank_name = intermediary_bank_name;
  }


  public String getIntermediary_bank_name()
  {
    return intermediary_bank_name;
  }


  public void setIntermediary_bank_acctno(String intermediary_bank_acctno)
  {
    this.intermediary_bank_acctno = intermediary_bank_acctno;
  }


  public String getIntermediary_bank_acctno()
  {
    return intermediary_bank_acctno;
  }


  public void setIntermediary_bank_bic(String intermediary_bank_bic)
  {
    this.intermediary_bank_bic = intermediary_bank_bic;
  }


  public String getIntermediary_bank_bic()
  {
    return intermediary_bank_bic;
  }


  public void setIntermediary_bank_branch(String intermediary_bank_branch)
  {
    this.intermediary_bank_branch = intermediary_bank_branch;
  }


  public String getIntermediary_bank_branch()
  {
    return intermediary_bank_branch;
  }

    public void setTelex_ref(String telex_ref) {
        this.telex_ref = telex_ref;
    }

    public String getTelex_ref() {
        return telex_ref;
    }

    public void setInvoice_number(String invoice_number) {
        this.invoice_number = invoice_number;
    }

    public String getInvoice_number() {
        return invoice_number;
    }

    public void setVendor_acct_type(String vendor_acct_type) {
        this.vendor_acct_type = vendor_acct_type;
    }

    public String getVendor_acct_type() {
        return vendor_acct_type;
    }

    public void setTransfer_id(String transfer_id) {
        this.transfer_id = transfer_id;
    }

    public String getTransfer_id() {
        return transfer_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setIsNewBen(boolean isNewBen) {
        this.isNewBen = isNewBen;
    }

    public boolean isIsNewBen() {
        return isNewBen;
    }

    public void setBenID(String benID) {
        this.benID = benID;
    }

    public String getBenID() {
        return benID;
    }

    public void setAuthorizerID(double authorizerID) {
        this.authorizerID = authorizerID;
    }

    public double getAuthorizerID() {
        return authorizerID;
    }

    public void setChargeOption(String chargeOption) {
        this.chargeOption = chargeOption;
    }

    public String getChargeOption() {
        return chargeOption;
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

    public void setCorresp_bank_bic(String corresp_bank_bic) {
        this.corresp_bank_bic = corresp_bank_bic;
    }

    public String getCorresp_bank_bic() {
        return corresp_bank_bic;
    }

    public void setCharge_amt(double charge_amt) 
	{
        this.charge_amt = charge_amt;
    }

    public double getCharge_amt() {


        return charge_amt;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }
}
