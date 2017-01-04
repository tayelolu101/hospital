/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package hospitalmanagementsystem;

/**
 *
 * @author abiolam
 */
public interface PatientMangement {
    void add(Patient p);
    void update(Patient p);
    Patient getPatient(String patientId);
    Patient[] getAllPatient();
    void delete(String patient);
    Patient[] search(String patientname);
    boolean exists(String patientId);
}
