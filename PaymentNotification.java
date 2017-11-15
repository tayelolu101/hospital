/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Notify;

import java.io.IOException;
import java.io.InputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.Path;
import javax.ws.rs.GET;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * REST Web Service
 *
 * @author appdev2
 */
@Path("MerchantNotification")
@XmlRootElement
public class PaymentNotification {

    @Context
    private UriInfo context;

    private Connection connection = null;

    private String PayerName;
    private String PayerPhoneNumber;
    private String ReferenceCode;
    private Double Amount;
    private String TransactionDate;
    private String Result;

    /**
     * Creates a new instance of paymentNotification
     */
    public PaymentNotification() {
    }

    /**
     * Retrieves representation of an instance of
     * PaymentNotification.getNotification
     *
     * @param MerchantID
     * @param Startdate
     * @param EndDate
     * @return an instance of java.util.List
     */
    @GET
    @Produces({"application/xml", "application/json"})
    public List<PaymentNotification> getNotificationByDate(@QueryParam("merchantId") String MerchantID,
            @QueryParam("start") String Startdate,
            @QueryParam("end") String EndDate) {

        PaymentNotification ntm = new PaymentNotification();

        List<PaymentNotification> response = new ArrayList<>();

        try {

            DateFormat nowFormat = new SimpleDateFormat("yyMMddHHmmss");
            java.util.Date dateTime;
            dateTime = nowFormat.parse(Startdate);
            java.sql.Date start = new java.sql.Date(dateTime.getTime());

            dateTime = nowFormat.parse(EndDate);
            java.sql.Date end = new java.sql.Date(dateTime.getTime());

            System.out.println(start);
            System.out.println(end);

            //Accessing the property files for required parameters
            Properties prop = new Properties();
            InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("Notify/ClientProp.properties");
            prop.load(inputStream);

            String urls = prop.getProperty("surl");
            System.out.println(urls);
            String server = prop.getProperty("serv_names");
            System.out.println(server);

            //registering to the server & connecting to the database
            Class.forName(server);
            connection = DriverManager.getConnection(urls);

            String Sqls = "select * from zib_mcash_merchant_notification where"
                    + " MerchantCode = " + MerchantID + " "
                    + "and TransactionDate between '" + start + " 00:00:00.000' and '" + end + " 23:59:59.000'";
            System.out.println(Sqls);

            //querying the table in the database
            CallableStatement prep = connection.prepareCall(Sqls);

            ResultSet rs = prep.executeQuery();

            while (rs.next()) {

                //setting the return values as the object properties
                ntm.setAmount(rs.getDouble("Amount"));
                ntm.setPayerPhoneNumber(rs.getString("PayerPhoneNumber"));
                ntm.setPayerName(rs.getString("PayerName"));
                ntm.setReferenceCode(rs.getString("ReferenceCode"));
                ntm.setTransactionDate(rs.getString("TransactionDate"));

                System.out.println(ntm.getAmount());
                System.out.println(ntm.getPayerName());
                System.out.println(ntm.getReferenceCode());
                System.out.println(ntm.getPayerPhoneNumber());
                System.out.println(ntm.getTransactionDate());
                System.out.println();
                //Adding each object to the arraylist collection
                response.add(ntm);

            }

        } catch (IOException | ClassNotFoundException | SQLException | ParseException ex) {

            Logger.getLogger(PaymentNotification.class.getName()).log(Level.SEVERE, null, ex);

        } finally {
            //closing the connection
            if (connection != null) {

                try {

                    connection.close();

                } catch (SQLException ex) {

                    Logger.getLogger(PaymentNotification.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        //returning empty object
        if (response.isEmpty()) {

            ntm.setResult("NO RECORD FOUND FOR MERCHANT WITH CODE : " + MerchantID + ", BETWEEN :" + Startdate + " AND :" + EndDate + " !");

            System.out.println(ntm.getResult());

            response.add(ntm);

            return response;
        }
        //returning the collection of object
        return response;
    }

    @GET
    @Path("{MerchantID}")
    @Produces({"application/xml", "application/json"})
    public List<PaymentNotification> getCurrentNotification(@PathParam("MerchantID") String MerchantID) {

        PaymentNotification ntms = new PaymentNotification();

        List<PaymentNotification> responses = new ArrayList<>();

        ArrayList<Integer> list = new ArrayList<>();

        int max;

        try {

            //Accessing the property files for required parameters
            Properties prop = new Properties();
            InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("Notify/ClientProp.properties");
            prop.load(inputStream);

            String urls = prop.getProperty("surl");
            System.out.println(urls);
            String server = prop.getProperty("serv_names");
            System.out.println(server);

            //registering to the server & connecting to the database
            Class.forName(server);
            connection = DriverManager.getConnection(urls);

            String Sqls = "select a.Id, a.PayerPhoneNumber, a.PayerName, a.ReferenceCode, a.Amount, a.TransactionDate, b.max_id"
                    + " from zib_mcash_merchant_notification a, mcash_merchant_pull_maxid b "
                    + "where a.MerchantCode = " + MerchantID + ""
                    + " and b.merchant_code = a.MerchantCode"
                    + " and a.Id > b.max_id";

            System.out.println(Sqls);

            //querying the table in the database
            CallableStatement prep = connection.prepareCall(Sqls);

            ResultSet rs = prep.executeQuery();

            while (rs.next()) {

                //setting the return values as the object properties
                ntms.setAmount(rs.getDouble("Amount"));
                ntms.setPayerPhoneNumber(rs.getString("PayerPhoneNumber"));
                ntms.setPayerName(rs.getString("PayerName"));
                ntms.setReferenceCode(rs.getString("ReferenceCode"));
                ntms.setTransactionDate(rs.getString("TransactionDate"));

                System.out.println(ntms.getAmount());
                System.out.println(ntms.getPayerName());
                System.out.println(ntms.getReferenceCode());
                System.out.println(ntms.getPayerPhoneNumber());
                System.out.println(ntms.getTransactionDate());
                System.out.println();

                //Adding each object to the arraylist collection
                responses.add(ntms);

                list.add(rs.getInt("Id"));

            }

            //returning empty object
            if (responses.isEmpty()) {

                ntms.setResult("NO NEW RECORD FOUND FOR MERCHANT WITH CODE : " + MerchantID + " !");

                System.out.println(ntms.getResult());

                responses.add(ntms);

                return responses;

            }

            //Looping through the ID value to set max_Id so when next the table is queried later it starts from a higher position 
            max = list.get(0);

            for (int i : list) {

                if (i > max) {

                    max = i;
                }
            }

            //Updating the max_Id column
            String Sqll = "UPDATE mcash_merchant_pull_maxid SET max_id = " + max + " WHERE merchant_code = " + MerchantID;
            System.out.println(Sqll);

            CallableStatement preps = connection.prepareCall(Sqll);
            preps.executeUpdate();

        } catch (IOException | ClassNotFoundException | SQLException ex) {

            Logger.getLogger(PaymentNotification.class.getName()).log(Level.SEVERE, null, ex);

        } finally {
            //closing the connection
            if (connection != null) {

                try {

                    connection.close();

                } catch (SQLException ex) {

                    Logger.getLogger(PaymentNotification.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        //returning the collection of object
        return responses;
    }

    public String getPayerName() {
        return PayerName;
    }

    public void setPayerName(String PayerName) {
        this.PayerName = PayerName;
    }

    public String getPayerPhoneNumber() {
        return PayerPhoneNumber;
    }

    public void setPayerPhoneNumber(String PayerPhoneNumber) {
        this.PayerPhoneNumber = PayerPhoneNumber;
    }

    public String getReferenceCode() {
        return ReferenceCode;
    }

    public void setReferenceCode(String ReferenceCode) {
        this.ReferenceCode = ReferenceCode;
    }

    public Double getAmount() {
        return Amount;
    }

    public void setAmount(Double Amount) {
        this.Amount = Amount;
    }

    public String getTransactionDate() {
        return TransactionDate;
    }

    public void setTransactionDate(String TransactionDate) {
        this.TransactionDate = TransactionDate;
    }

    public String getResult() {
        return Result;
    }

    public void setResult(String Result) {
        this.Result = Result;
    }

}
