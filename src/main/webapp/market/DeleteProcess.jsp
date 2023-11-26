<%@page import="m1notice.GoodsDAO"%>
<%@page import="m1notice.GoodsDTO"%>
<%@page import="fileupload.FileUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<% /* 일련번호를 폼값으로 받는다. > 본인확인위해 기존게시물추출 */
int gidx = Integer.parseInt(request.getParameter("idx"));

GoodsDTO gdto = new GoodsDTO();
GoodsDAO gdao = new GoodsDAO(application);
gdto = gdao.selectView(gidx);

int delResult = 0;
gdto.setGidx(gidx);
delResult = gdao.delgoods(gdto);
gdao.close();

System.out.println(gidx +" / "+delResult);

if(delResult == 1) {
	String sFileName = gdto.getSfile();
	FileUtil.deleteFile(request, "/Uploads", sFileName);
	JSFunction.alertLocation("삭제되었습니다.", "sub01.jsp", out);
}
else JSFunction.alertBack("삭제에 실패했습니다.", out); //삭제실패시뒤로이동
%>