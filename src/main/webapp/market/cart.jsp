<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utils.CookieManager"%>
<%@page import="m1notice.GoodsDTO"%>
<%@page import="m1notice.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<%@ include file="../include/IsLoggedIn.jsp" %>
<%
ArrayList<Integer> cart = (ArrayList<Integer>)session.getAttribute("cart");
DecimalFormat dFormat = new DecimalFormat("###,###");
%>
<script>
//콤마찍기
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
$(function () {
	// 상품상세페이지 가격 계산
	$('tr.item td input[type=number]').change(function () {
		var price = parseInt($(this).parent().siblings().filter(':eq(3)').find('span:eq(0)').html().replace(/,/g, ''));
	    $(this).parent().next().find('b.tprice').html(comma(price*$(this).val()));
	    $(this).parent().prev().find('span.point').html(price*$(this).val()/100);
	    var sum = 0;
	    $('b.tprice').each(function(){
	    	sum += parseInt($('b.tprice').html().replace(/,/g, ''));
	    });
	    $('.tprice2').html(comma(sum));
	});
});
</script>
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
			<h6 class="fw-bolder text-center mb-4">장바구니</h6>
			<table class="table">
				<thead class="table-secondary text-center">
					<tr>
						<th width="6%" >선택</th>
						<th width="10%" >이미지</th>
						<th width="*" >상품명</th>
						<th width="10%" >판매가</th>
						<th width="8%" >적립금</th>
						<th width="10%" >수량</th>
						<th width="10%" >합계</th>
						<th width="10%" >배송비</th>
						<th width="8%" >삭제</th>
					</tr>
				</thead>
				<tbody>
<% for(int gidx:cart){
		GoodsDAO gdao = new GoodsDAO(application);
		GoodsDTO gdto = gdao.selectView(gidx); %>
					<tr class="item">
						<td><input type="checkbox" name="selected" value="" /></td>
						<td><img src="../Uploads/<%= gdto.getSfile() %>" style="width:50px;" /></td>
						<td><a href="sub01_view.jsp?idx=<%= gdto.getGidx()%>"><%= gdto.getGname() %></a></td>
						<td><span class="price"><%= dFormat.format(gdto.getPrice()) %></span> 원</td>
						<td><span class="point"><%= gdto.getPrice()/100 %></span> 원</td>
						<td><input type="number" name="amount" value="1" class="border" min="1" style="width:50px" max="<%= gdto.getStock() %>" /></td>
						<td><b class="tprice"><%= dFormat.format(gdto.getPrice()) %></b> 원</td>
						<td>무료배송</td>
						<td><a href="">삭제</a></td>
					</tr>
<% } %>
				</tbody>
			</table>
			<p class="basket_text">[ 기본 배송 ] <span>상품구매금액</span> <b class="tprice2">0</b> + <span>배송비</span> 0 = 합계 : <b class="tprice2">0</b>원<br /><br />
			<button onclick="location.href='javascript:history.back()';">&lt; 쇼핑계속하기</button>&nbsp;
			<button onclick="location.href='cart02.jsp';">선택상품주문</button>&nbsp;
			<button onclick="location.href='cart02.jsp';">전체상품주문</button></p>
		</div>
	</div>
	<%@ include file="../include/quick.jsp" %>
</div>


<%@ include file="../include/footer.jsp" %>
</center>
 </body>
</html>
