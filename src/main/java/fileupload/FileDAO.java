package fileupload;

import java.util.List;
import java.util.Vector;

import common.DBConnPool;
import common.JDBConnect;
import jakarta.servlet.ServletContext;

/* 커넥션풀 이용해서 오라클 DB에 연결한다.
 * 설정정보는 server.xml, context.xml에 기술되어있다.
 * 이클립스는 복사본 사용하고, 원본은 Tomcat10.1 디렉토리 하위의 conf 폴더에 위치한다
 * 
 *  인파라미터있는 동적쿼리문 작성. 클라이언트가 폼값을 dto에 저장후 전달하면 해당 쿼리문의 인파라미터를 설정한다 */
public class FileDAO extends JDBConnect {
	
	public FileDAO(ServletContext application) {
		super(application);
	}
	
	public int insertFile(FileDTO dto) {
		int result = 0;
		try {
			String sql = "INSERT INTO boardfile VALUES (seq_notice.nextval, ?, ?, ?, 0, SYSDATE)";
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, dto.getBoard_idx());
			psmt.setString(2, dto.getOfile());
			psmt.setString(3, dto.getSfile());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("INSERT 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public List<FileDTO> FileList(int board_idx){
		
		List<FileDTO> flist = new Vector<FileDTO>();
		String sql = "SELECT * FROM boardfile WHERE board_idx="+board_idx;
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			while(rs.next()) {
				FileDTO dto = new FileDTO();
				dto.setIdx(rs.getInt(1));
				dto.setOfile(rs.getString(3));
				dto.setSfile(rs.getString(4));
				dto.setDowncnt(rs.getInt(5));
				dto.setPostdate(rs.getString(6));
				flist.add(dto);
			}
		}catch(Exception e) {
			System.out.println("SELECT 시 예외 발생");
			e.printStackTrace();
		}
		return flist;
	}
}
