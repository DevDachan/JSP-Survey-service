package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletContext;


public class DatabaseUtil {
	public Connection con;
	public Statement stmt;
	public PreparedStatement psmt;
	public ResultSet rs;
	
	public DatabaseUtil(ServletContext application) {
		try {
			
			String driver = application.getInitParameter("MysqlDriver");
			Class.forName(driver);		

			String dbURL = application.getInitParameter("MysqlURL");
			String dbID = application.getInitParameter("MysqlID");
			String dbPassword = application.getInitParameter("MysqlPassword");
			
			
			con = DriverManager.getConnection(dbURL,dbID, dbPassword);

		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void endclose() {
		try {
			if(rs != null) rs.close();
			if(stmt != null) rs.close();
			if(psmt != null) rs.close();
			if(con != null) con.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
}
