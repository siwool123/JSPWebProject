<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String id = request.getParameter("id");
MemberDAO dao = new MemberDAO(application);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 중복확인</title>
<script> 
    //재입력한 아이디를 부모창으로 전송한다.
    function idUse(){
        //opener속성을 통해 부모창의 DOM을 선택할 수 있다. 
        opener.document.joinForm.id.value = document.overlapFrm.retype_id.value;
        self.close();
    }
</script>
</head>
<body>
<h2>아이디 중복확인</h2>
<%
if(dao.checkId(id)){
%>      
   <p>입력한 아이디 <%= id %> 가 중복되어 사용할 수 없습니다. <br>
      다른 아이디를 다시 입력해 주세요.</p>
   <form name="overlapFrm">
      <input type="text" name="id" size="20" />
      <input type="submit" value="아이디중복확인" />
   </form>
<%
} else {
%>
	<p>입력한 아이디 <%= id %> 는 사용가능합니다. </p>
    <button onclick="idUse();">아이디 사용하기</button>
    <form name="overlapFrm">
    <input type="hidden" name="retype_id" value="<%= id %>" />
    </form>
<%
}
%>
</body>
</html>