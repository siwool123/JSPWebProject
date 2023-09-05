<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<% 
String userName = request.getParameter("user_name");
String userEmail = request.getParameter("user_email");

System.out.println(userName+" : "+userEmail);
MemberDAO dao = new MemberDAO(application);
MemberDTO dto = dao.idfind(userName, userEmail);
dao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 - 상세보기</title>
<script type="text/javascript">
//게시물삭제위한js함수 > confirm함수는 대화창에서 예 클릭시 true반환된다.
/* form 태그의 name속성통해 DOM을 얻어온다.
전송방식과 전송경로를 지정한다 > submit 함수로 폼값전송 
폼태그하위의 hidden타입설정된 일련번호전송 */
function deletePost() {
	var confirmed = confirm("정말로 삭제하시겠습니까?");
    if (confirmed) {
        var form = document.writeFrm;
        form.method = "post";
        form.action = "DeleteProcess.jsp";
        form.submit();
    }
}
</script>
</head>
<body>
<center>
<div id="wrap">
	<%@ include file="../include/top.jsp" %>
	<img src="../images/member/sub_image.jpg" id="main_visual" />
	<div class="contents_box">
		<div class="left_contents">
			<%@ include file = "../include/member_leftmenu.jsp" %>
		</div>
		<div class="right_contents">
		<% if(dto.getId() != null){		%>
		<p style="padding:10px"><span style="font-weight:bold; color:#333;"><%= dto.getName() %> 님,</span> <br />
		아이디는 <%= dto.getId() %> 입니다.</p>
		<p style="text-align:right; padding-right:10px;">
			<a href="login.jsp" style="border:1px solid red; padding:0 20px;"><img src="../images/lnb01.gif" /></a>
			<a href="join01.jsp"><img src="../images/login_btn03.gif" /></a>
		</p>
		<% }else{
			request.setAttribute("LoginErrMsg", "회원이름과 이메일을 다시 입력해주세요.");
			request.getRequestDispatcher("id_pw.jsp").forward(request, response);
		} %>
<div style="color: red; margin-top:20px;"> <%= request.getAttribute("LoginErrMsg")==null ? "" : request.getAttribute("LoginErrMsg") %></div>
		</div>
	</div>
	<%@ include file="../include/quick.jsp" %>
</div>
<%@ include file="../include/footer.jsp" %>
</center>
 </body>
</html>