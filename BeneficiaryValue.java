package com.zenithbank.banking.coporate.ibank.payment;

public class BeneficiaryValue {

	private String paymenttypeid;
	private String paymenttype;
	private String STATUSID;
	private String STATUS;

	private String BeneficiaryName;

	private String GenBankName;
	private String GenBankClearingCode;
	private String BeneficiaryAcctNo;
	private String BeneficiaryRef;

	private String Banksortcode; // bank sort code
	private String Branchname; // Branch name
	private String CompanyId;
	// private double CompanyId;
	private double VendorId;
	private String VendorName;
	private String vendorAddress;
	private String vendorCity;
	private String vendorState;
	private String vendorPhone;
	private String vendorGSM;
	private String vendorContactPerson;
	private String vendorEmail;
	private String vendorBankID;
	private int approvalLevel;
	private int approvedStatus;
	private String uploadOperator;
	private int authorizerid;
	
	//====added payment name =====//
	private String paymentName;

	public BeneficiaryValue() {
	}

	public void setuploadOperator(String uploadOperator) {
		this.uploadOperator = uploadOperator;
	}

	public String getuploadOperator() {
		return uploadOperator;
	}

	public void setBranchname(String Branchname) {
		this.Branchname = Branchname;
	}

	public String getBranchname() {
		return Branchname;
	}

	public void setBanksortcode(String Banksortcode) {
		this.Banksortcode = Banksortcode;
	}

	public String getBanksortcode() {
		return Banksortcode;
	}

	public void setBeneficiaryName(String BeneficiaryName) {
		this.BeneficiaryName = BeneficiaryName;
	}

	public String getBeneficiaryName() {
		return BeneficiaryName;
	}

	public void setGenBankName(String GenBankName) {
		this.GenBankName = GenBankName;
	}

	public String getGenBankName() {
		return GenBankName;
	}

	public void setGenBankClearingCode(String GenBankClearingCode) {
		this.GenBankClearingCode = GenBankClearingCode;
	}

	public String getGenBankClearingCode() {
		return GenBankClearingCode;
	}

	public void setBeneficiaryAcctNo(String BeneficiaryAcctNo) {
		this.BeneficiaryAcctNo = BeneficiaryAcctNo;
	}

	public String getBeneficiaryAcctNo() {
		return BeneficiaryAcctNo;
	}

	public void setPaymentName(String paymentName) {
		this.paymentName = paymentName;
	}

	public void setBeneficiaryRef(String BeneficiaryRef) {
		this.BeneficiaryRef = BeneficiaryRef;
	}

	public String getBeneficiaryRef() {
		return BeneficiaryRef;
	}

	public void setpaymenttypeid(String paymenttypeid) {
		this.paymenttypeid = paymenttypeid;
	}

	public String getpaymenttypeid() {
		return paymenttypeid;
	}

	public void setpaymenttype(String paymenttype) {
		this.paymenttype = paymenttype;
	}

	public String getpaymenttype() {
		return paymenttype;
	}

	public String getPaymentName() {
		return paymentName;
	}

	public void setSTATUSID(String STATUSID) {
		this.STATUSID = STATUSID;
	}

	public String getSTATUSID() {
		return STATUSID;
	}

	public void setSTATUS(String STATUS) {
		this.STATUS = STATUS;
	}

	public String getSTATUS() {
		return STATUS;
	}

	/*
	 * public void setCompanyId(double CompanyId) { this.CompanyId = CompanyId;
	 * }
	 * 
	 * 
	 * public double getCompanyId() { return CompanyId; }
	 */

	public void setVendorId(double VendorId) {
		this.VendorId = VendorId;
	}

	public double getVendorId() {
		return VendorId;
	}

	public void setVendorName(String VendorName) {
		this.VendorName = VendorName;
	}

	public String getVendorName() {
		return VendorName;
	}

	public void setCompanyId(String CompanyId) {
		this.CompanyId = CompanyId;
	}

	public String getCompanyId() {
		return CompanyId;
	}

	public void setApprovalLevel(int approvalLevel) {
		this.approvalLevel = approvalLevel;
	}

	public int getApprovalLevel() {
		return approvalLevel;
	}

	public void setApprovedStatus(int approvedStatus) {
		this.approvedStatus = approvedStatus;
	}

	public int getApprovedStatus() {
		return approvedStatus;
	}

	public void setAuthorizerid(int authorizerid) {
		this.authorizerid = authorizerid;
	}

	public int getAuthorizerid() {
		return authorizerid;
	}
}
