<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@page import="utils.JSFunction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
/* 로그인 체크를 위한 파일로 세션영역에 userid라는 속석값 없으면  js로 alert 띄운후 로그인페이지로 
이동 location 한다. 로그인이 필요한 모든페이지 상다넹 include 지시어로 포함시킬예정이다.
return : jsp가 tomcat에서 java 로 변환되면 스크립트렛에 작성된 코드는 _jspService() 메소드 내부에 기술된다. 
따라서 return 은 해당메소드의 실행을 종료한다는 의미를 가진다. return 이후 문장은 실행되지 않는다.
*/
if(session.getAttribute("UserId") == null){
	JSFunction.alertLocation("로그인 후 이용해주세요.", "../member/login.jsp", out);
	return;
}
%>