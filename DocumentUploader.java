package com.zenithbank.banking.coporate.ibank.payment;
import java.util.*;
public class DocumentUploader 
{
private String fullname;
private String loginid;
private int authlevel;
private Date paymentUploadDate;
private Date documentUploadDate;
private String documentTitle ;
private String documentName ;
private int documentId;

  public DocumentUploader()
  {
  }


  public void setFullname(String fullname)
  {
    this.fullname = fullname;
  }


  public String getFullname()
  {
    if(fullname == null)
      return "";
    return fullname;
  }


  public void setLoginid(String loginid)
  {
    this.loginid = loginid;
  }


  public String getLoginid()
  {
    return loginid;
  }


  public void setPaymentUploadDate(Date paymentUploadDate)
  {
    this.paymentUploadDate = paymentUploadDate;
  }


  public Date getPaymentUploadDate()
  {
    return paymentUploadDate;
  }


  public void setAuthlevel(int authlevel)
  {
    this.authlevel = authlevel;
  }


  public int getAuthlevel()
  {
    return authlevel;
  }

    public void setDocumentUploadDate(Date documentUploadDate) {
        this.documentUploadDate = documentUploadDate;
    }

    public Date getDocumentUploadDate() {
        return documentUploadDate;
    }

    public void setDocumentTitle(String documentTitle) {
        this.documentTitle = documentTitle;
    }

    public String getDocumentTitle() {
        return documentTitle;
    }

    public void setDocumentId(int documentId) {
        this.documentId = documentId;
    }

    public int getDocumentId() {
        return documentId;
    }

    public void setDocumentName(String documentName) {
        this.documentName = documentName;
    }

    public String getDocumentName() {
        return documentName;
    }
}
