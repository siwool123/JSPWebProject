package membership;

import common.JDBConnect;
import jakarta.servlet.ServletContext;

public class MemberDAO extends JDBConnect {

	public MemberDAO(ServletContext application) {
		super(application);
	}

	public MemberDAO(String driver, String url, String id, String pw) {
		super(driver, url, id, pw);
	}

	public MemberDTO getMemberDTO(String uid, String upw) {
		MemberDTO dto = new MemberDTO();
		String sql = "SELECT * FROM member WHERE id=? AND pw=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, uid);
			psmt.setString(2, upw);
			rs = psmt.executeQuery();

			if (rs.next()) { // 반환된 rs객체에 정보가있는지 확인
				dto.setId(rs.getString(1));
				dto.setPw(rs.getString(2));
				dto.setName(rs.getString(3));
				dto.setEmail(rs.getString(4));
				dto.setEmailok(rs.getString(5));
				dto.setPhone(rs.getString(6));
				dto.setAdd1(rs.getString(7));
				dto.setAdd2(rs.getString(8));
				dto.setAdd3(rs.getString(9));
				dto.setRegidate(rs.getDate(10));
				dto.setGrade(rs.getInt(11));
				dto.setPoint(rs.getInt(12));;
			}else {
				System.out.println("rs 에 정보가없습니다");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	public MemberDTO idfind(String uname, String uemail) {
		MemberDTO dto = new MemberDTO();
		String sql = "SELECT * FROM member WHERE name=? AND email=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, uname);
			psmt.setString(2, uemail);
			rs = psmt.executeQuery();
			if (rs.next()) { // 반환된 rs객체에 정보가있는지 확인
				dto.setId(rs.getString(1));
				dto.setName(rs.getString(3));
			}else System.out.println("미등록 회원입니다. 회원가입을 진행해주세요.");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	public MemberDTO pwfind(String id, String name) {
		MemberDTO dto = new MemberDTO();
		String sql = "SELECT * FROM member WHERE id=? and name=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, id);
			psmt.setString(2, name);
			rs = psmt.executeQuery();
			if (rs.next()) { // 반환된 rs객체에 정보가있는지 확인
				dto.setId(rs.getString(1));
				dto.setPw(rs.getString(2));
				dto.setName(rs.getString(3));
				dto.setEmail(rs.getString(4));
			}else System.out.println("미등록 회원입니다. 회원가입을 진행해주세요.");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	public int memberjoinDTO(MemberDTO dto) {
		String sql = "INSERT INTO member VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, 3, 0)";
		int affected = 0;
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, dto.getId());
			psmt.setString(2, dto.getPw());
			psmt.setString(3, dto.getName());
			psmt.setString(4, dto.getEmail());
			psmt.setString(5, dto.getEmailok());
			psmt.setString(6, dto.getPhone());
			psmt.setString(7, dto.getAdd1());
			psmt.setString(8, dto.getAdd2());
			psmt.setString(9, dto.getAdd3());
			
			affected = psmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return affected;
	}

	public int checkId(String id) {
		int result=0;
		String sql = "SELECT * FROM member WHERE id=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, id);
			rs = psmt.executeQuery();
			if (rs.next()) result=1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public MemberDTO viewMember(String uid) {
		MemberDTO dto = new MemberDTO();
		String sql = "SELECT * FROM member WHERE id=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, uid);
			rs = psmt.executeQuery();
			if(rs.next()) {
				dto.setId(rs.getString(1));
				dto.setPw(rs.getString(2));
				dto.setName(rs.getString(3));
				dto.setEmail(rs.getString(4));
				dto.setEmailok(rs.getString(5));
				dto.setPhone(rs.getString(6));
				dto.setAdd1(rs.getString(7));
				dto.setAdd2(rs.getString(8));
				dto.setAdd3(rs.getString(9));
				dto.setRegidate(rs.getDate(10));
				dto.setGrade(rs.getInt(11));
				dto.setPoint(rs.getInt(12));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	public int updateMember(MemberDTO dto) {
		int result = 0;
		String sql = "UPDATE member SET pw=?, name=?, email=?, emailok=?, phone=?, add1=?, add2=?, add3=? WHERE id=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, dto.getPw());
			psmt.setString(2, dto.getName());
			psmt.setString(3, dto.getEmail());
			psmt.setString(4, dto.getEmailok());
			psmt.setString(5, dto.getPhone());
			psmt.setString(6, dto.getAdd1());
			psmt.setString(7, dto.getAdd2());
			psmt.setString(8, dto.getAdd3());
			psmt.setString(9, dto.getId());
			result = psmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("회원정보 변경 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
	
	public int updatePoint(String id, int point) {
		int result = 0;
		String sql = "UPDATE member SET point=point+? WHERE id=?";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, point);
			psmt.setString(2, id);
			result = psmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("포인트 변경 중 예외발생");
			e.printStackTrace();
		}
		return result;
	}
}
