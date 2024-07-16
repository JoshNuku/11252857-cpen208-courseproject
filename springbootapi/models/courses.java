package com._7.studentapi.models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class courses {
     public Connection con =null;
    
       public String select_all_courses_and_registrations() {
        String result = null;
        String SQL = "SELECT * FROM course_management.select_all_courses_and_registrations()";
       Connection conn = con;
        try {
            
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                result = rs.getString("select_all_courses_and_registrations");
            }
        } catch (SQLException e) {
            // Print Errors in console.
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
    public String add_new_course(String json_request) {
        String result = null;
        String SQL = "SELECT * FROM course_management.add_new_course(?)";
       Connection conn = con;
        try {
            
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, json_request);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                result = rs.getString("add_new_course");
            }
        } catch (SQLException e) {
            // Print Errors in console.
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

