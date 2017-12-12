
<%@include file="/configuration.jsp"%>
<%@ page
  import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.auth.AuthScope,org.apache.commons.httpclient.methods.*,java.io.IOException,java.text.MessageFormat"%>

<%
    final class Connection {

        private Merchant merchant;

        Connection(Merchant merchant) {
            this.merchant = merchant;
        }

        String sendTransaction(String data) throws Exception {
            HttpClient httpClient = new HttpClient();
            // [Snippet] howToSetCredentials - start
            // set the API Username and Password in the header authentication field.
            httpClient.getState().setCredentials(AuthScope.ANY,
                    new UsernamePasswordCredentials(merchant.getApiUsername(), merchant.getPassword()));
            // [Snippet] howToSetCredentials - end
            // [Snippet] howToPut - start
            // [Snippet] howToSetURL - start
            PutMethod putMethod = new PutMethod(merchant.getGatewayUrl());
            // [Snippet] howToSetURL - end
            // [Snippet] howToPut - end
            putMethod.setDoAuthentication(true);
            // [Snippet] howToSetHeaders - start
            // set the charset to UTF-8
            StringRequestEntity entity = new StringRequestEntity(data, "application/json", "UTF-8");
            putMethod.setRequestEntity(entity);
            // [Snippet] howToSetHeaders - end
            HostConfiguration hostConfig = new HostConfiguration();
            hostConfig.setHost(merchant.getGatewayHost());
            configureProxy(httpClient);
            String body = null;
            // [Snippet] executeSendTransaction - start
            try {
                // send the transaction
                httpClient.executeMethod(hostConfig, putMethod);
                body = putMethod.getResponseBodyAsString();
            } catch (IOException ioe) {
                // we can replace a specific exception that
                // suits your application
                throw new Exception(ioe);
            } finally {
                putMethod.releaseConnection();
            }
            // [Snippet] executeSendTransaction - end
            return body;
        }

        String getTransaction() throws Exception {
            HttpClient httpClient = new HttpClient();
            // set the API Username and Password in the header authentication field.
            httpClient.getState().setCredentials(AuthScope.ANY,
                    new UsernamePasswordCredentials(merchant.getApiUsername(), merchant.getPassword()));

            GetMethod getMethod = new GetMethod(merchant.getGatewayUrl());

            getMethod.setDoAuthentication(true);

            HostConfiguration hostConfig = new HostConfiguration();
            hostConfig.setHost(merchant.getGatewayHost());
            configureProxy(httpClient);
            String body = null;

            try {
                // send the transaction
                httpClient.executeMethod(hostConfig, getMethod);
                body = getMethod.getResponseBodyAsString();
            } catch (IOException ioe) {
                // we can replace a specific exception that
                // suits your application
                throw new Exception(ioe);
            } finally {
                getMethod.releaseConnection();
            }

            return body;
        }

        // [Snippet] howToConfigureProxy - start
        // Check if proxy config is defined, if so configure the host and http client to tunnel through
        void configureProxy(HttpClient httpClient) {
            // If proxy server is defined, set the host configuration.
            if (merchant.getProxyServer() != null) {
                HostConfiguration hostConfig = httpClient.getHostConfiguration();
                hostConfig.setHost(merchant.getGatewayHost());
                hostConfig.setProxy(merchant.getProxyServer(), merchant.getProxyPort());

            }
            // If proxy authentication is defined, set proxy credentials
            if (merchant.getProxyUsername() != null) {
                NTCredentials proxyCredentials =
                        new NTCredentials(merchant.getProxyUsername(),
                                merchant.getProxyPassword(), merchant.getGatewayHost(),
                                merchant.getNtDomain());
                httpClient.getState().setProxyCredentials(merchant.getProxyAuthType(),
                        merchant.getProxyServer(), proxyCredentials);
            }
        }
        // [Snippet] howToConfigureProxy - end
     }

    final class Parser {

        private Merchant merchant;

        Parser(Merchant merchant) {
            this.merchant = merchant;
        }

        // [Snippet] howToConfigureURL - start
        // Formats the target URL for sending the transaction, based on the version
        // and merchant ID stored in config, as well as any custom values passed
        // to it, i.e. order and transaction ID's
        // Assign it to the gatewayUrl member in the merchantObj object
        String formRequestUrl(HttpServletRequest request) {
            String orderId = request.getParameter("orderId");
            String transactionId = request.getParameter("transactionId");
            String version = request.getParameter("version");
            StringBuilder url = new StringBuilder(merchant.getGatewayUrl());
            url.append("/version/");
            url.append(version);
            url.append("/merchant/");
            url.append(merchant.getMerchantId());
            url.append("/order/");
            url.append(orderId);
            url.append("/transaction/");
            url.append(transactionId);
            merchant.setGatewayUrl(url.toString());
            return merchant.getGatewayUrl();
        }
        // [Snippet] howToConfigureURL - end

        // [Snippet] howToConvertFormData - start
        // Convert parameter field value to JSON formmated value
        private String convertToJSonOrNull(String fieldValue) {
            if (fieldValue == null || fieldValue.trim().equals("")) {
                fieldValue = null;
            } else {
                fieldValue = "\"" + fieldValue + "\"";
            }
            return fieldValue;
        }

        // Creates the JSON encoded transaction body from http request parameters
        // Remember to make it check if the member is empty, assign null if it is
        String parse(HttpServletRequest request) {
            // Convert to JSON value if not empty or null.
            String cardSecurityCode = convertToJSonOrNull(request.getParameter("sourceOfFunds[provided][card][securityCode]"));
            String orderReference = convertToJSonOrNull(request.getParameter("order[reference]"));
            String sourceOfFundsType = convertToJSonOrNull(request.getParameter("sourceOfFunds[type]"));
            String cardNumber = convertToJSonOrNull(request.getParameter("sourceOfFunds[provided][card][number]"));
            String cardExpiryMonth = convertToJSonOrNull(request.getParameter("sourceOfFunds[provided][card][expiry][month]"));
            String cardExpiryYear = convertToJSonOrNull(request.getParameter("sourceOfFunds[provided][card][expiry][year]"));
            String transactionReference = convertToJSonOrNull(request.getParameter("transaction[reference]"));
            String customerIpAddress = convertToJSonOrNull(request.getParameter("customer[ipAddress]"));
            String transactionAmount = convertToJSonOrNull(request.getParameter("transaction[amount]"));
            String transactionCurrency = convertToJSonOrNull(request.getParameter("transaction[currency]"));
            String targetTransactionId = convertToJSonOrNull(request.getParameter("transaction[targetTransactionId]"));
            String apiOperation = convertToJSonOrNull(request.getParameter("apiOperation"));

            // Create JSON formatted data
            String data = MessageFormat.format(
                        "'{'\"apiOperation\":{0},"
                                + "\"sourceOfFunds\":'{'\"type\":{1},\"provided\":'{'\"card\":'{'\"number\":{2},"
                                + "\"expiry\":'{'\"month\":{3}, \"year\":{4}'}',\"securityCode\":{5}'}}}',"
                                + "\"order\":'{'\"reference\":{6}'}',"
                                + "\"transaction\":'{'\"amount\":{7},\"currency\":{8},\"reference\":{9},\"targetTransactionId\":{10}'}',"
                                + "\"customer\":'{'\"ipAddress\":{11}'}}'",
                    apiOperation,
                    sourceOfFundsType,
                    cardNumber,
                    cardExpiryMonth,
                    cardExpiryYear,
                    cardSecurityCode,
                    orderReference,
                    transactionAmount,
                    transactionCurrency,
                    transactionReference,
                    targetTransactionId,
                    customerIpAddress );
            return data;
        }
        // [Snippet] howToConvertFormData - end

        String parseInitiate(HttpServletRequest request) {
            // Convert to JSON value if not empty or null.
            String orderReference = convertToJSonOrNull(request.getParameter("order[reference]"));
            String sourceOfFundsType = convertToJSonOrNull(request.getParameter("sourceOfFunds[type]"));
            String transactionReference = convertToJSonOrNull(request.getParameter("transaction[reference]"));
            String customerIpAddress = convertToJSonOrNull(request.getParameter("customer[ipAddress]"));
            String orderAmount = convertToJSonOrNull(request.getParameter("order[amount]"));
            String orderCurrency = convertToJSonOrNull(request.getParameter("order[currency]"));
            String apiOperation = convertToJSonOrNull(request.getParameter("apiOperation"));
            String returnUrl = convertToJSonOrNull(request.getParameter("browserPayment[returnUrl]"));
            String operation = convertToJSonOrNull(request.getParameter("browserPayment[paypal][operation]"));
            String paymentConfirmation = convertToJSonOrNull(request.getParameter("browserPayment[paypal][paymentConfirmation]"));
            String message = MessageFormat.format("'{'\"apiOperation\":{0},\"sourceOfFunds\":'{'\"type\":{1}'}'," +
                    "\"browserPayment\":'{'\"returnUrl\":{2},\"paypal\":'{'\"operation\":{3},\"paymentConfirmation\":{4}'}}'" +
                    ",\"order\":'{'\"reference\":{5},\"amount\":{6},\"currency\":{7}'}'" +
                    ",\"transaction\":'{'\"reference\":{8}'}'" +
                    ",\"customer\":'{'\"ipAddress\":{9}'}}'",
                    apiOperation,
                    sourceOfFundsType,
                    returnUrl,
                    operation,
                    paymentConfirmation,
                    orderReference,
                    orderAmount,
                    orderCurrency,
                    transactionReference,
                    customerIpAddress);
            return message;
        }

        String parseConfirm(HttpServletRequest request) {
            // Convert to JSON value if not empty or null.
            String orderReference = convertToJSonOrNull(request.getParameter("order[reference]"));
            String transactionReference = convertToJSonOrNull(request.getParameter("transaction[reference]"));
            String orderAmount = convertToJSonOrNull(request.getParameter("order[amount]"));
            String orderCurrency = convertToJSonOrNull(request.getParameter("order[currency]"));
            String apiOperation = convertToJSonOrNull(request.getParameter("apiOperation"));
            String message = MessageFormat.format("'{'\"apiOperation\":{0}" +
                    ",\"order\":'{'\"reference\":{1},\"amount\":{2},\"currency\":{3}'}'" +
                    ",\"transaction\":'{'\"reference\":{4}'}}'",
                    apiOperation,
                    orderReference,
                    orderAmount,
                    orderCurrency,
                    transactionReference);
            return message;
        }
    }
%>