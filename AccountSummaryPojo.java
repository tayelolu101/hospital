package AccountSummary;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
@JsonIgnoreProperties(ignoreUnknown = true)
public class AccountSummaryPojo {

	
	 public int getLeaf_id() {
		return leaf_id;
	}

	public void setLeaf_id(int leaf_id) {
		this.leaf_id = leaf_id;
	}

	public String getNoOfLeafs() {
		return NoOfLeafs;
	}

	public void setNoOfLeafs(String noOfLeafs) {
		NoOfLeafs = noOfLeafs;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getState() {
		return State;
	}

	public void setState(String state) {
		State = state;
	}

	public String getApplicationType() {
		return applicationType;
	}

	public void setApplicationType(String applicationType) {
		this.applicationType = applicationType;
	}

	public String getAcctType() {
		return acctType;
	}

	public void setAcctType(String acctType) {
		this.acctType = acctType;
	}

	public String getAcctNo() {
		return acctNo;
	}

	public void setAcctNo(String acctNo) {
		this.acctNo = acctNo;
	}

	public int getSec_acct_id() {
		return sec_acct_id;
	}

	public void setSec_acct_id(int sec_acct_id) {
		this.sec_acct_id = sec_acct_id;
	}

	public String getAcctDesc() {
		return acctDesc;
	}

	public void setAcctDesc(String acctDesc) {
		this.acctDesc = acctDesc;
	}

	public String getIso_currency() {
		return iso_currency;
	}

	public void setIso_currency(String iso_currency) {
		this.iso_currency = iso_currency;
	}

	public double getCurrentBalance() {
		return currentBalance;
	}

	public void setCurrentBalance(double currentBalance) {
		this.currentBalance = currentBalance;
	}

	public double getAcctBalance() {
		return acctBalance;
	}

	public void setAcctBalance(double acctBalance) {
		this.acctBalance = acctBalance;
	}

	public double getAcctAvailable() {
		return acctAvailable;
	}

	public void setAcctAvailable(double acctAvailable) {
		this.acctAvailable = acctAvailable;
	}

	public int getBranchNumber() {
		return branchNumber;
	}

	public void setBranchNumber(int branchNumber) {
		this.branchNumber = branchNumber;
	}

	public int getClassCode() {
		return classCode;
	}

	public void setClassCode(int classCode) {
		this.classCode = classCode;
	}

	public String getRsm_name() {
		return rsm_name;
	}

	public void setRsm_name(String rsm_name) {
		this.rsm_name = rsm_name;
	}

	public int getRsm_id() {
		return rsm_id;
	}

	public void setRsm_id(int rsm_id) {
		this.rsm_id = rsm_id;
	}

	public String getBeneficiaryName() {
		return BeneficiaryName;
	}

	public void setBeneficiaryName(String beneficiaryName) {
		BeneficiaryName = beneficiaryName;
	}

	public String getDescription() {
		return Description;
	}

	public void setDescription(String description) {
		Description = description;
	}

	public double getAmount() {
		return Amount;
	}

	public void setAmount(double amount) {
		Amount = amount;
	}

	public int getPtid() {
		return ptid;
	}

	public void setPtid(int ptid) {
		this.ptid = ptid;
	}

	public int getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(int returnCode) {
		this.returnCode = returnCode;
	}

	@JsonProperty("applicationType")
	 private String applicationType;
	
	 @JsonProperty("AcctType")
	  private String acctType;
	 
	 @JsonProperty("AcctNo")
	  private String acctNo;
	 
	 @JsonProperty("Sec_Acct_Id")
	  private int    sec_acct_id;
	 
	 @JsonProperty("AcctDesc")
	  private String acctDesc;
	 
	 @JsonProperty("Iso_Currency")
	  private String iso_currency;
	 
	 @JsonProperty("CurrentBalance")
	  private double currentBalance;
	 
	 @JsonProperty("AcctBalance")
	  private double acctBalance;
	  
	  @JsonProperty("AcctAvailable")
	  private double acctAvailable;
	  
	  @JsonProperty("BranchNumber")
	  private int    branchNumber;
	  
	  @JsonProperty("ClassCode")
	  private int    classCode;
	  
	  @JsonProperty("Rsm_Name")
	  private String rsm_name;
	  
	  @JsonProperty("Rsm_Id")
	  private int    rsm_id;
	  
	  @JsonProperty("BeneficiaryName")
	  private String BeneficiaryName;
	  
	  @JsonProperty("Description")
	  private String Description;
	  
	  @JsonProperty("Amount")
	  private double Amount;
	  
	  @JsonProperty("Ptid")
	  private int ptid ;
	  
	  @JsonProperty("ReturnCode")
	  private int returnCode;
	  
	  @JsonProperty("leaf_id")
	  private int   leaf_id;
	  
	  @JsonProperty("NoOfLeafs")
	  private String   NoOfLeafs;
	  
	  @JsonProperty("branchName")
	  private String   branchName;
	  
	  @JsonProperty("State")
	   private String   State;

	  
}
