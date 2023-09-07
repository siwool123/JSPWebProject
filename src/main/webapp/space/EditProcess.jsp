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
int idx = Integer.parseInt(request.getParameter("idx"));
String title = request.getParameter("title");
String content = request.getParameter("content");
String prevOfile = request.getParameter("prevOfile");
String prevSfile = request.getParameter("prevSfile");

NoticeDTO dto = new NoticeDTO(); //폼값을 DTO객체에 저장한다.
dto.setIdx(idx);
dto.setTitle(title);
dto.setContent(content);
dto.setId(session.getAttribute("UserId").toString());
String oFileName = "";
String sDirectory = request.getServletContext().getRealPath("/Uploads/");

System.out.println(idx+" / "+title+" / "+content+" / "+prevOfile+" / "+prevSfile+" / "+sDirectory);

try{
	// Retrieves <input type="file" name="ofile" multiple="true">
	List<Part> fileParts = 
	    request.getParts().stream().filter(part -> "ofile".equals(part.getName()) && part.getSize() > 0).collect(Collectors.toList());

	for (Part filePart : fileParts) {
	    oFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
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
	    FileUtil.deleteFile(request, "/Uploads", prevSfile);
	}
}catch(Exception e) { 
	e.printStackTrace();
	JSFunction.alertBack("수정시 업로드한 파일명 얻어오는데 실패", out);
}
if(oFileName.equals("")){
	dto.setOfile(prevOfile);
    dto.setSfile(prevSfile);
}

NoticeDAO dao = new NoticeDAO(application);
int iResult = dao.updateEdit(dto); //기존처럼 게시물 1개를 등록할때 사용
dao.close();

System.out.println("dto세팅된 파일명 : " + dto.getOfile()+" / "+dto.getSfile()+" / 결과값 : "+iResult);

if (iResult == 1) JSFunction.alertLocation("게시글 수정에 성공했습니다.", "sub01_view.jsp?idx="+dto.getIdx(), out);
else JSFunction.alertBack("게시글 수정에 실패하였습니다.", out);
%>



