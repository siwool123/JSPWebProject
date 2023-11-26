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
<%@ include file="../include/IsLoggedIn.jsp" %>
<%@ include file="../include/global_head.jsp" %>
<%
String UserId = session.getAttribute("UserId").toString();
MemberDAO mdao = new MemberDAO(application);
MemberDTO mdto = mdao.viewMember(UserId);
if(mdto.getGrade()==3 && request.getParameter("tname").equals("staffboard")){
	JSFunction.alertBack("직원, 관리자만 이용 가능합니다.", out);
	return;
}
mdao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항_상세보기</title>
<style type="text/css">
.comment tr td, .comment tr, .comment {background-color:#f8f8f8;}
</style>
<script type="text/javascript">
function delComment(idx) {
	var confirmed = confirm("답변을 정말로 삭제하시겠습니까?");
    if (confirmed) {
        var form = document.delFrm;
        form.method = "post";
        form.action = "Delete.do?tname="+${tname}+"&idx="+${dto.idx};
        form.submit();
    }
}
/* function delPost() {
	var confirmed = confirm('게시물을 정말로 삭제하시겠습니까?");
    if (confirmed) {
        var form = document.commentDelFrm;
        form.method = "post";
        form.action = "CommentDelete.jsp?tname="+${tname}+"&cidx="+${cdto.idx};
        form.submit();
    }
} */
function validateForm(form) { 
    if (form.content.value == "") {
        alert("답글 내용을 입력하세요.");
        form.content.focus();
        return false;
    }
}
$(document).ready(function(){
	$("#editC").click(function(){
		$(".id1").hide();
	    $("#hideFrm").show();
	});
	$("#cancel").click(function(){
		$(".id1").show();
	    $("#hideFrm").hide();
	});
});
$(function(){
	$('#noticeLike').click(function(){
		alert("게시글 좋아요 1 증가");
		$(this).css('color', 'red');
		let params = {idx:$('#idx').val()};
		$.post('LikeProcess.jsp?tname='+${tname}+'&idx='+${dto.idx}, params, function(resD){
			console.log('콜백데이터', resD);
			let getCnt = $('.likecnt').html();
			$('.likecnt').html(parseInt(getCnt)+1);
	});
	$('.commentLike').click(function(){
		alert("답글 좋아요 1 증가");
		$(this).css({'color':'red'});
		let params = {comment_idx:$('#comment_idx').val()};
		$.post('CommentLike.jsp?tname='+${tname}+'&cidx='+$('#comment_idx').val(), params, function(resD){
			console.log('콜백데이터', resD);
			let getCnt = $('.clikecnt').html();
			$('.clikecnt').html(parseInt(getCnt)+1);
		});
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
				<%@ include file = "../include/community_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
<!-- 본문상단 타이틀 게시판명에따라 변경 -->
<c:if test='${ tname.equals("staffboard") }'>		
					<img src="../images/community/sub01_title.gif" alt="직원자료실" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;직원자료실<p>
</c:if>
<c:if test='${ tname.equals("guardboard") }'>
					<img src="../images/community/sub02_title.gif" alt="보호자 게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;보호자 게시판<p>
</c:if>				
				</div>
				<div>

<table class="table" width="90%">
<thead>
<tr><th colspan="4"><h5>${ dto.title }</h5></th></tr>
</thead>
<tbody>
	<tr>
		<td style="width:25%;">작성자 : ${ dto.id }</td>
		<td style="width:25%;">작성일 : ${ dto.postdate }</td>
		<td style="width:25%;">조회수 : ${ dto.visitcnt }</td>
		<td style="width:25%;">작성번호 : ${ dto.idx }</td>
	</tr>
	<tr>
		<td colspan="4">
		<c:if test="${ not empty dto.ofile and isImage == true }">
			<p class="text-center mt-5"><img src="../Uploads/${ dto.sfile }" style="max-width:100%" /></p>
		</c:if>
		<div class="mt-5 mb-5">${ dto.content }</div>
		</td>
	</tr>
	<tr>
		<td>첨부파일</td>
		<td>
		<c:if test="${ not empty dto.ofile }">
			<a href="../community/download.do?tname=${param.tname }&ofile=${ dto.ofile }&sfile=${ dto.sfile }&idx=${ dto.idx }">${ dto.ofile }</a>
		</c:if>
		</td>
		<td align="right">다운횟수 : ${ dto.downcnt }</td>
		<td align="right">좋아요 <i class="fa-solid fa-heart" id="noticeLike"></i> <span class="likecnt">${ dto.likecnt }</span>
		</td>
	</tr>
</tbody>
</table>
<!-- 답글목록출력 (답변작성자 본인에게만 수정,삭제버튼 표시 > 
수정 클릭시 기존답글 숨겨지고 그내용입력된 textarea창과 작성완료버튼 표시됨) -->
<table class="table table-borderless comment" width="90%">
<c:if test="${ not empty commentLists }">
	<c:forEach items="${ commentLists }" var="cdto" varStatus="loop">
	<tr>
		<td width="5%"><i class="fa-solid fa-face-smile" style="font-size:20px;"></i></td>
		<td width="64%">${ cdto.id } <span style="color:gray; margin-left:20px;">${ cdto.commentdate }</span>
		<c:if test="${ cdto.id.equals(UserId) }">
		&nbsp;&nbsp;&nbsp;<button id="editC" class="id1">수정</button>&nbsp;
<form name="commentDelFrm" method="post" action="CommentDelete.jsp?tname=${tname}&cidx=${cdto.idx}" style="display:inline;">
		<button type="submit" onclick="delComment(${cdto.idx});" class="id1">삭제</button>
		<input type="hidden" name="comment_idx" id="comment_idx" value="${ cdto.idx }" />
		<input type="hidden" name="tname" id="tname" value="${ tname }" />
</form>	
		</c:if>
		</td>
		<td align="right">좋아요 <i class="fa-solid fa-heart commentLike"></i> <span class="clikecnt">${ cdto.likecnt }</span>
		<span style="margin:0 10px;">|</span><a href="">신고</a>
		<input type="hidden" name="comment_idx" id="comment_idx" value="${ cdto.idx }" />
		</td>
	</tr>
	
	<tr class="border-bottom" class="id1">
		<td></td>
		<td colspan="2">${ cdto.content }</td>
	</tr>
	
<form name="commentEditFrm" method="post" action="CommentEdit.jsp?tname=${tname}&idx=${dto.idx}&cidx=${cdto.idx}" >
	<tr style="display:none;" id="hideFrm" class="border-bottom" >
		<td width="5%"></td>
		<td>
		<textarea name="content" style="width:100%;height:100px;">${ cdto.content }</textarea>
		</td>
		<td align="right"><button id="cancel">수정취소</button><button type="submit">수정완료</button></td>
	</tr>
</form>
	</c:forEach>
</c:if>	
</table>
<!-- 답변작성폼 -->
<form name="commentFrm" method="post" action="CommentWrite.jsp?tname=${ tname }&id=${dto.idx}" onsubmit="return validateForm(this);">
<input type="hidden" name="idx" value="${ dto.idx }" />
<table class="table comment">
<tr>
	<td width="5%"><i class="fa-solid fa-face-smile" style="font-size:20px;"></i></td>
	<td>
	<textarea name="content" style="width:100%;height:100px;" placeholder="로그인하셔야 답변 작성 가능합니다."></textarea><br/><br/>
	</td>
	<td align="right"  width="15%"><button type="submit">답글입력</button></td>
</tr>
</table>
</form>
<!-- 이전/다음페이지 타이틀및링크, 수정,삭제,목록 버튼 표시 테이블 -->
<table class="table table-borderless">
	<colgroup>
	    <col width="33%">
	    <col width="33%">
	    <col width="33%">
  	</colgroup>
	<tr align="center">
		<td width="23%" align="left">
<c:if test="${ dto.idx<maxmin[0] }">
		<a href="sub01_view.do?tname=${tname }&idx=${ prevIdx }">&lt; ${ JSFunction.titleCut(pdto.title, 16)}</a>
</c:if>	
		</td>
		<td width="33%" align="center">
		<button type="button" onclick="location.href='sub01.do?tname=${tname}';">목록보기</button>
<c:if test="${ dto.id.equals(UserId) }">
		<button type="button" onclick="location.href='sub01_edit.do?tname=${tname}&idx=${dto.idx}';">수정하기</button>
		<button tyep="submit" onclick="location.href='delete.do?tname=${tname}&idx=${dto.idx}';">삭제하기</button>
</c:if>	
		</td>
		<td width="23%" align="right">
<c:if test="${ dto.idx>maxmin[1] }">
		<a href="sub01_view.do?tname=${tname}&idx=${nextIdx}">${ JSFunction.titleCut(ndto.title, 16)} &gt;</a> 
</c:if>	
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