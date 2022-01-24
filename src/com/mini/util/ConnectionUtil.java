package com.mini.util;

import java.sql.*;

public class ConnectionUtil {

	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
		} catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
		
	}
	
	
	public static Connection getConnection() throws Exception {
		String url = "jdbc:oracle:thin:@localhost:1521:XE";
		String userId = "hr";
		String userPwd = "zxcv1234";
		
		Connection conn = DriverManager.getConnection(url, userId, userPwd); 
		
		return conn;
	}
	
	
}
