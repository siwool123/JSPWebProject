package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import m1notice.NoticeDAO;
import m1notice.NoticeDTO;

@WebServlet("/main/main.do")
public class MainCtrl extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		//DB연결
		NoticeDAO dao = new NoticeDAO(getServletContext());
		Map<String, Object> map = new HashMap<>();
		map.put("start", 1);
		map.put("end", 4);
		
		//공지사항 최근게시물4개추출
		map.put("tname", "notice");
		List<NoticeDTO> noticeL = dao.selectListPage(map);
		
		//자게 최근게시물 4개추출
		map.put("tname", "freeboard");
		List<NoticeDTO> freeboardL = dao.selectListPage(map);
		
		req.setAttribute("noticeL", noticeL);
		req.setAttribute("freeboardL", freeboardL);
		
		req.getRequestDispatcher("../main/main.jsp").forward(req, resp);
	}
	
}
