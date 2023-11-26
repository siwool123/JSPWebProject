package model2board;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import m1notice.CommentDAO;
import m1notice.CommentDTO;
import m1notice.NoticeDAO;
import m1notice.NoticeDTO;

/* 내용보기 매핑은 web.xml 아닌 어노테이션 통해 설정 */
@WebServlet("/community/sub01_view.do")
public class ViewController extends HttpServlet {
	
	/* 서블릿 수명주기 메서드 중 전송방식 상관없이 요청 처리하고 싶을때는 service()메서드를 오버라이딩하면 된다. 
	 * 해당 메서드 역할은 요청분석후 doget, dopost 를 호출하는 것이다
	 * 
	 * 파라미터로 전달된 일련번호 받는다 > 조회수1증가 > 게시물 인출
	 * 내용의 경우 Enter로 줄바꿈하므로 웹브라우저 출력시 <br>로 변경해야한다 > dto게시물을 request 영역에저장후 뷰로 포워드	 */
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ServletContext application = getServletContext();
		NoticeDAO dao = new NoticeDAO(application);
		int idx = Integer.parseInt(req.getParameter("idx")); 
		String tname = req.getParameter("tname");
		dao.updateVisitcnt(idx, tname);
		
		int[] maxmin = new int[2];
		maxmin = dao.maxmin(tname); //게시글번호 최대값, 최소값을 배열로 받아온다
		int prevIdx = dao.previousIdx(idx, tname); //이전 게시글 제목과 링크 달기위해 게시글번호 받아오기
		int nextIdx = dao.nextIdx(idx, tname); //다음게시글번호 받아오기
		
		NoticeDTO dto = dao.selectView(idx, tname);
		NoticeDTO pdto = dao.selectView(prevIdx, tname); //이전게시물dto받아오기
		NoticeDTO ndto = dao.selectView(nextIdx, tname); //다음게시물dto받아오기
		dao.close();
		
		dto.setContent(dto.getContent().replaceAll("\r\n", "<br/>"));
		
		//첨부파일 확장자 추출 및 이미지 타입 확인
		String ext = "", fileName = dto.getSfile();
		if(fileName!=null) ext = fileName.substring(fileName.lastIndexOf(".")+1);		
		String[] imgStr = {"png", "jpg", "gif", "bmp"};
		List<String> imgList = Arrays.asList(imgStr);
		boolean isImage = false;
		if(imgList.contains(ext)) isImage = true;
		
		CommentDAO cdao = new CommentDAO(application);
		List<CommentDTO> commentLists = cdao.selectList(idx); //해당게시물의 답변목록 받아오기
		cdao.close();
		
		req.setAttribute("dto", dto);
		req.setAttribute("commentLists", commentLists);
		req.setAttribute("isImage", isImage);
		req.setAttribute("tname", tname);
		req.setAttribute("maxmin", maxmin);
		req.setAttribute("pdto", pdto);
		req.setAttribute("ndto", ndto);
		req.setAttribute("prevIdx", prevIdx);
		req.setAttribute("nextIdx", nextIdx);
		req.getRequestDispatcher("/community/sub01_view.jsp?tname="+tname+"&idx="+idx).forward(req, resp);
	}
}
