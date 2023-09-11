<%@page import="m1notice.NoticeDAO"%>
<%@page import="m1notice.NoticeDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<%@ include file="../include/global_head.jsp" %>
<%
String tname = request.getParameter("tname");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항_작성하기</title>
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
<% if(tname.equals("imageboard")) { %>  
	var ofile = document.getElementById('ofile');
	var selectFile = ofile.files[0];
    if (!selectFile)) {
        alert("1MB 이하의 이미지 파일을 첨부해주세요.");
        ofile.focus();
        return false;
    } 
<%}%>
} 
/* $(function(){
	$('input[type=submit]').click({
		if ($('input[name=title]') == '') {
	        alert("제목을 입력하세요.");
	        $('input[name=title]').focus();
	        return false;
	    }
	    if ($('input[name=content]') == '') {
	        alert("내용을 입력하세요.");
	        $('input[name=content]').focus();
	        return false;
	    }
	    var imgFile = $('#ofile').val();
		var fileForm = /(.*?\.(jpg|jpeg|png|gif|bmp)$/;
		var maxSize = 1024*1024*5;
		var fileSize;
		if($(imgFile==''){
			alert('이미지 파일을 첨부해주세요.');
			$('input[type=file]').focus();
			return false;
		}
		if(imgFile!='' && imgFile!=null){
			fileSize = $('#ofile').files[0].size;
			if(!imgFile.match(fileForm)){alert('이미지 파일만 업로드 가능합니다.'); return false;}
			else if(fileSize>=maxSize){alert('파일 사이즈는 5MB까지 가능'); return false;}
		}		
	});
}); */
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
<% if(tname.equals("notice")) { %>				
					<img src="../images/space/sub01_title.gif" alt="공지사항" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;공지사항<p>
<% } else if(tname.equals("freeboard")) { %>	
				<img src="../images/space/sub03_title.gif" alt="자유게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;자유게시판<p>
<% } else if(tname.equals("imageboard")) { %>	
				<img src="../images/space/sub04_title.gif" alt="사진게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;사진게시판<p>
<%} else if(tname.equals("databoard")) { %>	
				<img src="../images/space/sub05_title.gif" alt="정보자료실" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;정보자료실<p>
<% } %>			
				</div>
				<div>
<form id="writeFrm" method="post" action="WriteProcess.jsp?tname=<%= tname %>"
      onsubmit="return validateForm(this.form);" enctype="multipart/form-data" multiple>
    <table class="table">
        <tr>
            <td>제목</td>
            <td>
            <input type="text" name="title" style="width:100%;" class="form-control form-control-sm" maxlength='200' />
            </td>
        </tr>
        <tr>
            <td>내용</td>
            <td>
                <textarea name="content" style="width: 100%; height:200px;" class="form-control form-control-sm"  maxlength='2000'></textarea>
            </td>
        </tr>
        <tr>
			<td>첨부파일</td>
			<td><input type="file" name="ofile" id="ofile" multiple class="form-control form-control-sm"
			<% if(tname.equals("imageboard")){ %> accept=".jpg, .png, .gif" <% } %>
			 />
				<br><p>개별 파일 용량은 1MB까지 업로드 가능합니다.</p>
			</td>
		</tr>
        <tr>
            <td colspan="2" align="center">
                <button type="submit">작성 완료</button>
                <button type="reset">다시 입력</button>
                <button type="button" onclick="location.href='sub01.jsp?tname=<%= tname %>';">목록 보기</button>
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