package fileupload;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/* 어노테이션 통해 매핑한다. 파일업로드 폼에서 submit하면 요청받아처리한다
 * 첨부파일 최대용량 설정 
 * maxFileSize : 개별파일의 최대용량으로 1Mb로 설정, 
 * maxRequestSize : 첨부할 전체파일의 용량으로 10Mb 설정
 * 
 *  파일업로드폼에서 전송방식은 post이므로 doPost를 오버라이딩한다
 * 파일 저장될 디렉토리의 물리적 경로 가져온다
 * 유틸리티 클래스의 uploadFile()호출하여 파일을 업로드한다
 * renameFile()호출하여 저장된 파일명 변경
 * 폼값 정리해서 테이블에 insert 처리한다.
 * 업로드 완료되면 파일목록페이지로 이동
 * 업로드 실패시 작성페이지로 포워드
 *  */
@WebServlet("/13FileUpload/UploadProcess.do")
@MultipartConfig(
	maxFileSize = 1024 * 1024, 
	maxRequestSize = 1024 * 1024 * 10
)
public class UploadProcess extends HttpServlet {
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			String sDirectory = getServletContext().getRealPath("/Uploads");
			
			String oFileName = FileUtil.uploadFile(req, sDirectory);
			
			String sFileName = FileUtil.renameFile(sDirectory, oFileName);
			
			insertMyFile(req, oFileName, sFileName);
			
			resp.sendRedirect("FileList.jsp"); //업로드 완료되면 파일목록페이지로 이동
		}catch(Exception e) {
			e.printStackTrace();
			req.setAttribute("errorMessage", "파일 업로드 오류");
			req.getRequestDispatcher("FileUploadMain.jsp").forward(req, resp);
		}
	}
	
	private void insertMyFile(HttpServletRequest req, String oFileName, String sFileName) {
		String title = req.getParameter("title");
		String[] cateArr = req.getParameterValues("cate");
		StringBuffer cateBuf = new StringBuffer();
		if(cateArr == null) cateBuf.append("선택한 항목 없음");
		else {
			for(String s:cateArr) cateBuf.append(s+", ");
		}
		System.out.println("파일외폼값 : "+title+"\n"+cateBuf);
		
/* dto객체에 폼값과 파일명(원본, 저장) 저장 > DAO객체생성하여 DBCP통해 오라클 연결
 * dto 객체 전달하여 테이블에 insert 한다 */
		MyFileDTO dto = new MyFileDTO();
		dto.setTitle(title);
		dto.setCate(cateBuf.toString());
		dto.setOfile(oFileName);
		dto.setSfile(sFileName);
		
		MyFileDAO dao = new MyFileDAO();
		dao.insertFile(dto);
		dao.close();
	}
}
