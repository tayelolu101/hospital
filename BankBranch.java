package com.zenithbank.banking.coporate.ibank.payment;


/**
 * @author Ubah John
 * This class provide implementation for all bank branches and the sort code
 * @version 1.0
 */
public class BankBranch 
{
  private String _bankcode;
  private String _branchsortcode;
  private String _branchname;
  public BankBranch()
  {
  }
  public BankBranch(String bankCode,String branchSortCode,String branchName)
  {
    this._bankcode = bankCode;
    this._branchsortcode = branchSortCode;
    this._branchname = branchName;
  }
  /**
   * set the branch bankcode for which this branch belong to
 */
  public void setBankCode(String bankcode)
  {
    this._bankcode = bankcode;
  }
   /**
   * get the branch bankcode for which this branch belong to
 */
  public String getBankCode()
  {
    return  _bankcode;
  }
   /**
   * set the branch sort code
 */
  public void setBrachSortCode(String branchsortcode)
  {
    _branchsortcode = branchsortcode;
  }
    /**
   * get the branch sort code
 */
  public String getBranchSortCode()
  {
    return _branchsortcode;
  }
  public void setBranchName(String branchname)
  {
    _branchname = branchname;
  }
    /**
   * set the branch name code
 */
  public String getBranchName()
  {
    return _branchname;
  }
}