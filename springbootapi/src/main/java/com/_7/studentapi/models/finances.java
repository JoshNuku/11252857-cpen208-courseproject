package com._7.studentapi.models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class finances {
    public Connection con =null;
    
       public String get_outstanding_fees() {
        String result = null;
        String SQL = "SELECT * FROM finance.get_outstanding_fees()";
       Connection conn = con;
        try {
            
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                result = rs.getString("get_outstanding_fees");
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
