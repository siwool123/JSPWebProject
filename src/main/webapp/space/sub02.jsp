<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<%@ include file="../include/IsLoggedIn.jsp" %>
<style>
#calendarTitle {display:none ;}
</style>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth', 
    //plugins: [ googleCalendarPlugin ],
    googleCalendarApiKey: 'AIzaSyC-XXNC_9Ur3cZ3JQxWAttU346_Z85BTng',
    events: {
      googleCalendarId: 'd5ca25c992455e98d8c82204244d348b0faa68bcb0893d3e752bac331716e35c@group.calendar.google.com',
      className: 'gcal-event' // an option!
    }
  });
  calendar.render();
});
</script>
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
					<img src="../images/space/sub02_title.gif" alt="프로그램일정" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;프로그램일정<p>
				</div>
				
				<!-- <div id="calendar"></div> -->
 <div class="mb-5">
<iframe src="https://calendar.google.com/calendar/embed?height=600&wkst=1&bgcolor=%23ffffff&ctz=Asia%2FSeoul&showTitle=0&showTz=0&showNav=1&showCalendars=1&showPrint=0&src=ZDVjYTI1Yzk5MjQ1NWU5OGQ4YzgyMjA0MjQ0ZDM0OGIwZmFhNjhiY2IwODkzZDNlNzUyYmFjMzMxNzE2ZTM1Y0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t&src=a28uc291dGhfa29yZWEjaG9saWRheUBncm91cC52LmNhbGVuZGFyLmdvb2dsZS5jb20&color=%23F6BF26&color=%23D50000" style="border: 0" width="100%" height="600" frameborder="0" scrolling="no"></iframe>
</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
