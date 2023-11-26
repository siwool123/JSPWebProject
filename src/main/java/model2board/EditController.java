package model2board;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import fileupload.FileUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import m1notice.NoticeDAO;
import m1notice.NoticeDTO;
import utils.JSFunction;
//요청명에 대한 매핑 > 수정페이지에서도 파일등록가능하므로 파일용량제한설정
@WebServlet("/community/sub01_edit.do")
@MultipartConfig( 
		maxFileSize = 1024*1024*3,
		maxRequestSize = 1024 * 1024 * 10
)
public class EditController extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String userId = session.getAttribute("UserId").toString();
		String tname = req.getParameter("tname");
		int idx = Integer.parseInt(req.getParameter("idx"));
		ServletContext application = getServletContext();
		NoticeDAO dao = new  NoticeDAO(application);
		NoticeDTO dto = dao.selectView(idx, tname);
		if(!userId.equals(dto.getId())){
			JSFunction.alertBack(resp, "작성자 본인만 수정할수있습니다.");
			return;
		}
		//첨부파일 확장자 추출 및 이미지 타입 확인
		String ext = "", fn = dto.getSfile();
		if(fn!=null) ext = fn.substring(fn.lastIndexOf(".")+1);		
		String[] imgStr = {"png", "jpg", "gif", "bmp"};
		List<String> imgList = Arrays.asList(imgStr);
		boolean isImage = false;
		if(imgList.contains(ext)) isImage = true; //첨부파일이 이미지이면 본문에 표시
		req.setAttribute("isImage", isImage);
		req.setAttribute("dto", dto);
		req.setAttribute("tname", tname);
		req.getRequestDispatcher("/community/sub01_edit.jsp").forward(req, resp);
	}

/* 수정내용입력후 전송폼값을 update쿼리문으로 갱신
 * 게시판은 post방식으로 전송되므로 dopost오버라이딩 */
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)	throws ServletException, IOException { 
		
		/*2. 파일업로드 외 처리 > 수정내용을 매개변수에서 얻어옴 
		 * 수정위해 hidden박스에저장된내용도 함께받아온다. 
		 * 게시물의 일련번호와 기존등록파일명이 함께 전송된다 */
		HttpSession session = req.getSession();
		String userId = session.getAttribute("UserId").toString();
		String tname = req.getParameter("tname");
		int idx = Integer.parseInt(req.getParameter("idx"));
		String prevOfile = req.getParameter("prevOfile");
		String prevSfile = req.getParameter("prevSfile");
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		
		//dto에 저장
		NoticeDTO dto = new NoticeDTO();
		dto.setTname(tname);
		dto.setIdx(idx);
		dto.setTitle(title);
		dto.setContent(content);
		dto.setId(userId);

//1. 파일업로드처리 > 업로드될 디렉토리의 물리적 경로 확인
		String sDirectory = req.getServletContext().getRealPath("/Uploads");
		String oFileName = ""; //파일업로드 
		try { 
			oFileName = FileUtil.uploadFile(req, sDirectory); 
		}catch(Exception e) { 
			e.printStackTrace();
			JSFunction.alertBack(resp, "개별 파일 용량은 3MB까지 업로드 가능합니다.");
			return; 
		}
/* 수정페이지에서 새로등록한파일있다면 기존내용수정해야함
 * 파일명 이름을 변경후 원본파일명과 저장파일명을 dto에 저장 */
		if(oFileName!="") {
			String sFileName = FileUtil.renameFile(sDirectory, oFileName);
			dto.setOfile(oFileName); //원본파일명 세팅
			dto.setSfile(sFileName); //서버에 저장된 파일명
			//기존파일삭제
			FileUtil.deleteFile(req, "/Uploads", prevSfile);
		}else {
			dto.setOfile(prevOfile); //첨부파일없으면 기존이름 유지
			dto.setSfile(prevSfile);
		}
		
		//DAO통해 DB에 수정내용반영
		ServletContext application = getServletContext();
		NoticeDAO dao = new NoticeDAO(application);
		int result = dao.updateEdit(dto);
		dao.close();
		
		//성공 or 실패?
		if(result==1)	JSFunction.alertLocation(resp, "게시글 수정에 성공했습니다.", "../community/sub01_view.do?tname="+tname+"&idx="+idx);
		else JSFunction.alertBack(resp, "게시글 수정에 실패했습니다.");
	}
}
