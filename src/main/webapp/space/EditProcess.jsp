<%@page import="java.io.IOException"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.List"%>
<%@page import="fileupload.FileUtil"%>
<%@page import="m1notice.NoticeDTO"%>
<%@page import="m1notice.NoticeDAO"%>
<%@page import="utils.JSFunction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<!-- 로그인 페이지에 오랫동안 머물러 세션이 삭제되는 경우가 있으므로
글쓰기 처리 페이지에서도 반드시 로그인을 확인해야한다.  -->    
 
<%
//클라이언트가 작성한 폼값을 받아온다. 
String sDirectory = request.getServletContext().getRealPath("/Uploads/");
String ofile = "";
try{
	Part part = request.getPart("ofile");
	String partHeader = part.getHeader("content-disposition");
	
	String[] phArr = partHeader.split("filename=");
	ofile = phArr[1].trim().replace("\"", "");
	
	System.out.println("partHeader="+partHeader+", ofile="+ofile);
}catch(Exception e) { 
	e.printStackTrace();
	JSFunction.alertBack("수정시 업로드한 원본파일명 얻어오는데 실패", out);
}

int idx = Integer.parseInt(request.getParameter("idx"));
String prevOfile = request.getParameter("prevOfile");
String prevSfile = request.getParameter("prevSfile");
String title = request.getParameter("title");
String content = request.getParameter("content");

System.out.println(sDirectory+" : "+title+" : "+content+" : "+ofile);

NoticeDTO dto = new NoticeDTO(); //폼값을 DTO객체에 저장한다.
dto.setTitle(title);
dto.setContent(content);
dto.setId(session.getAttribute("UserId").toString());

//파일업로드용 프로세스
//String filePath = "C:/Users/TJ/02Workspaces/09JSPServlet/JSPWebProject/src/main/webapp/Uploads/";

// Retrieves <input type="file" name="ofile" multiple="true">
if(ofile!="") {
List<Part> fileParts = 
    request.getParts().stream().filter(part -> "ofile".equals(part.getName()) && part.getSize() > 0).collect(Collectors.toList());

for (Part filePart : fileParts) {
    String oFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
    String sFileName = FileUtil.renameFile(sDirectory, oFileName);
    
    String dst = sDirectory + sFileName;
	
    try (BufferedInputStream fin = new BufferedInputStream(filePart.getInputStream());
        BufferedOutputStream fout = new BufferedOutputStream(new FileOutputStream(dst))) 
    { 	int data;
        while (true) {
            data = fin.read();             
            if(data == -1)  break;             
            fout.write(data);
        }
    } catch(IOException e) { 
    	e.printStackTrace();
    	JSFunction.alertBack("개별 파일 용량은 1MB까지 업로드 가능합니다.", out);
    }       
    System.out.println("Uploaded Filename: " + dst + ",  "+oFileName+ ",  "+sFileName);
    
    dto.setOfile(oFileName);
    dto.setSfile(sFileName);
}
FileUtil.deleteFile(request, "/Uploads", prevSfile);
}else {
	dto.setOfile(prevOfile); //첨부파일없으면 기존이름 유지
	dto.setSfile(prevSfile);
}
NoticeDAO dao = new NoticeDAO(application);
int iResult = dao.updateEdit(dto); //기존처럼 게시물 1개를 등록할때 사용
dao.close();

if (iResult == 1) JSFunction.alertLocation("게시글 수정에 성공했습니다.", "sub01_view.jsp?idx="+dto.getIdx(), out);
else JSFunction.alertBack("게시글 수정에 실패하였습니다.", out);
%>



