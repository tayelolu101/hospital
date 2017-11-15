
import java.io.IOException;
import java.util.regex.*;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.*;
import org.apache.commons.httpclient.StatusLine;
import org.apache.commons.httpclient.auth.AuthScope;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author appdev2
 */
public class Correct {

//     public static final String EXAMPLE_TEST = "This is my small example "
//            + "string which I'm going to " + "use for pattern matching.";
    public static void main(String[] args) {

        String URLL = "";
        HttpClient client = new HttpClient();
        HttpMethod method = new PostMethod(URLL);
        method.setDoAuthentication(true);
        HostConfiguration hostConfig = client.getHostConfiguration();
        hostConfig.setHost("172.29.38.8");
        hostConfig.setProxy("172.29.90.4", 8);
        //   NTCredentials proxyCredentials = new NTCredentials("", "", "", "");
        client.getState().setCredentials(AuthScope.ANY, new UsernamePasswordCredentials("", ""));
////        try {
////            URL url = new URL("");
////            HttpURLConnection urls = (HttpURLConnection) url.openConnection();
////            
////           
////        } catch (MalformedURLException ex) {
////            Logger.getLogger(Correct.class.getName()).log(Level.SEVERE, null, ex);
////        } catch (IOException ex) {
////            Logger.getLogger(Correct.class.getName()).log(Level.SEVERE, null, ex);
////        }
        try {
            // send the transaction
            client.executeMethod(hostConfig, method);
            StatusLine status = method.getStatusLine();

            if (status != null && method.getStatusCode() == 200) {

                System.out.println(method.getResponseBodyAsString() + "\n Status code : " + status);

            } else {

                System.err.println(method.getStatusLine()+"\n: Posting Failed !");
            }

        } catch (IOException ioe) {

            ioe.printStackTrace();

        }
        method.releaseConnection();

    }

    public static String getStartUp(String word) {
        
        return word;
    }

    public static void execute(String One, String Two) {

        Two = Two.replaceAll("\\\\n", "\n");
        try {
            System.out.println("Regex = " + One);
            System.out.println("Input = " + Two);

            Pattern pattern = Pattern.compile(One);
            Matcher match = pattern.matcher(Two);

            while (match.find()) {
                System.out.println("Found [" + match.group() + "]\nStarting at " + match.start() + " , \nEnding at " + (match.end() - 1));
            }
        } catch (PatternSyntaxException pse) {

            System.err.println("Bad regex: " + pse.getMessage());
            System.err.println("Description: " + pse.getDescription());
            System.err.println("Index: " + pse.getIndex());
            System.err.println("Incorrect pattern: " + pse.getPattern());
        }
    }
    
    
    
        
        

    
}
