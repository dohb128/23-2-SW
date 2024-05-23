package sw3;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ChatSubmitServlet")
public class ChatSubmitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
   
    	// 서블릿에서 요청의 문자열 인코딩을 설정
    	request.setCharacterEncoding("UTF-8");	//이 부분을 response에서 request로 바꾸니 오류 해결
    	response.setContentType("text/html; charset=UTF-8");

        // 클라이언트에서 이미 UTF-8로 인코딩되어 있다면 URLDecoder 사용하지 않고 직접 가져오기
    	String chatName = URLDecoder.decode(request.getParameter("chatName"), "UTF-8");
		String chatContent = URLDecoder.decode(request.getParameter("chatContent"), "UTF-8");

        if (chatName == null || chatName.equals("") || chatContent == null || chatContent.equals("")) {
            response.getWriter().write("0");
        } else { 
            response.getWriter().write(new ChatDAO().submit(chatName, chatContent));
        }  
    }
}

