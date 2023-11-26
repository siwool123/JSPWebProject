<%@page import="m1notice.GoodsDAO"%>
<%@page import="m1notice.GoodsDTO"%>
<%@page import="fileupload.FileDTO"%>
<%@page import="fileupload.FileDAO"%>
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
<%
//클라이언트가 작성한 폼값을 받아온다.
String sDirectory = request.getServletContext().getRealPath("/Uploads/");

String gname = request.getParameter("gname");
int price = Integer.parseInt(request.getParameter("price"));
int stock = Integer.parseInt(request.getParameter("stock"));
String content = request.getParameter("content");
System.out.println(sDirectory+" : "+gname+" : "+content);

GoodsDTO gdto = new GoodsDTO(); //폼값을 DTO객체에 저장한다.
gdto.setGname(gname);
gdto.setPrice(price);
gdto.setStock(stock);
gdto.setContent(content);

/*파일업로드용 프로세스*/
List<Part> fileParts = 
    request.getParts().stream().filter(part -> "ofile".equals(part.getName()) && part.getSize() > 0).collect(Collectors.toList());

for (Part p : fileParts) {
    String oFileName = Paths.get(p.getSubmittedFileName()).getFileName().toString();
    String sFileName = FileUtil.renameFile(sDirectory, oFileName);
    
    String dst = sDirectory + sFileName;
	
    try (BufferedInputStream fin = new BufferedInputStream(p.getInputStream());
        BufferedOutputStream fout = new BufferedOutputStream(new FileOutputStream(dst))) 
    { 	int data;
        while (true) {
            data = fin.read();             
            if(data == -1)  break;             
            fout.write(data);
        }
    } catch(IOException e) { e.printStackTrace();}       
    System.out.println("Uploaded Filename: " + dst + ", "+oFileName+ ",  "+sFileName);
    
    gdto.setOfile(oFileName);
    gdto.setSfile(sFileName);
}

GoodsDAO gdao = new GoodsDAO(application);
int iResult = gdao.insertWrite(gdto); //기존처럼 게시물 1개를 등록할때 사용
//더미게시물입력위해 반복문 사용
/* int iResult = 0;
 for(int i=1; i<=100; i++){
	gdto.setGname(gname+"-"+i);
	iResult = gdao.insertWrite(gdto);
}  */
gdao.close();

if (iResult == 1) JSFunction.alertLocation("상품글 작성에 성공했습니다.", "sub01.jsp", out);
else JSFunction.alertBack("상품글 작성에 실패하였습니다.", out);
%>



