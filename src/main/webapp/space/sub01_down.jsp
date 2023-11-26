<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.File"%>
<%@page import="utils.JSFunction"%>
<%@page import="m1notice.NoticeDAO"%>
<%@page import="fileupload.FileUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String tname = request.getParameter("tname");
String ofile = request.getParameter("ofile"); //원본파일명
String sfile = request.getParameter("sfile"); //저장파일명
int idx = Integer.parseInt(request.getParameter("idx")); //게시물일련번호

String sDirectory = request.getServletContext().getRealPath("/Uploads");
try {
	File file = new File(sDirectory, sfile);
	InputStream iStream = new FileInputStream(file);
	
	String client = request.getHeader("User-Agent");
	if (client.indexOf("WOW64") == -1) ofile = new String(ofile.getBytes("UTF-8"), "ISO-8859-1");
    else ofile = new String(ofile.getBytes("KSC5601"), "ISO-8859-1");

    /* 파일 다운로드용 응답 헤더 설정
서버에 저장된 파일을 다운로드시 원본파일명으로 변경한다
파일명이 한글인 경우 깨짐 현상이 발생할수있어 앞에다 깨짐처리를 먼저진행한다 */
    response.reset();
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + ofile + "\"");
    response.setHeader("Content-Length", "" + file.length() );

    // response 내장 객체로부터 새로운 출력 스트림 생성
    OutputStream oStream = response.getOutputStream();

    // 출력 스트림에 파일 내용 출력
    byte b[] = new byte[(int)file.length()];
    int readBuffer = 0;
    while ((readBuffer = iStream.read(b)) > 0 ) oStream.write(b, 0, readBuffer);

    // 입/출력 스트림 닫음
    iStream.close();
    oStream.close();
}catch (FileNotFoundException e) {
    System.out.println("파일을 찾을 수 없습니다.");
    e.printStackTrace();
}catch (Exception e) {
    System.out.println("예외가 발생하였습니다.");
    e.printStackTrace();
}

NoticeDAO dao = new NoticeDAO(application);
int result = dao.downcntPlus(idx, tname);
dao.close();

if (result == 1) JSFunction.alertBack("첨부파일 다운에 성공하였습니다.", out);
else JSFunction.alertBack("첨부파일 다운에 실패하였습니다.", out);
%>