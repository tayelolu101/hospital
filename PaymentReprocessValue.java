package com.zenithbank.banking.coporate.ibank.payment;
import java.util.Date;

public class PaymentReprocessValue 
{
   
     private int reprocess_id ;
     private int batch_id ;
     private String batch_reprocess_reason ;
     private double payment_id;
     private double amount;
     private String company_code          ;
     private Date payment_due_date_old   ;
     private Date payment_due_date_new   ;
     private String payment_method_old     ;
     private String payment_method_new     ;
     private String payment_type_old       ;
     private String payment_type_new      ;
     private String routing_method_old     ;
     private String routing_method_new     ;
     private String vendor_acct_no_old    ;
     private String vendor_acct_no_new     ;
     private String vendor_bank_old       ;
     private String vendor_bank_new        ;
     private String vendor_bank_branch_old ;
     private String vendor_bank_branch_new ;
     private String routing_bank_code_old  ;
     private String routing_bank_code_new  ;
     private String sort_code_old          ;
     private String sort_code_new         ;
     private String debit_acct_no_old     ;
     private String debit_acct_no_new      ;
     private String debit_acct_name_old     ;
     private String debit_acct_name_new      ;
     private String ptystatus_old          ;
     private String ptystatus_new          ;
     private int approval_level_old     ;
     private int approval_level_new     ;
     private Date approval_date_old     ;
     private String return_reason_old     ;
     private String return_reason_new      ;
     private int icount_old           ;
     private int icount_new           ;
     private String created_by            ;
     private Date create_dt             ;
     private String authorized_by         ;
     private int authorize_level       ;
     private int initiator_action       ;
     private int authorize_action       ;
     private String initiator_action_desc       ;
     private String authorizer_action_desc       ;
     private Date authorized_dt   ;
     private int status   ;
     
     private String vendor_name;

  
  public PaymentReprocessValue()
  {
  }


  public void setBatch_reprocess_reason(String batch_reprocess_reason)
  {
    this.batch_reprocess_reason = batch_reprocess_reason;
  }


  public String getBatch_reprocess_reason()
  {
    return batch_reprocess_reason;
  }



  public void setCompany_code(String company_code)
  {
    this.company_code = company_code;
  }


  public String getCompany_code()
  {
    return company_code;
  }


  public void setPayment_due_date_old(Date payment_due_date_old)
  {
    this.payment_due_date_old = payment_due_date_old;
  }


  public Date getPayment_due_date_old()
  {
    return payment_due_date_old;
  }


  public void setPayment_due_date_new(Date payment_due_date_new)
  {
    this.payment_due_date_new = payment_due_date_new;
  }


  public Date getPayment_due_date_new()
  {
    return payment_due_date_new;
  }


  public void setPayment_method_old(String payment_method_old)
  {
    this.payment_method_old = payment_method_old;
  }


  public String getPayment_method_old()
  {
    return payment_method_old;
  }


  public void setPayment_method_new(String payment_method_new)
  {
    this.payment_method_new = payment_method_new;
  }


  public String getPayment_method_new()
  {
    return payment_method_new;
  }


  public void setPayment_type_old(String payment_type_old)
  {
    this.payment_type_old = payment_type_old;
  }


  public String getPayment_type_old()
  {
    return payment_type_old;
  }


  public void setPayment_type_new(String payment_type_new)
  {
    this.payment_type_new = payment_type_new;
  }


  public String getPayment_type_new()
  {
    return payment_type_new;
  }


  public void setRouting_method_old(String routing_method_old)
  {
    this.routing_method_old = routing_method_old;
  }


  public String getRouting_method_old()
  {
    return routing_method_old;
  }


  public void setRouting_method_new(String routing_method_new)
  {
    this.routing_method_new = routing_method_new;
  }


  public String getRouting_method_new()
  {
    return routing_method_new;
  }


  public void setVendor_acct_no_old(String vendor_acct_no_old)
  {
    this.vendor_acct_no_old = vendor_acct_no_old;
  }


  public String getVendor_acct_no_old()
  {
    return vendor_acct_no_old;
  }


  public void setVendor_acct_no_new(String vendor_acct_no_new)
  {
    this.vendor_acct_no_new = vendor_acct_no_new;
  }


  public String getVendor_acct_no_new()
  {
    return vendor_acct_no_new;
  }


  public void setVendor_bank_old(String vendor_bank_old)
  {
    this.vendor_bank_old = vendor_bank_old;
  }


  public String getVendor_bank_old()
  {
    return vendor_bank_old;
  }


  public void setVendor_bank_new(String vendor_bank_new)
  {
    this.vendor_bank_new = vendor_bank_new;
  }


  public String getVendor_bank_new()
  {
    return vendor_bank_new;
  }


  public void setVendor_bank_branch_old(String vendor_bank_branch_old)
  {
    this.vendor_bank_branch_old = vendor_bank_branch_old;
  }


  public String getVendor_bank_branch_old()
  {
    return vendor_bank_branch_old;
  }


  public void setVendor_bank_branch_new(String vendor_bank_branch_new)
  {
    this.vendor_bank_branch_new = vendor_bank_branch_new;
  }


  public String getVendor_bank_branch_new()
  {
    return vendor_bank_branch_new;
  }


  public void setRouting_bank_code_old(String routing_bank_code_old)
  {
    this.routing_bank_code_old = routing_bank_code_old;
  }


  public String getRouting_bank_code_old()
  {
    return routing_bank_code_old;
  }


  public void setRouting_bank_code_new(String routing_bank_code_new)
  {
    this.routing_bank_code_new = routing_bank_code_new;
  }


  public String getRouting_bank_code_new()
  {
    return routing_bank_code_new;
  }


  public void setSort_code_old(String sort_code_old)
  {
    this.sort_code_old = sort_code_old;
  }


  public String getSort_code_old()
  {
    return sort_code_old;
  }


  public void setSort_code_new(String sort_code_new)
  {
    this.sort_code_new = sort_code_new;
  }


  public String getSort_code_new()
  {
    return sort_code_new;
  }


  public void setDebit_acct_no_old(String debit_acct_no_old)
  {
    this.debit_acct_no_old = debit_acct_no_old;
  }


  public String getDebit_acct_no_old()
  {
    return debit_acct_no_old;
  }


  public void setDebit_acct_no_new(String debit_acct_no_new)
  {
    this.debit_acct_no_new = debit_acct_no_new;
  }


  public String getDebit_acct_no_new()
  {
    return debit_acct_no_new;
  }


  public void setPtystatus_old(String ptystatus_old)
  {
    this.ptystatus_old = ptystatus_old;
  }


  public String getPtystatus_old()
  {
    return ptystatus_old;
  }


  public void setPtystatus_new(String ptystatus_new)
  {
    this.ptystatus_new = ptystatus_new;
  }


  public String getPtystatus_new()
  {
    return ptystatus_new;
  }


  public void setApproval_level_old(int approval_level_old)
  {
    this.approval_level_old = approval_level_old;
  }


  public int getApproval_level_old()
  {
    return approval_level_old;
  }


  public void setApproval_level_new(int approval_level_new)
  {
    this.approval_level_new = approval_level_new;
  }


  public int getApproval_level_new()
  {
    return approval_level_new;
  }


  public void setApproval_date_old(Date approval_date_old)
  {
    this.approval_date_old = approval_date_old;
  }


  public Date getApproval_date_old()
  {
    return approval_date_old;
  }


  public void setReturn_reason_old(String return_reason_old)
  {
    this.return_reason_old = return_reason_old;
  }


  public String getReturn_reason_old()
  {
    return return_reason_old;
  }


  public void setReturn_reason_new(String return_reason_new)
  {
    this.return_reason_new = return_reason_new;
  }


  public String getReturn_reason_new()
  {
    return return_reason_new;
  }


  public void setIcount_old(int icount_old)
  {
    this.icount_old = icount_old;
  }


  public int getIcount_old()
  {
    return icount_old;
  }


  public void setIcount_new(int icount_new)
  {
    this.icount_new = icount_new;
  }


  public int getIcount_new()
  {
    return icount_new;
  }


  public void setCreated_by(String created_by)
  {
    this.created_by = created_by;
  }


  public String getCreated_by()
  {
    return created_by;
  }


  public void setCreate_dt(Date create_dt)
  {
    this.create_dt = create_dt;
  }


  public Date getCreate_dt()
  {
    return create_dt;
  }


  public void setAuthorized_by(String authorized_by)
  {
    this.authorized_by = authorized_by;
  }


  public String getAuthorized_by()
  {
    return authorized_by;
  }


  public void setAuthorize_level(int authorize_level)
  {
    this.authorize_level = authorize_level;
  }


  public int getAuthorize_level()
  {
    return authorize_level;
  }


  public void setAuthorized_dt(Date authorized_dt)
  {
    this.authorized_dt = authorized_dt;
  }


  public Date getAuthorized_dt()
  {
    return authorized_dt;
  }


  public void setStatus(int status)
  {
    this.status = status;
  }


  public int getStatus()
  {
    return status;
  }


  public void setPayment_id(double payment_id)
  {
    this.payment_id = payment_id;
  }


  public double getPayment_id()
  {
    return payment_id;
  }


  public void setReprocess_id(int reprocess_id)
  {
    this.reprocess_id = reprocess_id;
  }


  public int getReprocess_id()
  {
    return reprocess_id;
  }


  public void setBatch_id(int batch_id)
  {
    this.batch_id = batch_id;
  }


  public int getBatch_id()
  {
    return batch_id;
  }


  public void setVendor_name(String vendor_name)
  {
    this.vendor_name = vendor_name;
  }


  public String getVendor_name()
  {
    return vendor_name;
  }


  public void setAuthorize_action(int authorize_action)
  {
    this.authorize_action = authorize_action;
  }


  public int getAuthorize_action()
  {
    return authorize_action;
  }


  public void setAmount(double amount)
  {
    this.amount = amount;
  }


  public double getAmount()
  {
    return amount;
  }


  public void setDebit_acct_name_old(String debit_acct_name_old)
  {
    this.debit_acct_name_old = debit_acct_name_old;
  }


  public String getDebit_acct_name_old()
  {
    return debit_acct_name_old;
  }


  public void setDebit_acct_name_new(String debit_acct_name_new)
  {
    this.debit_acct_name_new = debit_acct_name_new;
  }


  public String getDebit_acct_name_new()
  {
    return debit_acct_name_new;
  }


  public void setInitiator_action(int initiator_action)
  {
    this.initiator_action = initiator_action;
  }


  public int getInitiator_action()
  {
    return initiator_action;
  }


  public void setInitiator_action_desc(String initiator_action_desc)
  {
    this.initiator_action_desc = initiator_action_desc;
  }


  public String getInitiator_action_desc()
  {
    return initiator_action_desc;
  }


  public void setAuthorizer_action_desc(String authorizer_action_desc)
  {
    this.authorizer_action_desc = authorizer_action_desc;
  }


  public String getAuthorizer_action_desc()
  {
    return authorizer_action_desc;
  }
}