package utils;

public class BoardPage {
	
	/* List.jsp에서 전달해준 인수를 아래 매개변수를 통해 받는다. */ 
    public static String pagingStr(int totalCount, int pageSize, int blockPage, int pageNum, String reqUrl) {
    	//페이지 바로가기 링크를 저장할 문자열변수 생성
    	String pagingStr = "";
        
    	//전체 페이지 수를 계산한다. 
    	/* 현재 페이지 블럭에서 사용할 첫번째 페이지번호를 계산한다. 
        	현재 1페이지라 가정하면 (((1-1) / 5) * 5) + 1 = 1
        	현재 5페이지라 가정하면	(((5-1) / 5) * 5) + 1 = 1 => 즉 1~5페이지인 경우 해당블럭의 첫번째 페이지는 1이다.
        	현재 6페이지라 가정하면 (((6-1) / 5) * 5) + 1 = 6
        	현재 11페이지라 가정하면 (((11-1) / 5) * 5) + 1 = 11         */
        /* pageTemp가 1이 아닐때만, 즉 첫번째 블럭이 아닐때만 이전블록 바로가기 링크를 화면에 출력한다. */
    	int totalPages = (int) Math.ceil(totalCount / pageSize);
    	int pageTemp = ((pageNum - 1) / blockPage) * blockPage + 1;

        if (pageTemp != 1) {
            pagingStr += "<a href='" + reqUrl + "&pageNum=1'>[첫 페이지]</a>&nbsp;";            
            pagingStr += "<a href='" + reqUrl + "&pageNum=" + (pageTemp - 1)+ "'>[이전 블록]</a>";
        }
/* 각 페이지 번호로 바로가기 링크 출력
  앞에서 계산한 pageTemp를 blockPage만큼 반복해서 출력한다. 이때 1씩 증가시켜준다. 즉 한블록당 5페이지를 출력하게된다. 

만약 현재페이지라면 링크를 걸지 않는다. 
> 현재페이지가 아닌 경우에만 링크를 추가한다. 
> 반복하면서 1씩 증가시켜 순차적인 페이지번호를 출력한다.  */
     
        int blockCount = 1;
        while (blockCount <= blockPage && pageTemp <= totalPages) {
            if (pageTemp == pageNum) pagingStr += "&nbsp;" + pageTemp + "&nbsp;";
            else pagingStr += "&nbsp;<a href='" + reqUrl + "&pageNum=" + pageTemp+ "'>" + pageTemp + "</a>&nbsp;";
            pageTemp++;
            blockCount++;
        }
        
        //다음 페이지 블록 바로가기 링크 추가 > 마지막 페이지가 아닌 경우에만 다음블럭을 출력한다. 
        if (pageTemp <= totalPages) {
            pagingStr += "<a href='" + reqUrl + "&pageNum=" + pageTemp+ "'>[다음 블록]</a>&nbsp;";
            pagingStr += "<a href='" + reqUrl + "&pageNum=" + totalPages+ "'>[마지막 페이지]</a>";
        }
        return pagingStr;
    }

	/* List.jsp에서 전달해준 인수를 아래 매개변수를 통해 받는다. */ 
	public static String pagingImg (int totalcnt, int pageSize, int blockPage, int pageNum, String reqUrl) {
		String pagingStr = "<ul class='pagination pagination-sm justify-content-center'>"; 
		
		int totalPages = (int) Math.ceil((double)totalcnt / pageSize);
		int pageTemp = ((pageNum-1)/blockPage)*blockPage+1;

		if(pageTemp!=1) {
			pagingStr += "<li class='page-item'><a class='page-link' href='"+reqUrl+"&pageNum=1'><i class='fa-solid fa-angles-left'></i></a></li>";
			pagingStr += "<li class='page-item'><a class='page-link' href='"+reqUrl+"&pageNum="+(pageTemp-1)+"'><i class='fa-solid fa-angle-left'></i></a></li>";
		}
		
		int blockcnt = 1;
		while(blockcnt <= blockPage && pageTemp <= totalPages) {
			if(pageTemp==pageNum) pagingStr += "<li class='page-item'><a class='page-link active'>"+pageTemp+"</a></li>";
			else pagingStr += "<li class='page-item'><a class='page-link' href='"+reqUrl+"&pageNum="+pageTemp+"'>"+pageTemp+"</a></li>";
			pageTemp++;
			blockcnt++;
		}
		 if (pageTemp <= totalPages) {
	        pagingStr += "<li class='page-item'><a class='page-link' href='" + reqUrl + "&pageNum="+pageTemp+"'><i class='fa-solid fa-angle-right'></i></a></li>";
	        pagingStr += "<li class='page-item'><a class='page-link' href='" + reqUrl + "&pageNum="+totalPages+"'><i class='fa-solid fa-angles-right'></i></a></li>";
	     }
		 pagingStr += "</ul>";
	     return pagingStr;
	}
}
