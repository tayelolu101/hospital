/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package hospitalmanagementsystem;
import java.sql.*;
import javax.swing.JOptionPane;
/**
 *
 * @author abiolam
 */
public class HospitalDatabase {
   private static Connection con;
   public static Connection connect(){
       try{
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospital","root","");
       }catch(ClassNotFoundException ex){
           JOptionPane.showMessageDialog(null,"Database driver is missing "+ex,"Error", JOptionPane.ERROR_MESSAGE);
       }catch(SQLException ex){
           JOptionPane.showMessageDialog(null, "SQL error occured. " +ex,"Error", JOptionPane.ERROR_MESSAGE);
       }
       return con;
   }
   public static void disconnect(){
       if (con != null){
           try{
               con.close();
           }catch(SQLException ex){
               JOptionPane.showMessageDialog(null, "SQL error occured." +ex,"Error", JOptionPane.ERROR_MESSAGE);
           }
       }
   }
   
}
