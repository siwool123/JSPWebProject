<%@page import="utils.JSFunction"%>
<%@page import="utils.CookieManager"%>
<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
String userId = request.getParameter("user_id");
String userPw = request.getParameter("user_pw");
String idsave = request.getParameter("idsave");

System.out.println(userId+" : "+userPw);

MemberDAO dao = new MemberDAO(application);
MemberDTO dto = dao.getMemberDTO(userId, userPw);
dao.close();
System.out.println(dto.getId());

if(dto.getId() != null){
	if (idsave != null && idsave.equals("y")) CookieManager.makeCookie(response, "sua_loginId", userId, 86400);
	else CookieManager.deleteCookie(response, "sua_loginId");
	session.setAttribute("UserId", dto.getId());
	session.setAttribute("UserName", dto.getName());
	JSFunction.alertLocation(dto.getName()+" 님, 로그인에 성공했습니다.", "../main/main.jsp", out);
}else{
	JSFunction.alertBack("아이디와 비밀번호가 일치하지 않습니다. 다시 입력해주세요.", out);
	//request.setAttribute("LoginErrMsg", "아이디와 비밀번호를 다시 입력해주세요.");
	//request.getRequestDispatcher("/member/login.jsp").forward(request, response);
}
%>