/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Notify;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author appdev2
 */
@XmlRootElement(name = "Result") 
public class Result {
  
    private String PayerName;
    private String PayerPhoneNumber;
    private String ReferenceCode;
    private Double Amount;
    private String TransactionDate;
    
   // private String AuthentificationCode;
    
    
   
    /**
     * Creates a new instance of paymentNotification
     */
    public Result() {
    }

    

    @XmlElement
    public String getPayerName() {
        return this.PayerName;
    }

    public void setPayerName(String PayerName) {
        this.PayerName = PayerName;
    }

    @XmlElement
    public String getPayerPhoneNumber() {
        return this.PayerPhoneNumber;
    }

    public void setPayerPhoneNumber(String PayerPhoneNumber) {
        this.PayerPhoneNumber = PayerPhoneNumber;
    }

    @XmlElement
    public String getReferenceCode() {
        return this.ReferenceCode;
    }

    public void setReferenceCode(String ReferenceCode) {
        this.ReferenceCode = ReferenceCode;
    }

    @XmlElement
    public Double getAmount() {
        return this.Amount;
    }

    public void setAmount(Double Amount) {
        this.Amount = Amount;
    }

    @XmlElement
    public String getTransactionDate() {
        return this.TransactionDate;
    }

    public void setTransactionDate(String TransactionDate) {
        this.TransactionDate = TransactionDate;
    }

    
   
 

    
}
