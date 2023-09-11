package m1notice;

import java.sql.Date;
/* 멤버변수 : board 테이블 컬럼과 동일하게 선언
 * member 테이블과의 조인 통해 회원이름 출력해야할때 위해 멤버변수추가
 * 특별한이유없다면 생성자 따로 선언하지않는다.  */
public class NoticeDTO {
	private int idx;
	private String title;
	private String content;
	private String id;
	private Date postdate;
	private int visitcnt;
	private String ofile;
	private String sfile;
	private int downcnt;
	private String name;
	private int likecnt;
	private String tname;
	
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Date getPostdate() {
		return postdate;
	}
	public void setPostdate(Date postdate) {
		this.postdate = postdate;
	}
	public int getVisitcnt() {
		return visitcnt;
	}
	public void setVisitcnt(int visitcnt) {
		this.visitcnt = visitcnt;
	}
	public String getOfile() {
		return ofile;
	}
	public void setOfile(String ofile) {
		this.ofile = ofile;
	}
	public String getSfile() {
		return sfile;
	}
	public void setSfile(String sfile) {
		this.sfile = sfile;
	}
	public int getDowncnt() {
		return downcnt;
	}
	public void setDowncnt(int downcnt) {
		this.downcnt = downcnt;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getLikecnt() {
		return likecnt;
	}
	public void setLikecnt(int likecnt) {
		this.likecnt = likecnt;
	}
	public String getTname() {
		return tname;
	}
	public void setTname(String tname) {
		this.tname = tname;
	}
	
}
