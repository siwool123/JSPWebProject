<%@page import="utils.JSFunction"%>
<%@page import="membership.MemberDAO"%>
<%@page import="membership.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String id = request.getParameter("id");
String pw = request.getParameter("pw");
String name = request.getParameter("name");
String email = request.getParameter("email1")+"@"+request.getParameter("email2");
String emailok = request.getParameter("emailok");
String phone = request.getParameter("tel1")+"-"+request.getParameter("tel2")+"-"+request.getParameter("tel3");
String add1 = request.getParameter("zip");
String add2 = request.getParameter("addr1");
String add3 = request.getParameter("addr2");

/* 회원가입 성공한경우 > 세션 영역에 회원아이디와 이름을 저장 > 로그인페이지로 '이동' 한다.
회원가입 실패한 경우 > request 영역에 에러메세지 저장 > 회원가입 페이지로 '포워드' 한다.  */
int result = 0;
MemberDTO dto = new MemberDTO();
dto.setId(id);
dto.setPw(pw);
dto.setName(name);
dto.setEmail(email);
dto.setEmailok(emailok);
dto.setPhone(phone);
dto.setAdd1(add1);
dto.setAdd2(add2);
dto.setAdd3(add3);

MemberDAO dao = new MemberDAO(application);
result = dao.memberjoinDTO(dto);
dao.close();

if(result==1){
	JSFunction.alertLocation(dto.getName()+" 님, 회원가입을 환영합니다.", "/JSPWebProject/main/main.jsp", out);
}else{
	JSFunction.alertBack("회원가입에 실패하였습니다.", out);
}
%>