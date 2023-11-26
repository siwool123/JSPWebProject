<%@page import="m1notice.NoticeDAO"%>
<%@page import="m1notice.NoticeDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<%@ include file="../include/global_head.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항_작성하기</title>
<style>
#ta_count, #ta_count_2 { margin-left:10px}
#ta_count, #ta_count_2, .count {font-size:0.8em; color:gray;}
</style>
<script type="text/javascript">
/* 글쓰기 페이지에서 제목과 내용이 입력되었는지 검증하는 JS코드 */
function validateForm(form) { 
    if (form.gname.value == "") {
        alert("제목을 입력하세요.");
        form.gname.focus();
        return false;
    }
    if (form.content.value == "") {
        alert("내용을 입력하세요.");
        form.content.focus();
        return false;
    }
} 
$(function(){
	$('input[name=gname]').keyup(function(){
		$('#ta_count').html($(this).val().length);
		if($(this).val().length>80){
			alert("상품명을 80자 이내로 입력해주세요.");
			$(this).val($(this).val().substring(0,80));
			$('#ta_count').html("80");
			$(this).focus(); 
		}
	});
	$('textarea[name=content]').keyup(function(){
		$('#ta_count_2').html($(this).val().length);
		if($(this).val().length>900){
			alert("내용을 900자 이내로 입력해주세요.");
			$(this).val($(this).val().substring(0,900));
			$('#ta_count_2').html("900");
			$(this).focus(); 
		}
	});
});
</script>
</head>

 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/space/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/space_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
				<img src="../images/market/sub01_title.gif" alt="수아밀 제품 주문" class="con_title" />
				<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린장터&nbsp;>&nbsp;수아밀 제품 주문<p>
				</div>
<form id="writeFrm" method="post" action="WriteProcess.jsp"
      onsubmit="return validateForm(this.form);" enctype="multipart/form-data" multiple>
    <table class="table">
        <tr>
            <td>상품명<span id="ta_count">0</span><span class="count"> / 80</span></td>
            <td>
            <input type="text" name="gname" style="width:100%;" class="form-control form-control-sm" maxlength='80' />
            </td>
        </tr>
        <tr>
        	<td>단가</td>
        	<td><input type="number" name="price" style="width:100%;" class="form-control form-control-sm" max='1000000' required /></td>
        </tr>
        <tr>
        	<td>재고수량</td>
        	<td><input type="number" name="stock" style="width:100%;" class="form-control form-control-sm" max='10000' required /></td>
        </tr>
        <tr>
            <td>내용<span id="ta_count_2">0</span><span class="count"> / 900</span></td>
            <td>
                <textarea name="content" style="width: 100%; height:200px;" class="form-control form-control-sm"  maxlength='900'></textarea>
            </td>
        </tr>
        <tr>
			<td>첨부이미지</td>
			<td><input type="file" name="ofile" id="ofile" multiple class="form-control form-control-sm" accept=".jpg, .png, .gif" />
				<br><p>개별 파일 용량은 3MB까지 .jpg, .png, .gif 파일만 업로드 가능합니다.</p>
			</td>
		</tr>
        <tr>
            <td colspan="2" align="center">
                <button type="submit">작성 완료</button>
                <button type="reset">다시 입력</button>
                <button type="button" onclick="location.href='sub01.jsp';">목록 보기</button>
            </td>
        </tr>
    </table>
</form>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>