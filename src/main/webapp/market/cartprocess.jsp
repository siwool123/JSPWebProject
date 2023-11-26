<%@page import="java.util.ArrayList"%>
<%@page import="utils.JSFunction"%>
<%@page import="utils.CookieManager"%>
<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
int gidx = Integer.parseInt(request.getParameter("idx"));
//세션에 cart 라는 이름의 속성 객체 얻어오기
Object obj = session.getAttribute("cart");

// 마약 이런 객체가 없다면 생성
if(obj == null){
	ArrayList<Integer> cart = new ArrayList<>();
	session.setAttribute("cart", cart); // 세션에 속성으로 지정
	obj = session.getAttribute("cart");
}

// arraylist 로 형변환
ArrayList<Integer> cartL = (ArrayList<Integer>)obj;
cartL.add(gidx);

System.out.println("cart : "+cartL.toString());
session.setAttribute("cart", cartL);
// 다시 리다이렉트
JSFunction.alertLocation("장바구니에 상품을 담았습니다. 장바구니로 이동합니다.", "cart.jsp", out);
%>