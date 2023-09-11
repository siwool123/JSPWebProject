<%@page import="m1notice.NoticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int idx = Integer.parseInt(request.getParameter("idx"));
String tname = request.getParameter("tname");
NoticeDAO dao = new NoticeDAO(application);
dao.updateLikecnt(idx, tname);
%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/f101226514.js" crossorigin="anonymous"></script>
 <!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
.starPoint i:hover,
.starActive {
    color: red !important;
}
</style>
<script>
/* form 하위태그인 input, select, textarea에서는 this 사용가능
 * 따라서 this.form 통해 dom을 매개변수로 전달가능 */
function jsSubmit(f) {
	if(f.good.value=='') {
		alert('좋아요를 입력하세요');
		f.good.focus();
		return;
	}
	f.submit();
}
/* form의 하위태그가 아닌 a, img 같은 태그에서는 this 사용불가능 > docuemnt 통해 객체얻어와야한다. 
 */
function iconSubmit() {
	var f2 = document.frm;
	if(f2.good.value=='') {
		alert('좋아요를 입력하세요 2');
		f2.good.focus();
		return;
	}
	f2.submit();
}
$(function () {
$(".starPoint .fa-star").click(function () {
    $(this).addClass("starActive");
    $(this).prevAll().addClass("starActive");
    var starNum = $(".starActive").length;
    $(".starCount").text(starNum);
});

$('#btn01').click(function(){
	//alert("클림된?");
	$.post('formSubmit.jsp', {'good':$('#good').val()}, function(resD){
		console.log('콜백데이터', resD);
	});
});
});

$(function () {
	let like_count = document.getElementById('like_count')
	let likeval = document.getElementById('like_check').value
	const b_number = '${b.b_number}';
	const m_id = "${sessionScope.loginId}";
	const likeimg = document.getElementById("likeimg")

	if (likeval > 0) {
		likeimg.src = "/resources/img/좋아요후.png";
	}
	else {
		likeimg.src = "/resources/img/좋아요전.png";
	}
    // 좋아요 버튼을 클릭 시 실행되는 코드
$(".likeimg").on("click", function () {
	$.ajax({
      url: '/board/like',
      type: 'POST',
      data: { 'b_number': b_number, 'm_id': m_id },
      success: function (data) {
          if (data == 1) {
              $("#likeimg").attr("src", "/resources/img/좋아요후.png");
              location.reload();
          } else {
              $("#likeimg").attr("src", "/resources/img/좋아요전.png");
              location.reload();
          }
      }, error: function () {
          $("#likeimg").attr("src", "/resources/img/좋아요후.png");
          console.log('오타 찾으세요')
      }

  });

  });
  });
</script>
<body>
<form name="frm" method="post" action="formSubmit.jsp">
	<input type="text" name="good" value="좋아요" id="good" />
	<input type="submit" value="전송(only HTML)" />
	<input type="button" value="전송(with js)" onclick="jsSubmit(this.form);" />
	<a class="starPoint" href="javascript:iconSubmit();"><i class="fa-solid fa-heart" style="color:gray;font-size:20px;"></i></a> <span class="like_count">0</span>
	<input type="button" value="전송(ajax_post)" id="btn01" />
</form>
</body>
</html>