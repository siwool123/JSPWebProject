<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@page import="utils.BoardPage"%>
<%@page import="m1notice.NoticeDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="m1notice.NoticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<%
String UserId = session.getAttribute("UserId").toString();
MemberDAO mdao = new MemberDAO(application);
MemberDTO mdto = mdao.viewMember(UserId);

NoticeDAO dao = new NoticeDAO(application);
Map<String, Object> param = new HashMap<>();
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
if(searchWord != null){
	param.put("searchField", searchField);
	param.put("searchWord", searchWord);
}
int totalcnt = dao.selectCnt(param); //게시물수 확인

/*** 페이지 처리 start ***/
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));
int totalPage = (int) Math.ceil(totalcnt / pageSize); /* 전체페이지수 계산 */

/* 목록 처음진입시 페이지 관련 파라미터가 없는상태이므로 무조건 1page로 지정한다.
만약 파라미터가 pageNum이 있다면 request 내장객체통해 받아온후 페이지번호로 지정한다.
sub01.jsp > 이처럼 파라미터가 없는상태일때는 null
sub01.jsp?pageNum= > 이처럼 파라미터는 있는데 값없을떄는 빈값으로 체크된다. 
따라서 아래 if문은 2개의 조건으로 구성해야한다.*/
int pageNum = 1;
String pageTemp = request.getParameter("pageNum");
if(pageTemp != null && !pageTemp.equals("")) pageNum = Integer.parseInt(pageTemp);

/* 페이지 시작번호와 종료번호 계산후 map컬렉션에 추가한다. */
int start = (pageNum-1)*pageSize+1;
int end = pageNum*pageSize;
param.put("start", start);
param.put("end", end);
/*** 페이지 처리 end ***/

List<NoticeDTO> noticeLists = dao.selectListPage(param); //게시물 목록 받기
dao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
</head>
 <body>
<center>
<div id="wrap">
<%@ include file="../include/global_head.jsp" %>
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
			<div class="text-center mb-4 p-3" style="background-color:#e2e3e5;">
<form action="" method="get">
		<select name="searchField" style="height:26px; width:20%;padding-left:10px;">
		<option value="title">제목</option>
		<option value="content">내용</option>
		</select>
		<input type="text" name="searchWord" placeholder="검색어를 입력하세요." style="border:1px solid #adb5bd; height:26px; width:65%;padding-left:10px;" />
		<button type="submit" style="width:10%; height:26px; background-color:black; border:none;"><i style="color:white;" class="fa-solid fa-magnifying-glass"></i></button>
</form>
</div>
<div>
<table class="table table-hover">
   <thead class="table-secondary border-top">
     <tr align="center">
       <th width="10%">번호</th>
       <th width="50%">제목</th>
       <th width="15%">작성자</th>
       <th width="10%">조회수</th>
       <th width="15%">등록일</th>
     </tr>
   </thead>
   <tbody>
<%
if(noticeLists.isEmpty()){
%>	
	<tr>
		<td colspan="5" align="center">등록된 게시물이 없습니다.</td>
	</tr>
<%
}else{
	int virtualNum = 0;
	int cntNum = 0;
	for(NoticeDTO dto : noticeLists){
		virtualNum = totalcnt-((pageNum-1)*pageSize+cntNum++);
%>
     <tr>
       <td align="center"><%= virtualNum %></td>
       <td align="left"><a href="sub01_view.jsp?idx=<%= dto.getIdx() %>"><%= dto.getTitle() %></a></td>
       <td align="center"><%= dto.getId() %></td>
       <td align="center"><%= dto.getVisitcnt() %></td>
       <td align="center"><%= dto.getPostdate() %></td>
     </tr>
<%
	}
}
%>

   </tbody>
</table>
<table>
	<tr>
		<td width="85%">
		<%= BoardPage.pagingImg(totalcnt, pageSize, blockPage, pageNum, request.getRequestURI()) %>
		</td>
		<td width="*">
<% if(mdto.getAdmin()==1){ %>		
		<button type="button" onclick="location.href='sub01_write.jsp';" style="background-color:black; color:white; border:none; padding:4px 10px;">글쓰기</button>
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