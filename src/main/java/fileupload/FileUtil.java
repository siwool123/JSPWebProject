package fileupload;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

public class FileUtil {
	//파일업로드 (매개변수1:request 내장객체, 매개변수2:디렉토리명)
	public static String uploadFile (HttpServletRequest req, String sDirectory) throws ServletException, IOException {
		
/* 파일첨부위한 input태그의 name속성값이용해서 part 객체생성. 해당객체 통해 파일을 서버에 저장할수있다
 * part 객체에서아래 헤더값 읽어오면 전송된파일의 원본명을 알수있다. 콘솔에서 확인
 * 
 * "filename=" 를 구분자로 헤더값을 split()하면 String타입의 배열로 반환된다.
 * 앞에서 스플릿한 결과중 인덱스1은 파일명이된다.
 * 여기서 더블쿼테이션 제거하면 순수한 파일명만 남는다. replace 통해 제거한다
 * 이때 더블쿼테이션을 제거할 문자열로 사용하기위해 escape 시퀀스 \ 을 붙여줘야한다.
 * 
 * 전송파일이 있는경우 디렉토리에 파일 저장한다. 이때 write()메소드사용한다
 * File.separator : os 마다 경로 표시하는기호가 다르므로 "/" 대신 사용한다.
 * 원본파일명 반환
 *  */	
		Part part = req.getPart("ofile");
		
		String partHeader = part.getHeader("content-disposition");
		System.out.println("partHeader="+partHeader);
		
		String[] phArr = partHeader.split("filename=");
		String oFileName = phArr[1].trim().replace("\"", "");
		
		if(!oFileName.isEmpty()) part.write(sDirectory + File.separator + oFileName);
		
		return oFileName;
	}
	//파일명 변경
/* 파일명에서 확장자 잘라내기위해 뒤에서부터 . 위치찾는다. 2개의상의 . 이 파일명에 사용될수있기때문
 * 날자와 시간 이용해서 파일명으로 사용할 문자열을 생성한다
 * "년원일_시분초123" 형태가 된다
 * 
 * 원본파일명과 새파일명 통해 file객체 생성 > 파일명 변경 > 변경된 파일명 반환
 *  */
	public static String renameFile(String sDirectory, String fileName) {
		String ext = fileName.substring(fileName.lastIndexOf("."));
		String now = new SimpleDateFormat("yyyyMMdd_HmsS").format(new Date());
		
		File oldFile = new File(sDirectory + File.separator + fileName);
		File newFile = new File(sDirectory + File.separator + now+ext);
		
		oldFile.renameTo(newFile);
		return now+ext;
	}
	
	public static ArrayList<String> multiFile (HttpServletRequest req, String sDirectory) throws ServletException, IOException {
		
		ArrayList<String> listFN = new ArrayList<>();
		Collection<Part> parts = req.getParts();
		for(Part i:parts) {
			if(!i.getName().equals("ofile")) continue;
			String partHeader = i.getHeader("content-disposition");
			System.out.println("partHeader="+partHeader);
			String[] phArr = partHeader.split("filename=");
			String oFileName = phArr[1].trim().replace("\"", "");
			if(!oFileName.isEmpty()) i.write(sDirectory + File.separator + oFileName);
			listFN.add(oFileName);
		}
		return listFN;
	}
	
	public static void download(HttpServletRequest req, HttpServletResponse resp, String directory, String sfileName, String ofileName) {
		String sDirectory = req.getServletContext().getRealPath(directory);
		try {
			File file = new File(sDirectory, sfileName);
			InputStream iStream = new FileInputStream(file);
			
			String client = req.getHeader("User-Agent");
			if (client.indexOf("WOW64") == -1) ofileName = new String(ofileName.getBytes("UTF-8"), "ISO-8859-1");
	        else ofileName = new String(ofileName.getBytes("KSC5601"), "ISO-8859-1");

	        /* 파일 다운로드용 응답 헤더 설정
	 서버에 저장된 파일을 다운로드시 원본파일명으로 변경한다
	 파일명이 한글인 경우 깨짐 현상이 발생할수있어 앞에다 깨짐처리를 먼저진행한다 */
            resp.reset();
            resp.setContentType("application/octet-stream");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + ofileName + "\"");
            resp.setHeader("Content-Length", "" + file.length() );

            //out.clear();  // 출력 스트림 초기화

            // response 내장 객체로부터 새로운 출력 스트림 생성
            OutputStream oStream = resp.getOutputStream();

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
	}
	/*파일이 저장된 디렉토리의 물리적경로가져옴 > 	 */
	public static void deleteFile(HttpServletRequest req, String directory, String filename) {
		String sDirectory = req.getServletContext().getRealPath(directory);
		File file = new File( sDirectory + File.separator + filename );
		if(file.exists())	file.delete();		
	}
}
