/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hospitalmanagementsystem;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.swing.JOptionPane;

/**
 *
 * @author abiolam
 */
public class PatientDatabseManager implements PatientMangement {

    @Override
    public void add(Patient p) {
        try {
            Connection con = HospitalDatabase.connect();
            PreparedStatement insert = con.prepareCall("insert into Patient values(?,?,?,?,?,?,?,?)");
            insert.setString(1, p.getPatientId());
            insert.setString(2, p.getSurname());
            insert.setString(3, p.getFirstname());
            insert.setString(4, p.getOthername());
            insert.setString(5, p.getGender());
            insert.setString(6, p.getPhonenumber());
            insert.setString(7, p.getAddress());
            insert.setBytes(8, p.getPhoto());
            if (insert.executeUpdate() == 1) {
                JOptionPane.showMessageDialog(null, "Patient added successfully", "Add Patient", JOptionPane.ERROR_MESSAGE);
               
            } else {
                JOptionPane.showMessageDialog(null, "SQL error occured.", "Error", JOptionPane.ERROR_MESSAGE);
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "SQL error occured." + ex, "Error", JOptionPane.ERROR_MESSAGE);
        }
        HospitalDatabase.disconnect();
    }

    @Override
    public void update(Patient p) {
        try {
            Connection con = HospitalDatabase.connect();
            PreparedStatement insert = con.prepareCall("update patient set surname=?, firstname=?, othername=?, gender=?, phone=?, Address=?, passport=?   where pid = ?");
            insert.setString(1, p.getSurname());
            insert.setString(2, p.getFirstname());
            insert.setString(3, p.getOthername());
            insert.setString(4, p.getGender());
            insert.setString(5, p.getPhonenumber());
            insert.setString(6, p.getAddress());
            insert.setBytes(7, p.getPhoto());
            insert.setString(8, p.getPatientId());
            insert.executeUpdate();
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "SQL error occured. " + ex, "Error", JOptionPane.ERROR_MESSAGE);
        }
        HospitalDatabase.disconnect();
    }

    @Override
    public Patient getPatient(String patientId) {
        Patient p = null;
        try (Connection con = HospitalDatabase.connect()) {
            CallableStatement query = con.prepareCall("{call sp_getPatient(?)}");
            query.setString(1, patientId);
            ResultSet table = query.executeQuery();
            if (table.next()) {
                p = new Patient();
                p.setPatientId(patientId);
                p.setSurname(table.getString(2));
                p.setFirstname(table.getString(3));
                p.setOthername(table.getString(4));
                p.setGender(table.getString(5));
                p.setPhonenumber(table.getString(6));
                p.setAddress(table.getString(7));
                p.setPhoto(table.getBytes(8));
                table.close();
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "SQL error occured.", "Error", JOptionPane.ERROR_MESSAGE);
        }
        HospitalDatabase.disconnect();
        return p;
    }
    @Override
    public Patient[] getAllPatient() {
        Patient patients[] = null;
        ArrayList<Patient> ps = new ArrayList<>();
        try (Connection con = HospitalDatabase.connect()) {
            CallableStatement query = con.prepareCall("{call sp_getAllPatients()}");
            ResultSet table = query.executeQuery();
            while (table.next()) {
                ps.add(getPatient(table.getString(1)));
            }
            table.close();
            ps.trimToSize();
            patients = new Patient[ps.size()];
            patients = ps.toArray(patients);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "SQL error occured.", "Error", JOptionPane.ERROR_MESSAGE);
        }
        HospitalDatabase.disconnect();
        return patients;
    }

    @Override
    public void delete(String Patient) {

        try (Connection con = HospitalDatabase.connect()) {
            String query = "{call sp_deletePatient(?)}";
            PreparedStatement pmt = con.prepareCall(query);
            pmt.setString(1, Patient);
//                pmt.setString(2, p.getSurname());
//                pmt.setString(3, p.getFirstname());
//                pmt.setString(4, p.getOthername());
//                pmt.setString(5, p.getGender());
//                pmt.setString(1, p.getPhonenumber());
//                pmt.setString(1, p.getAddress());
//                pmt.setBytes(1, p.getPhoto());
            pmt.executeUpdate();

            HospitalDatabase.disconnect();
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "SQL error occured. " + ex, "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    @Override
    public Patient[] search(String patientname) {
        Patient patients[] = null;
        ArrayList<Patient> p = new ArrayList<>();
        try (Connection con = HospitalDatabase.connect()) {
            CallableStatement query = con.prepareCall("select * from patient where surname like ?");
            query.setString(1, "%" + patientname + "%");
            ResultSet table = query.executeQuery();
            while (table.next()) {
                p.add(getPatient(table.getString(1)));
            }
            table.close();
            p.trimToSize();
            patients = new Patient[p.size()];
            patients = p.toArray(patients);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "SQL error occured. " + ex, "Error", JOptionPane.ERROR_MESSAGE);
        }
        HospitalDatabase.disconnect();
        return patients;

    }

    @Override
    public boolean exists(String patientId) {
        return getPatient(patientId) != null;
    }

}
