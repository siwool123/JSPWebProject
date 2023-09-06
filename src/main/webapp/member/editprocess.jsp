<%@page import="membership.MemberDAO"%>
<%@page import="membership.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<% //수정폼에서입력한내용을 파라미터로 받는다.
String id = request.getParameter("id");
String name = request.getParameter("name");
String pw = request.getParameter("pw");
String email = request.getParameter("email1")+"@"+request.getParameter("email2");
String emailok = request.getParameter("emailok");
String phone = request.getParameter("tel1")+"-"+request.getParameter("tel2")+"-"+request.getParameter("tel3");
String add1 = request.getParameter("zip");
String add2 = request.getParameter("addr1");
String add3 = request.getParameter("addr2");

//dto객체에 수정할 내용을 저장
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

//DB연결위해 dao객체생성 > 
MemberDAO dao = new MemberDAO(application);
result = dao.updateMember(dto);
dao.close();

if(result==1){
	JSFunction.alertLocation(name+" 님, 회원정보 변경에 성공하였습니다.", "../main/main.jsp", out);
}else JSFunction.alertBack("회원정보 변경에 실패하였습니다.", out);
%>