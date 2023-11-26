package m1notice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import common.JDBConnect;
import jakarta.servlet.ServletContext;
import membership.MemberDTO;

/* JDBC 이용한 DB연결위한 클래스상속 >  인수생성자에서는 application 내장객체를 매개변수로 전달
 * 부모생성자에서는 application 통해 web.xml에 직접 접근하여 컨텍스트 초기화 파라미터를 얻어온다.  */

public class GoodsDAO extends JDBConnect {

	public GoodsDAO(ServletContext application) {
		super(application);
	}

	//게시물 개수 카운트하여 int형으로 반환하는메소드
	public int selectCnt(HashMap<String, Object> map) {
		int totalcnt = 0;
		String sql = "SELECT COUNT(*) FROM sua_goods";
		if(map.get("searchWord")!=null) sql += " WHERE "+map.get("searchField")+" LIKE '%"+map.get("searchWord")+"%'";
		try { 
			stmt = con.createStatement(); //정적 쿼리실행위한 Statement 객체생성
			rs = stmt.executeQuery(sql);
			rs.next(); //커서를 첫번쨰 행으로 이동하여 레코드를 읽는다. > 첫번째 컬럼 count(*) 의 값을 가져와서 변수에 저장
			totalcnt = rs.getInt(1);
		}catch(Exception e) {
			System.out.println("상품 개수를 구하는 중 예외발생");
			e.printStackTrace();
		}
		return totalcnt;
	}
	
/* 작성게시물을추출하여반환 > 반환값은 여러개 레코드를 반환할수있고 순서 보장해야하므로 List컬렉션 사용 
 * List컬렉션 생성 > 이때 타입매개변수는 notice 테이블 대상으로 하므로 NoticeDTO로 설정  */
	public List<GoodsDTO> selectList(String keyword) {
		List<GoodsDTO> bbs = new Vector<GoodsDTO>(); //벡터는 리스트의 일종. ArrayList와 유사
		String sql = "SELECT * FROM sua_goods";
		if(keyword!=null) sql += " WHERE gname LIKE '%"+keyword+"%'";
		sql += " ORDER BY gidx DESC";
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			//2개 이상의 레코드가 반환될수있으므로 while문 사용 > setter이용하여 각컬럼값을 멤버변수에 저장	
			while(rs.next()) {
				GoodsDTO gdto = new GoodsDTO();
				gdto.setGidx(rs.getInt(1));
				gdto.setGname(rs.getString(2));
				gdto.setPrice(rs.getInt(3));
				gdto.setGregidate(rs.getDate(4));
				gdto.setStock(rs.getInt(5));
				gdto.setSale(rs.getInt(6));
				gdto.setContent(rs.getString(7));
				gdto.setOfile(rs.getString(8));
				gdto.setSfile(rs.getString(9));
				
				bbs.add(gdto); //리스트에 dto추가
			}
		}catch(Exception e) {
			System.out.println("상품 조회 중 예외발생"); 
			e.printStackTrace();
		}
		return bbs;
	}

//게시물 입력위한 메소드. 폼값이 저장된 dto객체를 인수로 받는다.
	public int insertWrite(GoodsDTO gdto) {
		int result=0;
		try {
			String sql = "INSERT INTO sua_goods VALUES (seq_goods.NEXTVAL, ?, ?, sysdate, ?, 0, ?, ?, ?)";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, gdto.getGname());
			psmt.setInt(2, gdto.getPrice());
			psmt.setInt(3, gdto.getStock());
			psmt.setString(4, gdto.getContent());
			psmt.setString(5, gdto.getOfile());
			psmt.setString(6, gdto.getSfile());
			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			System.out.println("상품 입력 중 예외발생");
			e.printStackTrace();
		} 
		return result;
	}
	
	public GoodsDTO selectView(int gidx) {
		GoodsDTO gdto = new GoodsDTO();
		String sql = "SELECT * FROM sua_goods WHERE gidx=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, gidx);
			rs = psmt.executeQuery();
/* 일련번호는 중복되지 않으므로 단한개의 게시물을 추출한다. 따라서 while이아닌 if사용. 
 * next()메소드는 rs으로 반환된 게시물을 확인해서 존재하면 true 반환한다.
 * 각 컬럼값추출시 1부터시작한느 인덱스와 컬럼명 둘다사용가능. 날짜인 경우getDate()메소드로 추출가능 */
			if(rs.next()) {
				gdto.setGidx(rs.getInt(1));
				gdto.setGname(rs.getString(2));
				gdto.setPrice(rs.getInt(3));
				gdto.setStock(rs.getInt(5));
				gdto.setSale(rs.getInt(6));
				gdto.setContent(rs.getString(7));
				gdto.setOfile(rs.getString(8));
				gdto.setSfile(rs.getString(9));
			}
		}catch(Exception e) {
			System.out.println("상품 상세보기 중 예외발생");
			e.printStackTrace();
		}
		return gdto;
	}
	
	public ArrayList<Object> selectView2(int gidx, String id) {
		ArrayList<Object> list = new ArrayList<>();
		GoodsDTO gdto = new GoodsDTO();
		MemberDTO mdto = new MemberDTO();
		String sql = "SELECT * FROM sua_goods cross join member WHERE gidx=? and id=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, gidx);
			psmt.setString(2, id);
			rs = psmt.executeQuery();
/* 일련번호는 중복되지 않으므로 단한개의 게시물을 추출한다. 따라서 while이아닌 if사용. 
 * next()메소드는 rs으로 반환된 게시물을 확인해서 존재하면 true 반환한다.
 * 각 컬럼값추출시 1부터시작한느 인덱스와 컬럼명 둘다사용가능. 날짜인 경우getDate()메소드로 추출가능 */
			if(rs.next()) {
				gdto.setGidx(rs.getInt(1));
				gdto.setGname(rs.getString(2));
				gdto.setPrice(rs.getInt(3));
				gdto.setStock(rs.getInt(5));
				gdto.setSale(rs.getInt(6));
				gdto.setContent(rs.getString(7));
				gdto.setOfile(rs.getString(8));
				gdto.setSfile(rs.getString(9));
				list.add(gdto);
				mdto.setId(rs.getString(10));
				mdto.setPw(rs.getString(11));
				mdto.setName(rs.getString(12));
				mdto.setEmail(rs.getString(13));
				mdto.setEmailok(rs.getString(14));
				mdto.setPhone(rs.getString(15));
				mdto.setAdd1(rs.getString(16));
				mdto.setAdd2(rs.getString(17));
				mdto.setAdd3(rs.getString(18));
				mdto.setGrade(rs.getInt(20));
				list.add(mdto);
			}
		}catch(Exception e) {
			System.out.println("상품 상세보기 중 예외발생");
			e.printStackTrace();
		}
		return list;
	}
	
	public int[] purchase(GoodsDTO gdto, MemberDTO mdto, int n, String msg, String pay) {
		int[] result = new int[2];
		String sql = "UPDATE sua_goods SET sale=sale+?, stock=stock-? WHERE gidx=?";
		String sql2 = "INSERT INTO sua_order VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
				+ " to_char(sysdate, 'yymmdd')||lpad(seq_goods.nextval, 4, 0), ?, ?)";
		try {
			psmt = con.prepareStatement(sql2);
			psmt.setInt(1, gdto.getGidx());
			psmt.setString(2, gdto.getGname());
			psmt.setInt(3, gdto.getPrice());
			psmt.setInt(4, gdto.getStock());
			psmt.setInt(5, gdto.getSale());
			psmt.setString(6, gdto.getContent());
			psmt.setString(7, gdto.getOfile());
			psmt.setString(8, gdto.getSfile());
			psmt.setString(9, mdto.getId());
			psmt.setString(10, mdto.getName());
			psmt.setString(11, mdto.getEmail());
			psmt.setString(12, mdto.getPhone());
			psmt.setString(13, mdto.getAdd1());
			psmt.setString(14, mdto.getAdd2());
			psmt.setString(15, mdto.getAdd3());
			psmt.setInt(16, mdto.getGrade());
			psmt.setString(17, msg);
			psmt.setString(18, pay);
			result[0] = psmt.executeUpdate();
			
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, n);
			psmt.setInt(2, n);
			psmt.setInt(3, gdto.getGidx());
			result[1] = psmt.executeUpdate();
			
		}catch(Exception e) {
			System.out.println("상품 구매 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}

//상품 정보 수정
	public int editgoods(GoodsDTO gdto) {
		int result=0;
		try {
			String sql = "UPDATE sua_goods SET gname=?, price=?, stock=?, content=?, ofile=?, sfile=? WHERE gidx=?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, gdto.getGname());
			psmt.setInt(2, gdto.getPrice());
			psmt.setInt(3,  gdto.getStock());
			psmt.setString(4, gdto.getContent());
			psmt.setString(5, gdto.getOfile());
			psmt.setString(6, gdto.getSfile());
			psmt.setInt(7, gdto.getGidx());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("상품 수정 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public int delgoods(GoodsDTO dto) {
		int result=0;
		try {
			String sql = "DELETE FROM sua_goods WHERE gidx=?";
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, dto.getGidx());
			result = psmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("상품 삭제 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}

	public List<GoodsDTO> selectListPage(Map<String, Object> map) {
		List<GoodsDTO> bbs = new Vector<GoodsDTO>(); 
		/* 검색조선일치하는게시물얻어온후 각페이지에 출력할 쿼리작성 */
		String sql = "SELECT * FROM (SELECT T1.*, ROWNUM R FROM (SELECT * FROM sua_goods";
		if(map.get("keyword")!=null) sql += " WHERE gname LIKE '%"+map.get("keyword")+"%'";
		sql += " ORDER BY gidx DESC) T1) WHERE R BETWEEN ? AND ?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, map.get("start").toString());
			psmt.setString(2, map.get("end").toString());
			rs = psmt.executeQuery();
			while(rs.next()) {
				GoodsDTO gdto = new GoodsDTO();
				gdto.setGidx(rs.getInt(1));
				gdto.setGname(rs.getString(2));
				gdto.setPrice(rs.getInt(3));
				gdto.setStock(rs.getInt(5));
				gdto.setSale(rs.getInt(6));
				gdto.setContent(rs.getString(7));
				gdto.setOfile(rs.getString(8));
				gdto.setSfile(rs.getString(9));
				
				bbs.add(gdto); //리스트에 dto추가
			}
		}catch(Exception e) {
			System.out.println("상품 페이징 조회 중 예외발생"); 
			e.printStackTrace();
		}
		return bbs;
	}
	
	public int previousIdx(int gidx) {
		int result = 0;
		String sql = "SELECT MIN(gidx) FROM sua_goods WHERE gidx>"+gidx;
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			result = rs.getInt(1);
		}catch(Exception e) {
			System.out.println("이전상품 번호 구하는 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public int nextIdx(int gidx) {
		int result = 0;
		String sql = "SELECT MAX(gidx) FROM sua_goods WHERE gidx<"+gidx;
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			result = rs.getInt(1);
		}catch(Exception e) {
			System.out.println("다음상품 번호 구하는 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public int[] maxmin() {
		int[] maxmin = new int[2];
		String sql = "SELECT MAX(gidx), MIN(gidx) FROM sua_goods";
		try { 
			stmt = con.createStatement(); //정적 쿼리실행위한 Statement 객체생성
			rs = stmt.executeQuery(sql);
			rs.next(); //커서를 첫번쨰 행으로 이동하여 레코드를 읽는다. > 첫번째 컬럼 count(*) 의 값을 가져와서 변수에 저장
			maxmin[0] = rs.getInt(1);
			maxmin[1] = rs.getInt(2);
		}catch(Exception e) {
			System.out.println("최대최소 상품 번호 구하는 중 예외발생");
			e.printStackTrace();
		}
		return maxmin;
	}
	
}
