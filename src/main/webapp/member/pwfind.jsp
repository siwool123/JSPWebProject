<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.MessagingException"%>
<%@page import="javax.mail.internet.AddressException"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.PasswordAuthentication"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="utils.JSFunction"%>
<%@page import="membership.MemberDTO"%>
<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<% 

String userId = request.getParameter("user_id");
String userName = request.getParameter("user_name");
String userEmail = request.getParameter("user_email");

System.out.println(userName+" : "+userEmail);
MemberDAO dao = new MemberDAO(application);
MemberDTO dto = dao.pwfind(userId, userName);
dao.close();

if(dto.getPw()== null){
	JSFunction.alertBack("미등록 회원입니다. 회원가입을 진행해주세요.", out);
	return;
}

/*//2. Property에 SMTP 서버 정보 설정
Properties prop = new Properties();
prop.put("mail.smtp.host", "smtp.gmail.com");
prop.put("mail.smtp.port", 465);
prop.put("mail.smtp.auth", "true");
prop.put("mail.smtp.ssl.enable", "true");
prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");

//3. SMTP 서버정보와 사용자 정보를 기반으로 Session 클래스의 인스턴스 생성
Session session1 = Session.getDefaultInstance(prop, new javax.mail.Authenticator() {
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication("siwool12321@gmail.com", dto.getPw());
    }
});
// 4. Message 클래스의 객체를 사용하여 수신자와 내용, 제목의 메시지를 작성한다.
// 5. Transport 클래스를 사용하여 작성한 메세지를 전달한다.
MimeMessage message = new MimeMessage(session1);
try {
    message.setFrom(new InternetAddress("siwool12321@gmail.com"));
    // 수신자 메일 주소
    message.addRecipient(Message.RecipientType.TO, new InternetAddress(dto.getEmail()));

    message.setSubject(dto.getId()+" 님, 수아밀 회원 정보 발송드립니다."); // Subject

    message.setText("수아밀 방문을 환영합니다. "+dto.getId()+" 회원님의 비밀번호는 ["+dto.getPw()+"] 입니다. <div><a href='http://localhost:8082/JSPWebProject/main/main.jsp'>로그인 하러가기</a></div>"); // Text

    Transport.send(message);    // send message
	System.out.println("메일 보내기 성공");
} catch (AddressException e) {
    e.printStackTrace();
} catch (MessagingException e) {
    e.printStackTrace();
} */
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비번찾기</title>
</head>
<body>
<center>
<div id="wrap">
	<%@ include file="../include/top.jsp" %>
	<img src="../images/member/sub_image.jpg" id="main_visual" />
	<div class="contents_box">
		<div class="left_contents">
			<%@ include file = "../include/member_leftmenu.jsp" %>
		</div>
		<div class="right_contents">
<% if(dto.getPw() != null){		%>
		<p style="padding:10px"><b><%= userName %> 님,</b> <br />
		아이디 <%= userId %> 에 해당하는 비밀번호는 <b><%= dto.getPw() %></b> 입니다.</p>
		<p style="text-align:right; padding-right:10px;">
			<a href="login.jsp" style="border:1px solid red; padding:0 20px;"><img src="../images/lnb01.gif" /></a>
			<a href="join01.jsp"><img src="../images/login_btn03.gif" /></a>
		</p>
<% } %>
		</div>
	</div>
	<%@ include file="../include/quick.jsp" %>
</div>
<%@ include file="../include/footer.jsp" %>
</center>
 </body>
</html>