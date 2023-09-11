<%@page import="m1notice.NoticeDAO"%>
<%@page import="m1notice.NoticeDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    if (form.title.value == "") {
        alert("제목을 입력하세요.");
        form.title.focus();
        return false;
    }
    if (form.content.value == "") {
        alert("내용을 입력하세요.");
        form.content.focus();
        return false;
    }
} 
$(function(){
	$('input[name=title]').keyup(function(){
		$('#ta_count').html($(this).val().length);
		if($(this).val().length>80){
			alert("제목을 80자 이내로 입력해주세요.");
			$(this).val($(this).val().substring(0,80));
			$('#ta_count').html("80");
			$(this).focus(); 
		}
	});
	$('textarea[name=content]').keyup(function(){
		$('#ta_count_2').html($(this).val().length);
		if($(this).val().length>800){
			alert("내용을 800자 이내로 입력해주세요.");
			$(this).val($(this).val().substring(0,800));
			$('#ta_count_2').html("800");
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
<c:if test='${ param.tname.equals("staffboard") }'>		
					<img src="../images/community/sub01_title.gif" alt="직원자료실" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;직원자료실<p>
</c:if>
<c:if test='${ param.tname.equals("guardboard") }'>
					<img src="../images/community/sub02_title.gif" alt="보호자 게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;보호자 게시판<p>
</c:if>		
				</div>
				<div>
<form id="writeFrm" method="post" action="../community/sub01_write.do?tname=${ param.tname }"
      onsubmit="return validateForm(this.form);" enctype="multipart/form-data" multiple>
    <table class="table">
        <tr>
            <td>제목<span id="ta_count">0</span><span class="count"> / 80</span></td>
            <td>
            <input type="text" name="title" style="width:100%;" class="form-control form-control-sm" maxlength='80' />
            </td>
        </tr>
        <tr>
            <td>내용<span id="ta_count_2">0</span><span class="count"> / 800</span></td>
            <td>
                <textarea name="content" style="width: 100%; height:200px;" class="form-control form-control-sm"  maxlength='800'></textarea>
            </td>
        </tr>
        <tr>
			<td>첨부파일</td>
			<td><input type="file" name="ofile" id="ofile" multiple class="form-control form-control-sm" />
				<br><p>개별 파일 용량은 1MB까지 업로드 가능합니다.</p>
			</td>
		</tr>
        <tr>
            <td colspan="2" align="center">
                <button type="submit">작성 완료</button>
                <button type="reset">다시 입력</button>
                <button type="button" onclick="location.href='sub01.jsp?tname=${ param.tname }';">목록 보기</button>
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