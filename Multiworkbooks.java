/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduler;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

public class Multiworkbooks {

    private static final String FILE_NAME = "MyFirstExcel.xls";

    public static void main(String[] args) {

        double[] list = new double[]{4, 7, 6, 5, 9, 4, 7, 5, 6, 10, 8, 2, 3, 44, 78, 53};
        max(list);
        

        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("Datatypes in Java");
        Object[][] datatypes = {
            {"Datatype", "Type", "Size(in bytes)"},
            {"int", "Primitive", 2},
            {"float", "Primitive", 4},
            {"double", "Primitive", 8},
            {"char", "Primitive", 1},
            {"String", "Non-Primitive", "No fixed size"}
        };

        int rowNum = 0;
        System.out.println("Creating excel");

        for (Object[] datatype : datatypes) {

            Row row = sheet.createRow(rowNum++);
            int colNum = 0;
            for (Object field : datatype) {
                Cell cell = row.createCell(colNum++);
                if (field instanceof String) {
                    cell.setCellValue((String) field);
                } else if (field instanceof Integer) {
                    cell.setCellValue((Integer) field);
                }
            }
        }

        try {
            FileOutputStream outputStream = new FileOutputStream(FILE_NAME);
            workbook.write(outputStream);
            workbook.close();
        } catch (FileNotFoundException e) {
        } catch (IOException e) {
        }

        System.out.println("Done");

        String bello = "ILE_NAME";
        if (bello.length() == 3) {
            System.err.println("ERROR");
        } else {
            System.out.println("GOOD");
        }
    }

    public static void  max(double[] num) {
        double maxi = num[0];
         double sum = 0;
        for (double i : num) {
            if (i > maxi) {
                maxi = i;
            }    
            sum = sum + i;
        }
        System.out.println("Maxi : " +maxi);
        System.out.println("Sum : " +sum);
        
        double ave = (sum/maxi);
        System.out.println("Ave : " + ave);
    }
    
}
