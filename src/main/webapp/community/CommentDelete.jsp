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
<!-- 로그인 페이지에 오랫동안 머물러 세션이 삭제되는 경우가 있으므로
글쓰기 처리 페이지에서도 반드시 로그인을 확인해야한다.  -->    
 
<%
String tname = request.getParameter("tname");
int idx = Integer.parseInt(request.getParameter("idx"));
System.out.println(idx);

int comment_idx = Integer.parseInt(request.getParameter("comment_idx"));
CommentDTO cdto = new CommentDTO();
CommentDAO cdao = new CommentDAO(application);
cdto = cdao.selectView(comment_idx);
String sessionId = session.getAttribute("UserId").toString();

int delResult = 0;
if(cdto.getId().equals(sessionId)){
	cdto.setIdx(comment_idx);
	delResult = cdao.deletePost(cdto);
	cdao.close();
	
	System.out.println(comment_idx +" / "+sessionId +" / "+delResult);
	
	if(delResult == 1) JSFunction.alertLocation("답글이 삭제되었습니다.", "sub01_view.jsp?tname="+tname+"&idx="+idx, out);
	else JSFunction.alertBack("답글 삭제에 실패했습니다.", out); //삭제실패시뒤로이동
}else{
	JSFunction.alertBack("본인만 삭제할 수 있습니다.", out); //작성자본인아니면 삭제불가
	return;
}
%>



