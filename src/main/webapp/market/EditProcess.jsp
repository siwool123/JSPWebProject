<%@page import="m1notice.GoodsDAO"%>
<%@page import="m1notice.GoodsDTO"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.List"%>
<%@page import="fileupload.FileUtil"%>
<%@page import="m1notice.NoticeDTO"%>
<%@page import="m1notice.NoticeDAO"%>
<%@page import="utils.JSFunction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/IsLoggedIn.jsp" %>
<!-- 로그인 페이지에 오랫동안 머물러 세션이 삭제되는 경우가 있으므로 글쓰기 처리 페이지에서도 반드시 로그인을 확인해야한다.  -->    
<%
/* String UserId = session.getAttribute("UserId").toString();
MemberDAO mdao = new MemberDAO(application);
MemberDTO mdto = mdao.viewMember(UserId);
mdao.close();
if(!UserId.equals(mdto.getId())) {JSFunction.alertBack("관리자 본인만 수정할수있습니다.", out); return;} */
//클라이언트가 작성한 폼값을 받아온다.
int gidx = Integer.parseInt(request.getParameter("idx"));
String gname = request.getParameter("gname");
int price = Integer.parseInt(request.getParameter("price"));
int stock = Integer.parseInt(request.getParameter("stock"));
String content = request.getParameter("content");
String prevOfile = request.getParameter("prevOfile");
String prevSfile = request.getParameter("prevSfile");

GoodsDTO gdto = new GoodsDTO(); //폼값을 DTO객체에 저장한다.
gdto.setGidx(gidx);
gdto.setGname(gname);
gdto.setPrice(price);
gdto.setStock(stock);
gdto.setContent(content);
String oFileName = "";
String sDirectory = request.getServletContext().getRealPath("/Uploads/");

System.out.println(gidx+" / "+gname+" / "+content+" / "+prevOfile+" / "+prevSfile+" / "+sDirectory);

try{
	// Retrieves <input type="file" name="ofile" multiple="true">
	List<Part> fileParts = 
	    request.getParts().stream().filter(part -> "ofile".equals(part.getName()) && part.getSize() > 0).collect(Collectors.toList());

	for (Part filePart : fileParts) {
	    oFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
	    String sFileName = FileUtil.renameFile(sDirectory, oFileName);
	    
	    String dst = sDirectory + sFileName;
		
	    try (BufferedInputStream fin = new BufferedInputStream(filePart.getInputStream());
	        BufferedOutputStream fout = new BufferedOutputStream(new FileOutputStream(dst))) 
	    { 	int data;
	        while (true) {
	            data = fin.read();             
	            if(data == -1)  break;              
	            fout.write(data);
	        }
	    } catch(IOException e) { 
	    	e.printStackTrace();
	    	JSFunction.alertBack("개별 파일 용량은 1MB까지 업로드 가능합니다.", out);
	    }       
	    
	    System.out.println("Uploaded Filename: " + dst + ",  "+oFileName+ ",  "+sFileName);
	    
	    gdto.setOfile(oFileName);
	    gdto.setSfile(sFileName);
	    FileUtil.deleteFile(request, "/Uploads", prevSfile);
	}
}catch(Exception e) { 
	e.printStackTrace();
	JSFunction.alertBack("수정시 업로드한 파일명 얻어오는데 실패", out);
}
if(oFileName.equals("")){
	gdto.setOfile(prevOfile);
    gdto.setSfile(prevSfile);
}

GoodsDAO gdao = new GoodsDAO(application);
int iResult = gdao.editgoods(gdto); //상품글 1개 수정
gdao.close();

System.out.println("dto세팅된 파일명 : " + gdto.getOfile()+" / "+gdto.getSfile()+" / 결과값 : "+iResult);

if (iResult == 1) JSFunction.alertLocation("게시글 수정에 성공했습니다.", "sub01_view.jsp?idx="+gdto.getGidx(), out);
else JSFunction.alertBack("게시글 수정에 실패하였습니다.", out);
%>



