package com.zenithbank.merchantclient;


import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LoadPropFile {

	private static LoadPropFile instance = null;
	private static final Logger logger = LoggerFactory.getLogger(LoadPropFile.class);
	private String CRON_TIMER = "cronTimer";
	private String workingDir = System.getProperty("user.dir");
	private String fileConfigLocation = workingDir+"\\"+"ClientProp.properties";
	private String cronTimer;
	private String classLoaderLocation = "com/zenithbank/merchantclient/ClientProp.properties";
	
	private String url ;
	private String server;
	private String userName;
	private String password;
	private String host;
	private String proxy;
	private String port;


	public LoadPropFile() {
		if (instance == null) {
			
			Properties prop = new Properties();
			
			FileInputStream fileInputStream = null;
			InputStream inputStream = null;
			try {
				fileInputStream = new FileInputStream(fileConfigLocation);
			} catch (FileNotFoundException e1) {
				logger.info( "  Please Include file in location ::: " +fileConfigLocation);
				logger.info(" Using default file bundled :::: " + classLoaderLocation) ;
			    inputStream = LoadPropFile.class.getClassLoader()
						.getResourceAsStream(classLoaderLocation);
				
				
			}
			try {
				
				if(fileInputStream == null){
					
					prop.load(inputStream);
				}else{
					

					prop.load(fileInputStream);
					logger.info(" Using default file  :::: " +  fileConfigLocation) ;
				}
		
				
				this.cronTimer = prop.getProperty(CRON_TIMER);
				this.url  = prop.getProperty("surl");
				this.server = prop.getProperty("serv_names");
				this.userName  = prop.getProperty("userName");
				this.password = prop.getProperty("password");
				this.host = prop.getProperty("host");
				this.proxy =  prop.getProperty("proxy");
				this.port = prop.getProperty("port");
			
				System.out.println("Cron timer :: " + this.cronTimer);
				if(fileInputStream != null){
					fileInputStream.close();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		

	}

	public static LoadPropFile getInstance() {
		if (instance == null) {

			instance = new LoadPropFile();
		}

		return instance;
	}

	public String getCronTimer() {
		return this.cronTimer;
	}

	


	public String getWorkingDir() {
		return this.workingDir;
	}

	

	public String getUrl() {
		return this.url;
	}

	
	public String getServer() {
		return this.server;
	}



	public String getUserName() {
		return this.userName;
	}

	
	public String getPassword() {
		return this.password;
	}



	public String getHost() {
		return this.host;
	}

	

	public String getProxy() {
		return this.proxy;
	}

	public String getPort() {
		return this.port;
	}

	

}
