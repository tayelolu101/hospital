/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package MerchantInformation;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.Consumes;
import javax.ws.rs.Path;
import javax.ws.rs.POST;
import javax.ws.rs.core.Response;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * REST Web Service
 *
 * @author appdev2
 */
@Path("merchants")
public class Merchants {

    @Context
    private UriInfo context;
    
     private Connection connection = null;

    /**
     * Creates a new instance of Merchants
     */
    public Merchants() {
    }

    private String SessionID;
    private String RequestorID;
    private String PayerPhoneNumber;
    private String PayerName;
    private String MerchantCode;
    private String MerchantName;
    private String MerchantPhoneNumber;
    private String ReferenceCode;
    private double Amount;
    private String TransactionDate;
    private String ResponseCode;
    private boolean NotifyMerchant;
    private String NotifyMerchantDt;

    /**
     * @return the SessionID
     */
    public String getSessionID() {
        return SessionID;
    }

    /**
     * @param SessionID the SessionID to set
     */
    public void setSessionID(String SessionID) {
        this.SessionID = SessionID;
    }

    /**
     * @return the RequestorID
     */
    public String getRequestorID() {
        return RequestorID;
    }

    /**
     * @param RequestorID the RequestorID to set
     */
    public void setRequestorID(String RequestorID) {
        this.RequestorID = RequestorID;
    }

    /**
     * @return the PayerPhoneNumber
     */
    public String getPayerPhoneNumber() {
        return PayerPhoneNumber;
    }

    /**
     * @param PayerPhoneNumber the PayerPhoneNumber to set
     */
    public void setPayerPhoneNumber(String PayerPhoneNumber) {
        this.PayerPhoneNumber = PayerPhoneNumber;
    }

    /**
     * @return the PayerName
     */
    public String getPayerName() {
        return PayerName;
    }

    /**
     * @param PayerName the PayerName to set
     */
    public void setPayerName(String PayerName) {
        this.PayerName = PayerName;
    }

    /**
     * @return the MerchantCode
     */
    public String getMerchantCode() {
        return MerchantCode;
    }

    /**
     * @param MerchantCode the MerchantCode to set
     */
    public void setMerchantCode(String MerchantCode) {
        this.MerchantCode = MerchantCode;
    }

    /**
     * @return the MerchantName
     */
    public String getMerchantName() {
        return MerchantName;
    }

    /**
     * @param MerchantName the MerchantName to set
     */
    public void setMerchantName(String MerchantName) {
        this.MerchantName = MerchantName;
    }

    /**
     * @return the MerchantPhoneNumber
     */
    public String getMerchantPhoneNumber() {
        return MerchantPhoneNumber;
    }

    /**
     * @param MerchantPhoneNumber the MerchantPhoneNumber to set
     */
    public void setMerchantPhoneNumber(String MerchantPhoneNumber) {
        this.MerchantPhoneNumber = MerchantPhoneNumber;
    }

    /**
     * @return the ReferenceCode
     */
    public String getReferenceCode() {
        return ReferenceCode;
    }

    /**
     * @param ReferenceCode the ReferenceCode to set
     */
    public void setReferenceCode(String ReferenceCode) {
        this.ReferenceCode = ReferenceCode;
    }

    /**
     * @return the Amount
     */
    public double getAmount() {
        return Amount;
    }

    /**
     * @param Amount the Amount to set
     */
    public void setAmount(double Amount) {
        this.Amount = Amount;
    }

    /**
     * @return the TransactionDate
     */
    public String getTransactionDate() {
        return TransactionDate;
    }

    /**
     * @param TransactionDate the TransactionDate to set
     */
    public void setTransactionDate(String TransactionDate) {
        this.TransactionDate = TransactionDate;
    }

    /**
     * @return the ResponseCode
     */
    public String getResponseCode() {
        return ResponseCode;
    }

    /**
     * @param ResponseCode the ResponseCode to set
     */
    public void setResponseCode(String ResponseCode) {
        this.ResponseCode = ResponseCode;
    }

    /**
     * @return the NotifyMerchant
     */
    public boolean getNotifyMerchant() {
        return NotifyMerchant;
    }

    /**
     * @param NotifyMerchant the NotifyMerchant to set
     */
    public void setNotifyMerchant(boolean NotifyMerchant) {
        this.NotifyMerchant = NotifyMerchant;
    }

    /**
     * @return the NotifyMerchatDt
     */
    public String getNotifyMerchantDt() {
        return NotifyMerchantDt;
    }

    /**
     * @param NotifyMerchatDt the NotifyMerchatDt to set
     */
    public void setNotifyMerchantDt(String NotifyMerchatDt) {
        this.NotifyMerchantDt = NotifyMerchatDt;
    }

    /**
     * POST method for updating or creating an instance of Merchants
     *
     * @param file
     * @return
     */
    @POST
    @Consumes({"text/plain", "application/xml"})
    public Response notifyMerchant(String file) {

        String content = ServiceClient.decrypteData(file.trim());
        boolean exceptionThrown = false;
        Response response;

        System.out.println("Content: " + content);

        if (content == null || content.equalsIgnoreCase("") || content.isEmpty()) {

            System.err.println("No Content Found");

            response = Response.status(Response.Status.BAD_REQUEST).build();

        } else {

            Merchants info = new Merchants();

           // Connection connection = null;
            boolean notified = false;

            try {
                
                //Reading parametres from a file.
                Properties prop = new Properties();
                InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("MerchantInformation/NotifyProperty.properties");

                prop.load(inputStream);
                //prop.load(new FileInputStream("C:\\Users\\appdev2\\Documents\\nbProjects\\NibssMerchant\\NotifyProperty.properties"));

                System.out.println("Content: " + content);

                System.out.println("************************");
                
                
                //Reading through the XML generated from the Encrypted string.
                DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
                Document doc = dBuilder.parse(new InputSource(new ByteArrayInputStream(content.getBytes("utf-8"))));

                doc.getDocumentElement().normalize();
                NodeList nList = doc.getElementsByTagName("PaymentNotification");

                for (int temp = 0; temp < nList.getLength(); temp++) {

                    Node nNode = nList.item(temp);

                    if (nNode.getNodeType() == Node.ELEMENT_NODE) {

                        Element eElement = (Element) nNode;
                        
                        //Assigning each node element as the object property.
                        info.setSessionID(eElement.getElementsByTagName("SessionID").item(0).getTextContent());
                        info.setRequestorID(eElement.getElementsByTagName("RequestorID").item(0).getTextContent());
                        info.setPayerPhoneNumber(eElement.getElementsByTagName("PayerPhoneNumber").item(0).getTextContent());
                        info.setPayerName(eElement.getElementsByTagName("PayerName").item(0).getTextContent());
                        info.setMerchantCode(eElement.getElementsByTagName("MerchantCode").item(0).getTextContent());
                        info.setMerchantName(eElement.getElementsByTagName("MerchantName").item(0).getTextContent());
                        info.setMerchantPhoneNumber(eElement.getElementsByTagName("MerchantPhoneNumber").item(0).getTextContent());
                        info.setReferenceCode(eElement.getElementsByTagName("ReferenceCode").item(0).getTextContent());
                        info.setAmount(Double.parseDouble(eElement.getElementsByTagName("Amount").item(0).getTextContent()));
                        info.setTransactionDate(eElement.getElementsByTagName("TransactionDate").item(0).getTextContent());
                        info.setResponseCode(eElement.getElementsByTagName("ResponseCode").item(0).getTextContent());

                    }
                    //converting the transaction date to dateTime format
                    DateFormat nowFormat = new SimpleDateFormat("yyMMddHHmmss");
                    java.util.Date dateTime;
                    dateTime = nowFormat.parse(info.getTransactionDate());
                    java.sql.Date transactionDate = new java.sql.Date(dateTime.getTime());

//                  if(!notified){ 
                    //Assigning notification & date of notification
                    info.setNotifyMerchant(Boolean.valueOf(notified));
                    info.setNotifyMerchantDt(null);

//                  }else{
//                              info.setNotifyMerchant(Boolean.valueOf(notified));
//                              DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
//                                Date dated = new Date();
//                                info.setNotifyMerchatDt(dateFormat.format(dated));
                    
                    //getting parameters to connect to database
                    String url = prop.getProperty("url");
                    String server = prop.getProperty("serv_name");

                    System.out.println(url);
                    System.out.println(server);
                    
                    //Registering the Database.
                    Class.forName(server);
                    
                    //Connecting to the database.
                    connection = DriverManager.getConnection(url);
                    
                    //condition to be sure connection is opened
                    if (!connection.isClosed()) {
                        System.out.println("Connection is opened");
                    }

                    // Callable statement to insert data
                    String insertSql =/* "{call zsp_mcash_merchant_notification_ins (?,?,?,?,?,?,?,?,?,?,?,?,?)}";//*/ "INSERT INTO Zib_Mcash_merchant_notification (SessionID ,RequestorID, PayerPhoneNumber, PayerName, MerchantCode, MerchantName, MerchantPhoneNumber, ReferenceCode, Amount, TransactionDate, ResponseCode, NotifyMerchant, NotifyMerchantDt) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";

                    PreparedStatement prep = connection.prepareCall(insertSql);

                    //Assigning values to the table column
                    prep.setString(1, info.getSessionID());
                    prep.setString(2, info.getRequestorID());
                    prep.setString(3, info.getPayerPhoneNumber());
                    prep.setString(4, info.getPayerName());
                    prep.setString(5, info.getMerchantCode());
                    prep.setString(6, info.getMerchantName());
                    prep.setString(7, info.getMerchantPhoneNumber());
                    prep.setString(8, info.getReferenceCode());
                    prep.setDouble(9, info.getAmount());
                    prep.setDate(10, transactionDate);
                    prep.setString(11, info.getResponseCode());
                    prep.setBoolean(12, info.getNotifyMerchant());
                    prep.setString(13, info.getNotifyMerchantDt());
                    // prep.setString(14, "-");
                    
                    //command to insert into table
                    prep.executeUpdate();
                }
                
                System.out.println("======Information has been inserted into table.======");

            } catch (IOException ex) {
                
                Logger.getLogger(Merchants.class.getName()).log(Level.SEVERE, null, ex);
                exceptionThrown = true;
                
            } catch (ParserConfigurationException ex) {
                
                Logger.getLogger(Merchants.class.getName()).log(Level.SEVERE, null, ex);
                exceptionThrown = true;
                
            } catch (SAXException ex) {
                
                Logger.getLogger(Merchants.class.getName()).log(Level.SEVERE, null, ex);
                exceptionThrown = true;
                
            } catch (DOMException ex) {
                
                Logger.getLogger(Merchants.class.getName()).log(Level.SEVERE, null, ex);
                exceptionThrown = true;
                
            } catch (NumberFormatException ex) {
                
                Logger.getLogger(Merchants.class.getName()).log(Level.SEVERE, null, ex);
                exceptionThrown = true;
                
            } catch (ParseException ex) {
                
                Logger.getLogger(Merchants.class.getName()).log(Level.SEVERE, null, ex);
                exceptionThrown = true;
                
            } catch (ClassNotFoundException ex) {
                
                Logger.getLogger(Merchants.class.getName()).log(Level.SEVERE, null, ex);
                exceptionThrown = true;
                
            } catch (SQLException ex) {
                
                Logger.getLogger(Merchants.class.getName()).log(Level.SEVERE, null, ex);
                exceptionThrown = true;
                
            } finally {
                //closing the connection
                if (connection != null) {
                    
                    try {
                        
                        connection.close();
                        
                    } catch (SQLException ex) {
                    }
                }
            }
            if (exceptionThrown) {

                response = Response.status(Response.Status.INTERNAL_SERVER_ERROR).build();

            } else {

                response = Response.status(200).build();
            }
        }
        return response;
    }
    
    //Main method to test this application.
//    public static void main(String[] args) {
//
//        String test = "85010C03F59D20A5FFA484380107FF524A71395FD44DDE43BC7E51603F3042E8B8C82C5804945BBB4A70D4548E43829F208D4A99B3A5FEB9F37B3C94359A95561AD53710FDCAA63F692A4113E12A9ABBBAA6F69E947688A673AB161D86C0E32F2419E6F660808D4E99D206207F25156926C38F5908489CE2A247A0C1EA20E18E041DD4ED0D12240384A0AC984D7756E513BEAE75C07E42447A3D2FEE013EDCFFC5700E266A502C052B4F09A0D3A19DB5BCCE0F11A3F0DEF0976279469814F063163165FEBFC302392CE02A5B629AD88DF40182C3918C88B10C4C38CB806E7C843B4C0142FF43F969B3E593C91F1A745CFB5D4CBEA2A301D8A6717FB207FBA698C60CC68C2E871775D84C4BB2E9B12DC9C0C756C552DEBE7FB18CBB83B8DCE2F74EA0C0D7D86DD9BF675B8BFAD77F97EDAA632D18D20FD03467E72C957A1588317199CD74C7CADFAAA6643E5E7818605BE12FB77EDAE2794ED933CB1BF0066C5610A9E38EF9D6DC3E33901278F3D80C7F1347D5AF5922A3C0030F27E2FD315192829B28C5BA26AB73430BF2E344F41E8A42EDAD0C104BACE948F245AF9E1A362C88D838B6750B3BEEEB98431678D12E660478BC1583BE6CD409450C2BED74AA4C30CE5F3131F8CC94660EDB8DE7FC73A32F6D0B8DA605C4AEB810EEBBBDB18824D01182CE6AAF1D21A8F8703136BB0360CA5E53E795FBBE6EE24143CD0E210449EF20191E987B0CD8C2E4B2346C3B8614FBF092CD9F10DD8DAB06738FA3F5264ACA0E0639F12C07CEAB1F1B7B1A32ADE288F821197C92C5905E3241604C178393A268D0FB1068A5DEE95C099F4FAFA10F93EBC2179C1BEF40A43290AA14AA5EBB96EA0F87A0D474E81C0BB96BFCB6AAA6E2F8162B37963D7CACF49AC15D71B2A875C1FA654F084780F885F3B4746D41CB41A9EFAD1945B9B6FD;";
//        String tested = ServiceClient.decrypteData(test);
//        System.out.println(tested);
//        Merchants me = new Merchants();
//        me.notifyMerchant(test);
 //   }
}
