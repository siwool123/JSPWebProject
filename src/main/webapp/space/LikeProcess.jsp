<%@page import="m1notice.NoticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String tname = request.getParameter("tname");
System.out.println(tname);
int idx = Integer.parseInt(request.getParameter("idx"));
out.println("전송된폼값 : "+idx);
NoticeDAO dao = new NoticeDAO(application);
int result = dao.updateLikecnt(idx, tname);
if(result==1) out.println("성공");
else out.println("실패");
%>