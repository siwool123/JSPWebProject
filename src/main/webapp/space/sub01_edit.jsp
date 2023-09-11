<%@page import="java.util.stream.Collectors"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="fileupload.FileUtil"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.util.List"%>
<%@page import="m1notice.NoticeDAO"%>
<%@page import="m1notice.NoticeDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<%@ include file="../include/global_head.jsp" %>
<%
String tname = request.getParameter("tname");
int idx = Integer.parseInt(request.getParameter("idx"));
NoticeDAO dao = new NoticeDAO(application);
NoticeDTO dto = dao.selectView(idx, tname); 
String sessionId = session.getAttribute("UserId").toString();
if(!sessionId.equals(dto.getId())){
	JSFunction.alertBack("작성자 본인만 수정할수있습니다.", out); return;
}
dao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 수정하기</title>
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
<%} %>	
				</div>
				<div>
<form name="writeFrm" method="post" action="EditProcess.jsp?tname=<%= tname %>" onsubmit="return validateForm(this);" enctype="multipart/form-data">
<input type="hidden" name="idx" value="<%= dto.getIdx() %>" />
<input type="hidden" name="id" value="<%= dto.getId() %>" />
<input type="hidden" name="prevOfile" value="<%= dto.getOfile() %>" />
<input type="hidden" name="prevSfile" value="<%= dto.getSfile() %>" />
    <table class="table">
        <tr>
            <td>제목</td>
            <td>
            <input type="text" name="title" style="width:100%;" class="form-control form-control-sm" value="<%= dto.getTitle() %>" />
            </td>
        </tr>
        <tr>
            <td>내용</td>
            <td>
                <textarea name="content" style="width: 100%; height:200px;" class="form-control form-control-sm"><%= dto.getContent() %></textarea>
            </td>
        </tr>
        <tr>
			<td>첨부파일</td>
			<td><input type="file" name="ofile" value="1" multiple class="form-control form-control-sm" id="formFileSm" />
				<br/><p>개별 파일 용량은 1MB까지 업로드 가능합니다.</p>
			</td>
		</tr>
        <tr>
            <td colspan="2" align="center">
                <button type="submit">작성 완료</button>
                <button type="reset">다시 입력</button>
                <button type="button" onclick="location.href='sub01.jsp?tname=<%= tname%>';">목록 보기</button>
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