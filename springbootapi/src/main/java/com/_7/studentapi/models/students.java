package com._7.studentapi.models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class students {
  public Connection con =null;
    
       public String select_all_students() {
        String result = null;
        String SQL = "SELECT * FROM student_info.select_all_students()";
       Connection conn = con;
        try {
            
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                result = rs.getString("select_all_students");
            }
        } catch (SQLException e) {
            // Print Errors in console.
            result = e.getMessage();
            System.out.println(e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                }
            }
        }
        return result;
    }   
    public String add_new_student(String json_request) {
        String result = null;
        String SQL = "SELECT * FROM student_info.add_new_student(?)";
       Connection conn = con;
        try {
            
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, json_request);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                result = rs.getString("add_new_student");
            }
        } catch (SQLException e) {
            // Print Errors in console.
            result = e.getMessage();
            System.out.println(e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                }
            }
        }

        return result;
    }
}
