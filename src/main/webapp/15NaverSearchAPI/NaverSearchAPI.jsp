<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(function() {
	/* ajax() 함수에서 사용할 대부분의 속성들을 미리 설정하는 역할을 한다.
	만약 해당 페이지에 2개 이상의 ajax()함수가 있다면 반복적인 설정을 하지 
	않아도 되므로 편리하다. */
	$.ajaxSetup({
		url : "../NaverSearchAPI.do", //요청URL(ajax로 전송한값이 전달되는 위치)
        type : "get", //전송방식
        contentType : "text/html;charset:utf-8",
        dataType : "json", //콜백 데이터의 형식 
        success : sucFuncJson, //성공했을때 실행할 콜백 함수 
        error : errFunc //실패했을때 실행할 콜백 함수 
	});
	//검색하기 버튼을 클릭하면 아래 함수를 실행한다. 
    $('#searchBtn').click(function() {
    	/* 앞에서 ajaxSetup()에서 설정한 모든 내용을 그대로 상속받아 사용하고
    	추가적인 부분만 설정하면 된다. */
    	$.ajax({
    		/* 서버로 요청시 전송할 데이터, 즉 파라미터를 의미한다. 2개 이상의
    		값을 전송할 수 있도록 JSON형태로 조립해서 설정해야한다. */
    		data : {
    			keyword : $('#keyword').val(), //검색어
    			startNum : $('#startNum option:selected').val() //시작위치
    		},
    	});
    });
	//<select> 박스의 항목을 선택하는 순간 발생되는 change이벤트에 대한 처리
    $('#startNum').change(function() {
    	$.ajax({
    		data : {
    			keyword : $('#keyword').val(),
    			startNum : $('#startNum option:selected').val()
    		},
    	});
    });
});

//성공시 호출할 콜백함수를 JS함수로 정의 
function sucFuncJson(d) {
	console.log("성공", d);
    var str = "";
    /* 콜백데이터는 JSON이므로 key를 통해 접근하면 된다. */
    console.log("검색결과", d.total);
    /* 검색결과는 items 키값에 배열 형태로 반환된다. 따라서 배열의 크기만큼
    반복해서 파싱하기 위해 each() 함수를 사용한다. */
    $.each(d.items, function(index, item) {
        str += "<ul>";
        str += "    <li>" + (index + 1) + "</li>";
        str += "    <li>" + item.title + "</li>";
        str += "    <li>" + item.description + "</li>";
        str += "    <li>" + item.bloggername + "</li>";
        str += "    <li>" + item.bloggerlink + "</li>";
        str += "    <li>" + item.postdate + "</li>";
        str += "    <li><a href='" + item.link + "' target='_blank'>바로가기</a></li>";
        str += "</ul>";
    });
    //JS의 innerHTML()과 동일한 역할의 함수로 html형식으로 삽입한다. 
    $('#searchResult').html(str);
}

// 실패 시 경고창을 띄워줍니다.
function errFunc(e) {
    alert("실패: " + e.status);
}
</script>

<style>
    ul{border:2px #cccccc solid;}
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
		<!-- ajax를 통해 폼값을 전송할때는 jQuery에서 대부분의 설정을 하므로
		<form> 태그는 아래와같이 기본설정만 하면된다.  -->
		<form id="searchFrm">			
			한페이지에 20개씩 노출됨 <br />
			
			<!-- 검색결과에서 출력할 시작위치  -->
			<select id="startNum">
				<option value="1">1페이지</option>
				<option value="21">2페이지</option>
				<option value="41">3페이지</option>
				<option value="61">4페이지</option>
				<option value="81">5페이지</option>
			</select>
			
			<!-- 검색어 입력 상자  -->
			<input type="text" id="keyword" size="30" />
			
			<!-- jQuery를 통해 폼값을 전송하므로 버튼도 submit타입이 아닌
			button타입으로 설정하면 되고, 해당 엘리먼트를 선택할 수 있도록
			id속성을 부여해야한다.  -->
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