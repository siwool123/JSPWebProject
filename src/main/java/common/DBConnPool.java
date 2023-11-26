package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


/* JNDI(Java Naming and Directory Interface) : 
 디렉토리 서비스에서 제공하는 데이터 및 객체를 찾아서 참조(lookup)하는
 api로 쉽게말하면 외부에 있는 객체를 이름으로 찾아오기 위한 기술
 
DBCP(Database Connection Pool : 커넥션풀) : 
DB와 연결된 커넥션 객체를 미리 ㅁ나들어 풀에 저장해뒀다 필요할때 가져다
쓰고 반납하는 기법. DB 부하 줄이고 자원을 효율적으로 관리할수있다. */
public class DBConnPool {
	public Connection con; 
	public Statement stmt; 
	public PreparedStatement psmt; 
	public ResultSet rs; 
	
/* 커넥션풀 설정 위해 context.xml, server.xml 파일에 엘리먼트를 추가해야한다.
 * 1. Context 객체 생성 > Tomcat 웹서버 생성 
 * 2. 앞에서 생성한 객체로 JNDI 서비스 구조의 초기 root 디렉토리를 얻어온다.
 *	해당 디렉토리 이름은 탐캣 서버경로를 의미한다. 
 * 3. server.xml 에 등록한 네이밍을 lookup하여 DataSource를 얻어온다. 
 * 	 즉 DB연결위한 정보를 갖고있다.
 * 4. 커넥션풀에 생성해둔 객체를 가져다가 사용한다. */
	public DBConnPool() {
		try {
			Context initCtx = new InitialContext();
			Context ctx = (Context)initCtx.lookup("java:comp/env");
			DataSource source = (DataSource)ctx.lookup("dbcp_myoracle");
			con = source.getConnection();
			System.out.println("DB 커넥션 풀 연결 성공");
		}catch(Exception e){
			System.out.println("DB 커넥션 풀 연결 실패");
			e.printStackTrace();
		}
	}
//여기서 close는 객체의 소멸이 아닌 반납이다.
	public void close() {
		try {
			if(rs!=null) rs.close();
			if(stmt!=null) stmt.close(); 
			if(psmt!=null) psmt.close(); //연결확인후 자원해제한다
			if(con!=null) con.close();
			System.out.println("DB 커넥션 풀 자원 반납");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
