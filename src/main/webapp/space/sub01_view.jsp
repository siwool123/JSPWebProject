<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="m1notice.CommentDTO"%>
<%@page import="m1notice.CommentDAO"%>
<%@page import="fileupload.FileUtil"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@page import="m1notice.NoticeDTO"%>
<%@page import="m1notice.NoticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="../include/global_head.jsp" %>
<%@ include file="../include/IsLoggedIn.jsp" %>
<%
String UserId = session.getAttribute("UserId").toString();
MemberDAO mdao = new MemberDAO(application);
MemberDTO mdto = mdao.viewMember(UserId);
mdao.close();
/*게시물 인출위해 파라미터를 받아온다. > dao객체생성하여 오라클연결
> 게시물 조회수 증가 > 게시물 내용 추출하여 dto에 저장 */
String tname = request.getParameter("tname");

int idx = Integer.parseInt(request.getParameter("idx"));
String ofile = request.getParameter("ofile"); 
String sfile = request.getParameter("sfile");

NoticeDAO dao = new NoticeDAO(application);
dao.updateVisitcnt(idx, tname);
int[] maxmin = new int[2];
maxmin = dao.maxmin(tname);
int prevIdx = dao.previousIdx(idx, tname);
int nextIdx = dao.nextIdx(idx, tname);
NoticeDTO dto = dao.selectView(idx, tname);
dao.close();
dto.setContent(dto.getContent().replaceAll("\r\n", "<br/>"));

CommentDAO cdao = new CommentDAO(application);
List<CommentDTO> commentLists = cdao.selectList(idx);
cdao.close();
//첨부파일 확장자 추출 및 이미지 타입 확인
String ext = "", fileName = dto.getSfile();
if(fileName!=null) ext = fileName.substring(fileName.lastIndexOf(".")+1);		
String[] imgStr = {"png", "jpg", "gif", "bmp"};
List<String> imgList = Arrays.asList(imgStr);

boolean isImage = false;
if(imgList.contains(ext)) isImage = true;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항_상세보기</title>
<script type="text/javascript">
//게시물삭제위한js함수 > confirm함수는 대화창에서 예 클릭시 true반환된다.
/* form 태그의 name속성통해 DOM을 얻어온다.
전송방식과 전송경로를 지정한다 > submit 함수로 폼값전송 
폼태그하위의 hidden타입설정된 일련번호전송 */
function deletePost() {
	var confirmed = confirm("정말로 삭제하시겠습니까?");
    if (confirmed) {
        var form = document.viewFrm;
        form.method = "post";
        form.action = "DeleteProcess.jsp";
        form.submit();
    }
}
function validateForm(form) { 
    if (form.content.value == "") {
        alert("답글 내용을 입력하세요.");
        form.content.focus();
        return false;
    }
}
$(document).ready(function(){
	$("#editComment").click(function(){
		$(".hideContent").hide();
		$("#hideFrm").show();
	});
});
</script>
<style>
.hideContent {display:inline-block;}
</style>
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
<% } %>				
				</div>
				<div>

<table class="table" width="90%">
<thead>
<tr><th colspan="4"><h5><%= dto.getTitle() %></h5></th></tr>
</thead>
<tbody>
	<tr>
		<td style="width:25%;">작성자 : <%= dto.getId() %></td>
		<td style="width:25%;">작성일 : <%= dto.getPostdate() %></td>
		<td style="width:25%;">조회수 : <%= dto.getVisitcnt() %></td>
		<td style="width:25%;">작성번호 : <%= dto.getIdx() %></td>
	</tr>
	<tr>
		<td colspan="4"><br /><%= dto.getContent().replace("\r\n", "<br/>") %><br />
		<% if(dto.getOfile()!=null && isImage==true) { %>
			<div class="text-center"><img src="../Uploads/<%= dto.getSfile() %>" style="max-width:100%" />
		<% } %></div>
		</td>
	</tr>
	<tr>
		<td>첨부파일</td>
		<td>
		<% if(dto.getOfile()!=null) { %>
			<a href="sub01_download.jsp?tname=<%= tname %>&ofile=<%= dto.getOfile() %>&sfile=<%= dto.getSfile() %>&idx=<%= dto.getIdx()%>"><%= dto.getOfile() %></a>
		<% } %>
		</td>
		<td align="right">다운횟수 : <%= dto.getDowncnt() %></td>
		<td align="right">좋아요 <buttton type="button"><i class="fa-regular fa-heart" style="color:red"></i></buttton> <%= dto.getLikecnt() %></td>
	</tr>
</tbody>
</table>

<table class="table table-borderless" width="90%">
<%
if(!commentLists.isEmpty()){
	for(CommentDTO cdto : commentLists){
%>
	<tr>
		<td width="5%"><i class="fa-solid fa-face-smile" style="font-size:20px;"></i></td>
		<td width="64%"><%= cdto.getId() %> <span style="color:gray; margin-left:20px;"><%= cdto.getCommentdate() %></span>
		<% if(cdto.getId().equals(UserId)){ %>	&nbsp;&nbsp;&nbsp;
		<button id="editComment" class="hideContent">수정</button>&nbsp;
<form name="commentDeleteFrm" method="post" action="CommentDelete.jsp" style="display:inline;">
<input type="hidden" name="comment_idx" value="<%= cdto.getIdx() %>" />	
<input type="hidden" name="idx" value="<%= idx %>" />
		<button type="submit" onclick="deletePost();" class="hideContent">삭제</button>
</form>	
		<% } %>
		</td>
		<td align="right"> <buttton type="button"><i class="fa-regular fa-heart" style="color:red"></i></buttton> 좋아요 <%= cdto.getLikecnt() %> | <a href="">신고</a></td>
	</tr>
	
	<tr class="border-bottom" class="hideContent">
		<td></td>
		<td colspan="2"><%= cdto.getContent() %></td>
	</tr>
	
<form name="commentEditFrm" method="post" action="CommentEdit.jsp" >
<input type="hidden" name="comment_idx" value="<%= cdto.getIdx() %>" />
<input type="hidden" name="idx" value="<%= idx %>" />
	<tr style="display:none;" id="hideFrm" class="border-bottom" >
		<td width="5%"></td>
		<td>
		<textarea name="content" style="width:100%;height:100px;"><%= cdto.getContent() %></textarea>
		</td>
		<td align="right"><button type="submit">수정완료</button></td>
	</tr>
</form>

<%
	}
}
%>
</table>
<form name="commentFrm" method="post" action="CommentWrite.jsp" onsubmit="return validateForm(this);">
<input type="hidden" name="idx" value="<%= idx %>" />
<table class="table">
<tr>
	<td width="5%"><i class="fa-solid fa-face-smile" style="font-size:20px;"></i></td>
	<td>
	<textarea name="content" style="width:100%;height:100px;"></textarea>
	</td>
	<td align="right"><button type="submit">답글입력</button></td>
</tr>
</table>
</form>
<table class="table table-borderless">
	<colgroup>
	    <col width="33%">
	    <col width="33%">
	    <col width="33%">
  	</colgroup>
	<tr align="center">
		<td width="23%" align="left">
<% if(idx<maxmin[0]){ %>
		<a href="sub01_view.jsp?tname=<%= tname %>&idx=<%= prevIdx %>">&lt; 이전글 보기</a>
<% } %>
		</td>
		<td width="33%" align="center">
		<form name="viewFrm">
		<input type="hidden" name="idx" value="<%= idx %>" />
		<button type="button" onclick="location.href='sub01.jsp?tname=<%= tname %>';">목록보기</button>
<% if(tname.equals("notice") && mdto.getAdmin()==1 || tname.equals("freeboard")){ %>
		<button type="button" onclick="location.href='sub01_edit.jsp?tname=<%= tname %>&idx=<%= dto.getIdx()%>';">수정하기</button>
		<!-- 삭제버튼누르면 js함수 호출. 해당함수는 submit()통해 폼값을서버로전송 -->
		<button type="button" onclick="deletePost();">삭제하기</button>
		</form> 
<%	} %>
		</td>
		<td width="23%" align="right">
<% if(idx>maxmin[1]){ %>
		<a href="sub01_view.jsp?tname=<%= tname %>&idx=<%= nextIdx %>">다음글 보기 &gt;</a> 
<% } %>
		</td>
	</tr>
</table>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>


	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>