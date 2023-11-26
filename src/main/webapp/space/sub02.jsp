<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<%@ include file="../include/IsLoggedIn.jsp" %>
  <!-- fullcalendar CDN -->
  <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
  <style>
    /* 캘린더 위의 해더 스타일(날짜가 있는 부분) */
    #calendar {height:600px !important; } 
    a {text-decoration: none !important; }
    .fc-daygrid-day-number, .fc-col-header-cell-cushion, .fc-today-button {color: black !important; }
    .fc--button {width: 0 !important; margin: 0 !important; padding: 0 !important;}
    .fc-col-header-cell {background-color: #ededed;}
    .fc-day-sat a { color:#0000FF !important; }     /* 토요일 */
    .fc-day-sun a { color:#FF0000 !important; }    /* 일요일 */
    .fc-button-group, .fc-next-button, .fc-button, .fc-button-primary, .fc-toolbar-chunk div {display:inline; float:left;}
    .fc-button-primary, .fc-prev-button, .fc-button {background-color: white !important; border:none !important;}
    .fc-icon {color:black;}
    .fc-h-event {background-color:yellow !important; border:none !important; }
    .fc-event-title {color:black !important;}
  </style>
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
				
<div id='calendar-container' class="mt-5 mb-5">
      <div id='calendar'></div>
    </div>
    <script>
    (function(){
      $(function(){
        // calendar element 취득
        var calendarEl = $('#calendar')[0];
        // full-calendar 생성하기
        var calendar = new FullCalendar.Calendar(calendarEl, {
          height: '700px', // calendar 높이 설정
          expandRows: true, // 화면에 맞게 높이 재설정
          slotMinTime: '08:00', // Day 캘린더에서 시작 시간
          slotMaxTime: '20:00', // Day 캘린더에서 종료 시간
          // 해더에 표시할 툴바
          headerToolbar: {
            left: '',
            center: 'prev, title, next, today',
            right: ''
          },
          eventClick: function(info) { // 이벤트를 클릭할 때 발생하는 이벤트
            // show event details in a popup
            var eventTitle = info.event.title;
            var eventStart = info.event.start;
            var eventEnd = info.event.end;
            var eventDetails = "Title: " + eventTitle + "\n\n시작일: " + eventStart + "\n종료일: " + eventEnd;
            alert(eventDetails);

            if(confirm("'"+ info.event.title +"' 일정을 삭제하시겠습니까 ?")){
                info.event.remove();
            }

            console.log(info.event);
            var events = new Array(); // Json 데이터를 받기 위한 배열 선언
            var obj = new Object();
                obj.title = info.event._def.title;
                obj.start = info.event._instance.range.start;
                events.push(obj);

            console.log(events);
            $(function deleteData(){
                $.ajax({
                    url: "/full-calendar/calendar-admin-update",
                    method: "DELETE",
                    dataType: "json",
                    data: JSON.stringify(events),
                    contentType: 'application/json',
                })
            })
          },
          initialView: 'dayGridMonth', // 초기 로드 될때 보이는 캘린더 화면(기본 설정: 달)
          initialDate: new Date(), // 초기 날짜 설정 (설정하지 않으면 오늘 날짜가 보인다.)
          navLinks: true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
          editable: true, // 수정 가능?
          selectable: true, // 달력 일자 드래그 설정가능
          nowIndicator: true, // 현재 시간 마크
          dayMaxEvents: true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)
          droppable: true,
          eventAdd: function(obj) { // 이벤트가 추가되면 발생하는 이벤트
            console.log(obj);
          },
          eventChange: function(obj) { // 이벤트가 수정되면 발생하는 이벤트
            console.log(obj);
          },
          eventRemove: function(obj){ // 이벤트가 삭제되면 발생하는 이벤트
            console.log(obj);
          },
          select: function(arg) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다.
            var title = prompt('일정을 입력해주세요 :');
            if (title) {
              calendar.addEvent({
            	 editable: true,
                title: title,
                start: arg.start,
                end: arg.end,
                allDay: arg.allDay,
              })
            }
            calendar.unselect()
          },
          // 이벤트 
          events: [
            {
              title: 'All Day Event',
              start: '2023-07-01',
            },
            {
              title: 'Long Event',
              start: '2023-07-07',
              end: '2023-07-10'
            },
            {   
            editable: true,
              groupId: 999,
              title: 'Repeating Event',
              start: '2023-07-09T16:00:00',
            },
            {
              groupId: 999,
              title: 'Repeating Event',
              start: '2023-07-16T16:00:00'
            },
            {
              title: 'Conference',
              start: '2023-10-11',
              end: '2023-10-13',
            },
            {
              title: 'Meeting',
              start: '2023-07-12T10:30:00',
              end: '2023-07-12T12:30:00'
            },
            {
              title: 'Lunch',
              start: '2023-07-12T12:00:00'
            },
            {
              title: 'Meeting',
              start: '2023-07-12T14:30:00'
            },
            {
              title: 'Happy Hour',
              start: '2023-07-12T17:30:00'
            },
            {
              title: 'Dinner',
              start: '2023-07-12T20:00:00'
            },
            {
              title: 'Birthday Party',
              start: '2023-07-13T07:00:00'
            },
            {
              title: 'Click for Google',
              url: 'http://google.com/', // 클릭시 해당 url로 이동
              start: '2023-07-28'
            }
          ]
        });
        // 캘린더 랜더링
        calendar.render();
      });
    })();
  </script>

			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
