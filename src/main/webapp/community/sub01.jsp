<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="../include/global_head.jsp" %>
 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/community/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/community_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
<c:choose>		
	<c:when test='${ tname.equals("staff") }'>		
					<img src="../images/community/sub01_title.gif" alt="직원자료실" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;직원자료실<p>
	</c:when>
	<c:when test='${ tname.equals("guard") }'>
					<img src="../images/community/sub02_title.gif" alt="보호자 게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;보호자 게시판<p>
	</c:when>
</c:choose>
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
<c:choose> 
	<c:when test="${ empty boardLists }">
	<tr>
		<td colspan="5" align="center">등록된 게시물이 없습니다.</td>
	</tr>
	</c:when>
	<c:otherwise> <!-- 출력할 게시물이 있을때 -->
		<c:forEach items="${ boardLists }" var="row" varStatus="loop">
		int virtualNum = 0;
		int countNum = 0;
		for(NoticeDTO dto : noticeLists){
		virtualNum = totalCount-((pageNum-1)*pageSize+countNum++);
     <tr>
       <td align="center">${ virtualNum }</td>
       <td align="left"><a href="sub01_view.jsp?tname=${tname}&idx=${ row.idx }">${ JSFunction.titleCut(row.title, 30) }</a></td>
       <td align="center">${ row.id }</td>
       <td align="center">${ row.visitcnt }</td>
       <td align="center">${ row.postdate }</td>
     </tr>
		</c:forEach>
	</c:otherwise>
</c:choose>
   </tbody>
</table>
<table width="100%">
	<tr>
		<td width="20%">총 ${ totalCount } 개   [ ${ pageNum } / ${totalPage} 페이지 ]</td>
		<td width="*" class="text-center">
		${ BoardPage.pagingImg(totalCount, pageSize, blockPage, pageNum, uri) }
		</td>
		<td width="15%" align="right">
<c:set></c:set>
<c:if test='tname.equals("staff") && mdto.grade==2 || tname.equals("staff") && mdto.grade==1 || tname.equals("guard")'>
		<button type="button" onclick="location.href='sub01_write.jsp?tname=${ tname }';" >글쓰기</button>
</c:if>
		</td>
	</tr>
</table>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
