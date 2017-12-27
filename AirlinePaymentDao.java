package com.zenithbank.banking.coporate.ibank.payment;

import com.dwise.util.CryptoManager;

import com.zenithbank.banking.ibank.account.RequestValue;
import com.zenithbank.banking.ibank.common.BaseAdapter;

import com.zenithbank.banking.ibank.transfer.LocalTransferValue;

import java.sql.*;

import java.text.SimpleDateFormat;

public class AirlinePaymentDao {

    private BaseAdapter baseAdapter;
    
    public AirlinePaymentDao() {
        baseAdapter = new BaseAdapter();
    }
    
    public String[] getAccTypeAndCurrency(String accNo) throws SQLException{
        System.out.println("This is the account number: "+accNo);
        PreparedStatement pst = null;
        Connection conn = null;
        String[] accTypeAndCurrency = new String[2];
        String sql = "select a.acct_type, (select iso_code from phoenix..ad_gb_crncy " +
                     "where crncy_id = a.crncy_id ) as currency from phoenix..dp_display " +
                     "a where acct_no = ? and status = ? ";

        try {
            conn = baseAdapter.getConnection1();
            pst = conn.prepareStatement(sql);
            pst.setString(1,accNo);
            pst.setString(2,"active");
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                accTypeAndCurrency[0] = rs.getString("acct_type");
                accTypeAndCurrency[1] = rs.getString("currency");
            }
             rs.close();
            return accTypeAndCurrency;
            
        }
        finally {
            pst.close();
            conn.close();
        }
    }
    
    public void doAirlinePayment(LocalTransferValue transferValue, 
                                String description) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "INSERT INTO ZENBASE..ZIB_AIRLINE_PAYMENT("
                    + "AIRLINE_ID,DEBIT_ACCOUNT_NO,CREDIT_ACCOUNT_NO,AMOUNT,"
                    + "PNR_NO,PASSENGER_NAME,PASSENGER_EMAIL,PASSENGER_PHONE_NO,"
                    + "PASSPORT_NO,DESCRIPTION,STATUS,VALUE_DATE) "
                    + "VALUES (?,?,?,?,?,?,?,?,?,?,?,Getdate())";
        
        
        try {
            con = baseAdapter.getConnection1();
            ps = con.prepareStatement(sql);
            ps.setInt(1,Integer.parseInt(transferValue.getcash_mc()));  
            ps.setString(2,transferValue.getacct_no());
            ps.setString(3,transferValue.gettransfer_no());
            ps.setDouble(4,transferValue.getamt());
            ps.setString(5,transferValue.gettest_ques());
            ps.setString(6,transferValue.getben_surname());
            ps.setString(7,transferValue.getemailaddress());
            ps.setString(8,transferValue.getphone());
            ps.setString(9,transferValue.getPCollection());
            ps.setString(10,description);
            ps.setString(11,"NOT SENT");
            
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("There was a problem inserting into... " +
                        "INSERT INTO ZENBASE..ZIB_AIRLINE_PAYMENT");
            System.out.println();
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
                if (ps != null) ps.close();
                if (rs != null) rs.close();
            }
            catch (Exception e) {}
        }
    }
    
    public void doSms(LocalTransferValue transferValue) {
        int maxid = 0;
        Connection con = null;
        Statement  stmt = null;
        ResultSet rs = null;
        PreparedStatement ps = null;
        String ac_type = "";
        try {
            con = baseAdapter.getConnection1();
            stmt = con.createStatement();
            
            rs = stmt.executeQuery("SELECT ISNULL (MAX(ptid)+1,1) "
                    + "FROM zenbase..zib_sms_messages");
            
            if (rs.next())  maxid = rs.getInt(1);
            
            ac_type = transferValue.getacct_no().substring(0,1);                         
            if (ac_type.trim().equalsIgnoreCase("4"))
                ac_type = "SA";
            else 
                ac_type = "CA";
        }
        catch (SQLException e) {
            System.out.println("Problem executing SELECT ISNULL "
                + "(MAX(ptid)+1,1) FROM zenbase..zib_sms_messages");
            System.out.println();
            e.printStackTrace();
        }
        finally {
            try {
                if (con != null) con.close();
                if (stmt != null) stmt.close();
                if (rs != null) rs.close();
            }
            catch (Exception e) {}
        }
        String sql = "insert into zenbase..zib_sms_messages(recipient_addr,"
                        + "sender_addr,message,status,ptid,create_dt,acct_no,"
                        + "acct_type,reason,channel) "
                        + "values(?,?,?,?,?,Getdate(),?,?,?,?)";                            
        
        try
        {
                 ps = con.prepareStatement(sql);
                 ps.setString(1,"Airline Payment");
                 ps.setString(2,transferValue.getacct_no());
                 ps.setString(3,"AlertZ");
                 ps.setString(4,"Sent");
                 ps.setInt(5,maxid);
                 ps.setString(6,transferValue.getacct_no());
                 ps.setString(7,ac_type);
                 ps.setString(8, transferValue.gettransfer_no());
                 ps.setString(9,"Ibank Transfer");                                                                              
                 ps.executeUpdate();
                 
        } catch(Exception e) {
            System.out.println("Problem running insert into "
                    + "zenbase..zib_sms_messages");
            e.printStackTrace();
        } finally{
            try {
                if(ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {}
        }       
    }
    
    public void updateZenbase(RequestValue request) {
        CryptoManager crypto = new CryptoManager();
        SimpleDateFormat sd2  = new SimpleDateFormat("EEE, MMMM d, yyyy hh:mm a");
        String custnoencode = crypto.encode(request.getCardNo());
        String loginidencode = crypto.encode(request.getUserName());
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = baseAdapter.getConnection();
            ps = con.prepareStatement("UPDATE ZENBASENET..ZIB_CUSTOMER_DATA_1 SET TRF_LAST_LOGIN_DT = GETDATE() WHERE CUSTOMER_NO = ? AND LOGIN = ?"  );
            
                    ps.setString(1,custnoencode);
                    ps.setString(2,loginidencode);
                    ps.executeUpdate();
        }
        catch (SQLException e) {
            System.out.println("Error doing this UPDATE "
            + "ZENBASENET..ZIB_CUSTOMER_DATA_1");
            e.printStackTrace();
        }
        finally{
                try {
                    if (con != null) con.close();
                    if (ps != null) ps.close();
                }
                catch (SQLException e) {}
        }                 
    }
}
