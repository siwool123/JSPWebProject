package real.project;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/NaverSearchAPI.do")
public class NaverSearchServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String clientId = "VXlYWEUTb17iJsYHHc5o";
		String clientSecret = "Qy3ejdqGXx";
		
		String keyword = req.getParameter("keyword");
		int startNum=0; //검색시작위치
		String text = null; //검색어
        try {
        	startNum = Integer.parseInt(req.getParameter("startNum"));
        	text = URLEncoder.encode(keyword, "UTF-8"); //검색어는 파라미터로 받은후 utf-8로 인코딩한다
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("검색어 인코딩 실패",e);
        }
/* 네이버 검색api 요청url은 아래처럼 정의되어있다. 우리는 json 결과받을것이므로 첫번째 주소로 요청한다.
 * 파라미터는 query(검색어), display(출력갯수), start(출력시작위치) 3가지를 사용한다  */
        String apiURL = "https://openapi.naver.com/v1/search/blog?query="+text+"&display=20&start="+startNum; // JSON 결과
        //String apiURL = "https://openapi.naver.com/v1/search/blog.xml?query="+ text; // XML 결과

        Map<String, String> requestHeaders = new HashMap<>();
        requestHeaders.put("X-Naver-Client-Id", clientId);
        requestHeaders.put("X-Naver-Client-Secret", clientSecret);
        String responseBody = get(apiURL,requestHeaders);
        
      //검색결과 json을 콘솔에 출력 > 서블릿에서 jsp없이 즉시내용출력위해 컨텐츠타입 설정 > 반환된 json결과를 웹브라우저에 그대로 출력한다
        System.out.println(responseBody); 
        resp.setContentType("test/html;charset=utf-8");
        resp.getWriter().write(responseBody);
    }
	
	//아래의 3개 메서드는 수정없이 그대로 사용하면된다
    private static String get(String apiUrl, Map<String, String> requestHeaders){
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }

            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream());
            } else { // 오류 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }

    private static HttpURLConnection connect(String apiUrl){
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }

    private static String readBody(InputStream body){
        InputStreamReader streamReader = new InputStreamReader(body);

        try (BufferedReader lineReader = new BufferedReader(streamReader)) {
            StringBuilder responseBody = new StringBuilder();

            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }

            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는 데 실패했습니다.", e);
        }
    }
}
