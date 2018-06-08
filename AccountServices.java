package AccountSummary;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.zenithbank.stringhelper.JSONArray;
import com.zenithbank.stringhelper.JSONObject;


public class AccountServices {

	private static  String BaseUrl = null;
	private static String getConsolidatedAccountStatements = null;
	private static String GetDailyActivityStatements= null;
	private static String VendorPaymentDebitAccountNoUrl = null;
	private static String GetCustomerDetail = null;
	private static String X_CALLER_ID = null;
	private static String X_CALLER_NAME = null;
	private static String X_CALLER_PASSWORD = null;
	private static String X_CALLER_SESSION_ID = null;
	private static String CERT_1 = null;
	private static String CERT_2 = null;
	private SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy hh:mm:ss");
    private SimpleDateFormat formatter2 = new SimpleDateFormat("dd/MM/yyyy");
	private static DecimalFormat df2 = new DecimalFormat(".##");
	private static BigDecimal val = new BigDecimal(0).setScale(2, BigDecimal.ROUND_HALF_UP);

	private static boolean IS_DEV;

	static {
		Properties ps = new Properties();
		try {
			ps.load(AccountServices.class.getResourceAsStream("Account.properties"));
			IS_DEV = ps.getProperty("accountservice.dev.mode").contains("true");
			getConsolidatedAccountStatements = ps.getProperty("zencore.accountservices.getConsolidatedAccountStatements.uri");
			VendorPaymentDebitAccountNoUrl = ps.getProperty("zencore.accountservices.getVendorPaymentDebitAccountNo.uri");
			GetCustomerDetail = ps.getProperty("zencore.accountservices.getCustomerDetail.uri");
			GetDailyActivityStatements = ps.getProperty("zencore.accountservices.getDailyActivityStatements.uri");
			BaseUrl = ps.getProperty("zencore.baseurl");
			CERT_2 = ps.getProperty("zencore.accountservices.2");
			CERT_1 = ps.getProperty("zencore.accountservices.1");
			X_CALLER_ID = ps.getProperty("zencore.caller.id");
			X_CALLER_NAME = ps.getProperty("zencore.caller.name");
			X_CALLER_PASSWORD = ps.getProperty("zencore.caller.password");
			X_CALLER_SESSION_ID = ps.getProperty("zencore.cust.session.id");
		} catch (FileNotFoundException ex) {
			Logger.getLogger(AccountServices.class.getName()).log(Level.SEVERE, null, ex);
		} catch (IOException ex) {
			Logger.getLogger(AccountServices.class.getName()).log(Level.SEVERE, null, ex);
		}
	}
	
	
	private HttpURLConnection getHttpConnectionWithHeader(String apiUrl) throws IOException {
		URL url = new URL(apiUrl);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestProperty("X-CallerID", X_CALLER_ID);
		con.setRequestProperty("X-CallerName", X_CALLER_NAME);
		con.setRequestProperty("X-CallerPassword", X_CALLER_PASSWORD);
		con.setRequestProperty("X-CUST-SESSIONID", X_CALLER_SESSION_ID);
		con.setRequestProperty("Content-Type", "application/json");

		return con;

	}
	
	 public AccountSummaryPojo[] getVendorPaymentDebitAccountNo(String companycode,String accountNumber, Integer rim_no,Integer roleid) {
		 AccountSummaryPojo[] accountsummaryvalues = new  AccountSummaryPojo[0];
         AccountSummaryPojo account = null;
       
	 
	 if (IS_DEV) {

			System.setProperty(CERT_1, CERT_2);
		}
		List<AccountSummaryPojo> listValue = new ArrayList<AccountSummaryPojo>();

		URL url = null;
		
		try {
			
			String API_URL = BaseUrl+VendorPaymentDebitAccountNoUrl;

			if((rim_no == null || rim_no.equals("")) && (roleid == null || roleid.equals(""))){								
					
					API_URL = API_URL +"companyCode="+companycode+"&accountNumber="+accountNumber;
					
		    }else if((rim_no == null || rim_no.equals("")) && ((!roleid.equals("")) || roleid != null)){
					
					API_URL = API_URL +"companyCode="+companycode+"&accountNumber="+accountNumber+"&roleId="+roleid;
					
		    }
		    else if((roleid == null || roleid.equals("")) && ((!rim_no.equals("")) || rim_no != null)){
				
		    	API_URL = API_URL +"companyCode="+companycode+"&accountNumber="+accountNumber+"&rimNo="+rim_no;
	   
		    }else{
		    	
				API_URL = API_URL +"companyCode="+companycode+"&accountNumber="+accountNumber+"&rimNo="+rim_no+"&roleId="+roleid;
		    }
				
									
			 System.out.println("API URL FOR RETRIEVAL " + API_URL);
			 
			url = new URL(API_URL);
			
			HttpURLConnection con = getHttpConnectionWithHeader(API_URL);

			con.setRequestMethod("GET");

			int responseCode = con.getResponseCode();

			// con.connect();
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;

			StringBuilder inputBuffer = new StringBuilder();
			
			if (responseCode == HttpURLConnection.HTTP_OK) {

				while ((inputLine = in.readLine()) != null) {

					inputBuffer.append(inputLine);
				}
				System.out.println("content " + inputBuffer.toString());

				JSONObject json = new JSONObject(inputBuffer.toString());

				JSONArray Accounts = (JSONArray) json.get("data");
				

				for (int i = 0; i < Accounts.length(); i++) {
				    account = new AccountSummaryPojo();
					JSONObject accountObject = Accounts.getJSONObject(i);
					account.setNoOfLeafs  (accountObject.optString("AccountNo"));
					System.out.println("Value : " + account.getNoOfLeafs());
					listValue.add(account);
				}
				 accountsummaryvalues = new AccountSummaryPojo[listValue.size()];
				 accountsummaryvalues = (AccountSummaryPojo[]) listValue.toArray(accountsummaryvalues);

			}

			in.close();

		} catch (Exception e) {
			
			e.printStackTrace();
		}
		  return accountsummaryvalues;
	 }



	public AccountSummaryPojo getCustomerDetail(String accountNumber) {

		AccountSummaryPojo accountPojo = new AccountSummaryPojo();
		System.out.println("hey");
		if (IS_DEV) {

			System.setProperty(CERT_1, CERT_2);
		}

		URL url = null;

		try {

			String API_URL = BaseUrl+GetCustomerDetail;

			API_URL = API_URL.replace("{accountNumber}", accountNumber);
			System.out.println("API URL FOR RETRIEVAL " + API_URL);
			url = new URL(API_URL);
			HttpURLConnection con = getHttpConnectionWithHeader(API_URL);

			con.setRequestMethod("GET");

			int responseCode = con.getResponseCode();

			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;

			StringBuilder inputBuffer = new StringBuilder();

			if (responseCode == HttpURLConnection.HTTP_OK) {

				while ((inputLine = in.readLine()) != null) {

					inputBuffer.append(inputLine);
				}
                 System.out.println(inputBuffer.toString());
				JSONObject json = new JSONObject(inputBuffer.toString());

				JSONObject account = (JSONObject) json.get("data");

				accountPojo.setBranchNumber(Integer.parseInt(account.optString("BranchNumber")));
				accountPojo.setRsm_id(Integer.parseInt(account.optString("RsmID")));
				accountPojo.setClassCode(Integer.parseInt(account.optString("ClassCode")));

				System.out.println(accountPojo.getBranchNumber());
				System.out.println(accountPojo.getRsm_id());
				System.out.println(accountPojo.getClassCode());
			}

			in.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return accountPojo;

	}

	public AccountStatementsItemPojo[] getDailyActivityStatements(String accountNumber){
		AccountStatementsItemPojo[] accountstatementitems = new  AccountStatementsItemPojo[0];
		AccountStatementsItemPojo accountstatementitem = null;
		ArrayList<AccountStatementsItemPojo> listValue = new ArrayList<AccountStatementsItemPojo>();



		if (IS_DEV) {
			System.setProperty(CERT_1, CERT_2);
		}

		URL url = null;

		try {

			String API_URL = BaseUrl+GetDailyActivityStatements;

			API_URL = API_URL +"accountNumber="+accountNumber;


			System.out.println("API URL FOR RETRIEVAL " + API_URL);

			url = new URL(API_URL);

			HttpURLConnection con = getHttpConnectionWithHeader(API_URL);

			con.setRequestMethod("GET");

			int responseCode = con.getResponseCode();

			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;

			StringBuilder inputBuffer = new StringBuilder();

			if (responseCode == HttpURLConnection.HTTP_OK) {

				while ((inputLine = in.readLine()) != null) {

					inputBuffer.append(inputLine);
				}
				System.out.println("content :" + inputBuffer.toString());

				JSONObject json = new JSONObject(inputBuffer.toString());

				JSONObject jsons = (JSONObject) json.get("data");

				JSONArray statementItem = (JSONArray) jsons.get("Statements");

				for (int i = 0; i < statementItem.length(); i++) {
					accountstatementitem = new AccountStatementsItemPojo();
					JSONObject accountObject = statementItem.getJSONObject(i);

					try {

						String dt = accountObject.optString("EffectiveDate");
						Date EffectiveDate = formatter.parse(dt);
						accountstatementitem.setEffectiveDate(EffectiveDate);
					}catch (Exception ex){

					}
					accountstatementitem.setTranAmount(accountObject.optDouble("Amount"));
					accountstatementitem.setDescription(accountObject.optString("Description"));
					//	accountstatementitem.setCheckNumber(accountObject.optInt("ReferenceNo"));
					//	accountstatementitem.setbranch(accountObject.optString("PostingBranchNo"));
					//	accountstatementitem.setTranCode(accountObject.optInt(""));
					listValue.add(accountstatementitem);
				}
				accountstatementitems = new AccountStatementsItemPojo[listValue.size()];
				accountstatementitems =  listValue.toArray(accountstatementitems);
			}
		}catch(Exception ex){

		}

		return accountstatementitems;
	}



	public AccountStatementsItemPojo[] getConsolidatedAccountStatements(String [] accountNumber , String StartDate, String EndDate)
	{
		AccountStatementsItemPojo[] accountstatementitems = new  AccountStatementsItemPojo[0];
		AccountStatementsItemPojo accountstatementitem = null;
		ArrayList<AccountStatementsItemPojo> listValue = new ArrayList<AccountStatementsItemPojo>();


		if (IS_DEV) {

			System.setProperty(CERT_1, CERT_2);
		}

		try {

			String API_URL = BaseUrl+getConsolidatedAccountStatements;

			System.out.println("API URL: " + API_URL);
			JSONObject postObject = new JSONObject();
			postObject.put("AccountList", accountNumber);
			postObject.put("BeginDate", StartDate);
			postObject.put("EndDate", EndDate);

			byte[] postDataBytes = postObject.toString().getBytes("UTF-8");

			HttpURLConnection con = getHttpConnectionWithHeader(API_URL);

			con.setRequestMethod("POST");
			con.setDoOutput(true);
			con.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));

			System.out.println("Postbytes " + postObject.toString());
			con.getOutputStream().write(postDataBytes);
			int responseCode = con.getResponseCode();

			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;

			StringBuilder inputBuffer = new StringBuilder();

			if (responseCode == HttpURLConnection.HTTP_OK) {

				while ((inputLine = in.readLine()) != null) {

					inputBuffer.append(inputLine);
				}

				System.out.println("content :" + inputBuffer.toString());
				JSONObject json = new JSONObject(inputBuffer.toString());
				JSONObject jsons = (JSONObject) json.get("data");
				JSONArray JsonItems = (JSONArray) jsons.get("StatementRequest");

				for (int j = 0; j < JsonItems.length(); j++) {

					JSONObject accountObjecter = JsonItems.getJSONObject(j);
					JSONArray statementItem = (JSONArray) accountObjecter.get("Statements");

					for (int i = 0; i < statementItem.length(); i++) {

						accountstatementitem = new AccountStatementsItemPojo();
						JSONObject accountObject = statementItem.getJSONObject(i);

						try {

                            Date EffectiveDate = formatter2.parse(accountObject.optString("EffectiveDate"));
                            accountstatementitem.setEffectiveDate(EffectiveDate);

                        }catch (Exception ex){

                        }
//						Date CreateDate = formatter.parse(accountObject.optString("CreateDate"));
//                       accountstatementitem.setCreateDate(CreateDate);
                         accountstatementitem.setDrCr(accountObject.optString("DrCr"));
//                       accountstatementitem.setTranAmount(accountObject.optDouble(""));
//                       accountstatementitem.setItemType(accountObject.optString(""));
//                       accountstatementitem.setPostingCode(accountObject.optString(""));
//                       accountstatementitem.setReversal(accountObject.optString(""));
//                       accountstatementitem.setHistoryDesc(accountObject.optString(""));
//                       accountstatementitem.setTranCodeDesc(accountObject.optString(""));
//                       accountstatementitem.setTranOrigin(accountObject.optInt(""));
//                       accountstatementitem.setOriginTracerNo(accountObject.optString(""));
//                       accountstatementitem.setReg_E_Desc(accountObject.optString(""));
//                       accountstatementitem.setCheckNumber(accountObject.optInt(""));
//                       accountstatementitem.setPtid(accountObject.optLong(""));
//                       accountstatementitem.setIso_currency(accountObject.optString(""));
						listValue.add(accountstatementitem);


					}
				}
			}

				accountstatementitems = new AccountStatementsItemPojo[listValue.size()];
				accountstatementitems = (AccountStatementsItemPojo[]) listValue.toArray(accountstatementitems);

		}catch(Exception ex){

		}

		return accountstatementitems;
	}
	 
	 
	 public static void main(String [] args) {

		 try{
		 AccountServices acc = new AccountServices();
			 AccountStatementsItemPojo[] pojo = acc.getDailyActivityStatements("1014458889");
			// String [] acct= {"1014458889"};
			// AccountStatementsItemPojo[] pojo = acc.getConsolidatedAccountStatements(acct , "01-05-2018", "24-05-2018");
			// AccountSummaryPojo[] pojo = acc.getVendorPaymentDebitAccountNo("CIB0190066174", "1015443262", 1, null);
		//AccountSummaryPojo pojo = acc.getCustomerDetail("1015443262");


		for(int i = 0; i < pojo.length; i++){

			System.out.println("# : " + pojo[i].getEffectiveDate());
		//	System.out.println("# : " + pojo[i].getDescription());
			System.out.println("# : " + pojo[i].getDrCr() );
		}



		 }catch (Exception e){

		 	e.printStackTrace();
		 }


	}
}
