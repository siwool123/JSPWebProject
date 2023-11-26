<%@page import="m1notice.ReviewDAO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="m1notice.GoodsDTO"%>
<%@page import="m1notice.GoodsDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="m1notice.CommentDTO"%>
<%@page import="m1notice.CommentDAO"%>
<%@page import="fileupload.FileUtil"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<%@ include file="../include/global_head.jsp" %>
<%
String UserId = session.getAttribute("UserId").toString();
MemberDAO mdao = new MemberDAO(application);
MemberDTO mdto = mdao.viewMember(UserId);
mdao.close();
int gidx = Integer.parseInt(request.getParameter("idx"));
String ofile = request.getParameter("ofile"); 
String sfile = request.getParameter("sfile");

GoodsDAO gdao = new GoodsDAO(application);
int[] maxmin = new int[2];
maxmin = gdao.maxmin(); //게시글번호 최대값, 최소값을 배열로 받아온다
int prevIdx = gdao.previousIdx(gidx); //이전 게시글 제목과 링크 달기위해 게시글번호 받아오기
int nextIdx = gdao.nextIdx(gidx); //다음게시글번호 받아오기
GoodsDTO gdto = gdao.selectView(gidx); //현재게시물dto 받아오기
GoodsDTO pgdto = gdao.selectView(prevIdx); //이전게시물dto받아오기
GoodsDTO ngdto = gdao.selectView(nextIdx); //다음게시물dto받아오기
gdao.close();
gdto.setContent(gdto.getContent().replaceAll("\r\n", "<br/>"));

ReviewDAO rdao = new ReviewDAO(application);
List<CommentDTO> reviewLists = rdao.selectList(gidx); //해당게시물의 답변목록 받아오기
rdao.close();
//첨부파일 확장자 추출 및 이미지 타입 확인
String ext = "", fileName = gdto.getSfile();
if(fileName!=null) ext = fileName.substring(fileName.lastIndexOf(".")+1);		
String[] imgStr = {"png", "jpg", "gif"};
List<String> imgList = Arrays.asList(imgStr);

boolean isImage = false;
if(imgList.contains(ext)) isImage = true; //상품첨부파일이 이미지이면 본문에 표시
DecimalFormat dFormat = new DecimalFormat("###,###");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품주문_상세보기</title>
<style type="text/css">
.comment tr td, .comment tr, .comment {background-color:#f8f8f8;}
.hideCon {display:inline-block;}
input {height:28px;}
.starPoint i:hover, .starActive {color: red !important;}
#ta_count { margin-left:10px; color:gray;}
</style>
<script type="text/javascript">
//게시물삭제위한js함수 > confirm함수는 대화창에서 예 클릭시 true반환된다.
/* form 태그의 name속성통해 DOM을 얻어온다 > 전송방식과 전송경로를 지정한다 > submit 함수로 폼값전송 > 폼태그하위의 hidden타입설정된 일련번호전송 */
function deletePost() {
    if (confirm("정말로 삭제하시겠습니까?")) {
        var form = document.viewFrm;
        form.method = "post";
        form.action = "DeleteProcess.jsp?idx=<%=gidx%>";
        form.submit();
    }
}
//콤마찍기
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
$(function () {
	$(".editComment").click(function(){
		$(this).hide();
		$(this).next().hide();
		$(this).parent().parent().next().hide();
		$(this).parent().parent().next().next().show();
		//var commentId = $(this).data('comment-id');
		//if($(".hideCon").data('comment-id')==commentId) $(".hideCon").hide();
		//$(this).closest('.hideCon').hide();
		//$(this).closest('tr').next('tr#unhide').show();
	});
	// 상품상세페이지 가격 계산
	var tprice = Number(<%=gdto.getPrice()%>);
	$('input[type=number]').change(function () {
	    $("#tprice").html(comma(tprice*$(this).val()));
	});
	// 제품상세페이지 리뷰작성시 별점매기기
    $(".starPoint .fa-star").click(function () {
        $(this).addClass("starActive");
        $(this).prevUntil('input[name=start]').addClass("starActive");
        var starNum = $(".starPoint .starActive").length;
        $(".starCnt").text(starNum);
        $('input[name=starCnt]').val(starNum);
    });
	$('.commentLike').click(function(){
		alert("리뷰 좋아요 1 증가");
		$(this).css('color', 'red');
		var commentId = $(this).data('comment-id'), sid = $('span').data('comment-id'); 
		// 클릭된 버튼의 data-comment-id 속성을 통해 답글 ID를 가져옵니다. > 나머지 코드는 답글 ID를 사용하여 클릭된 버튼과 관련된 답글의 좋아요 숫자를 업데이트합니다.
		var likeCnt = $(this).next(), likeCnt2 = parseInt($(this).next().text()); // 현재 좋아요 숫자를 가져옵니다.
	    likeCnt.text(likeCnt2+1);
		var params = {comment_idx:commentId};
		$.post('ReviewLike.jsp', params, function(resD){
			console.log('commentId값, cnt값', commentId, likeCnt2);
		});
	});
	$('textarea[name=content]').keyup(function(){
		$('#ta_count').html($(this).val().length);
		if($(this).val().length>400){
			alert("내용을 400자 이내로 입력해주세요.");
			$(this).val($(this).val().substring(0,400));
		}
	});
});
</script>
</head>
 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>
		<img src="../images/market/sub_image.jpg" id="main_visual" />
		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/market_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/market/sub01_title.gif" alt="수아밀 제품 주문" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린장터&nbsp;>&nbsp;수아밀 제품 주문<p>
				</div>
<div class="container">
  <div class="row">
    <div class="col-5">
      <% if(gdto.getOfile()!=null && isImage==true) { %>
			<img src="../Uploads/<%= gdto.getSfile() %>" style="max-width:100%" class="text-center" />
		<% } %>
    </div>
    <div class="col-7">
		<form id="writeFrm" method="post" action="cartprocess.jsp">
		<input type="hidden" name="gidx" id="gidx" value="<%= gdto.getGidx() %>" />
			<table class="table" width="100%">
				<tr><th colspan="2"><h5 class="fw-bold"><%= gdto.getGname() %></h5></th></tr>
				<tr>
					<td width="30%">판매가</td>
					<td><%= dFormat.format(gdto.getPrice()) %> 원</td>
				</tr>
				<tr>
					<td>재고</td>
					<td><%= gdto.getStock() %></td>
				</tr>
				<tr>
					<td>수량</td>
					<td>
					<input type="number" name="amount" min="1" max="<%= gdto.getStock() %>" value="1" id="amount" class="border" /> 
					</td>
				</tr>
				<tr>
					<td>총 금액</td>
					<td><b id="tprice"><%= dFormat.format(gdto.getPrice()) %></b> 원</td>
				</tr>
				<tr>
					<td>적립금</td>
					<td><span id="save"><%= gdto.getPrice()/100 %></span> 원</td>
				</tr>
				<tr>
					<td>주문메세지</td>
					<td><input type="text" name="msg" placeholder="케익 문구 등 요청사항을 입력하세요." class="border" size="40" required /></td>
				</tr>
				<tr>
					<td colspan="2" align="center"><button type="submit"><i class="fa-solid fa-dollar-sign" style="color:white;"></i> 바로구매</button>
					<button onclick="location.href='cartprocess.jsp?idx=<%=gidx%>';"><i class="fa-solid fa-cart-shopping" style="color:white;"></i> 장바구니</button></td>
				</tr>
			</table>
		</form>
    </div>
  </div>
</div>
	<% if(gdto.getOfile()!=null && isImage==true) { %>
		<div class="text-center mt-5"><img src="../Uploads/<%= gdto.getSfile() %>" style="max-width:100%" /></div>
	<% } %>
	<div class="mt-5 mb-5">	<%= gdto.getContent().replace("\r\n", "<br/>") %></div>
<!-- 답글목록출력 (답변작성자 본인에게만 수정,삭제버튼 표시 > 수정 클릭시 기존답글 숨겨지고 그내용입력된 textarea창과 작성완료버튼 표시됨) -->
<% if(!reviewLists.isEmpty()){ %>
	<div class="text-center bg-dark" style="color:white;line-height:26px;width:100%;" >리뷰 <%= reviewLists.size() %></div>
	<table class="table table-borderless comment" width="90%">
	<% for(CommentDTO rdto : reviewLists){ %>
	<tr>
		<td width="5%"><i class="fa-solid fa-face-smile" style="font-size:20px;"></i></td>
		<td width="73%"><%= rdto.getId() %> <span style="color:gray; margin:0 20px;"><%= rdto.getCommentdate() %></span>
		<span><% for(int i=0; i<rdto.getStar(); i++){ %><i class="fa-solid fa-star starActive"></i><% } %></span>&nbsp;&nbsp;&nbsp;
<% if(rdto.getId().equals(UserId)){ %>	
		<button class="editComment" data-comment-id="<%= rdto.getIdx() %>">수정</button>&nbsp;
<form name="ReviewDelFrm" method="post" action="ReviewDelete.jsp" style="display:inline;">
<input type="hidden" name="comment_idx" value="<%= rdto.getIdx() %>" />	
<input type="hidden" name="idx" value="<%= gidx %>" />
		<button type="submit" onclick="confirm("정말로 리뷰를 삭제하시겠습니까?");" class="hideCon" data-comment-id="<%= rdto.getIdx() %>">삭제</button>
</form>	
<% } %>
		</td>
		<td align="right">좋아요 <i class="fa-solid fa-heart commentLike" data-comment-id="<%= rdto.getIdx() %>"></i> <span data-comment-id="<%= rdto.getIdx() %>"><%= rdto.getLikecnt() %></span>
		<span style="margin:0 10px;">|</span><a href="">신고</a><input type="hidden" name="comment_idx" value="<%= rdto.getIdx() %>" />	
		</td>
	</tr>
	<tr class="border-bottom" class="hideCon" data-comment-id="<%= rdto.getIdx() %>">
		<td></td>
		<td colspan="2" class="hideCon" data-comment-id="<%= rdto.getIdx() %>"><%= rdto.getContent().replace("\r\n", "<br/>") %> <br /><br />
		<% String fileName2 = rdto.getSfile(); //첨부파일 확장자 추출 및 이미지 타입 확인
		if(fileName2!=null) ext = fileName2.substring(fileName2.lastIndexOf(".")+1);
		boolean isImage2 = false;
		if(imgList.contains(ext)) isImage2 = true; //상품첨부파일이 이미지이면 본문에 표시
		if(rdto.getOfile()!=null && isImage2==true) { %>
		<img src="../Uploads/<%= rdto.getSfile() %>" style="max-width:300px;margin-bottom:20px;" />
		<% } %>
		</td>
	</tr>
	<tr style="display:none;" id="unhide" class="border-bottom" data-comment-id="<%= rdto.getIdx() %>">
		<form name="commentEditFrm" method="post" action="ReviewEdit.jsp" data-comment-id="<%= rdto.getIdx() %>" enctype="multipart/form-data" multiple>
		<input type="hidden" name="prevROfile" value="<%= rdto.getOfile() %>" />
		<input type="hidden" name="prevRSfile" value="<%= rdto.getSfile() %>" />
		<input type="hidden" name="comment_idx" value="<%= rdto.getIdx() %>" />
		<input type="hidden" name="idx" value="<%= gidx %>" />
		<input type="hidden" name="prevStarCnt" value="<%= rdto.getStar() %>" />
		<td width="5%"></td>
		<td>
		<textarea name="content" style="width:100%;height:100px;padding:10px;"><%= rdto.getContent() %></textarea>
		<% String fileName3 = rdto.getSfile(); //첨부파일 확장자 추출 및 이미지 타입 확인
		if(fileName3!=null) ext = fileName3.substring(fileName3.lastIndexOf(".")+1);
		boolean isImage3 = false;
		if(imgList.contains(ext)) isImage3 = true; //리뷰에 첨부이미지 있으면 본문에 표시
		if(rdto.getOfile()!=null && isImage3==true) { %>
		<img src="../Uploads/<%= rdto.getSfile() %>" style="max-width:100px;margin-top:20px;" />
		<% } %>
		<br /><br /><span class="starPoint">
	<% for(int i=0; i<5; i++){ %><i type="button" class="fa-solid fa-star"></i><% } %>
         &nbsp;&nbsp; &nbsp;<b class="starCnt">5 </b><span style="color: #999;"> / 5</span>
	</span> &nbsp;&nbsp; &nbsp; 별점을 남겨주세요.  <input type="hidden" name="starCnt" value="5" /><br /><br />
	<p>첨부 이미지 : 개별 파일 용량은 3MB까지이며, .jpg, .png, .gif 파일만 업로드 가능합니다.</p>
	<input type="file" name="rofile" id="rofile" multiple class="form-control form-control-sm" accept=".jpg, .png, .gif" />
		</td>
		<td align="right"><button type="submit">수정완료</button></td>
		</form>
	</tr>
<%
	}
}
%>
</table>
<!-- 답변작성폼 -->
<form name="reviewFrm" method="post" action="ReviewWrite.jsp?idx=<%=gidx%>" onsubmit="return validateForm(this);"  enctype="multipart/form-data" multiple>
<div class="text-center bg-dark" style="color:white;line-height:26px;width:100%;" >리뷰작성</div>
<table class="table comment">
<tr>
	<td width="5%" class="pt-4"><i class="fa-solid fa-face-smile" style="font-size:20px;"></i></td>
	<td class="pt-4 pb-4">
	<textarea name="content" style="width:100%;height:100px;padding:10px;" placeholder="로그인하셔야 리뷰 작성 가능합니다. 400자 이내로 작성해주세요."></textarea><br/><br/>
	<br /><span class="starPoint">
	<% for(int i=0; i<5; i++){ %><i type="button" class="fa-solid fa-star"></i><% } %>
         &nbsp;&nbsp; &nbsp;<b class="starCnt">5 </b><span style="color: #999;"> / 5</span>
	</span> &nbsp;&nbsp; &nbsp; 별점을 남겨주세요. <input type="hidden" name="starCnt" value="5" /> <br /><br />
	<p>첨부 이미지 : 개별 파일 용량은 3MB까지이며, .jpg, .png, .gif 파일만 업로드 가능합니다.</p>
	<input type="file" name="rofile" id="rofile" multiple class="form-control form-control-sm" accept=".jpg, .png, .gif" />
	</td>
	<td align="right" width="15%" class="pt-4"><button type="submit">리뷰입력</button><br /><br /><span id="ta_count">0</span> / 400</td>
</tr>
</table>
</form>
<!-- 이전/다음페이지 타이틀및링크, 수정,삭제,목록 버튼 표시 테이블 -->
<div align="center">
<button type="button" onclick="location.href='sub01.jsp';">목록보기</button>
<% if(mdto.getGrade()==1) { %>
		<form name="viewFrm" style="display:inline;">
		<button type="button" onclick="location.href='sub01_edit.jsp?idx=<%= gidx %>';">수정하기</button>
		<!-- 삭제버튼누르면 js함수 호출. 해당함수는 submit()통해 폼값을서버로전송 -->
		<button type="button" onclick="deletePost();">삭제하기</button>
		</form> 
<%	} %>
</div>
<div class="container">
  <div class="row">
    <div class="col text-center mt-5">
      <% if(gidx<maxmin[0]){ %>
      	<img src="../Uploads/<%= pgdto.getSfile() %>" style="width:40%" class="text-center" /><br />
		<a href="sub01_view.jsp?idx=<%= prevIdx %>">이전상품 : <%= JSFunction.titleCut(pgdto.getGname(), 16) %></a>
	  <% } %>
    </div>
    <div class="col text-center mt-5">
      <% if(gidx>maxmin[1]){ %>
		<img src="../Uploads/<%= ngdto.getSfile() %>" style="width:40%" class="text-center" /><br />
		<a href="sub01_view.jsp?idx=<%= nextIdx %>">다음상품 : <%= JSFunction.titleCut(ngdto.getGname(), 16) %></a> 
	  <% } %>
    </div>
  </div>
</div>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>


	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>