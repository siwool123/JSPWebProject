<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@page import="m1notice.NoticeDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="m1notice.NoticeDAO"%>
<%@page import="utils.BoardPage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<%
String tname = request.getParameter("tname");
String UserId = session.getAttribute("UserId").toString();
MemberDAO mdao = new MemberDAO(application);
MemberDTO mdto = mdao.viewMember(UserId);

//DAO객체 생성을 통해 DB에 연결한다. 
NoticeDAO dao = new NoticeDAO(application);

/* 검색어가 있는 경우 클라이언트가 선택한 필드명과 검색어를 저장할 Map컬렉션을 생성한다. */
Map<String, Object> param = new HashMap<String, Object>();

/********************************/
//현재 게시판에서 사용하는 테이블을 Map컬렉션에 저장한다.
param.put("tname", tname);
/*********************************/

/* 검색폼에서 입력한 검색어와 필드명을 파라미터로 받아온다. 해당 <form>
태그의 전송방식은 get, action 속성은 없는 상태이므로 현재 페이지로 
폼값이 전송된다. */
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
if (searchWord != null) {
	/* 클라이언트가 입력한 검색어가 있는경우에만 Map컬렉션에 
	컬럼명과 검색어를 추가한다. 해당 값은 DB처리를 위한 Model객체로
	전달된다. */
  param.put("searchField", searchField);
  param.put("searchWord", searchWord);
}

//Map컬렉션을 인수로 게시물의 갯수를 카운트한다. 
int totalCount = dao.selectCnt(param);

/* #paging관련 코드 추가 start# */

/* web.xml에 설정한 컨텍스트 초기화 파라미터를 읽어온다.
초기화 파라미터는 String으로 저장되므로 산술연산을 위해 int형으로 
변환해야한다. */
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));

/* 전체 페이지수를 계산한다. 
(전체게시물의 갯수 / 페이지당 출력할 게시물 갯수) => 결과값의 올림처리
가령 게시물의 갯수가 51개라면 나눴을때 결과가 5.1이된다. 이때 무조건
올림처리하여 6페이지로 설정하게된다. 
만약 totalCount를 double형으로 변환하지 않으면 정수가 결과가 나오게
되므로 5페이지가 된다. 이 부분을 주의해야한다. */ 
int totalPage = (int)Math.ceil((double)totalCount / pageSize); 

/*목록에 처음 진입했을때는 페이지 관련 파라미터가 없는 상태이므로 무조건
1page로 지정한다. 만약 파라미터 pageNum이 있다면 request내장객체를 통해
받아온후 페이지번호로 지정한다.
List.jsp => 이와같이 파라미터가 없는 상태일때는 null
List.jsp?pageNum= => 이와같이 파라미터는 있는데 값이 없을때는 빈값으로체크된다. 따라서 아래 if문은 2개의 조건으로 구성해야한다. */
int pageNum = 1; 
String pageTemp = request.getParameter("pageNum");
if (pageTemp != null && !pageTemp.equals(""))
	pageNum = Integer.parseInt(pageTemp); 

/*게시물의 구간을 계산한다. 
각 페이지의 시작번호와 종료번호를 현재 페이지 번호와 페이지사이즈를 통해 계산한 후 DAO로 전달하기 위해 Map컬렉션에 추가한다. */
int start = (pageNum - 1) * pageSize + 1;
int end = pageNum * pageSize;
param.put("start", start);
param.put("end", end);
/* #paging관련 코드 추가 end# */

//목록에 출력할 게시물을 인출하여 반환받는다. 
List<NoticeDTO> noticeLists = dao.selectListPage(param);
//DB 자원 해제 
dao.close(); 
%>
<%@ include file="../include/global_head.jsp" %>
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
<% if(tname.equals("notice")) { %>
				<img src="../images/space/sub01_title.gif" alt="공지사항" class="con_title" />
				<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;공지사항<p>
<% } else if(tname.equals("freeboard")) { %>	
				<img src="../images/space/sub03_title.gif" alt="자유게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;자유게시판<p>
<% } %>			
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
   <thead class="table-secondary">
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
	int countNum = 0;
	for(NoticeDTO dto : noticeLists){
		virtualNum = totalCount-((pageNum-1)*pageSize+countNum++);
%>
     <tr>
       <td align="center"><%= virtualNum %></td>
       <td align="left"><a href="sub01_view.jsp?tname=<%=tname %>&idx=<%= dto.getIdx()%>"><%= dto.getTitle() %></a></td>
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
<table width="100%">
	<tr>
		<td width="85%" class="text-center">
		<%= BoardPage.pagingImg(totalCount, pageSize, blockPage, pageNum, request.getRequestURI()) %>
		</td>
		<td width="*">
<% if(tname.equals("notice") && mdto.getAdmin()==1 || tname.equals("freeboard")){ %>		
		<button type="button" onclick="location.href='sub01_write.jsp?tname=<%=tname %>';" >글쓰기</button>
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