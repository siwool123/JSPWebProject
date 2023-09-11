package utils;

import java.io.PrintWriter;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.jsp.JspWriter;
/* 메소드 생성시 static 통해 정적메소들 정의하면 객체생성없이 클래스명으로 즉시메소드 호출가능
 * 자바클래스에서는 jsp 내장객체를 즉시 사용할수없으므로 반드시 매개변수로 전달받아 사용해야한다.
 * 여기선 웹브라우저에 문자열을 출력하기위해 out 내장객체를 jspwriter 타입으로 받은후 사용하고있다. */

public class JSFunction {
	
	public static void alertLocation(String msg, String url, JspWriter out) {
		try {
			String script = "<script>alert('"+msg+"'); location.href='"+url+"';</script>";
			out.println(script);
		}catch(Exception e) {}
	}
	
	public static void alertBack(String msg, JspWriter out) {
		try {
			String script = "<script>alert('"+msg+"'); history.back();</script>";
			out.println(script);
		}catch(Exception e) {}
	}
	
	public static void alertLocation(HttpServletResponse resp, String msg, String url) {
		try {
		//컨텐츠 타입설정 > PrintWriter 객체통해 스크립트를 서블릿에서 직접 출력
			resp.setContentType("text/html;charset=UTF-8");
			PrintWriter writer = resp.getWriter();
			String script = "<script>alert('"+msg+"'); location.href='"+url+"'; </script>";
			writer.print(script);
		}catch(Exception e) {}
	}
	
	public static void alertBack(HttpServletResponse resp, String msg) {
		try {
			resp.setContentType("text/html;charset=UTF-8");
			PrintWriter writer = resp.getWriter();
			String script = "<script>alert('"+msg+"'); history.back();</script>";
			writer.print(script);
		}catch(Exception e) {}
	}
	
	public static String titleCut(String title, int n) {
		String result = title;
		try {
			if(title.length()>n) result = title.substring(0, n)+"...";
		}catch(Exception e) {}
		return result;
	}
}
