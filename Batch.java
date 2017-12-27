package com.zenithbank.banking.coporate.ibank.payment;
import java.util.*;

public class Batch 
{
    private double batchid;
    private String  original_filename;
    private String server_filename;
    private int zenith_client_id;
    private Date upload_date;
    private Date upload_date_timestamp;
    private String upload_operator;
    private Date approval_date;
    private int approval_operator;
    private String batch_status;
    private String bulk_file_upload;
    
  //23022014 - batch payment upload
    private int process_count ;
    private int failed_count  ;
    private int total_count  ;
    private String status ;
    private String msg ;
    //12092014
    private String uploader_fullname;
    
 
  public Batch()
  {
  }


  public void setBatchid(double batchid)
  {
    this.batchid = batchid;
  }


  public double getBatchid()
  {
    return batchid;
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


  public void setZenith_client_id(int zenith_client_id)
  {
    this.zenith_client_id = zenith_client_id;
  }


  public int getZenith_client_id()
  {
    return zenith_client_id;
  }


  public void setUpload_date(Date upload_date)
  {
    this.upload_date = upload_date;
  }


  public Date getUpload_date()
  {
    return upload_date;
  }


  public void setUpload_operator(String upload_operator)
  {
    this.upload_operator = upload_operator;
  }


  public String getUpload_operator()
  {
    return upload_operator;
  }


  public void setApproval_date(Date approval_date)
  {
    this.approval_date = approval_date;
  }


  public Date getApproval_date()
  {
    return approval_date;
  }


  public void setApproval_operator(int approval_operator)
  {
    this.approval_operator = approval_operator;
  }


  public int getApproval_operator()
  {
    return approval_operator;
  }


  public void setBatch_status(String batch_status)
  {
    this.batch_status = batch_status;
  }


  public String getBatch_status()
  {
    return batch_status;
  }


  public void setBulk_file_upload(String bulk_file_upload)
  {
    this.bulk_file_upload = bulk_file_upload;
  }


  public String getBulk_file_upload()
  {
    return bulk_file_upload;
  }

    public void setUpload_date_timestamp(Date upload_date_timestamp) {
        this.upload_date_timestamp = upload_date_timestamp;
    }

    public Date getUpload_date_timestamp() {
        return upload_date_timestamp;
    }

    public void setProcess_count(int process_count) {
        this.process_count = process_count;
    }

    public int getProcess_count() {
        return process_count;
    }

    public void setFailed_count(int failed_count) {
        this.failed_count = failed_count;
    }

    public int getFailed_count() {
        return failed_count;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setTotal_count(int total_count) {
        this.total_count = total_count;
    }

    public int getTotal_count() {
        return total_count;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setUploader_fullname(String uploader_fullname) {
        this.uploader_fullname = uploader_fullname;
    }

    public String getUploader_fullname() {
        return uploader_fullname;
    }
}
