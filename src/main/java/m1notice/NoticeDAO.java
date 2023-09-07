package m1notice;

import java.util.List;
import java.util.Map;
import java.util.Vector;
import common.JDBConnect;
import jakarta.servlet.ServletContext;

/* JDBC 이용한 DB연결위한 클래스상속 >  인수생성자에서는 application 내장객체를 매개변수로 전달
 * 부모생성자에서는 application 통해 web.xml에 직접 접근하여 컨텍스트 초기화 파라미터를 얻어온다.  */

public class NoticeDAO extends JDBConnect {

	public NoticeDAO(ServletContext application) {
		super(application);
	}

	//게시물 개수 카운트하여 int형으로 반환하는메소드
	public int selectCnt(Map<String, Object> map) {
		int totalcnt = 0;
		String sql = "SELECT COUNT(*) FROM "+map.get("tname");
		if(map.get("searchWord")!=null) sql += " WHERE "+map.get("searchField")+" LIKE '%"+map.get("searchWord")+"%'";
		try { 
			stmt = con.createStatement(); //정적 쿼리실행위한 Statement 객체생성
			rs = stmt.executeQuery(sql);
			rs.next(); //커서를 첫번쨰 행으로 이동하여 레코드를 읽는다. > 첫번째 컬럼 count(*) 의 값을 가져와서 변수에 저장
			totalcnt = rs.getInt(1);
		}catch(Exception e) {
			System.out.println("게시물 수를 구하는 중 예외발생");
			e.printStackTrace();
		}
		return totalcnt;
	}
	
/* 작성게시물을추출하여반환 > 반환값은 여러개 레코드를 반환할수있고 순서 보장해야하므로 List컬렉션 사용 
 * List컬렉션 생성 > 이때 타입매개변수는 notice 테이블 대상으로 하므로 NoticeDTO로 설정  */
	public List<NoticeDTO> selectList(Map<String, Object> map) {
		List<NoticeDTO> bbs = new Vector<NoticeDTO>(); //벡터는 리스트의 일종. ArrayList와 유사
		String sql = "SELECT * FROM "+map.get("tname");
		if(map.get("searchWord")!=null) sql += " WHERE "+map.get("searchField")+" LIKE '%"+map.get("searchWord")+"%'";
		sql += " ORDER BY idx DESC";
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			//2개 이상의 레코드가 반환될수있으므로 while문 사용 > setter이용하여 각컬럼값을 멤버변수에 저장	
			while(rs.next()) {
				NoticeDTO dto = new NoticeDTO();
				dto.setIdx(rs.getInt(1));
				dto.setTitle(rs.getString(2));
				dto.setContent(rs.getString(3));
				dto.setId(rs.getString(4));
				dto.setPostdate(rs.getDate(5));
				dto.setVisitcnt(rs.getInt(6));
				dto.setOfile(rs.getString(7));
				dto.setSfile(rs.getString(8));
				dto.setDowncnt(rs.getInt(9));
				dto.setLikecnt(rs.getInt(10));
				
				bbs.add(dto); //리스트에 dto추가
			}
		}catch(Exception e) {
			System.out.println("게시물 조회 중 예외발생"); 
			e.printStackTrace();
		}
		return bbs;
	}

//게시물 입력위한 메소드. 폼값이 저장된 dto객체를 인수로 받는다.
	public int insertWrite(NoticeDTO dto) {
		int result=0;
		try {
			String sql = "INSERT INTO "+dto.getTname()+" VALUES (seq_notice.NEXTVAL, ?, ?, ?, sysdate, 0, ?, ?, 0, 0)";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, dto.getTitle());
			psmt.setString(2, dto.getContent());
			psmt.setString(3, dto.getId());
			psmt.setString(4, dto.getOfile());
			psmt.setString(5, dto.getSfile());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("게시물 입력 중 예외발생");
			e.printStackTrace();
		} 
		return result;
	}
	
	public NoticeDTO selectView(int idx, String tname) {
		NoticeDTO dto = new NoticeDTO();
		String sql = "SELECT N.*, M.name FROM member M INNER JOIN "+tname+" N ON M.id=N.id WHERE N.idx=?";
		
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, idx);
			rs = psmt.executeQuery();
/* 일련번호는 중복되지 않으므로 단한개의 게시물을 추출한다. 따라서 while이아닌 if사용. 
 * next()메소드는 rs으로 반환된 게시물을 확인해서 존재하면 true 반환한다.
 * 각 컬럼값추출시 1부터시작한느 인덱스와 컬럼명 둘다사용가능. 날짜인 경우getDate()메소드로 추출가능 */
			if(rs.next()) {
				dto.setIdx(rs.getInt(1));
				dto.setTitle(rs.getString(2));
				dto.setContent(rs.getString(3));
				dto.setId(rs.getString(4));
				dto.setPostdate(rs.getDate(5));
				dto.setVisitcnt(rs.getInt(6));
				dto.setOfile(rs.getString(7));
				dto.setSfile(rs.getString(8));
				dto.setDowncnt(rs.getInt(9));
				dto.setLikecnt(rs.getInt(10));
				dto.setName(rs.getString(11));
				
			}
		}catch(Exception e) {
			System.out.println("게시물 상세보기 중 예외발생");
			e.printStackTrace();
		}
		return dto;
	}
	
	public void updateVisitcnt(int idx, String tname) {
		String sql = "UPDATE "+tname+" SET visitcnt=visitcnt+1 WHERE idx=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, idx);
			psmt.executeQuery();
		}catch(Exception e) {
			System.out.println("게시물 조회수 증가 중 예외발생");
			e.printStackTrace();
		}
	}

//게시물 수정하기 > 특정일련번호에 해당하는 게시물 수정
	public int updateEdit(NoticeDTO dto) {
		int result=0;
		try {
			String sql = "UPDATE "+dto.getTname()+" SET title=?, content=?, ofile=?, sfile=? WHERE idx=?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, dto.getTitle());
			psmt.setString(2, dto.getContent());
			psmt.setString(3, dto.getOfile());
			psmt.setString(4, dto.getSfile());
			psmt.setInt(5, dto.getIdx());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("게시물 수정 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public int deletePost(NoticeDTO dto) {
		int result=0;
		try {
			String sql = "DELETE FROM "+dto.getTname()+" WHERE idx=?";
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, dto.getIdx());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("게시물 삭제 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}

	public List<NoticeDTO> selectListPage(Map<String, Object> map) {
		List<NoticeDTO> bbs = new Vector<NoticeDTO>(); 
		/* 검색조선일치하는게시물얻어온후 각페이지에 출력할 쿼리작성 */
		String sql = "SELECT * FROM (SELECT T1.*, ROWNUM R FROM (SELECT * FROM "+map.get("tname");
		if(map.get("searchWord")!=null) {
			sql += " WHERE " + map.get("searchField")+ " LIKE '%" + map.get("searchWord") + "%'";
		}
		sql += " ORDER BY idx DESC) T1) WHERE R BETWEEN ? AND ?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, map.get("start").toString());
			psmt.setString(2, map.get("end").toString());
			rs = psmt.executeQuery();
			while(rs.next()) {
				NoticeDTO dto = new NoticeDTO();
				dto.setIdx(rs.getInt(1));
				dto.setTitle(rs.getString(2));
				dto.setContent(rs.getString(3));
				dto.setId(rs.getString(4));
				dto.setPostdate(rs.getDate(5));
				dto.setVisitcnt(rs.getInt(6));
				dto.setOfile(rs.getString(7));
				dto.setSfile(rs.getString(8));
				dto.setDowncnt(rs.getInt(9));
				dto.setLikecnt(rs.getInt(10));
				bbs.add(dto); //리스트에 dto추가
			}
		}catch(Exception e) {
			System.out.println("게시물 페이징 조회 중 예외발생"); 
			e.printStackTrace();
		}
		return bbs;
	}
	
	public int previousIdx(int idx, String tname) {
		int result = 0;
		String sql = "SELECT MIN(idx) FROM "+tname+" WHERE idx>"+idx;
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			result = rs.getInt(1);
		}catch(Exception e) {
			System.out.println("이전게시물 번호 구하는 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public int nextIdx(int idx, String tname) {
		int result = 0;
		String sql = "SELECT MAX(idx) FROM "+tname+" WHERE idx<"+idx;
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			result = rs.getInt(1);
		}catch(Exception e) {
			System.out.println("다음게시물 번호 구하는 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public int[] maxmin(String tname) {
		int[] maxmin = new int[2];
		String sql = "SELECT MAX(idx), MIN(idx) FROM "+tname;
		try { 
			stmt = con.createStatement(); //정적 쿼리실행위한 Statement 객체생성
			rs = stmt.executeQuery(sql);
			rs.next(); //커서를 첫번쨰 행으로 이동하여 레코드를 읽는다. > 첫번째 컬럼 count(*) 의 값을 가져와서 변수에 저장
			maxmin[0] = rs.getInt(1);
			maxmin[1] = rs.getInt(2);
		}catch(Exception e) {
			System.out.println("최대최소 게시물 번호 구하는 중 예외발생");
			e.printStackTrace();
		}
		return maxmin;
	}
	
	public void downcntPlus(int idx, String tname) {
		String sql = "UPDATE "+tname+" SET downcnt=NVL(downcnt, 0)+1 WHERE idx="+idx;
		try {
			stmt = con.createStatement();
			stmt.executeQuery(sql);
		}catch(Exception e) {
			System.out.println("게시물 다운로드수 증가 중 예외발생");
			e.toString();
		}
	}
	
	public void updateLikecnt(int idx, String tname) {
		String sql = "UPDATE "+tname+" SET likecnt=NVL(likecnt, 0)+1 WHERE idx=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, idx);
			psmt.executeQuery();
		}catch(Exception e) {
			System.out.println("좋아요 수 증가 중 예외발생");
			e.printStackTrace();
		}
	}
}
