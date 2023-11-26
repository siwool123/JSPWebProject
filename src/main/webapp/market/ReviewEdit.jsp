<%@page import="m1notice.ReviewDAO"%>
<%@page import="m1notice.CommentDAO"%>
<%@page import="m1notice.CommentDTO"%>
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
<!-- 로그인 페이지에 오랫동안 머물러 세션이 삭제되는 경우가 있으므로 글쓰기 처리 페이지에서도 반드시 로그인을 확인해야한다.  -->    
<%
int gidx = Integer.parseInt(request.getParameter("idx"));
int comment_idx = Integer.parseInt(request.getParameter("comment_idx"));
String prevrOfile = request.getParameter("prevROfile");
String prevrSfile = request.getParameter("prevRSfile");
int pStarcnt = Integer.parseInt(request.getParameter("prevStarCnt"));

CommentDTO rdto = new CommentDTO();
rdto.setIdx(comment_idx);
rdto.setContent(request.getParameter("content"));
rdto.setStar(Integer.parseInt(request.getParameter("starCnt")));

String roFileName = "";
String sDirectory = request.getServletContext().getRealPath("/Uploads/");
try{
/*img파일업로드용 프로세스*/
List<Part> fileParts = 
	    request.getParts().stream().filter(part -> "rofile".equals(part.getName()) && part.getSize() > 0).collect(Collectors.toList());

for (Part filePart : fileParts) {
	roFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
    String rsFileName = FileUtil.renameFile(sDirectory, roFileName);
    
    String dst = sDirectory + rsFileName;
	
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
    System.out.println("Uploaded Filename: " + dst + ",  "+roFileName+ ",  "+rsFileName);
    rdto.setOfile(roFileName);
    rdto.setSfile(rsFileName);
    FileUtil.deleteFile(request, "/Uploads", prevrSfile);
}
}catch(Exception e) { 
	e.printStackTrace();
	JSFunction.alertBack("리뷰수정시 업로드한 파일명 얻어오는데 실패", out);
}
if(roFileName.equals("")){
	rdto.setOfile(prevrOfile);
    rdto.setSfile(prevrSfile);
}

ReviewDAO rdao = new ReviewDAO(application);
int iResult = rdao.updateEdit(rdto); 
rdao.close();
System.out.println(iResult);
if (iResult == 1) JSFunction.alertLocation("리뷰 수정에 성공했습니다.", "sub01_view.jsp?idx="+gidx, out);
else JSFunction.alertBack("리뷰 수정에 실패하였습니다.", out);
%>



