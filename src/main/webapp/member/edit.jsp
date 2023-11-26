<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<%@ include file="../include/IsLoggedIn.jsp" %>
<% 
String UserId = session.getAttribute("UserId").toString();
MemberDAO dao = new MemberDAO(application);
MemberDTO dto = dao.viewMember(UserId);
if(!UserId.equals(dto.getId())){
	JSFunction.alertBack("작성자 본인만 수정할수있습니다.", out);
	return;
}
dao.close();
String[] phoneArr = dto.getPhone().split("-");
String[] emailArr = dto.getEmail().split("@");
String emailok = "";
if(dto.getEmailok()!=null&&dto.getEmailok().equals("y")) emailok = "checked";
%>
<script>
function formValidate(frm) {
	if (frm.name.value == '') {
        alert("이름을 입력해주세요.");
        frm.name.focus(); return false;
    }
    //패스워드 입력 확인
    if (frm.pw.value == '') {
        alert("패스워드를 입력해주세요."); frm.pw.focus(); return false;
    }
    if (frm.pw.value.length < 8 || frm.pw.value.length > 12) {
        alert("패스워드는 8~12자 사이만 가능합니다.");
        frm.pw.focus(); return false;
    }
    if (frm.pw2.value == '') {
        alert("패스워드 확인을 위해 재입력해주세요."); frm.pw2.focus(); return false;
    }
    if(frm.tel1.value==''||frm.tel2.value==''||frm.tel3.value=='') {
		alert("휴대폰 번호를 입력해주세요."); frm.tel1.focus(); return false;
	}
	if(frm.email1.value==''||frm.email2.value=='') {
		alert("이메일 주소를 입력해주세요."); frm.email1.focus(); return false;
	}
	if(frm.zip.value==''||frm.addr1.value==''||frm.addr2.value=='') {
		alert("주소를 입력해주세요."); frm.zip.focus(); return false;
	}
}
function inputEmail(frm) {
    var choiceDomain = frm.email_domain.value;
    if (choiceDomain == '') {
        frm.email1.focus();
    }
    else if (choiceDomain == '직접입력') {
        frm.email2.value = '';
        frm.email2.readOnly = false;
        frm.email2.focus();
    }
    else {
        frm.email2.value = choiceDomain;
        frm.email2.readOnly = true;
    }
}
function focusMove(x, y, z) {
    if (document.getElementById(x).value.length >= z) {
        document.getElementById(y).focus();
    }
}
$(function () {
	$("input[name=pw2]").keyup(function () {
        if ($(this).val()!=$("input[name=pw]").val()) {
			$("#pwResult").text("비밀번호가 일치하지 않습니다.").css("color", "red");
        }else $("#pwResult").text("비밀번호가 일치합니다.").css("color", "green");
    });
});
</script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
//다음 주소 api
function postOpen() {
    new daum.Postcode({
        oncomplete: function (data) {
            console.log(data);
            console.log(data.zonecode);
            console.log(data.address);

            let frm = document.joinForm;
            frm.zip.value = data.zonecode;
            frm.addr1.value = data.address;
            frm.addr2.focus();
        }
    }).open();
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
					<img src="../images/join_tit.gif" alt="회원가입" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;회원정보변경<p>
				</div>

				<p class="join_title"><img src="../images/join_tit03.gif" alt="회원정보입력" /></p>
				<form name="editmemberForm" action="editprocess.jsp" method="post" onsubmit="return formValidate(this);">
				<input type="hidden" name="id" value="<%= dto.getId() %>" />
				<table cellpadding="0" cellspacing="0" border="0" class="join_box">
					<colgroup>
						<col width="80px;" /><col width="*" />
					</colgroup>
					<tr>
						<th><img src="../images/join_tit001.gif" /></th>
						<td><input type="text" name="name" value="<%= dto.getName() %>" class="join_input" /></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit002.gif" /></th>
						<td><%= dto.getId() %></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit003.gif" /></th>
						<td><input type="password" name="pw" value="<%= dto.getPw() %>" class="join_input" />&nbsp;&nbsp;<span>* 8자 이상 12자 이내의 영문/숫자 조합</span></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit04.gif" /></th>
						<td><input type="password" name="pw2" value="<%= dto.getPw() %>" class="join_input" />&nbsp;&nbsp;<span id="pwResult"></span></td>
					</tr>
					

					<tr>
						<th><img src="../images/join_tit06.gif" /> / <br /><img src="../images/join_tit07.gif" />
						</th>
						<td>
							<input type="text" name="tel1" id="tel1" value="<%= phoneArr[0] %>" maxlength="3" class="join_input" style="width:50px;" onkeyup="focusMove('tel1','tel2',3);" />&nbsp;-&nbsp;
							<input type="text" name="tel2" id="tel2" value="<%= phoneArr[1] %>" maxlength="4" class="join_input" style="width:50px;" onkeyup="focusMove('tel2','tel3',4);" />&nbsp;-&nbsp;
							<input type="text" name="tel3" id="tel3" value="<%= phoneArr[2] %>" maxlength="4" class="join_input" style="width:50px;" onkeyup="focusMove('tel3','email1',4);" />
						</td>
					</tr>
					<tr>
						<th><img src="../images/join_tit08.gif" /></th>
						<td>
 
					<input type="text" id="email1" name="email1" style="width:100px;height:20px;border:solid 1px #dadada;" value="<%= emailArr[0] %>" /> @ 
					<input type="text" name="email2" style="width:150px;height:20px;border:solid 1px #dadada;" value="<%= emailArr[1] %>" readonly />
					<select name="email_domain" onchange="inputEmail(this.form);" class="pass" id="email_domain" >
						<option value="" >직접입력</option>
						<option value="naver.com" >naver.com</option>
						<option value="daum.net" >daum.net</option>
						<option value="hanmail.net" >hanmail.net</option>
						<option value="gmail.com" >gmail.com</option>
						<option value="yahoo.co.kr" >yahoo.co.kr</option>
						<option value="yahoo.com" >yahoo.com</option>
					</select>
	 
						<input type="checkbox" name="emailok" value="y" <%= emailok %>><span>이메일 수신동의</span></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit09.gif" /></th>
						<td>
						<input type="text" name="zip" value="<%= dto.getAdd1() %>" class="join_input" style="width:80px;" />
						<a onclick="postOpen();" style="cursor:pointer;">[우편번호검색]</a><br/>
						<input type="text" name="addr1" value="<%= dto.getAdd2() %>"  class="join_input" style="width:550px; margin-top:5px;" /><br>
						<input type="text" name="addr2" value="<%= dto.getAdd3() %>"  class="join_input" style="width:550px; margin-top:5px;" />
						</td>
					</tr>
				</table>

				<p style="text-align:center; margin-bottom:20px"><input type="image" src="../images/btn01.gif" />&nbsp;&nbsp;<a href="#"><img src="../images/btn02.gif" /></a></p>
				</form>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
