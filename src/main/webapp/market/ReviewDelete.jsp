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
int ridx = Integer.parseInt(request.getParameter("comment_idx"));
int gidx = Integer.parseInt(request.getParameter("idx"));
CommentDTO rdto = new CommentDTO();
ReviewDAO rdao = new ReviewDAO(application);
rdto = rdao.selectView(ridx);
String sessionId = session.getAttribute("UserId").toString();

int delResult = 0;
if(rdto.getId().equals(sessionId)){
	rdto.setIdx(ridx);
	delResult = rdao.deletePost(rdto);
	rdao.close();
	System.out.println(ridx +" / "+sessionId +" / "+delResult);
	
	if(delResult == 1) {
		String sFileName = rdto.getSfile();
		FileUtil.deleteFile(request, "/Uploads", sFileName);
		JSFunction.alertLocation("리뷰가 삭제되었습니다.", "sub01_view.jsp?idx="+gidx, out);
	}
	else JSFunction.alertBack("리뷰 삭제에 실패했습니다.", out); //삭제실패시뒤로이동
}else{
	JSFunction.alertBack("본인만 삭제할 수 있습니다.", out); //작성자본인아니면 삭제불가
	return;
}
%>



