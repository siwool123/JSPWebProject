package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.ServletContext;

public class JDBConnect {

	public Connection con; // DB연결
	public Statement stmt; // 정적쿼리실행
	public PreparedStatement psmt; // 동적쿼리문실행
	public ResultSet rs; // select 실행결과 반환

//기본생성자 : 매개변수가없는 생성자
	public JDBConnect() {
		try {
			Class.forName("oracle.jdbc.OracleDriver");
			String url = "jdbc:oracle:thin:@localhost:1521:xe";
			String id = "sua_project";
			String pw = "1234";
			con = DriverManager.getConnection(url, id, pw);

			System.out.println("DB 연결 성공 (기본생성자)");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

//인수생성자1
	public JDBConnect(String driver, String url, String id, String pw) {
		try {
			Class.forName(driver);
			con = DriverManager.getConnection(url, id, pw);
			System.out.println("DB 연결 성공 (인수생성자 1)");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

//인수생성자2 : jsp에서 application 내장객체를 매개변수로 전달한다.
	public JDBConnect(ServletContext application) {
		try { // 자바클래스의 메소드내에서 web.xml을 접근한다.
			String driver = application.getInitParameter("OracleDriver");
			Class.forName(driver);
			String url = application.getInitParameter("OracleURL");
			String id = application.getInitParameter("OracleId");
			String pw = application.getInitParameter("OraclePw");
			con = DriverManager.getConnection(url, id, pw);
			System.out.println("DB 연결 성공 (인수생성자 2)");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void close() {
		try {
			if (rs != null)	rs.close();
//			if(stmt!=null) stmt.close(); 
			if (psmt != null) psmt.close(); // 연결확인후 자원해제한다
			if (con != null) con.close();
			System.out.println("JDBC 자원해제");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
