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
import utils.JSFunction;

/* 검증페이지로 진입시 get 방식으로 처리한다
 * 페이지로 전달되는 파라미터가 컨트롤러에서 필요한 경우엔 request 내장객체 통해 받아 사용한다
 * 만약 jsp에서 필요하면 el의 내장객체 param을 이용하면된다 */

@WebServlet("/community/delete.do")
public class Delete extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String tname = req.getParameter("tname");
		int idx = Integer.parseInt(req.getParameter("idx"));
		ServletContext application = getServletContext();
		NoticeDAO dao = new NoticeDAO(application);
		/*기존게시물 내용을 가져온다. > 게시물삭제 > 게시물삭제성공시 첨부파일도 삭제	
		 * 서버에 실제 저장된 파일명으로 삭제 > 삭제완료시 목록으로 이동 / 비번불칠치 시 뒤로이동 */
		NoticeDTO dto = new NoticeDTO();
		dto = dao.selectView(idx, tname);
		int result = dao.deletePost(dto);
		dao.close();
		
		System.out.println(idx +" / "+tname +" / "+result);
		if(result==1) {
			String sFileName = dto.getSfile();
			FileUtil.deleteFile(req, "/Uploads", sFileName);
			JSFunction.alertLocation(resp, "삭제되었습니다.", "sub01.do?tname="+tname);
		}
		else JSFunction.alertBack(resp, "삭제에 실패했습니다.");
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)	throws ServletException, IOException { 
		
		
	}
}
