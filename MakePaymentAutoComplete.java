package com.zenithbank.banking.coporate.ibank.payment;

import com.zenithbank.banking.ibank.common.BaseAdapter;
import com.dwise.util.*;
import java.util.ArrayList;
import java.sql.*;

public class MakePaymentAutoComplete extends BaseAdapter {

    public MakePaymentAutoComplete() {
        
    }
    
    
    
    
    
    public String getBeneficiaryByPayType(String companyCode, String name,String paymentType) {
        if(name.contains("delete"))
            return null;
            
        java.sql.Connection con  = null;
        PreparedStatement command  = null;
        ResultSet rs = null;
        StringBuilder vendorBuilder = new StringBuilder();  
        try
        {
            con = getConnection();
          
            
            //String query = "select distinct vendor_name,vendor_id,payment_type from zenbasenet..zib_cib_gb_beneficiary  where company_id=?  and payment_type = ? and status = 'Active' and vendor_name like '%".concat(name).concat("%'");
            String query = "select distinct vendor_name,vendor_id,payment_type,vendor_code,vendor_acct_no,vendor_bankname from zenbasenet..zib_cib_gb_beneficiary  where company_id=?  and payment_type = ? and status = 'Active' and vendor_name like '%".concat(name).concat("%'");
            
            command = con.prepareStatement(query);
            command.setString(1,companyCode);
            command.setString(2,paymentType);
            rs = command.executeQuery();
            int i = 0;
            while(rs.next())
            {
                if(i > 0) 
                {
                    vendorBuilder.append("\n");
                }
                //vendorBuilder.append(rs.getString("vendor_name")).append("|").append(rs.getString("vendor_id")).append("|").append(rs.getString("payment_type"));
                vendorBuilder.append(rs.getString("vendor_name")).append("|").append(rs.getString("vendor_id")).append("|").append(rs.getString("payment_type")).append("|").append(rs.getString("vendor_code")).append("|").append(rs.getString("vendor_acct_no")).append("|").append(rs.getString("vendor_bankname"));
                ++i;
            }
            rs.close();
            
        }
        catch(Exception ex)
        {
        }
        finally
        {

            try{if(rs != null)rs.close();}catch(Exception ex){}
            try{if(command != null)command.close();}catch(Exception ex){}
            try{ if(con != null)con.close();}catch(Exception ex){}
        }
        return vendorBuilder.toString();

    }
    
    
     
    
    
    public String getBeneficiary(String companyCode, String name) {
        if(name.contains("delete"))
            return null;
            
        java.sql.Connection con  = null;
        PreparedStatement command  = null;
        ResultSet rs = null;
        StringBuilder vendorBuilder = new StringBuilder();  
        try
        {
            con = getConnection();
          
            
            //String query = "select distinct vendor_name,vendor_id,payment_type from zenbasenet..zib_cib_gb_beneficiary  where company_id=? and status = 'Active' and vendor_name like '%".concat(name).concat("%'");//08072014
             String query = "select distinct vendor_name,vendor_id,payment_type,vendor_code,vendor_acct_no,vendor_bankname from zenbasenet..zib_cib_gb_beneficiary  where company_id=? and status = 'Active' and vendor_name like '%".concat(name).concat("%'");
     
            command = con.prepareStatement(query);
            command.setString(1,companyCode);
            rs = command.executeQuery();
            int i = 0;
            while(rs.next())
            {
                if(i > 0) 
                {
                    vendorBuilder.append("\n");
                }
              //vendorBuilder.append(rs.getString("vendor_name")).append("|").append(rs.getString("vendor_id")).append("|").append(rs.getString("payment_type"));
                vendorBuilder.append(rs.getString("vendor_name")).append("|").append(rs.getString("vendor_id")).append("|").append(rs.getString("payment_type")).append("|").append(rs.getString("vendor_code")).append("|").append(rs.getString("vendor_acct_no")).append("|").append(rs.getString("vendor_bankname"));
                ++i;
            }
            rs.close();
            
        }
        catch(Exception ex)
        {
        }
        finally
        {

            try{if(rs != null)rs.close();}catch(Exception ex){}
            try{if(command != null)command.close();}catch(Exception ex){}
            try{ if(con != null)con.close();}catch(Exception ex){}
        }
        return vendorBuilder.toString();

    }
    
   
    public String getZenithBank(String name) {
        if(name.contains("delete"))
            return null;
            
        java.sql.Connection con  = null;
        PreparedStatement command  = null;
        ResultSet rs = null;
        StringBuilder vendorBuilder = new StringBuilder();  
        try
        {
           con = getConnection();
            
           //String query = "select distinct bankname,bank_cbn_alphacode from zenbasenet..zib_tb_banks where bankname like '%".concat(name).concat("%'");
            String query = "select distinct bank_name,bank_code from zenbasenet..zib_nibssgiro_banks where bank = 'Y' and bank_code = '057' and bank_name like '%".concat(name).concat("%'");
    
           command = con.prepareStatement(query);
           rs = command.executeQuery();
                 
           int i = 0;
           while(rs.next())
           {
              if(i > 0) 
              {
                  vendorBuilder.append("\n");
              }
             // vendorBuilder.append(rs.getString("bankname")).append("|").append(rs.getString("bank_cbn_alphacode"));
              vendorBuilder.append(rs.getString("bank_name")).append("|").append(rs.getString("bank_code"));
              ++i;
           }
           rs.close();
            
        }
        catch(Exception ex)
        {
        }
        finally
        {
            try{if(rs != null)rs.close();}catch(Exception ex){}
            try{if(command != null)command.close();}catch(Exception ex){}
            try{ if(con != null)con.close();}catch(Exception ex){}
        }
        return vendorBuilder.toString();
    }
   
   
   
    public String getBanks(String name) {
        if(name.contains("delete"))
            return null;
            
        java.sql.Connection con  = null;
        PreparedStatement command  = null;
        ResultSet rs = null;
        StringBuilder vendorBuilder = new StringBuilder();  
        try
        {
           con = getConnection();
            
           //String query = "select distinct bankname,bank_cbn_alphacode from zenbasenet..zib_tb_banks where bankname like '%".concat(name).concat("%'");
            String query = "select distinct bank_name,bank_code from zenbasenet..zib_nibssgiro_banks where bank = 'Y' and bank_name like '%".concat(name).concat("%'");
           //System.out.println("query getbanks - " + query);
           command = con.prepareStatement(query);
           rs = command.executeQuery();
                 
           int i = 0;
           while(rs.next())
           {
              if(i > 0) 
              {
                  vendorBuilder.append("\n");
              }
             // vendorBuilder.append(rs.getString("bankname")).append("|").append(rs.getString("bank_cbn_alphacode"));
              vendorBuilder.append(rs.getString("bank_name")).append("|").append(rs.getString("bank_code"));
              ++i;
           }
           rs.close();
            
        }
        catch(Exception ex)
        {
        }
        finally
        {
            try{if(rs != null)rs.close();}catch(Exception ex){}
            try{if(command != null)command.close();}catch(Exception ex){}
            try{ if(con != null)con.close();}catch(Exception ex){}
        }
        return vendorBuilder.toString();
    }
    
    
    
    public String getBankBranches(String name, String bankId) {
        if(name.contains("delete"))
            return null;
            
        java.sql.Connection con  = null;
        PreparedStatement command  = null;
        ResultSet rs = null;
        StringBuilder vendorBuilder = new StringBuilder();  
        try
        {
           con = getConnection();
            
           String query = "select distinct branch_name,branch_sortcode from zib_nibssgiro_branches where bank_code=? and branch_sortcode is not null and branch_name like '%".concat(name).concat("%'");
    
           command = con.prepareStatement(query);
           command.setString(1,bankId);
           rs = command.executeQuery();
                 
           int i = 0;
           while(rs.next())
           {
              if(i > 0) 
              {
                  vendorBuilder.append("\n");
              }
              vendorBuilder.append(rs.getString("branch_name")).append("|").append(rs.getString("branch_sortcode"));
              ++i;
           }
           rs.close();
            
        }
        catch(Exception ex)
        {
        }
        finally
        {
            try{if(rs != null)rs.close();}catch(Exception ex){}
            try{if(command != null)command.close();}catch(Exception ex){}
            try{ if(con != null)con.close();}catch(Exception ex){}
        }
        return vendorBuilder.toString();
    }
}
