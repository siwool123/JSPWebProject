<%@page import="m1notice.ReviewDAO"%>
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
//클라이언트가 작성한 폼값을 받아온다.
String sDirectory = request.getServletContext().getRealPath("/Uploads/");
int gidx=Integer.parseInt(request.getParameter("idx"));
CommentDTO rdto = new CommentDTO();
rdto.setBoard_idx(gidx);
rdto.setId(session.getAttribute("UserId").toString());
rdto.setContent(request.getParameter("content"));
rdto.setStar(Integer.parseInt(request.getParameter("starCnt")));

/*img파일업로드용 프로세스*/
List<Part> fileParts = 
    request.getParts().stream().filter(part -> "rofile".equals(part.getName()) && part.getSize() > 0).collect(Collectors.toList());

for (Part p : fileParts) {
    String roFileName = Paths.get(p.getSubmittedFileName()).getFileName().toString();
    String rsFileName = FileUtil.renameFile(sDirectory, roFileName);
    
    String dst = sDirectory + rsFileName;
	
    try (BufferedInputStream fin = new BufferedInputStream(p.getInputStream());
        BufferedOutputStream fout = new BufferedOutputStream(new FileOutputStream(dst))) 
    { 	int data;
        while (true) {
            data = fin.read();             
            if(data == -1)  break;             
            fout.write(data);
        }
    } catch(IOException e) { e.printStackTrace();}       
    System.out.println("Uploaded Filename: " + dst + ", "+roFileName+ ",  "+rsFileName);
    rdto.setOfile(roFileName);
    rdto.setSfile(rsFileName);
}

ReviewDAO rdao = new ReviewDAO(application);
int iResult = rdao.insertWrite(rdto); //기존처럼 게시물 1개를 등록할때 사용
rdao.close();
if (iResult == 1) JSFunction.alertLocation("리뷰 작성에 성공했습니다.", "sub01_view.jsp?idx="+gidx, out);
else JSFunction.alertBack("리뷰 작성에 실패하였습니다.", out);
%>



