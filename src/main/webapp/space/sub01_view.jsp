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
/*게시물 인출위해 파라미터를 받아온다. > dao객체생성하여 오라클연결
> 게시물 조회수 증가 > 게시물 내용 추출하여 dto에 저장 */

int idx = Integer.parseInt(request.getParameter("idx"));
String ofile = request.getParameter("ofile"); 
String sfile = request.getParameter("sfile");
FileUtil.download(request, response, "/Uploads", sfile, ofile);

NoticeDAO dao = new NoticeDAO(application);
dao.updateVisitcnt(idx);
int maxIdx = dao.maxIdx();
int prevIdx = dao.previousIdx(idx);
int nextIdx = dao.nextIdx(idx);
NoticeDTO dto = dao.selectView(idx);
dao.downcntPlus(idx);
dao.close();
dto.setContent(dto.getContent().replaceAll("\r\n", "<br/>"));

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
        form.action = "sub01_delete.jsp";
        form.submit();
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
					<img src="../images/space/sub01_title.gif" alt="공지사항" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;공지사항<p>
				</div>
				<div>

<form enctype="multipart/form-data" name="viewFrm">
<input type="hidden" name="idx" value="<%= idx %>" />
<table class="table"  width="90%">
<thead>
<tr><th colspan="4"><h4><%= dto.getTitle() %></h4></th></tr>
</thead>
<tbody>
	<tr>
		<td style="vertical-align:middle; width:25%;">작성자 : <%= dto.getId() %></td>
		<td style="vertical-align:middle; width:25%;">작성일 : <%= dto.getPostdate() %></td>
		<td style="vertical-align:middle; width:25%;">조회수 : <%= dto.getVisitcnt() %></td>
		<td style="vertical-align:middle; width:25%;">작성번호 : <%= dto.getIdx() %></td>
	</tr>
	<tr>
		<td colspan="4" style="vertical-align:middle;"><%= dto.getContent().replace("\r\n", "<br/>") %>
		<c:if test="${ not empty dto.ofile and isImage == true }">
			<br /><img src="../Uploads/${ dto.sfile }" style="max-width:100%" />
		</c:if>
		</td>
	</tr>
	<tr>
		<td style="vertical-align:middle;">첨부파일</td>
		<td>
		<% if(dto.getOfile()!=null) { %>
			<a href="../sub01_download.do?ofile=<%= dto.getOfile() %>&sfile=<%= dto.getSfile() %>&idx=<%= dto.getIdx()%>"><%= dto.getOfile() %></a>
		<% } %>
		</td>
		<td style="vertical-align:middle;">다운횟수</td>
		<td><%= dto.getDowncnt() %></td>
	</tr>
</tbody>
</table>
<table  width="100%">
	<colgroup>
	    <col width="33%">
	    <col width="33%">
	    <col width="33%">
  	</colgroup>
	<tr align="center">
		<td width="33%" align="left">
		<% if(idx<maxIdx){ %>
		<a href="sub01_view.jsp?idx=<%= prevIdx %>">&lt; 이전글 보기</a>
		<% } %>
		</td>
		<td width="33%" align="center">
		<button type="button" onclick="location.href='sub01.jsp';">목록보기</button>
		<% if(mdto.getAdmin()==1) { %>
		<button type="button" onclick="location.href='sub01_edit.jsp?idx=<%= dto.getIdx() %>';">수정하기</button>
		<!-- 삭제버튼누르면 js함수 호출. 해당함수는 submit()통해 폼값을서버로전송 -->
		<button tyep="button" onclick="deletePost();">삭제하기</button>
		<%	} %>
		</td>
		<td width="33%" align="right">
		<% if(idx>1){ %>
		<a href="sub01_view.jsp?idx=<%= nextIdx %>">다음글 보기 &gt;</a> 
		<% } %>
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