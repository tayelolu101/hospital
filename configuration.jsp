<%@ page import="java.util.Map, java.util.HashMap"%>
<%!

    /*
    Set all your configuration here

    If you want to have multiple configuration sets, copy and paste
    the configuration lines and create a new map with a different variable name
    this map can then be parsed into the Merchant constructor from process.jsp

    The debug configuration setting is useful for printing requests and responses
    If you're receiving an error or unexpected output, set this flag to TRUE
    The debug output will help indicate the cause of the problem

    Please comment the proxy settings if you do not wish to use a proxy

    */
    static Map<String, Object> configuration;
    static {
            configuration = new HashMap<String, Object>();

            // The host of the Payment Gateway
            configuration.put("gatewayHost", null);

            // Base URL of the Payment Gateway. Do not include the version.
            configuration.put("gatewayUrl", "https://[INSERT-DOMAIN]/api/rest");

            // If no authentication is required, only uncomment proxyServer
            // Server name or IP address and port number of your proxy server
            configuration.put("proxyServer", null);
            configuration.put("proxyPort", null);

            // Username and password for proxy server authentication
            configuration.put("proxyUsername", null);
            configuration.put("proxyPassword", null);

            // Proxy authentication type e.g. (NTLM, BASIC)
            configuration.put("proxyAuthType", null);

            //NT domain to authenticate in
            configuration.put("ntDomain", null);

            // The debug setting controls displaying the raw content of the request and
            // response for a transaction.
            // In production you should ensure this is set to FALSE as to not display/use
            // this debugging information
            configuration.put("debug", false);

            // Version number of the API being used for your integration
            // this is the default value if it isn't being specified in process.jsp
            configuration.put("version", "13");

            // Merchant ID supplied by your payments provider
            configuration.put("merchantId", "[INSERT-MERCHANT-ID]");

            // API username in the format below where Merchant ID is the same as above
            configuration.put("apiUsername", "merchant.[INSERT-MERCHANT-ID]");

            // API password which can be configured in Merchant Administration
            configuration.put("password", null);

            // [Snippet] howToConfigureSslCert - start
            // If using certificate validation, modify the following configuration settings

            // alternate trust store file
            // leave as null if you use default java trust store
            String trustStore = null;
            // trust store password
            String trustStorePassword = null;

            if (trustStore != null) {
                System.setProperty("javax.net.ssl.trustStore", trustStore);
                System.setProperty("javax.net.ssl.trustStorePassword", trustStorePassword);
            }
            // [Snippet] howToConfigureSslCert - end

    }
%>

<%

    final class Merchant {
        private String gatewayHost;
        private String gatewayUrl;
        private String proxyServer;
        private Integer proxyPort;
        private String proxyUsername;
        private String proxyPassword;
        private String proxyAuthType;
        private String ntDomain;
        private boolean debug;
        private String version;
        private String merchantId;
        private String apiUsername;
        private String password;
        private String trustStorePath;
        private String trustStorePassword;

        Merchant(Map<String, Object> configuration) {
            gatewayHost = (String) configuration.get("gatewayHost");
            proxyServer = (String) configuration.get("proxyServer");
            proxyPort = (Integer) configuration.get("proxyPort");
            proxyUsername = (String) configuration.get("proxyUsername");
            proxyPassword = (String) configuration.get("proxyPassword");
            proxyAuthType = (String) configuration.get("proxyAuthType");
            ntDomain = (String) configuration.get("ntDomain");
            gatewayUrl = (String) configuration.get("gatewayUrl");
            debug = (Boolean) configuration.get("debug");
            version = (String) configuration.get("version");
            merchantId = (String) configuration.get("merchantId");
            password = (String) configuration.get("password");
            apiUsername = (String) configuration.get("apiUsername");
        }

        String getGatewayHost() {
            return gatewayHost;
        }

        String getNtDomain() {
            return ntDomain;
        }

        String getProxyServer() {
            return proxyServer;
        }

        String getProxyUsername() {
            return proxyUsername;
        }

        String getProxyPassword() {
            return proxyPassword;
        }

        String getProxyAuthType() {
            return proxyAuthType;
        }

        Boolean debugMode() {
            return debug;
        }

        Integer getProxyPort() {
            return proxyPort;
        }

        String getGatewayUrl() {
            return gatewayUrl;
        }

        String getMerchantId() {
            return merchantId;
        }

        String getPassword() {
            return password;
        }

        void setGatewayUrl(String gatewayUrl) {
            this.gatewayUrl = gatewayUrl;
        }

        void setVersion(String version) {
            this.version = version;
        }

        String getVersion() {
            return version;
        }

        String getApiUsername() {
            return apiUsername;
        }

    }
%>
