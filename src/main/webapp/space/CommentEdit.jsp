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
String content = request.getParameter("content");
int idx = Integer.parseInt(request.getParameter("idx"));
int comment_idx = Integer.parseInt(request.getParameter("comment_idx"));
CommentDTO cdto = new CommentDTO();

cdto.setIdx(comment_idx);
//cdto.setBoard_idx(idx);
//cdto.setId(session.getAttribute("UserId").toString());
cdto.setContent(content);

CommentDAO cdao = new CommentDAO(application);
int iResult = cdao.updateEdit(cdto); 
cdao.close();
System.out.println(iResult);
if (iResult == 1) JSFunction.alertLocation("답글 수정에 성공했습니다.", "sub01_view.jsp?idx="+idx, out);
else JSFunction.alertBack("답글 수정에 실패하였습니다.", out);
%>



