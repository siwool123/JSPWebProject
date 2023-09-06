<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//로그아웃 처리1 : session 영역의 속성명을 지정하여 삭제
session.removeAttribute("UserId");
session.removeAttribute("UserName");

//세션영역 전체속성을 한꺼번에 삭제. 만약 회원인증 이외 데이터있다면 사용시주의
session.invalidate(); 
//로그아웃 처리후 로그인페이지로 '이동' 한다.
response.sendRedirect("login.jsp");
%>