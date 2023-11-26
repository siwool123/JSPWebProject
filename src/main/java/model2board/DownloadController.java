package model2board;

import java.io.IOException;

import fileupload.FileUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import m1notice.NoticeDAO;
import m1notice.NoticeDTO;

/* 요청명에대한 매핑은 어노테이션으로 설정 */
@WebServlet("/community/download.do")
public class DownloadController extends HttpServlet {
	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String tname = req.getParameter("tname");
		String ofile = req.getParameter("ofile"); //원본파일명
		String sfile = req.getParameter("sfile"); //저장파일명
		int idx = Integer.parseInt(req.getParameter("idx")); //게시물일련번호
		
		FileUtil.download(req, resp, "/Uploads", sfile, ofile);
		ServletContext application = getServletContext();
		NoticeDAO dao = new NoticeDAO(application);
		dao.downcntPlus(idx, tname);
		
		dao.close();
	}
}
