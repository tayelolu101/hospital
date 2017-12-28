package com.zenithbank.merchantclient;

import java.io.IOException;
import java.io.InputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;



import org.apache.commons.httpclient.HostConfiguration;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.StatusLine;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.commons.httpclient.methods.PostMethod;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MerchantNotificationJob implements Job{
	private static final Logger logger = LoggerFactory.getLogger(MerchantNotificationJob.class);
    DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	private static LoadPropFile propFile = LoadPropFile.getInstance();
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// TODO Auto-generated method stub
		//logger.info(dateFormat.format(System.currentTimeMillis()) +" ::  Started Main!!!!");
        MerchantClient merchantClient = new MerchantClient();
        Connection connection = null;
        Properties prop = new Properties();
        String Id;
        String SessionID;
        String RequestorID;
        String PayerPhoneNumber;
        String PayerName;
        String MerchantCode;
        String MerchantName;
        String MerchantPhoneNumber;
        String ReferenceCode;
        Double Amount;
        String API_HTTP_Method;
        String API_URL;
        String API_UserId;
        String API_Password;
        String API_Key;
        InputStream inputStream = merchantClient.getClass().getClassLoader().getResourceAsStream("com/zenithbank/merchantclient/ClientProp.properties");

        try {
			prop.load(inputStream);
		} catch (IOException e) {
	
			e.printStackTrace();
			
			throw new JobExecutionException("Canot find Input stream for prop file ");
		}

        try {

            // Properties prop = merchantClient.getProp();
       

            String urls = propFile.getUrl();
            String server = propFile.getServer();
            String userName = propFile.getUserName();
            String password = propFile.getPassword();
            String host = propFile.getHost();
            String proxy = propFile.getProxy();
            //String domain = prop.getProperty("domain");
            Integer port = Integer.parseInt(propFile.getPort());
            
         /*   logger.info("URLS " + urls);
            logger.info("server " + server);

            logger.info("userName " + userName);

            logger.info("password " + password);

            logger.info("host " + host);

            logger.info("port " + port);

            logger.info("proxy " + proxy);

            logger.info("URLS " + urls);*/

             
            Class.forName(server);
            connection = DriverManager.getConnection(urls);

            String Sqls = "{call zsp_mcash_merchant_notify_ret}";
            CallableStatement prep = connection.prepareCall(Sqls);
            ResultSet rs = prep.executeQuery();

            while (rs.next()) {

                Id = rs.getString("Id");
                SessionID = rs.getString("SessionID");
                RequestorID = rs.getString("RequestorID");
                PayerPhoneNumber = rs.getString("PayerPhoneNumber");
                PayerName = rs.getString("PayerName");
                MerchantCode = rs.getString("MerchantCode");
                MerchantName = rs.getString("MerchantName");
                MerchantPhoneNumber = rs.getString("MerchantPhoneNumber");
                ReferenceCode = rs.getString("ReferenceCode");
                Amount = rs.getDouble("Amount");
                API_HTTP_Method = rs.getString("API_HTTP_Method");
                API_URL = rs.getString("API_URL");
                API_UserId = rs.getString("API_UserId");
                API_Password = rs.getString("API_Password");
                API_Key = rs.getString("API_Key");

                API_URL = API_URL.replace("{Id}", Id);
                API_URL = API_URL.replace("{SessionID}", SessionID);
                API_URL = API_URL.replace("{RequestorID}", RequestorID);
                API_URL = API_URL.replace("{PayerPhoneNumber}", PayerPhoneNumber);
                API_URL = API_URL.replace("{PayerName}", PayerName);
                API_URL = API_URL.replace("{MerchantCode}", MerchantCode);
                API_URL = API_URL.replace("{MerchantName}", MerchantName);
                API_URL = API_URL.replace("{MerchantPhoneNumber}", MerchantPhoneNumber);
                API_URL = API_URL.replace("{ReferenceCode}", ReferenceCode);
                String Amounts = String.valueOf(Amount);
                API_URL = API_URL.replace("{Amount}", Amounts);
                API_URL = API_URL.replace("{API_Key}", API_Key);
                API_URL = API_URL.replace(" ", "%");

                if (API_UserId == null) {
                    API_UserId = "";
                } else {
                    API_URL = API_URL.replace("{API_UserId}", API_UserId);
                }
                if (API_Password == null) {
                    API_Password = "";
                } else {
                    API_URL = API_URL.replace("{API_Password}", API_Password);
                }

                if (API_HTTP_Method.equalsIgnoreCase("QueryString")) {

                        int length = API_URL.indexOf("?");
                        String Api = API_URL.substring(0, length);
                        System.out.println("API ::::::  " + Api);
                        System.out.println("API_URL ::::::: " + API_URL);

                        HttpClient client = new HttpClient();
                        HttpMethod method = new PostMethod(API_URL);
                        method.setDoAuthentication(true);
                        HostConfiguration hostConfig = client.getHostConfiguration();
                       // hostConfig.setHost(host);
                      //  hostConfig.setProxy(proxy, port);
                        //   NTCredentials proxyCredentials = new NTCredentials(userName, password, host, domain);
                        client.getState().setCredentials(AuthScope.ANY, new UsernamePasswordCredentials(userName, password));
                        // send the transaction
                        client.executeMethod(hostConfig, method);
                        StatusLine status = method.getStatusLine();

                        if (status != null && method.getStatusCode() == 200) {  //successful post call

                            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                            Date dated = new Date();
                            String notifyDated = dateFormat.format(dated);

                            String query = "UPDATE zib_mcash_merchant_notification SET NotifyMerchant = 1, NotifyMerchantDt = ?, ErrorText = ? WHERE Id = ?";
                            PreparedStatement preps = connection.prepareCall(query);
                            preps.setString(1, notifyDated);
                            preps.setString(2, null);
                            preps.setString(3, Id);
                            preps.executeUpdate();

                            System.out.println(Id);
                            System.out.println("RECORD UPDATED");

                            System.out.println(method.getResponseBodyAsString() + "\n Status code : " + status);

                        } else {

                            System.err.println("Posting Failed : " + method.getStatusCode()+ "\n" + method.getStatusLine());

                            String Error = "Posting to this Merchant failed:\n ERROR :::" + method.getStatusLine();
                            String equery = "UPDATE zib_mcash_merchant_notification SET ErrorText = ?  WHERE Id = ?";
                            PreparedStatement preps = connection.prepareCall(equery);
                            preps.setString(1, Error);
                            preps.setString(2, Id);
                            preps.executeUpdate();
                            System.out.println("ERROR UPDATED");
                        }

                        method.releaseConnection();

                    } else {

                        System.out.println("API_URL ::: " + API_URL);

                        NameValuePair[] data = {
                            new NameValuePair("Amount", Amounts),
                            new NameValuePair("PayerName", PayerName),
                            new NameValuePair("Telephone", PayerPhoneNumber),
                            new NameValuePair("Key", API_Key)};

                        /* String data = "Amount=" + Amounts + "&Telephone=" + PayerPhoneNumber + "& Key=" + API_Key;
                         String data  = "<PaymentNotification>\n"
                         + "<PayerName>" + PayerName + "</PayerName>\n"
                         + "<PayerPhoneNumber>" + PayerPhoneNumber + "</PayerPhoneNumber>\n"
                         + "<ReferenceCode>" + ReferenceCode + "</ReferenceCode>\n"
                         + "<Amount>" + Amounts + "</Amount>\n"
                         + "<SessionID>" + SessionID + "</SessionID>\n"
                         + "<RequestorID>" + RequestorID + "</RequestorID>\n"
                         + "<MerchantName>" + MerchantName + "</MerchantName>\n"
                         + "<MerchantPhoneNumber>" + MerchantPhoneNumber + "</MerchantPhoneNumber>\n"
                         + "<MerchantCode>" + MerchantCode + "</MerchantCode>"
                         + "</PaymentNotification>";*/
                        HttpClient client = new HttpClient();
                        PostMethod method = new PostMethod(API_URL);
                        method.setDoAuthentication(true);
                        HostConfiguration hostConfig = client.getHostConfiguration();
                      //  hostConfig.setHost(host);
                     //   hostConfig.setProxy(proxy, port);

                        //   NTCredentials proxyCredentials = new NTCredentials(userName, password, host, domain);
                        client.getState().setCredentials(AuthScope.ANY, new UsernamePasswordCredentials(userName, password));
                        method.setRequestHeader("Content-Type", "application/xml");
                        method.setRequestHeader("charset", "UTF-8");
                        //  method.setRequestBody(param);
                        method.setRequestBody(data);
                       // method.setQueryString(data);
                        // send the transaction
                        client.executeMethod(hostConfig, method);

                        StatusLine status = method.getStatusLine();

                        if (status != null && method.getStatusCode() == 200) {  //successful post call

                            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                            Date dated = new Date();
                            String notifyDated = dateFormat.format(dated);

                            String query = "UPDATE zib_mcash_merchant_notification SET NotifyMerchant = 1, NotifyMerchantDt = ?, ErrorText = ? WHERE Id = ?";
                            PreparedStatement preps = connection.prepareCall(query);
                            preps.setString(1, notifyDated);
                            preps.setString(2, null);
                            preps.setString(3, Id);
                            preps.executeUpdate();

                           System.out.println("RECORD UPDATED");

                            System.out.println(method.getResponseBodyAsString() + "\n Status code : " + status);

                        } else {

                            System.err.println("Posting Failed : " + method.getStatusCode() + "\n" + method.getStatusLine());

                            String Error = "Posting to this Merchant failed:\n ERROR ::: " + method.getStatusLine();
                            String equery = "UPDATE zib_mcash_merchant_notification SET ErrorText = ?  WHERE Id = ?";
                            PreparedStatement preps = connection.prepareCall(equery);
                            preps.setString(1, Error);
                            preps.setString(2, Id);
                            preps.executeUpdate();
                            System.out.println("ERROR UPDATED");
                        }

                        method.releaseConnection();
                }
            }

        } catch (ClassNotFoundException ex) {
        	logger.info("ClassNotFoundException :::::: 1");
     
        } catch (IOException ex) {
        
        	logger.info("IOException :::::: 2");
        } catch (SQLException ex) {
        
        	logger.info("SQLException :::::: 3");
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        //logger.info(dateFormat.format(System.currentTimeMillis()) +" :: End Main!!!!");
	}
	
	
	

}
