<%@page import="fileupload.FileUtil"%>
<%@page import="m1notice.NoticeDAO"%>
<%@page import="m1notice.NoticeDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<% /* 일련번호를 폼값으로 받는다. > 본인확인위해 기존게시물추출 */
int idx = Integer.parseInt(request.getParameter("idx"));
String tname = request.getParameter("tname");

NoticeDTO dto = new NoticeDTO();
NoticeDAO dao = new NoticeDAO(application);
dto = dao.selectView(idx, tname);

String sessionId = session.getAttribute("UserId").toString();
//String sessionId = (String)session.getAttribute("UserId");
/* 세션영역에 저장된 회원정보를 얻어온후 String 타입으로 변환한다.
  세션아이디와 게시물아이디가일치하면 작성자 본인이므로..> 게시물 삭제 > 삭제후목록으로이동*/

int delResult = 0;
if(dto.getId().equals(sessionId)){
	dto.setIdx(idx);
	dto.setTname(tname);
	delResult = dao.deletePost(dto);
	dao.close();
	
	System.out.println(idx +" / "+sessionId +" / "+delResult);
	
	if(delResult == 1) {
		String sFileName = dto.getSfile();
		FileUtil.deleteFile(request, "/Uploads", sFileName);
		JSFunction.alertLocation("삭제되었습니다.", "sub01.jsp?tname="+tname, out);
	}
	else JSFunction.alertBack("삭제에 실패했습니다.", out); //삭제실패시뒤로이동
}else{
	JSFunction.alertBack("본인만 삭제할 수 있습니다.", out); //작성자본인아니면 삭제불가
	return;
}
%>