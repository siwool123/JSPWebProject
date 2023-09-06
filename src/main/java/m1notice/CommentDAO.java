package m1notice;

import java.util.List;
import java.util.Vector;

import common.JDBConnect;
import jakarta.servlet.ServletContext;

public class CommentDAO extends JDBConnect {
	
	public CommentDAO(ServletContext application) {
		super(application);
	}
	
	public List<CommentDTO> selectList(int idx) {
		List<CommentDTO> bbs = new Vector<CommentDTO>(); //벡터는 리스트의 일종. ArrayList와 유사
		String sql = "SELECT * FROM sua_comment WHERE board_idx="+idx;
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			//2개 이상의 레코드가 반환될수있으므로 while문 사용 > setter이용하여 각컬럼값을 멤버변수에 저장	
			while(rs.next()) {
				CommentDTO dto = new CommentDTO();
				dto.setIdx(rs.getInt(1));
				dto.setBoard_idx(rs.getInt(2));
				dto.setId(rs.getString(3));
				dto.setCommentdate(rs.getDate(4));
				dto.setParent_idx(rs.getInt(5));
				dto.setContent(rs.getString(6));
				dto.setLikecnt(rs.getInt(7));
				dto.setReplycnt(rs.getInt(8));
				
				bbs.add(dto); //리스트에 dto추가
			}
		}catch(Exception e) {
			System.out.println("답글 조회 중 예외발생"); 
			e.printStackTrace();
		}
		return bbs;
	}
	
	public void updateLikecnt(int idx) {
		String sql = "UPDATE sua_comment SET likecnt=NVL(likecnt, 0)+1 WHERE idx=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, idx);
			psmt.executeQuery();
		}catch(Exception e) {
			System.out.println("좋아요 수 증가 중 예외발생");
			e.printStackTrace();
		}
	}
	
	public void updateReplycnt(int idx) {
		String sql = "UPDATE sua_comment SET replycnt=NVL(replycnt, 0)+1 WHERE idx=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, idx);
			psmt.executeQuery();
		}catch(Exception e) {
			System.out.println("대댓글수 증가 중 예외발생");
			e.printStackTrace();
		}
	}
	
	//답글 입력위한 메소드. 폼값이 저장된 dto객체를 인수로 받는다.
	public int insertWrite(CommentDTO dto) {
		int result=0;
		try {
			String sql = "INSERT INTO sua_comment VALUES (seq_comment.NEXTVAL, ?, ?, SYSDATE, null, ?, 0, 0)";
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, dto.getBoard_idx());
			psmt.setString(2, dto.getId());
			psmt.setString(3, dto.getContent());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("답글 입력 중 예외발생");
			e.printStackTrace();
		} 
		return result;
	}
}
