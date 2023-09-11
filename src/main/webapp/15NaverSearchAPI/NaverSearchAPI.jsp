<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>네이버검색api</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/f101226514.js" crossorigin="anonymous"></script><!-- 아이콘 -->
<script>
$(function(){
	$.ajaxSetup({
/* ajax함수에서 사용할 대부분의 속성들을 미리 설정하는 역할. 만약 해당페이지에 2개이상 ajax 함수가있다면 설정을 반복하지않아도되므로 편리하다 */
		url:"../NaverSearchAPI.do", //요청url
		type:"get", //전송방식
		contentType:"text/html;charset:utf-8;",
		dataType:"json", //콜백데이터의 형식
		success: sucFuncJson, 
		error: errFunc
	});
	$('#searchBtn').click(function(){
		/* 아에서 ajaxSetup 에서 설정한 모든 내용을 그대로 상속받아 사용하고 추가적인 부분만 설정하면된다
		서버로 요청시 전송할 데이터, 즉 파라미터 의미. 2개이상의 값 전송할수있도록 json 형태로 조립해서 설정해야한다 */
		$.ajax({
			data:{
				keyword:$('#keyword').val(), //검색어
				startNum:$('#startNum option:selected')val() //시작위치
			},
		});
	});
	$('#startNum').change(function(){
		$.ajax({
			data:{
				keyword:$('#keyword').val(),
				startNum:$('#startNum option:selected')val()
			},
		});
	});
});
//성공시 호출할 콜백함수를 js함수로 정의 > 콜백데이터는 json이므로 key로 접근 > 검색결과는 items 키칵ㅄ에 배열형태로 반환된다.
//따라서 배열크기만큼 반복하여 결과출력
function sucFuncJson(d){
	console.log("성공", d);
	var str="";
	console.log("검색결과", d.total);
	$.each(d.items, function(index, item){
		str+="<ul><li>"+(index+1)+"</li><li>"+item.title+"</li><li>"+item.desciption+"</li><li>"+item.bloggername+"</li>";
		str+="<li>"+item.bloggerlink+"</li><li>"+item.postdate+"</li><li><a href='"+item.link+"' target='_blank'>바로가기</a></li></ul>";
	});
	$('#searchResult').html(str); //js의 innerHTML()과 동일한 역할의함수로 html형식으로 삽입
}
function errFunc(e){
	alert("실패 : "+e.status);
}
</script>
<style>
ul {border:1px solid #cccccc}
</style>
</head>
<body>
	<div class="container">
	<div class="row">
		<a href="../NaverSearchAPI.do?keyword=종각역맛집&startNum=1">
			네이버검색정보JSON바로가기
		</a>
	</div>	
	<div class="row">
		<form id="searchFrm">			
			한페이지에 20개씩 노출됨 <br />
			<!-- 검색결과에서 출력할 시작위치 -->
			<select id="startNum">
				<option value="1">1페이지</option>
				<option value="21">2페이지</option>
				<option value="41">3페이지</option>
				<option value="61">4페이지</option>
				<option value="81">5페이지</option>
			</select>
			
			<input type="text" id="keyword" size="30" value="종각역맛집" />
<!-- jquery로 폼값전송하므로 버튼도 submit타입 아닌 button 타입으로 설정하면되고, 해당엘리먼트를 선택할수있도록 id속성부여해야한다 -->
			<button type="button" class="btn btn-info" id="searchBtn">
				Naver검색API요청하기
			</button>		
		</form>	
	</div>
	
	<div class="row" id="searchResult">
		요기에 정보가 노출됩니다
	</div>		
</div>

</body>
</html>