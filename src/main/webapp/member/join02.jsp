<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<script>
//회원가입시 폼값인증
function formValidate(frm) {
	if (frm.name.value == '') {
        alert("이름을 입력해주세요.");
        frm.name.focus(); return false;
    }
    if (frm.id.value == '') {
        alert("아이디를 입력해주세요.");
        frm.id.focus(); return false;
    }
    if (frm.id.value.length < 8 || frm.id.value.length > 12) {
        alert("아이디는 8~12자 사이만 가능합니다.");
        frm.id.focus(); return false;
    }
    if (!isNaN(frm.id.value.charAt(0))) {
        alert('아이디는 숫자로 시작할 수 없습니다.');
        frm.id.focus(); return false;
    }
    if (!frm.id.readOnly) {
        alert('아이디 중복확인이 필요합니다.'); return false;
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
//아이디 중복확인 
function idCheck(){
    if(document.joinForm.id.value==''){
        alert("아이디를 입력후 중복확인 해주세요.");
        document.joinForm.id.focus();
    }else{
        window.open('idcheck.jsp?id='+document.joinForm.id.value, 'idOver', 'width=500,height=300');
        document.joinForm.id.readOnly = true;
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
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;회원가입<p>
				</div>

				<p class="join_title"><img src="../images/join_tit03.gif" alt="회원정보입력" /></p>
				<form name="joinForm" action="registAction.jsp" method="post" onsubmit="return formValidate(this);">
				<table cellpadding="0" cellspacing="0" border="0" class="join_box">
					<colgroup>
						<col width="80px;" />
						<col width="*" />
					</colgroup>
					<tr>
						<th><img src="../images/join_tit001.gif" /></th>
						<td><input type="text" name="name" value="" class="join_input" /></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit002.gif" /></th>
						<td><input type="text" name="id" id="id" value="" class="join_input" />&nbsp;
						<a onclick="idCheck(this.form);" style="cursor:pointer;"><img src="../images/btn_idcheck.gif" alt="중복확인"/></a>&nbsp;&nbsp;<span>* 8자 이상 12자 이내의 영문/숫자 조합하여 공백 없이 기입</span></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit003.gif" /></th>
						<td><input type="password" name="pw" value="" class="join_input" />&nbsp;&nbsp;<span>* 8자 이상 12자 이내의 영문/숫자 조합</span></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit04.gif" /></th>
						<td><input type="password" name="pw2" value="" class="join_input" />&nbsp;&nbsp;<span id="pwResult"></span></td>
					</tr>
					

					<tr>
						<th><img src="../images/join_tit06.gif" /> / <br /><img src="../images/join_tit07.gif" />
						</th>
						<td>
							<input type="text" name="tel1" id="tel1" value="" maxlength="3" class="join_input" style="width:50px;" onkeyup="focusMove('tel1','tel2',3);" />&nbsp;-&nbsp;
							<input type="text" name="tel2" id="tel2" value="" maxlength="4" class="join_input" style="width:50px;" onkeyup="focusMove('tel2','tel3',4);" />&nbsp;-&nbsp;
							<input type="text" name="tel3" id="tel3" value="" maxlength="4" class="join_input" style="width:50px;" onkeyup="focusMove('tel3','email1',4);" />
						</td>
					</tr>
					<tr>
						<th><img src="../images/join_tit08.gif" /></th>
						<td>
 
					<input type="text" id="email1" name="email1" style="width:100px;height:20px;border:solid 1px #dadada;" value="" /> @ 
					<input type="text" name="email2" style="width:150px;height:20px;border:solid 1px #dadada;" value="" readonly />
					<select name="email_domain" onchange="inputEmail(this.form);" class="pass" id="email_domain" >
						<option value="" >직접입력</option>
						<option value="naver.com" >naver.com</option>
						<option value="daum.net" >daum.net</option>
						<option value="hanmail.net" >hanmail.net</option>
						<option value="gmail.com" >gmail.com</option>
						<option value="yahoo.co.kr" >yahoo.co.kr</option>
						<option value="yahoo.com" >yahoo.com</option>
					</select>
	 
						<input type="checkbox" name="emailok" value="y"><span>이메일 수신동의</span></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit09.gif" /></th>
						<td>
						<input type="text" name="zip" value="" class="join_input" style="width:80px;" />
						<a onclick="postOpen();" style="cursor:pointer;">[우편번호검색]</a><br/>
						<input type="text" name="addr1" value=""  class="join_input" style="width:550px; margin-top:5px;" /><br>
						<input type="text" name="addr2" value=""  class="join_input" style="width:550px; margin-top:5px;" />
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
