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
String tname = request.getParameter("tname");
String sDirectory = request.getServletContext().getRealPath("/Uploads/");

String title = request.getParameter("title");
String content = request.getParameter("content");
System.out.println(sDirectory+" : "+title+" : "+content+"<br>"+request.getSession().getServletContext().getRealPath("/"));

NoticeDTO dto = new NoticeDTO(); //폼값을 DTO객체에 저장한다.
dto.setTitle(title);
dto.setContent(content);
dto.setId(session.getAttribute("UserId").toString());

//파일업로드용 프로세스
//String filePath = "C:/Users/TJ/02Workspaces/09JSPServlet/JSPWebProject/src/main/webapp/Uploads/";

// Retrieves <input type="file" name="ofile" multiple="true">
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
    } catch(IOException e) { e.printStackTrace();}       
    System.out.println("Uploaded Filename: " + dst + ",  "+oFileName+ ",  "+sFileName);
    
    dto.setOfile(oFileName);
    dto.setSfile(sFileName);
}
dto.setTname(tname);
NoticeDAO dao = new NoticeDAO(application);
int iResult = dao.insertWrite(dto); //기존처럼 게시물 1개를 등록할때 사용
//더미게시물입력위해 반복문 사용
/*int iResult = 0;
for(int i=1; i<=100; i++){
	dto.setTitle(title+"-"+i);
	iResult = dao.insertWrite(dto);
}*/
dao.close();

if (iResult == 1) JSFunction.alertLocation("게시글 작성에 성공했습니다.", "sub01.jsp?tname="+tname, out);
else JSFunction.alertBack("게시글 작성에 실패하였습니다.", out);
%>



