package model2board;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.jsp.JspWriter;
import m1notice.NoticeDAO;
import m1notice.NoticeDTO;
import membership.MemberDAO;
import membership.MemberDTO;
import utils.BoardPage;
import utils.JSFunction;

@WebServlet("/community/sub01.do")
public class ListController extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		ServletContext application = getServletContext();
		NoticeDAO dao = new NoticeDAO(application);
		
		String tname = req.getParameter("tname");
		String searchField = req.getParameter("searchField");
		String searchWord = req.getParameter("searchWord");
		
		/* 게시물의 구간 및 검색어 관련 파라미터 저장위한 map컬렉션 생성
		 * req 통해 검색어 파라미터 받아와서, 검색어 포함게시물이있다면 map에 추가 
		 * 게시물갯수를 카운트 (검색어있다면 where절 추가) */
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tname", tname);
		if(searchWord != null) {
			map.put("searchField", searchField);
			map.put("searchWord", searchWord);
		}
		int totalCount = dao.selectCnt(map);
		
		/* 페이지 처리 start : 
	모델2 방식의 게시판에서는 요청을 서블릿이 먼저 받으므로 내장객체 사용위해 반드시 아래처럼 
	메소드로 객체 얻어온 후 사용해야한다 */
		
		int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
		int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));
		
		int pageNum = 1; //현재페이지 확인
		String pageTemp = req.getParameter("pageNum");
		if(pageTemp != null && !pageTemp.equals("")) pageNum = Integer.parseInt(pageTemp);

		/* 목록에 출력할 게시물 범위계산 : 페이지 시작번호와 종료번호 계산후 map컬렉션에 추가한다. */
		int start = (pageNum-1)*pageSize+1;
		int end = pageNum*pageSize;
		map.put("start", start);
		map.put("end", end);
		/* 페이지 처리 end */
		
		List<NoticeDTO> boardLists = dao.selectListPage(map); //해당페이지에 출력할 게시물을 list로 받기
		dao.close();
		
		//뷰로 전달할 매개변수 추가
		String pagingImg = BoardPage.pagingImg(totalCount, pageSize, blockPage, pageNum, "../community/sub01.do?tname="+tname);
		map.put("pagingImg", pagingImg); //페이지번호
		map.put("totalCount", totalCount); //전체게시물개수
		map.put("pageSize", pageSize); //한페이지에 출력할 개수
		map.put("pageNum", pageNum); //현재페이지 번호
		
		//뷰(jsp 페이지)로 전달할 데이터를 request 영역에 저장
		req.setAttribute("boardLists", boardLists);
		req.setAttribute("tname", tname);
		req.setAttribute("map", map);
		req.getRequestDispatcher("/community/sub01.do?tname="+tname).forward(req, resp);
	}
}
