<%@page import="utils.JSFunction"%>
<%@page import="m1notice.NoticeDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="m1notice.NoticeDAO"%>
<%@page import="utils.CookieManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
String sua_loginId = CookieManager.readCookie(request, "sua_loginId");
String cookie = "";
if(!sua_loginId.equals("")) cookie = "checked";

//DB연결
NoticeDAO dao = new NoticeDAO(application);
Map<String, Object> map = new HashMap<>();
map.put("start", 1);
map.put("end", 4);

//공지사항 최근게시물4개추출
map.put("tname", "notice");
List<NoticeDTO> noticeL = dao.selectListPage(map);
//자게 최근게시물 4개추출
map.put("tname", "freeboard");
List<NoticeDTO> freeboardL = dao.selectListPage(map);
//사진최근게시물 6개 추출
map.put("end", 6);
map.put("tname", "imageboard");
List<NoticeDTO> imageboardL = dao.selectListPage(map);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>마포구립장애인 직업재활센터</title>
<style type="text/css" media="screen">
@import url("../css/common.css");
@import url("../css/main.css");
@import url("../css/sub.css");
</style>
</head>
<script>
//로그인페이지 : 아이디/비번 검사 로직
function validateForm(form) {
	//입력값이 공백인지 확인후 경고창, 포커스이동, 폼값전송 중단처리를 한다.
    if (!form.user_id.value) {
        alert("아이디를 입력하세요.");
        form.user_id.focus();
        return false;
    }
    if (form.user_pw.value == "") {
        alert("패스워드를 입력하세요.");
        form.user_pw.focus();
        return false;
    }
}
var iframe = document.getElementById("myframe"); 
var cthide = iframe.contentWindow.document.getElementById('calendarTitle');
cthide.style.display = 'none';
</script>
<body>
<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp"%>
		
		<div id="main_visual">
		<a href="/product/sub01.jsp"><img src="../images/main_image_01.jpg" /></a><a href="/product/sub01_02.jsp"><img src="../images/main_image_02.jpg" /></a><a href="/product/sub01_03.jsp"><img src="../images/main_image_03.jpg" /></a><a href="/product/sub02.jsp"><img src="../images/main_image_04.jpg" /></a>
		</div>

		<div class="main_contents">
			<div class="main_con_left">
				<p class="main_title" style="border:0px; margin-bottom:0px;"><img src="../images/main_title01.gif" alt="로그인 LOGIN" /></p>
				<div class="login_box">

    <%
if (session.getAttribute("UserId") == null) { 
    %>			
<form action="../member/loginprocess.jsp" method="post" name="loginForm" onsubmit="return validateForm(this);">		
					<table cellpadding="0" cellspacing="0" border="0">
						<colgroup>
							<col width="45px" />
							<col width="120px" />
							<col width="55px" />
						</colgroup>
						<tr>
							<th><img src="../images/login_tit01.gif" alt="아이디" /></th>
							<td><input type="text" name="user_id" value="<%= sua_loginId %>" class="login_input" tabindex="1" /></td>
							<td rowspan="2"><input type="image" src="../images/login_btn01.gif" alt="로그인" tabindex="3" /></td>
						</tr>
						<tr>
							<th><img src="../images/login_tit02.gif" alt="패스워드" /></th>
							<td><input type="password" name="user_pw" value="" class="login_input" tabindex="2" /></td>
						</tr>
					</table>
					<p>
						<input type="checkbox" name="idsave" value="y" <%= cookie %> /><img src="../images/login_tit03.gif" alt="저장" />
						<a href="../member/id_pw.jsp"><img src="../images/login_btn02.gif" alt="아이디/패스워드찾기" /></a>
						<a href="../member/join01.jsp"><img src="../images/login_btn03.gif" alt="회원가입" /></a>
					</p>
					</form>
<%
}else{%>		 
					<!-- 로그인 후 -->
					<p style="padding:10px 0px 10px 10px"><span style="font-weight:bold; color:#333;"><%= session.getAttribute("UserName") %> 님,</span> 반갑습니다.<br />로그인 하셨습니다.</p>
					<p style="text-align:right; padding-right:10px;">
						<a href="../member/edit.jsp"><img src="../images/login_btn04.gif" /></a>
						<a href="../member/logout.jsp"><img src="../images/login_btn05.gif" /></a>
					</p>
<%} %>		
<div style="color: red; margin-top:20px;"> <%= request.getAttribute("LoginErrMsg")==null ? "" : request.getAttribute("LoginErrMsg") %></div>	 
				</div>
			</div>
			<div class="main_con_center">
				<p class="main_title"><img src="../images/main_title02.gif" alt="공지사항 NOTICE" /><a href="../space/sub01.jsp?tname=notice"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<ul class="main_board_list">
<% if(!noticeL.isEmpty()){
	for(NoticeDTO dto : noticeL){ %>
					<li><a href="../space/sub01_view.jsp?tname=notice&idx=<%= dto.getIdx()%>"><%= JSFunction.titleCut(dto.getTitle(), 23) %></a><span><%= dto.getPostdate() %></span></li>
<% }
} %>
				</ul>
			</div>
			<div class="main_con_right">
				<p class="main_title"><img src="../images/main_title03.gif" alt="자유게시판 FREE BOARD" /><a href="../space/sub01.jsp?tname=freeboard"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<ul class="main_board_list">
<% if(!freeboardL.isEmpty()){
	for(NoticeDTO dto : freeboardL){ %>
					<li><a href="../space/sub01_view.jsp?tname=freeboard&idx=<%= dto.getIdx()%>"><%= JSFunction.titleCut(dto.getTitle(), 23) %></a><span><%= dto.getPostdate() %></span></li>
<% }
} %>
				</ul>
			</div>
		</div>

		<div class="main_contents">
			<div class="main_con_left">
				<p class="main_title"><img src="../images/main_title04.gif" alt="월간일정 CALENDAR" /></p>
				<img src="../images/main_tel.gif" />
			</div>
			<div class="main_con_center">
				<p class="main_title" style="border:0px; margin-bottom:0px;"><img src="../images/main_title05.gif" alt="월간일정 CALENDAR" /><a href="../space/sub02.jsp"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<%-- <div class="cal_top">
					<table cellpadding="0" cellspacing="0" border="0">
						<colgroup>
							<col width="13px;" />
							<col width="*" />
							<col width="13px;" />
						</colgroup>
						<tr>
							<td><a href=""><img src="../images/cal_a01.gif" style="margin-top:3px;" /></a></td>
							<td><img src="../images/calender_2012.gif" />&nbsp;&nbsp;<img src="../images/calender_m1.gif" /></td>
							<td><a href=""><img src="../images/cal_a02.gif" style="margin-top:3px;" /></a></td>
						</tr>
					</table>
				</div>
				<div class="cal_bottom">
					<table cellpadding="0" cellspacing="0" border="0" class="calendar">
						<colgroup>
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th><img src="../images/day01.gif" alt="S" /></th>
							<th><img src="../images/day02.gif" alt="M" /></th>
							<th><img src="../images/day03.gif" alt="T" /></th>
							<th><img src="../images/day04.gif" alt="W" /></th>
							<th><img src="../images/day05.gif" alt="T" /></th>
							<th><img src="../images/day06.gif" alt="F" /></th>
							<th><img src="../images/day07.gif" alt="S" /></th>
						</tr>
						<tr>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">1</a></td>
							<td><a href="">2</a></td>
							<td><a href="">3</a></td>
						</tr>
						<tr>
							<td><a href="">4</a></td>
							<td><a href="">5</a></td>
							<td><a href="">6</a></td>
							<td><a href="">7</a></td>
							<td><a href="">8</a></td>
							<td><a href="">9</a></td>
							<td><a href="">10</a></td>
						</tr>
						<tr>
							<td><a href="">11</a></td>
							<td><a href="">12</a></td>
							<td><a href="">13</a></td>
							<td><a href="">14</a></td>
							<td><a href="">15</a></td>
							<td><a href="">16</a></td>
							<td><a href="">17</a></td>
						</tr>
						<tr>
							<td><a href="">18</a></td>
							<td><a href="">19</a></td>
							<td><a href="">20</a></td>
							<td><a href="">21</a></td>
							<td><a href="">22</a></td>
							<td><a href="">23</a></td>
							<td><a href="">24</a></td>
						</tr>
						<tr>
							<td><a href="">25</a></td>
							<td><a href="">26</a></td>
							<td><a href="">27</a></td>
							<td><a href="">28</a></td>
							<td><a href="">29</a></td>
							<td><a href="">30</a></td>
							<td><a href="">31</a></td>
						</tr>
						<tr>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
						</tr>
					</table>
				</div> --%>
				<iframe id="myframe" src="https://calendar.google.com/calendar/embed?height=600&wkst=1&bgcolor=%23ffffff&ctz=Asia%2FSeoul&showTitle=0&showTz=0&showNav=1&showCalendars=1&showPrint=0&src=ZDVjYTI1Yzk5MjQ1NWU5OGQ4YzgyMjA0MjQ0ZDM0OGIwZmFhNjhiY2IwODkzZDNlNzUyYmFjMzMxNzE2ZTM1Y0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t&src=a28uc291dGhfa29yZWEjaG9saWRheUBncm91cC52LmNhbGVuZGFyLmdvb2dsZS5jb20&color=%23F6BF26&color=%23D50000" width="100%" height="250" frameborder="0" scrolling="no"></iframe>
			</div>
			<div class="main_con_right">
				<p class="main_title"><img src="../images/main_title06.gif" alt="사진게시판 PHOTO BOARD" /><a href="../space/sub01.jsp?tname=imageboard"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<ul class="main_photo_list">
<% if(!imageboardL.isEmpty()){
	for(NoticeDTO dto : imageboardL){ %>
					<li>
						<dl>
						<a href="../space/sub01_view.jsp?tname=freeboard&idx=<%= dto.getIdx()%>">
							<dt><img src="../Uploads/<%= dto.getSfile() %>" style="width:95px;height:63px;border:1px solid #d1d1d1;" /></dt>
							<dd><%= JSFunction.titleCut(dto.getTitle(), 7) %></dd>
						</a>
						</dl>
					</li>
<% }} %>
				</ul>
			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>

	<%@ include file="../include/footer.jsp"%>
	
</center>
</body>
</html>