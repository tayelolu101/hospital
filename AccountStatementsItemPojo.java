package AccountSummary;

import java.util.Date;

public class AccountStatementsItemPojo {

    private Date effectiveDate;
    private Date createDate;
    private String drCr;
    private String itemType;
    private String Description;
    private String reg_E_Desc;
    private int tranOrigin;
    private double tranAmount;
    private int tranCode;
    private String transfer_acct_type;
    private String transfer_acct_no;
    private int checkNumber;
    private long ptid;
    private String postingCode;
    private String reversal;
    private String historyDesc;
    private String tranCodeDesc;
    private String originTracerNo;
    private String iso_currency;
    private int totalDebit;
    private int totalCredit;
    private double ntotalDebit;
    private double ntotalCredit;
    private double sumtotalDebit;
    private double sumtotalCredit;
    private String branch;


    public AccountStatementsItemPojo()
    {
    }

    public int gettotalDebit(){return totalDebit; }
    public int gettotalCredit(){return totalCredit; }
    public double getntotalDebit(){return ntotalDebit; }
    public double getntotalCredit(){return ntotalCredit; }
    public double getsumtotalDebit(){return sumtotalDebit; }
    public double getsumtotalCredit(){return sumtotalCredit; }
    public Date getEffectiveDate(){return effectiveDate; }
    public Date getCreateDate(){return createDate; }
    public String getDescription(){return Description; }
    public String getReg_E_Desc(){return reg_E_Desc; }
    public int getTranOrigin(){return tranOrigin; }
    public double getTranAmount(){return tranAmount; }
    public int getTranCode(){return tranCode; }
    public String getTransfer_acct_type(){return transfer_acct_type; }
    public String getTransfer_acct_no(){return transfer_acct_no; }
    public int getCheckNumber(){return checkNumber;}
    public long getPtid(){return ptid;}
    public String getIso_currency() {return iso_currency;}
    public String getbranch() {return branch;}




    public void setEffectiveDate(Date effectiveDate){ this.effectiveDate = effectiveDate; }
    public void setCreateDate(Date createDate){ this.createDate = createDate; }
    public void setDescription(String Description){ this.Description = Description; }
    public void setReg_E_Desc(String reg_E_Desc){ this.reg_E_Desc = reg_E_Desc; }
    public void setTranOrigin(int tranOrigin){ this.tranOrigin = tranOrigin; }
    public void setTranAmount(double tranAmount){ this.tranAmount = tranAmount; }
    public void setTranCode(int tranCode){ this.tranCode = tranCode; }
    public void setTransfer_acct_type(String transfer_acct_type){ this.transfer_acct_type = transfer_acct_type; }
    public void setTransfer_acct_no(String transfer_acct_no){ this.transfer_acct_no = transfer_acct_no; }
    public void setCheckNumber(int checkNumber){ this.checkNumber = checkNumber; }
    public void setPtid(long ptid){ this.ptid = ptid; }
    public void setIso_currency(String iso_currency){ this.iso_currency = iso_currency; }
    public void setntotalDebit(double ntotalDebit){ this.ntotalDebit = ntotalDebit; }
    public void setntotalCredit(double ntotalCredit){ this.ntotalCredit = ntotalCredit; }
    public void setsumtotalCredit(double sumtotalCredit){ this.sumtotalCredit = sumtotalCredit; }
    public void setsumtotalDebit(double sumtotalDebit){ this.sumtotalDebit = sumtotalDebit; }
    public void settotalCredit(int totalCredit){ this.totalCredit = totalCredit; }
    public void settotalDebit(int totalDebit){ this.totalDebit = totalDebit; }
    public String getDrCr() {
        return drCr;
    }
    public void setDrCr(String drCr) {
        this.drCr = drCr;
    }
    public String getHistoryDesc() {
        return historyDesc;
    }
    public void setHistoryDesc(String historyDesc) {
        this.historyDesc = historyDesc;
    }
    public String getItemType() {
        return itemType;
    }
    public void setItemType(String itemType) {
        this.itemType = itemType;
    }
    public String getOriginTracerNo() {
        return originTracerNo;
    }
    public void setOriginTracerNo(String originTracerNo) {
        this.originTracerNo = originTracerNo;
    }
    public String getPostingCode() {
        return postingCode;
    }
    public void setPostingCode(String postingCode) {
        this.postingCode = postingCode;
    }
    public String getReversal() {
        return reversal;
    }
    public void setReversal(String reversal) {
        this.reversal = reversal;
    }
    public String getTranCodeDesc() {
        return tranCodeDesc;
    }
    public void setTranCodeDesc(String tranCodeDesc) {
        this.tranCodeDesc = tranCodeDesc;
    }

    public void setbranch(String branch){ this.branch = branch; }

}
