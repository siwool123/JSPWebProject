package utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CookieManager {
/* 쿠키생성 : 생성시 response 내장객체가 필요하므로 매개변수로 jsp에서 전달받아야함
 * 나머지는 쿠키명, 쿠키값, 유효시간 설정위한 매개변수 */	
	public static void makeCookie(HttpServletResponse response, String cName, String cValue, int cTime) {
		Cookie cookie = new Cookie(cName, cValue);
		cookie.setPath("/");
		cookie.setMaxAge(cTime);
		response.addCookie(cookie);
	}
	/* 쿠키값읽기 : request 내장객체가 필요하므로 매개변수로 선언한다 */
	public static String readCookie(HttpServletRequest request, String cName) {
		String cookieV = "";
		Cookie[] cookies = request.getCookies();
		if(cookies!=null){
			for(Cookie i:cookies){
				String cookieN = i.getName();
				if(cookieN.equals(cName)) cookieV = i.getValue();
			}
		}
		return cookieV;
	}
/* 쿠키삭제 : 유지시간을 0으로 설정시 삭제되므로 앞에서 정의한 makeCookie 메소드사용  */
	public static void deleteCookie(HttpServletResponse response, String cName) {
		makeCookie(response, cName, "", 0);
	}
}
