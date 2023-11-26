package m1notice;

import java.sql.Date;
/* 멤버변수 : board 테이블 컬럼과 동일하게 선언
 * member 테이블과의 조인 통해 회원이름 출력해야할때 위해 멤버변수추가
 * 특별한이유없다면 생성자 따로 선언하지않는다.  */
public class GoodsDTO {
	private int gidx;
	private String gname;
	private int price;
	private Date gregidate;
	private int stock;
	private int sale;
	private String content;
	private String ofile;
	private String sfile;	
	
	public int getGidx() {
		return gidx;
	}
	public void setGidx(int gidx) {
		this.gidx = gidx;
	}
	public String getGname() {
		return gname;
	}
	public void setGname(String gname) {
		this.gname = gname;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public Date getGregidate() {
		return gregidate;
	}
	public void setGregidate(Date gregidate) {
		this.gregidate = gregidate;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public int getSale() {
		return sale;
	}
	public void setSale(int sale) {
		this.sale = sale;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
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
	
}
