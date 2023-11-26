<%@page import="m1notice.ReviewDAO"%>
<%@page import="m1notice.NoticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int comment_idx = Integer.parseInt(request.getParameter("comment_idx"));
System.out.println("전송된폼값 : "+comment_idx);
ReviewDAO cdao = new ReviewDAO(application);
int result = cdao.updateLikecnt(comment_idx);
if(result==1) out.println("성공");
else out.println("실패");
%>