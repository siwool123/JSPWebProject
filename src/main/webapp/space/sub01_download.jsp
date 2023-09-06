<%@page import="m1notice.NoticeDAO"%>
<%@page import="fileupload.FileUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String ofile = request.getParameter("ofile"); //원본파일명
String sfile = request.getParameter("sfile"); //저장파일명
int idx = Integer.parseInt(request.getParameter("idx")); //게시물일련번호

FileUtil.download(request, response, "/Uploads", sfile, ofile);

NoticeDAO dao = new NoticeDAO(application);
dao.downcntPlus(idx);
dao.close();
%>