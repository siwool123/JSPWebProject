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
				CommentDTO cdto = new CommentDTO();
				cdto.setIdx(rs.getInt(1));
				cdto.setBoard_idx(rs.getInt(2));
				cdto.setId(rs.getString(3));
				cdto.setCommentdate(rs.getDate(4));
				cdto.setContent(rs.getString(5));
				cdto.setLikecnt(rs.getInt(6));
				cdto.setStar(rs.getInt(7));
				cdto.setOfile(rs.getString(8));
				cdto.setSfile(rs.getString(9));
				
				bbs.add(cdto); //리스트에 dto추가
			}
		}catch(Exception e) {
			System.out.println("답글 조회 중 예외발생"); 
			e.printStackTrace();
		}
		return bbs;
	}
	
	public int updateLikecnt(int idx) {
		int result = 0;
		String sql = "UPDATE sua_comment SET likecnt=likecnt+1 WHERE idx=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, idx);
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("좋아요 수 증가 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	//답글 입력위한 메소드. 폼값이 저장된 dto객체를 인수로 받는다.
	public int insertWrite(CommentDTO cdto) {
		int result=0;
		try {
			String sql = "INSERT INTO sua_comment VALUES (seq_comment.NEXTVAL, ?, ?, SYSDATE, ?, 0, ?, ?, ?)";
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, cdto.getBoard_idx());
			psmt.setString(2, cdto.getId());
			psmt.setString(3, cdto.getContent());
			psmt.setInt(4, cdto.getStar());
			psmt.setString(5, cdto.getOfile());
			psmt.setString(6, cdto.getSfile());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("답글 입력 중 예외발생 : "+result+", "+cdto.getBoard_idx()+", "+cdto.getId()+", "+cdto.getContent());
			e.printStackTrace();
		} 
		return result;
	}
	
	public CommentDTO selectView(int idx) {
		CommentDTO cdto = new CommentDTO();
		String sql = "SELECT * FROM sua_comment WHERE idx=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, idx);
			rs = psmt.executeQuery();
/* 일련번호는 중복되지 않으므로 단한개의 게시물을 추출한다. 따라서 while이아닌 if사용. 
 * next()메소드는 rs으로 반환된 게시물을 확인해서 존재하면 true 반환한다.
 * 각 컬럼값추출시 1부터시작한느 인덱스와 컬럼명 둘다사용가능. 날짜인 경우getDate()메소드로 추출가능 */
			if(rs.next()) {
				cdto.setIdx(rs.getInt(1));
				cdto.setBoard_idx(rs.getInt(2));
				cdto.setId(rs.getString(3));
				cdto.setCommentdate(rs.getDate(4));
				cdto.setContent(rs.getString(5));
				cdto.setLikecnt(rs.getInt(6));
				cdto.setStar(rs.getInt(7));
				cdto.setOfile(rs.getString(8));
				cdto.setSfile(rs.getString(9));
			}
		}catch(Exception e) {
			System.out.println("답글불러오기 중 예외발생");
			e.printStackTrace();
		}
		return cdto;
	}
	
	//답글 수정하기 > 특정일련번호에 해당하는 게시물 수정
	public int updateEdit(CommentDTO cdto) {
		int result=0;
		try {
			String sql = "UPDATE sua_comment SET content=?, star=?, ofile=? sfile=? WHERE idx=?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, cdto.getContent());
			psmt.setInt(2, cdto.getStar());
			psmt.setString(3, cdto.getOfile());
			psmt.setString(4, cdto.getSfile());
			psmt.setInt(5, cdto.getIdx());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("답글 수정 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public int deletePost(CommentDTO cdto) {
		int result=0;
		try {
			String sql = "DELETE FROM sua_comment WHERE idx=?";
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, cdto.getIdx());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("답글 삭제 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
}
