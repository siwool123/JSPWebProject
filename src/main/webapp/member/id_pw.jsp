<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<script>
//아이디찾기 로직
function validateForm(form) {
    if (!form.user_name.value) {
        alert("회원이름을 입력하세요.");
        form.user_name.focus();
        return false;
    }
    if (form.user_email.value == "") {
        alert("이메일 주소를 입력하세요.");
        form.user_email.focus();
        return false;
    }
}
</script>
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
				<div class="top_title">
					<img src="../images/member/id_pw_title.gif" alt="" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;아이디/비밀번호찾기<p>
				</div>
<form action="idfind.jsp" method="post" name="idfindForm" onsubmit="return validateForm(this);">	
				<div class="idpw_box">
					<div class="id_box">
						<ul>
							<li><input type="text" name="user_name" value="" class="login_input01" /></li>
							<li><input type="text" name="user_email" value="" class="login_input01" /></li>
						</ul>
						<input type="image" src="../images/member/id_btn01.gif" class="id_btn" />
						<a href="join01.jsp"><img src="../images/login_btn03.gif" class="id_btn02" /></a>
					</div>
</form>
					<div class="pw_box">
						<ul>
							<li><input type="text" name="" value="" class="login_input01" /></li>
							<li><input type="text" name="" value="" class="login_input01" /></li>
							<li><input type="text" name="" value="" class="login_input01" /></li>
						</ul>
						<a href=""><img src="../images/member/id_btn01.gif" class="pw_btn" /></a>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
