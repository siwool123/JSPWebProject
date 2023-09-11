package model2board;

import java.io.IOException;
import java.util.ArrayList;

import fileupload.FileDAO;
import fileupload.FileDTO;
import fileupload.FileUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import m1notice.Notice2DAO;
import m1notice.NoticeDAO;
import m1notice.NoticeDTO;
import utils.JSFunction;

/* 글쓰기 위한 서블릿은 doGet과 doPost 둘다오버라이딩한다
 * 글쓰기 페이지로 진입시 get방식의 요청이고, 전송눌러 폼값 서버전송시 post방식으로 요청하게된다 */
@WebServlet("/community/sub01_write.do")
public class WriteController extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/community/sub01_write.jsp").forward(req, resp);
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)	throws ServletException, IOException { 
	//1. 파일업로드처리 > 업로드될 디렉토리의 물리적 경로 확인
	String sDirectory = req.getServletContext().getRealPath("/Uploads");
	String oFileName = "";
	try { 
		oFileName = FileUtil.uploadFile(req, sDirectory); 
	}catch(Exception e) { 
		e.printStackTrace();
		JSFunction.alertBack(resp, "개별 파일 용량은 2MB까지 업로드 가능합니다.");
		return; 
	}
	
	String tname = req.getParameter("tname");
	//2. 파일업로드 외 처리 > 첨부파일 이외의 폼값을 dto에 저장 
	NoticeDTO dto = new NoticeDTO();
	dto.setTitle(req.getParameter("title"));
	dto.setContent(req.getParameter("content"));
	dto.setTname(tname);
	HttpSession session = req.getSession();
	dto.setId(session.getAttribute("UserId").toString());
	
	/* 첨부파일이 정상적으로 등록되어 원본파일명 반환됐다면 > 파일명을 날짜_시간.확장자 형식으로 변경 > 원본과 변경된 파일명을 DTO에 저장	 */
	if(oFileName!="") {
		String sFileName = FileUtil.renameFile(sDirectory, oFileName);
		dto.setOfile(oFileName); //원본파일명 세팅
		dto.setSfile(sFileName); //서버에 저장된 파일명
	}
	
	//ServletContext application = getServletContext();
	//DAO통해 DB에 게시내용 저장
	Notice2DAO dao = new Notice2DAO();
	//int result = dao.insertWrite(dto);
	//더미게시물입력위해 반복문 사용
	int iResult = 0;
	for(int i=1; i<=100; i++){
		dto.setTitle(req.getParameter("title")+"-"+i);
		iResult = dao.insertWrite(dto);
	}
	dao.close();
	
	//성공 or 실패?
	if(iResult==1)	JSFunction.alertLocation(resp, "게시글 작성에 성공했습니다.", "../community/sub01.do?tname="+tname);
	else JSFunction.alertBack(resp, "게시글 작성에 실패했습니다.");
	}
}
