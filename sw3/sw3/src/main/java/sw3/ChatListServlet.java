package sw3;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ChatListServlet")
public class ChatListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String listType = request.getParameter("listType");

        if (listType == null || listType.equals("")) {
            response.getWriter().write("");
        } else if (listType.equals("today")) {
            response.getWriter().write(getToday());
        } else if (listType.equals("ten")) {
            response.getWriter().write(getTen());
        } else {
            try {
                Integer.parseInt(listType);
                response.getWriter().write(getID(listType));
            } catch (Exception e) {
                response.getWriter().write("");
            }
        }
    }

	// 현재 날짜의 채팅 목록을 JSON 형식으로 반환하는 메서드
	public String getToday() {
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		ChatDAO chatDAO = new ChatDAO();
		// 현재 날짜의 채팅 목록을 데이터베이스에서 가져오기
		ArrayList<Chat> chatList = chatDAO.getChatList(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
		for (int i = 0; i < chatList.size(); i++) {
			result.append("[{\"value\": \"" + chatList.get(i).getChatName() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"}]");
			if (i != chatList.size() - 1)
				result.append(",");
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size() - 1).getChatID() + "\"}");
		return result.toString();
	}

	// 최근 10개의 채팅 목록을 JSON 형식으로 반환하는 메서드
	public String getTen() {
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		ChatDAO chatDAO = new ChatDAO();
		// 최근 10개의 채팅 목록을 데이터베이스에서 가져오기
		ArrayList<Chat> chatList = chatDAO.getChatListByRecent(10);
		for (int i = 0; i < chatList.size(); i++) {
			result.append("[{\"value\": \"" + chatList.get(i).getChatName() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"}]");
			if (i != chatList.size() - 1)
				result.append(",");
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size() - 1).getChatID() + "\"}");
		return result.toString();
	}

	// 특정 ID부터의 최근 채팅 목록을 JSON 형식으로 반환하는 메서드
	public String getID(String chatID) {
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		ChatDAO chatDAO = new ChatDAO();
		// 특정 ID부터의 최근 채팅 목록을 데이터베이스에서 가져오기
		ArrayList<Chat> chatList = chatDAO.getChatListByRecent(chatID);
		for (int i = 0; i < chatList.size(); i++) {
			result.append("[{\"value\": \"" + chatList.get(i).getChatName() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"}]");
			if (i != chatList.size() - 1)
				result.append(",");
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size() - 1).getChatID() + "\"}");
		return result.toString();
	}
}
