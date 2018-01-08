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
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;




/**
 * REST Web Service
 *
 * @author appdev2
 */


@Path("MerchantNotification")
@XmlRootElement(name = "Payment")
public class PaymentNotification{
    
    private Connection connection = null;   
       
    private String ResponseCode;
    
    private List<Result> results; 
    
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
    @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})//({"application/xml", "application/json"})
    public PaymentNotification getNotificationByDate(@QueryParam("merchantId") String MerchantID,
            @QueryParam("start") String Startdate,
            @QueryParam("end") String EndDate) {
        
        List<Result> res = new ArrayList<>();
          
        PaymentNotification  pay = new PaymentNotification();

        try {

            DateFormat nowFormat = new SimpleDateFormat("yyMMdd");
            java.util.Date dateTime;
            dateTime = nowFormat.parse(Startdate);
            java.sql.Date start = new java.sql.Date(dateTime.getTime());

            dateTime = nowFormat.parse(EndDate);
            java.sql.Date end = new java.sql.Date(dateTime.getTime());

            System.out.println(start);
            System.out.println(end);

            long Starter = start.getTime();//Converting start date to milliseconds
            long ended = end.getTime();//Converting start date to milliseconds
            
            System.out.println("Starter : " + Starter);
            System.out.println("Starter : " + ended);
            
            //Getting the date range for 3 days
            long secondsInMilli = 1000;
            long minutesInMilli = secondsInMilli * 60;
            long hoursInMilli = minutesInMilli * 60;
            long daysInMilli = hoursInMilli * 24;
            long ThreedaysInMilli = daysInMilli * 3;
            System.out.println("ThreedaysInMilli : " + ThreedaysInMilli);
            
            long range = ThreedaysInMilli;// Date range for 3 days in milliseconds
            
            if((ended - Starter) > range){ // Condition to check that the period requested is not more than 3 days
                
                System.err.println("Requested period more than 3 days"); 
                
                pay.setResponseCode("03");
               // ntm.setResult("Date range is invalid, kindly specify a date range not more than 3 days.");

                //response.add(pay);

                return pay;
            }

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
            
             Logger.getLogger("Sqls: " + Sqls);

            //querying the table in the database
            CallableStatement prep = connection.prepareCall(Sqls);

            ResultSet rs = prep.executeQuery();

            if(rs.next()){
                
                pay.setResponseCode("00");
               // System.out.println("i am here");
               
                   
            }
             
            while (rs.next()) {               
                  
               
               Result result = new Result();
           
                //setting the return values as the object properties
                result.setAmount(rs.getDouble("Amount"));
                result.setPayerPhoneNumber(rs.getString("PayerPhoneNumber"));
                result.setPayerName(rs.getString("PayerName"));
                result.setReferenceCode(rs.getString("ReferenceCode"));
                result.setTransactionDate(rs.getString("TransactionDate")); 
                res.add(result);
             

                System.out.println(result.getAmount());
                System.out.println(result.getPayerName());
                System.out.println(result.getReferenceCode());
                System.out.println(result.getPayerPhoneNumber());
                System.out.println(result.getTransactionDate());
                System.out.println();
              
                  pay.setResults(res);
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
        if (res.isEmpty()) {
            
            pay.setResponseCode("02");
           // ntm.setResult("NO RECORD FOUND FOR MERCHANT WITH CODE : " + MerchantID + ", BETWEEN " + Startdate + " AND " + EndDate + " !");
                             
           

            return pay;
        }
        //returning the collection of object if it is not empty
        
       
        return pay;
    }

    @GET
    @Path("{MerchantID}")
    @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})//({"application/xml", "application/json"})
    public PaymentNotification getCurrentNotification(@PathParam("MerchantID") String MerchantID) {

        PaymentNotification pay = new PaymentNotification();
             
        List<Result> responses = new ArrayList<>();

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
                    + " from zib_mcash_merchant_notification a, zib_mcash_merchant_pull_maxid b "
                    + "where a.MerchantCode = " + MerchantID + ""
                    + " and b.merchant_code = a.MerchantCode"
                    + " and a.Id > b.max_id";

            System.out.println(Sqls);
            
             Logger.getLogger("Sqls: " + Sqls);

            //querying the table in the database
            CallableStatement prep = connection.prepareCall(Sqls);

            ResultSet rs = prep.executeQuery();
            
            if (rs.next()){
                
                pay.setResponseCode("00");
                
            }
           
            while (rs.next()) {

                Result result = new Result();
              
                //setting the return values as the object properties
                result.setAmount(rs.getDouble("Amount"));
                result.setPayerPhoneNumber(rs.getString("PayerPhoneNumber"));
                result.setPayerName(rs.getString("PayerName"));
                result.setReferenceCode(rs.getString("ReferenceCode"));
                result.setTransactionDate(rs.getString("TransactionDate"));
                responses.add(result);
            
                
                System.out.println(result.getAmount());
                System.out.println(result.getPayerName());
                System.out.println(result.getReferenceCode());
                System.out.println(result.getPayerPhoneNumber());
                System.out.println(result.getTransactionDate());
                System.out.println();

                             
                pay.setResults(responses);
                list.add(rs.getInt("Id"));

            }
            
            //returning empty object
            if (responses.isEmpty()) {
                
                pay.setResponseCode("01");
                //ntms.setResult("NO NEW RECORD FOUND FOR MERCHANT WITH CODE : " + MerchantID + " !");            


                return pay;

            }

            //Looping through the ID value to set max_Id so when next the table is queried it starts from a higher position 
            max = list.get(0);

            for (int i : list) {

                if (i > max) {

                    max = i;
                }
            }

            //Updating the max_Id column
            String Sqll = "UPDATE zib_mcash_merchant_pull_maxid SET max_id = " + max + " WHERE merchant_code = " + MerchantID;
            System.out.println(Sqll);
            
            Logger.getLogger("Sqll: " + Sqll);

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
        //returning the collection of object if it is not empty
        return pay;
    }


    public List<Result> getResults() {
        return results;
    }
    @XmlElementWrapper
    @XmlElement(name="result")
    public void setResults(List<Result> results) {
        this.results = results;
    }

    public String getResponseCode() {
        return ResponseCode;
    }

    public void setResponseCode(String ResponseCode) {
        this.ResponseCode = ResponseCode;
    }

}
